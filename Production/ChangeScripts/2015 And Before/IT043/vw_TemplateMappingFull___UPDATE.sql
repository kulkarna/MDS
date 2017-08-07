USE [lp_documents]
GO

/****** Object:  View [dbo].[vw_TemplateMappingFull]    Script Date: 05/31/2012 09:24:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
--	Created By: Ryan Russon
--	Created: 4/15/2011
--		Returns contents of the TemplateMapping table and basic information for Product, Market, Utility, etc.
--		View provides the prefered integer IDs and other legacy codes for easier JOINs and for UI purposes
------------------------------------------------
-- Modified by: Ryan Russon			06/21/2011		Added Branding for IT090
-- Modified by: Ryan Russon			03/09/2012		Changed DocumentLanguage to point to new table in LibertyPower
-- =============================================
	ALTER VIEW [dbo].[vw_TemplateMappingFull]

	AS

	SELECT
		--Put fields from TemplateMap first
		tm.[TemplateMapID]					AS [TemplateMapID],
		tm.[TemplateID]						AS [TemplateID],
		dt.[document_type_id]				AS [DocumentTypeID],
		dt.[document_type_name]				AS [DocumentTypeName],
		dt.[repository_folder]				AS [RepositoryFolder],
		t.[template_name]					AS [TemplateName],
		t.[TemplateTitle]					AS [TemplateTitle],
		t.[force_table_rowcount]			AS [ForcedRowCount],
		t.[inactive_ind]					AS [IsInactive],
		t.[deleted_ind]						AS [IsDeleted],
		0									AS [EtfId],						--Temporary kludge since this field moved to TemplateVersions
		tm.[MarketID]						AS [MarketID],
		tm.[UtilityID]						AS [UtilityID],
		tm.[AccountTypeID]					AS [AccountTypeID],
		tm.[ChannelGroupID]					AS [ChannelGroupID], 
		tm.[ProductID]						AS [ProductID],
		tm.[ContractType]					AS [ContractType],
		--tm.[LanguageID]						AS [LanguageID],
		tm.[IsDefault]						AS [IsDefault],
		tm.[TermMinMonths]					AS [TermMinMonths],
		tm.[TermMaxMonths]					AS [TermMaxMonths],
		tm.[ProductBrandId]					AS [ProductBrandId],
		tm.[DateCreated]					AS [DateCreated],
		tm.[CreatedBy]						AS [CreatedBy],
		--Add fields with codes/names from associated tables
		--from [LibertyPower]..[AccountType]
		at.[AccountType]					AS AccountType,
		at.[Description]					AS AccountTypeDescription,
		at.[AccountGroup]					AS AccountTypeGroup,
		--from [LibertyPower]..[ChannelGroup]
		cg.[Name]							AS ChannelGroupName,
		cg.[Description]					AS ChannelGroupDescription,
		cg.[ChannelTypeID]					AS ChannelTypeID,
		--from [lp_common]..[common_product]
		c.[seq]								AS ContractTypeID,
		--from [lp_documents]..[document_language]
		l.[LanguageID]						AS LanguageID,
		l.[Description]						AS LanguageName,
		--from [LibertyPower]..[Market]
		m.[MarketCode]						AS MarketCode,
		m.[RetailMktDescp]					AS RetailMarketDescription,
		m.[WholesaleMktId]					AS WholesaleMarketID,
		m.[PucCertification_number]			AS PucCertificationNumber,
		pb.[Name]							AS BrandName,
		--from [lp_common]..[common_product]
		p.[product_descp]					AS ProductDescription,
		p.[product_category]				AS ProductCategory,
		p.[product_sub_category]			AS ProductSubCategory,
		--from [LibertyPower]..[Utility]
		u.[UtilityCode]						AS UtilityCode,
		u.[FullName]						AS UtilityFullName,
		u.[ShortName]						AS UtilityShortName,
		u.[DunsNumber]						AS UtilityDunsNumber,
		u.[EntityId]						AS UtilityEntityID,
		u.[LegacyName]						AS UtilityLegacyName

	FROM [lp_documents]..[TemplateMap]				tm WITH (NOLOCK)
	JOIN lp_documents..document_template			t WITH (NOLOCK)
		ON t.template_id = tm.TemplateID
	JOIN [lp_documents]..[document_type]			dt WITH (NOLOCK)
		ON dt.document_type_id = t.document_type_id
	--JOIN lp_documents..[TemplateVersions] tv
	--	ON tv.TemplateId = t.template_id
	
	--Optionally Mapped Entities--
	LEFT JOIN [LibertyPower]..[AccountType]			at WITH (NOLOCK)
		ON at.ID = tm.AccountTypeID
	LEFT JOIN [LibertyPower]..[ChannelGroup]		cg WITH (NOLOCK)
		ON cg.ChannelGroupID = tm.ChannelGroupID
	LEFT JOIN [lp_common]..[common_views]			c WITH (NOLOCK)		--ContractTypes
		ON c.option_id = tm.ContractType
		AND c.process_id = 'CONTRACT TYPE'
	LEFT JOIN [LibertyPower]..[Language]			l WITH (NOLOCK)
		ON l.LanguageID = t.LanguageID
	LEFT JOIN [lp_common]..[common_product]			p WITH (NOLOCK)
		ON p.product_id = tm.ProductID
		and p.inactive_ind = 0
	LEFT JOIN [LibertyPower]..[Utility]				u WITH (NOLOCK)
		--ON (u.id = tm.UtilityID		OR		u.UtilityCode = p.utility_id)
		ON u.id = tm.UtilityID
		and u.InactiveInd = 0
	LEFT JOIN [LibertyPower]..[ProductBrand]		pb WITH (NOLOCK)
		--ON (pb.ProductBrandID = tm.ProductBrandId		OR		pb.ProductBrandID = p.ProductBrandID)
		ON pb.ProductBrandID = tm.ProductBrandId
		AND pb.Active = 1
	LEFT JOIN [LibertyPower]..[Market]				m WITH (NOLOCK)
		--ON (m.ID = tm.MarketID		OR		m.ID = u.MarketID)
		ON m.ID = tm.MarketID
		AND m.InactiveInd = 0


GO


