USE [Lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetTemplateInfoByContract]    Script Date: 07/03/2013 10:27:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- ============================================
--	Created By: Ryan Russon - 06/25/2011
--	Given a ContractNumber and DocumentType, returns the best template match --with precedence to any Associated document
--	Given a ContractNumber and TemplateId, returns the selected template associated account/product/market information need by legacy code
--	EXAMPLES:
--		exec usp_GetTemplateInfoByContract @ContractNumber='2011-0028674', @DocumentTypeId=2
--		exec usp_GetTemplateInfoByContract @ContractNumber='2011-0028674', @TemplateId=77
-- ============================================
--	Modified:	12/29/2011 - RR - Changed sorting to look at IsDefault FIRST
--	Modified:	12/30/2011 - RR - When getting an associated doc, based off history, get only the most recent match
--	Modified:	01/10/2012 - RR - When getting an associated doc, ignore soft-deleted documents from print history
-- ====================================================
--  Modified:   7/3/2013 - Guy G. Updated to accomodate changes for Online Enrollment
--              where contract number may have a value but not yet be in the system.
--              TFS id : 14939
-- ====================================================
ALTER PROC [dbo].[usp_GetTemplateInfoByContract] 
(
	@ContractNumber		varchar(20) = '',
	@DocumentTypeId		int = 0,									--Optional, set value to get the best matched Template
	@TemplateId			int = NULL									--Optional, set value to get a specific TemplateId (even if it doesn't match criteria)
)

AS

BEGIN

	SET NOCOUNT ON

	--Get language for template based off language for the first account associated with this Contract Number
	DECLARE @LanguageId					int							--Defaults to English (1) if no entry is found for an account
	DECLARE @TemplateVersionId			int
	DECLARE @associatedTemplate			int
	DECLARE @parentAssociatedTemplate	int
	DECLARE @ContractNotInSystem		bit = 0

	--contract is provided but it's not in system, this means it's coming from open enrollmente
	if not exists(select contract_nbr from vw_ConsolidatedAccountInfo where contract_nbr = @ContractNumber)
	begin
		set @ContractNotInSystem=1
	end
	
	

	SET @associatedTemplate = ISNULL(@LanguageId, 0)
	
	SELECT TOP 1
		@LanguageId = a.LanguageId
	FROM lp_documents..vw_ConsolidatedAccountInfo a (NOLOCK)		--Get language based off account (wherever the account for the contractNumber happens to be stored)
	WHERE a.contract_nbr = @ContractNumber
	ORDER BY a.priority
	
	if isnull(@LanguageId,0)=0 
	begin
		set @Languageid=1
	end
	
	IF @TemplateId IS NULL	OR isnull(@LanguageId,0)=0										--No Template was specified, look for an associated document (and version) by DocTypeId
	--Try to get the associated template for this Contract and type of document (if an association exists)
	BEGIN
		SELECT TOP 1
			@associatedTemplate = da.assoc_document_id,
			@parentAssociatedTemplate = da.main_document_id,
			@TemplateVersionId = tv.TemplateVersionId
		FROM lp_documents..document_history						AS h (NOLOCK)
		JOIN lp_documents..TemplateVersions						AS tv (NOLOCK)
			ON tv.TemplateVersionId = h.TemplateVersionId			--Look for an exact version stored in document_history
		JOIN lp_documents..document_association					AS da (NOLOCK)
			ON da.main_document_id = tv.templateId
		JOIN lp_documents..document_template					AS dt (NOLOCK)
			ON (	dt.template_id = da.assoc_document_id
					AND dt.document_type_id = @DocumentTypeId
				)
		WHERE h.contract_nbr = @ContractNumber
		AND da.IsAttachment = 0
		AND h.inactive_ind = 0										--No soft-deleted printings
		ORDER BY h.history_id DESC									--Get the most recent association
	END


--we have a non system contract and a main template
if @ContractNotInSystem=1 and exists(select top 1 main_document_id from document_association where main_document_id=@TemplateId)
BEGIN 

		select @associatedTemplate=a.assoc_document_id
		from document_association a
		join document_template t on a.assoc_document_id = t.template_id
		where a.main_document_id= @TemplateId


	SELECT TOP 1
		dt.Template_ID								AS 'TemplateId'
		, dt.template_name
		, dt.TemplateTitle
		, dt.date_created
		, dt.date_modified
		, dt.document_type_id
		, t.document_type_name
		, isnull(mk.ID, 0)							AS 'MarketId' 
		, mk.MarketCode
		, isnull(ut.ID, 0)							AS 'UtilityId'
		, ut.UtilityCode
		, isnull(tm.AccountTypeID, 0)				AS 'AccountTypeId'
		, tm.productid								AS 'ProductId'
		, isnull(tm.ProductBrandID, 0)				AS 'ProductBrandId'
		, tm.contracttype							AS 'ContractType'
		, isnull(@LanguageId, 1)					AS 'LanguageId'
		, 0											AS 'term_months'
		, isnull(tv.TemplateVersionId, 0)			AS 'TemplateVersionId'
		, isnull(tv.VersionCode, 'N/A')				AS 'VersionCode'
		, CAST(tm.IsDefault as bit)					AS 'IsDefault'
		, NULL										AS 'AssociatedTemplateId'		--This is NOT by Association
		, isnull(dt.force_table_rowcount, 1)		AS 'force_table_rowcount'
		, 0						AS 'priority'
	FROM lp_documents..document_template AS dt (NOLOCK) 
	JOIN lp_documents..TemplateVersions				AS tv (NOLOCK) on dt.Template_ID = tv.TemplateId
	join Lp_documents..TemplateMap					as TM (NOLOCK) on dt.template_id = tm.TemplateID
	join Lp_documents..document_type				as t  (NOLOCK) on dt.document_type_id = t.document_type_id
	left join libertypower..Utility					as ut (NOLOCK) on  tm.UtilityID = ut.ID
	left join libertypower..Market					as mk (NOLOCK) on  tm.MarketID = mk.ID 
	WHERE	 dt.template_id=@associatedTemplate
		ORDER BY tm.IsDefault DESC, tv.ExpirationDate DESC,  tm.ProductID DESC, tm.ProductBrandID DESC, tm.UtilityId DESC, tm.MarketId DESC

	RETURN 1
			  
END






--we have a non system contract and a child template
if @ContractNotInSystem=1 and exists(select top 1 * from document_association where assoc_document_id=@TemplateId)


BEGIN 
	
    set @associatedTemplate=@TemplateId
	


	SELECT TOP 1
		dt.Template_ID								AS 'TemplateId'
		, dt.template_name
		, dt.TemplateTitle
		, dt.date_created
		, dt.date_modified
		, dt.document_type_id
		, t.document_type_name
		, isnull(mk.ID, 0)							AS 'MarketId' 
		, mk.MarketCode
		, isnull(ut.ID, 0)							AS 'UtilityId'
		, ut.UtilityCode
		, isnull(tm.AccountTypeID, 0)				AS 'AccountTypeId'
		, tm.productid								AS 'ProductId'
		, isnull(tm.ProductBrandID, 0)				AS 'ProductBrandId'
		, tm.contracttype							AS 'ContractType'
		, isnull(@LanguageId, 1)					AS 'LanguageId'
		, 0											AS 'term_months'
		, isnull(tv.TemplateVersionId, 0)			AS 'TemplateVersionId'
		, isnull(tv.VersionCode, 'N/A')				AS 'VersionCode'
		, CAST(tm.IsDefault as bit)					AS 'IsDefault'
		, NULL										AS 'AssociatedTemplateId'		--This is NOT by Association
		, isnull(dt.force_table_rowcount, 1)		AS 'force_table_rowcount'
		, 0						AS 'priority'
	FROM lp_documents..document_template AS dt (NOLOCK) 
	left JOIN lp_documents..TemplateVersions				AS tv (NOLOCK) on dt.Template_ID = tv.TemplateId
	left join Lp_documents..TemplateMap					as TM (NOLOCK) on dt.template_id = tm.TemplateID
	join Lp_documents..document_type				as t  (NOLOCK) on dt.document_type_id = t.document_type_id
	left join libertypower..Utility					as ut (NOLOCK) on  tm.UtilityID = ut.ID
	left join libertypower..Market					as mk (NOLOCK) on  tm.MarketID = mk.ID 
	WHERE	 dt.template_id=@associatedTemplate
		ORDER BY tm.IsDefault DESC, tv.ExpirationDate DESC,  tm.ProductID DESC, tm.ProductBrandID DESC, tm.UtilityId DESC, tm.MarketId DESC

	RETURN 1
					  
END




	IF @associatedTemplate > 0										--Specified TemplateId or an Associated template overrides any matches in the TemplateMap table
	BEGIN
		SELECT TOP 1
			dt.template_id							AS 'TemplateId'
			, dt.template_name
			, dt.TemplateTitle
			, dt.date_created
			, dt.date_modified
			, dt.document_type_id
			, t.document_type_name
			, isnull(a.MarketId, 0)					AS 'MarketId'
			, a.retail_mkt_id
			, isnull(a.UtilityId, 0)				AS 'UtilityId'
			, a.utility_id
			, isnull(a.AccountTypeID, 0)			AS 'AccountTypeId'
			, a.product_id							AS 'ProductId'
			, isnull(a.ProductBrandID, 0)			AS 'ProductBrandId'
			, a.contract_type						AS 'ContractType'
			, isnull(dt.LanguageId, 1)				AS 'LanguageId'
			, isnull(a.term_months, 0)				AS 'term_months'
			, isnull(tv.TemplateVersionId, 0)		AS 'TemplateVersionId'
			, isnull(tv.VersionCode, 'N/A')			AS 'VersionCode'
			, CAST(0 as bit)						AS 'IsDefault'
			, @parentAssociatedTemplate				AS 'AssociatedTemplateId'
			, ISNULL(dt.force_table_rowcount, 1)	AS 'force_table_rowcount'
			, 0										AS 'priority'
		FROM lp_documents..document_template					AS dt (NOLOCK)
		JOIN lp_documents..document_type						AS t (NOLOCK)
			ON t.document_type_id = dt.document_type_id
		JOIN (	select top 1 contract_nbr, MarketId, retail_mkt_id, UtilityId, utility_id, AccountTypeId, product_id, contract_type, term_months, ProductBrandId
				from lp_documents..vw_ConsolidatedAccountInfo acct (NOLOCK)
				where acct.contract_nbr = @ContractNumber)		AS a
			ON a.contract_nbr = @ContractNumber
		JOIN lp_documents..TemplateVersions						AS tv (NOLOCK)
			ON tv.TemplateId = dt.template_id
		WHERE dt.template_id = @associatedTemplate
		ORDER BY tv.ExpirationDate DESC
		RETURN 1
	END

--ELSE NO @associatedTemplate/@TemplateId							--Find the best match in the TemplateMap table
	SELECT TOP 1
		tm.TemplateID								AS 'TemplateId'
		, dt.template_name
		, dt.TemplateTitle
		, dt.date_created
		, dt.date_modified
		, dt.document_type_id
		, t.document_type_name
		, isnull(a.MarketId, 0)						AS 'MarketId'
		, a.retail_mkt_id
		, isnull(a.UtilityId, 0)					AS 'UtilityId'
		, a.utility_id
		, isnull(a.AccountTypeID, 0)				AS 'AccountTypeId'
		, a.product_id								AS 'ProductId'
		, isnull(a.ProductBrandID, 0)				AS 'ProductBrandId'
		, a.contract_type							AS 'ContractType'
		, isnull(@LanguageId, 1)					AS 'LanguageId'
		, isnull(a.term_months, 0)					AS 'term_months'
		, isnull(tv.TemplateVersionId, 0)			AS 'TemplateVersionId'
		, isnull(tv.VersionCode, 'N/A')				AS 'VersionCode'
		, CAST(tm.IsDefault as bit)					AS 'IsDefault'
		, NULL										AS 'AssociatedTemplateId'		--This is NOT by Association
		, isnull(dt.force_table_rowcount, 1)		AS 'force_table_rowcount'
		, isnull(a.priority, 0)						AS 'priority'
	FROM lp_documents..vw_ConsolidatedAccountInfo				AS a (NOLOCK)
	--Join to the mapping on ANY matching condition, but ensure that all conditions are met below
	JOIN lp_documents..TemplateMap								AS tm (NOLOCK)
		ON (
			a.product_id		= tm.ProductID
			OR a.ProductBrandID	= tm.ProductBrandId
			OR a.MarketId		= tm.MarketID
			OR a.UtilityId		= tm.UtilityID
			OR a.LanguageId		= tm.LanguageID
			OR a.AccountTypeId	= tm.AccountTypeID
			OR a.contract_type	= tm.ContractType
		)
	JOIN lp_documents..document_template						AS dt (NOLOCK)
		ON (	dt.template_id = tm.TemplateID
				AND dt.document_type_id = @DocumentTypeId
				AND	( @LanguageId IS NULL or dt.LanguageId = @LanguageId )
			)
	JOIN lp_documents..document_type							AS t (NOLOCK)
		ON t.document_type_id = dt.document_type_id
	JOIN lp_documents..TemplateVersions							AS tv (NOLOCK)
		ON tv.TemplateId = dt.template_id
	WHERE	a.contract_nbr		= @ContractNumber
	AND		dt.document_type_id	= @DocumentTypeId
	--	Insure that ALL conditions are a match	--
	AND	(	a.product_id		= tm.ProductID			OR		tm.ProductID IS NULL)
	AND	(	a.ProductBrandID	= tm.ProductBrandId		OR		tm.ProductBrandId IS NULL)
	AND	(	a.MarketId			= tm.MarketID			OR		tm.MarketID IS NULL)
	AND	(	a.UtilityId			= tm.UtilityID			OR		tm.UtilityID IS NULL)
	AND	(	a.LanguageId		= tm.LanguageID			OR		tm.LanguageID IS NULL)
	AND (	a.AccountTypeId		= tm.AccountTypeID		OR		tm.AccountTypeID IS NULL)
	AND (	a.contract_type		= tm.ContractType		OR		tm.ContractType IS NULL)
	AND ((	tm.TermMinMonths IS NULL	and		TermMaxMonths IS NULL)
		OR(	a.term_months		BETWEEN tm.TermMinMonths and TermMaxMonths	)
	)
	--Order DESCending because NULLS come first
	ORDER BY tm.IsDefault DESC, tv.ExpirationDate DESC, a.priority, tm.ProductID DESC, tm.ProductBrandID DESC, tm.UtilityId DESC, tm.MarketId DESC

	RETURN 1
END 



GO


