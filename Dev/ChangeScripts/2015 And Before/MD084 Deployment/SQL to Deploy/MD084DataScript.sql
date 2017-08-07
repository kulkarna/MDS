
-- product type and brand  --------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Libertypower..ProductType WHERE Name LIKE '%multi%')
BEGIN
	INSERT INTO Libertypower..ProductType
	SELECT 'Multi-Term', 1, 'libertypower\rideigsler', GETDATE()
END

DECLARE	@ProductTypeID	int
SELECT @ProductTypeID = ProductTypeID FROM Libertypower..ProductType WHERE Name LIKE '%multi%'

IF NOT EXISTS (SELECT 1 FROM Libertypower..ProductBrand WHERE ProductTypeID = @ProductTypeID)
BEGIN
	INSERT INTO Libertypower..ProductBrand
	SELECT @ProductTypeID, 'Smart Step', 0, 0, 3, 1, 'libertypower\rideigsler', GETDATE(), 1
END

-- products  -----------------------------------------------------------------------------------
INSERT	INTO [lp_common].[dbo].[common_product]([product_id],[product_descp],[product_category],[product_sub_category], 
		[utility_id],[frecuency],[db_number],[term_months],[date_created],[username],[inactive_ind],[active_date],[chgstamp], 
		[default_expire_product_id],[requires_profitability],[is_flexible],[account_type_id],[IsCustom],[IsDefault],[ProductBrandID])
SELECT	SUBSTRING((SUBSTRING(RTRIM(CAST([product_id] as varchar(20))), 1, CHARINDEX('_',[product_id]) - 1)   ) + '_MT' +
		SUBSTRING(RTRIM(CAST([product_id] as varchar(20))), CHARINDEX('_',[product_id]), (LEN(RTRIM(CAST([product_id] as varchar(20)))) - LEN(CHARINDEX('_',[product_id]) - 1))), 1, 20), -- product id for multi-term
		[product_descp] + ' MULTI-TERM', -- product description for multi-term
		[product_category],[product_sub_category],[utility_id],[frecuency],[db_number],[term_months],[date_created], 
		p.[username],[inactive_ind],[active_date],p.[chgstamp],[default_expire_product_id],[requires_profitability], 
		[is_flexible],[account_type_id],[IsCustom],[IsDefault], 
		17 -- product brand for multi-term
FROM	[lp_common].[dbo].[common_product] p WITH (NOLOCK)
		INNER JOIN Libertypower..Utility u WITH (NOLOCK)
		ON p.utility_id = u.UtilityCode
WHERE	1=1
AND p.inactive_ind = 0
AND p.iscustom = 0
AND p.isdefault = 0
AND p.ProductBrandID in(1,13)
AND	u.InactiveInd = 0
ORDER BY 1

-- backfill account event history  -------------------------------------------------------------
UPDATE	Libertypower..AccountEventHistory
SET		ProductTypeID = z.ProductTypeID
FROM	Libertypower..AccountEventHistory h
		INNER JOIN
(
	SELECT	b.ProductTypeID, h.ID
	FROM	Libertypower..ProductBrand b WITH (NOLOCK)
			INNER JOIN lp_common..common_product p WITH (NOLOCK)
			ON b.ProductBrandID = p.ProductBrandID
			INNER JOIN Libertypower..AccountEventHistory h WITH (NOLOCK)
			ON p.product_id = h.ProductID
)z ON h.ID = z.ID	

-- pricing sheet template  ---------------------------------------------------------------------
INSERT [Libertypower].[dbo].[DailyPricingTemplateTags] ([SheetTemplate], [SheetName], [HeaderTag], [Footer1Tag], [Footer2Tag], [ExpirationTag], [HeaderStatementTag], [SubmissionStatementTag], [CustomerClassStatementTag], [ProductTaxStatementTag], [ConfidentialityStatementTag], [SizeRequirementTag], [MarketTag], [UtilityTag], [SegmentTag], [ChannelTypeTag], [ZoneTag], [ServiceClassTag], [StartDateTag], [TermTag], [PriceTag], [SalesChannelTag], [DateTimeTag], [WorkbookAllowEditing], [WorkbookPassword]) VALUES (N'\\lpcnocfs2\Repository\ManagedFiles\PricingSheets\PricingSheetMultiTermTemplate.xlsx', N'\\lpcnocfs2\Repository\ManagedFiles\PricingSheets\Liberty Power Daily Pricing for [SalesChannel] [DateTime].xlsx', N'[Header]', N'[Footer_1]', N'[Footer_2]', N'[expiration_date]', N'[header_statement]', N'[submission_statement]', N'[customer_class_statement]', N'[product_tax_statement]', N'[confidentiality_statement]', N'[size_requirement]', N'[market]', N'[utility]', N'[segment]', N'[channel_type]', N'[zone]', N'[service_class_name]', N'[start_date]', N'[term]', N'[price]', N'[SalesChannel]', N'[DateTime]', 0, N'nowayjose')
