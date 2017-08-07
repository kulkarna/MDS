USE [lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetTemplateInfoByContract]    Script Date: 12/27/2012 11:19:30 ******/
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
--	Modified:	12/27/2012 - RR	- Only return Templates that have an active TemplateVersion
-- ============================================
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

	SET @associatedTemplate = ISNULL(@TemplateId, 0)
	
	SELECT TOP 1
		@LanguageId = a.LanguageId
	FROM lp_documents..vw_ConsolidatedAccountInfo a (NOLOCK)		--Get language based off account (wherever the account for the contractNumber happens to be stored)
	WHERE a.contract_nbr = @ContractNumber
	ORDER BY a.priority

	IF @TemplateId IS NULL											--No Template was specified, look for an associated document (and version) by DocTypeId
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
			ON	tv.TemplateId = dt.template_id
			AND tv.EffectiveDate <= GETDATE()
			AND (tv.ExpirationDate > GETDATE()	or	tv.ExpirationDate IS NULL)
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
		ON	tv.TemplateId = dt.template_id
			AND tv.EffectiveDate <= GETDATE()
			AND (tv.ExpirationDate > GETDATE()	or	tv.ExpirationDate IS NULL)
	WHERE	a.contract_nbr		= @ContractNumber
	AND		dt.document_type_id	= @DocumentTypeId
	--	Insure that ALL conditions are a match	--
	AND	(	a.product_id		= tm.ProductID			OR		tm.ProductID IS NULL	)
	AND	(	a.ProductBrandID	= tm.ProductBrandId		OR		tm.ProductBrandId IS NULL	)
	AND	(	a.MarketId			= tm.MarketID			OR		tm.MarketID IS NULL	)
	AND	(	a.UtilityId			= tm.UtilityID			OR		tm.UtilityID IS NULL	)
	AND	(	a.LanguageId		= tm.LanguageID			OR		tm.LanguageID IS NULL	)
	AND (	a.AccountTypeId		= tm.AccountTypeID		OR		tm.AccountTypeID IS NULL	)
	AND (	a.contract_type		= tm.ContractType		OR		tm.ContractType IS NULL	)
	AND (	(	tm.TermMinMonths IS NULL	and		TermMaxMonths IS NULL	)
		OR	(	a.term_months		BETWEEN tm.TermMinMonths and TermMaxMonths	)
	)
	--Order DESCending because NULLS come first
	ORDER BY tm.IsDefault DESC, tv.ExpirationDate DESC, a.priority, tm.ProductID DESC, tm.ProductBrandID DESC, tm.UtilityId DESC, tm.MarketId DESC

	RETURN 1
END 



GO


