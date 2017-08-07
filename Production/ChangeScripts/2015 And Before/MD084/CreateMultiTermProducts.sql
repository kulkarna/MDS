INSERT	INTO [lp_common].[dbo].[common_product]([product_id],[product_descp],[product_category],[product_sub_category], 
		[utility_id],[frecuency],[db_number],[term_months],[date_created],[username],[inactive_ind],[active_date],[chgstamp], 
		[default_expire_product_id],[requires_profitability],[is_flexible],[account_type_id],[IsCustom],[IsDefault],[ProductBrandID])
SELECT	SUBSTRING((SUBSTRING(RTRIM(CAST([product_id] as varchar(20))), 1, CHARINDEX('_',[product_id]) - 1)   ) + '_MT' +
		SUBSTRING(RTRIM(CAST([product_id] as varchar(20))), CHARINDEX('_',[product_id]), (LEN(RTRIM(CAST([product_id] as varchar(20)))) - LEN(CHARINDEX('_',[product_id]) - 1))), 1, 20), -- product id for multi-term
		[product_descp] + ' MULTI-TERM', -- product description for multi-term
		[product_category],[product_sub_category],[utility_id],[frecuency],[db_number],[term_months],[date_created], 
		p.[username],[inactive_ind],[active_date],p.[chgstamp],[default_expire_product_id],[requires_profitability], 
		[is_flexible],[account_type_id],[IsCustom],[IsDefault], 
		20 -- product brand for multi-term
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