USE [lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_TemplateMappingSelect]    Script Date: 12/27/2012 10:31:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
--	Author:			Eric Hernandez
--	Create date:	03/22/2011
--	Description:	Selects all templates matching
--	Usage Example:	EXEC lp_documents..usp_TemplateMappingSelect @MarketID=1, @GetBestFit=1
--	Modified:		03/24/2011 - Ryan Russon
--					Changed to use new view, added @DocumentType, some new columns, and other minor changes
--	Modified:		06/29/2011 - Ryan Russon	-- Added @ProductBrandID
--	Modified:		08/15/2011 - Ryan Russon	-- Added code to intuit @@ProductBrandId, @UtilityID, and @MarketID by product when necessary
--	Modified:		10/03/2011 - Ryan Russon	-- Tiny modification to handle language correctly (since it's tied to Template --not mapping)
--	Modified:		12/27/2012 - Ryan Russon	-- Only return Templates that have an active TemplateVersion
-- =============================================
ALTER PROCEDURE [dbo].[usp_TemplateMappingSelect] (
	@DocumentType		INT = NULL
	,@MarketID			INT = NULL
	,@UtilityID			INT = NULL
	,@ProductBrandID	INT = NULL
	,@ProductID			CHAR(20) = NULL
	,@AccountTypeID		INT = NULL
	,@ContractType		CHAR(20) = NULL
	,@LanguageID		INT = NULL
	,@ChannelGroupID	INT = NULL
	,@TermMinMonths		INT = NULL
	,@TermMaxMonths		INT = NULL
	,@GetBestFit		BIT = 0
)

AS

BEGIN
	--Try to set @ProductBrandId, @UtilityID, and @MarketID by product, if we have it so we can pick up mappings by brand, utility, and market even when indirectly intuited by product.
	IF (@ProductID IS NOT NULL)
		SELECT	@ProductBrandID = pb.ProductBrandID
				, @UtilityID = u.id
				, @MarketID = m.ID
		FROM [lp_common]..[common_product] p (NOLOCK)
		LEFT JOIN [LibertyPower]..[Utility] u (NOLOCK)
			ON u.UtilityCode = p.utility_id
			AND u.InactiveInd = 0
		LEFT JOIN [LibertyPower]..[ProductBrand] pb (NOLOCK)
			ON pb.ProductBrandID = p.ProductBrandID
			AND pb.Active = 1
		LEFT JOIN [LibertyPower]..[Market] m (NOLOCK)
			ON m.ID = u.MarketID
			AND m.InactiveInd = 0
		WHERE p.product_id = @ProductID
--		AND p.inactive_ind = 0

	--Try to set @MarketID by utility, if we need to
	IF (@MarketID IS NULL		AND		@UtilityID IS NOT NULL)
		SELECT	@MarketID = m.ID
		FROM [LibertyPower]..[Utility] u (NOLOCK)
		LEFT JOIN [LibertyPower]..[Market] m (NOLOCK)
			ON m.ID = u.MarketID
			AND m.InactiveInd = 0
		WHERE u.UtilityCode = @UtilityID
		AND u.InactiveInd = 0

	--Return only the best default match
	IF @GetBestFit = 1
	  BEGIN
			SELECT TOP 1
				--tm.[TemplateMapID]
				tm.[TemplateID]
				,tm.[DocumentTypeID]
				,tm.[DocumentTypeName]
				,tm.[RepositoryFolder]
				,tm.[TemplateName]
				,tm.[TemplateTitle]
				,tm.[ForcedRowCount]
		FROM lp_documents..vw_TemplateMappingFull tm (NOLOCK)
		JOIN lp_documents..TemplateVersions tv (NOLOCK)
			ON tv.TemplateId = tm.TemplateID
			AND tv.EffectiveDate <= GETDATE()
			AND (tv.ExpirationDate > GETDATE()	or	tv.ExpirationDate IS NULL)
		WHERE tm.IsInactive = 0
		AND tm.IsDeleted = 0
		AND (@DocumentType IS NULL		OR tm.DocumentTypeID = @DocumentType)

--CONDITIONS MUST MATCH PARAMS EXACTLY--
		AND (tm.MarketID IS NULL		OR tm.MarketID = @MarketID)
		AND (tm.UtilityID IS NULL		OR tm.UtilityID = @UtilityID)
		AND (tm.ProductID IS NULL		OR tm.ProductID = @ProductID)
		AND (tm.ProductBrandId IS NULL	OR tm.ProductBrandId = @ProductBrandID)
		AND (tm.AccountTypeID IS NULL	OR tm.AccountTypeID = @AccountTypeID)
		AND (tm.ContractType IS NULL	OR tm.ContractType = @ContractType)
		AND (tm.ChannelGroupID IS NULL	OR tm.ChannelGroupID = @ChannelGroupID)
		AND (@LanguageID IS NULL		OR tm.LanguageID = @LanguageID)		--LanguageId is NOT mapped, but an attribute of the Template

--OR USE THE SAME CONDITIONS AS BELOW FOR A LIBERAL MATCH?--
		--AND (@MarketID IS NULL			OR tm.MarketID IS NULL			OR tm.MarketID = @MarketID)
		--AND (@UtilityID IS NULL			OR tm.UtilityID IS NULL			OR tm.UtilityID = @UtilityID)
		--AND (@ProductID IS NULL			OR tm.ProductID IS NULL			OR tm.ProductID = @ProductID)
		--AND (@ProductBrandId IS NULL	OR tm.ProductBrandId IS NULL	OR tm.ProductBrandId = @ProductBrandID)
		--AND (@AccountTypeID IS NULL		OR tm.AccountTypeID IS NULL		OR tm.AccountTypeID = @AccountTypeID)
		--AND (@ContractType IS NULL		OR tm.ContractType IS NULL		OR tm.ContractType = @ContractType)
		--AND (@ChannelGroupID IS NULL	OR tm.ChannelGroupID IS NULL	OR tm.ChannelGroupID = @ChannelGroupID)
		--AND (@LanguageID IS NULL		OR tm.LanguageID IS NULL		OR tm.LanguageID = @LanguageID)

		AND (@TermMinMonths IS NULL		OR tm.TermMinMonths IS NULL		OR tm.TermMinMonths <= @TermMinMonths)
		AND (@TermMaxMonths IS NULL		OR tm.TermMaxMonths IS NULL		OR tm.TermMaxMonths >= @TermMaxMonths)
		--NOTE: order by search criteria IDs _DESC_ so we get the most recent association (in case IsDefault=1 isn't enough to differentiate the best template
		ORDER BY	tm.IsDefault desc, tm.ProductID desc, tm.ProductBrandId desc, tm.UtilityID desc, tm.MarketID desc, tm.AccountTypeID desc, tm.ContractType desc, tm.ChannelGroupID desc, 
					tm.TemplateID desc, tm.TermMinMonths asc, tm.TermMaxMonths asc
	END
	ELSE
	BEGIN
		SELECT DISTINCT
				--tm.[TemplateMapID],
				tm.[TemplateID]
				,tm.[DocumentTypeID]
				,tm.[DocumentTypeName]
				,tm.[RepositoryFolder]
				,tm.[TemplateName]
				,tm.[TemplateTitle]
				,tm.[ForcedRowCount]
		FROM lp_documents.dbo.vw_TemplateMappingFull tm (NOLOCK)
		JOIN lp_documents..TemplateVersions tv (NOLOCK)
			ON tv.TemplateId = tm.TemplateID
			AND tv.EffectiveDate <= GETDATE()
			AND (tv.ExpirationDate > GETDATE()	or	tv.ExpirationDate IS NULL)
		WHERE tm.IsInactive = 0
		AND tm.IsDeleted = 0
		AND (@DocumentType IS NULL		OR tm.DocumentTypeID = @DocumentType)		--DocumentType cannot be NULL in TemplateMap table
		AND (@MarketID IS NULL			OR tm.MarketID IS NULL			OR tm.MarketID = @MarketID)
		AND (@UtilityID IS NULL			OR tm.UtilityID IS NULL			OR tm.UtilityID = @UtilityID)
		AND (@ProductID IS NULL			OR tm.ProductID IS NULL			OR tm.ProductID = @ProductID)
		AND (@ProductBrandId IS NULL	OR tm.ProductBrandId IS NULL	OR tm.ProductBrandId = @ProductBrandID)
		AND (@AccountTypeID IS NULL		OR tm.AccountTypeID IS NULL		OR tm.AccountTypeID = @AccountTypeID)
		AND (@ContractType IS NULL		OR tm.ContractType IS NULL		OR tm.ContractType = @ContractType)
		AND (@ChannelGroupID IS NULL	OR tm.ChannelGroupID IS NULL	OR tm.ChannelGroupID = @ChannelGroupID)
		AND (@LanguageID IS NULL		OR tm.LanguageID IS NULL		OR tm.LanguageID = @LanguageID)
		AND (@TermMinMonths IS NULL		OR tm.TermMinMonths IS NULL		OR tm.TermMinMonths <= @TermMinMonths)
		AND (@TermMaxMonths IS NULL		OR tm.TermMaxMonths IS NULL		OR tm.TermMaxMonths >= @TermMaxMonths)
		ORDER BY tm.TemplateName, tm.TemplateID
	END
END


GO


