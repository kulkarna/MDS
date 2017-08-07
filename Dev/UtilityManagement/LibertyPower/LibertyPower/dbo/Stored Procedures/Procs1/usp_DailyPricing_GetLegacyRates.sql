
/*******************************************************************************
 * usp_DailyPricing_GetLegacyRates
 * Gets all the rate records from the Legacy table
 *
 * History
 *******************************************************************************
 * 8/04/2010 - George Worthington
 * Created.
 *******************************************************************************
 * Updated: 9/21/2010
 * Migrated table product_transition from Workspace to LibertyPower
 *******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricing_GetLegacyRates]
	
AS
BEGIN

--	write to log
exec usp_DailyPricingLogInsert_New 3, 8, 'Legacy Rate update: Begin legacy rate loading.', NULL, 0	

-- drop and create temp table
EXEC usp_DailyPricingRecreateLegacyRateTempTable	

INSERT INTO	DailyPricingLegacyRatesTemp (ProductID, RateID, MarketID, UtilityID, ZoneID, 
			ServiceClassID, ChannelGroupID, Term, AccountTypeID, ChannelTypeID, 
			ProductTypeID, RateDesc, DueDate, ContractEffStartDate, TermMonths, Rate, IsTermRange)
SELECT DISTINCT 
	t.product_Id
	,t.rate_id
	,t.marketID
	,t.UtilityID
	,t.ZoneID
	,t.ServiceClassID
	,CASE WHEN LEN(t.rate_id) = 9 THEN 
		CAST(SUBSTRING(CAST(t.rate_id AS varchar(25)), 2, 2) AS int)
	ELSE 
		-1 
	END
	,t.Term
	,t.AccountTypeID
	,t.ChannelTypeId
	,t.ProductTypeId
	,r.Rate_descp
	,r.Due_Date
	,r.Contract_eff_start_date
	,r.Term_Months
	,r.rate
	, (Case when t.product_id like '%_SS%' then 1 else 0 end)
FROM 
	LibertyPower.dbo.product_transition t  (NOLOCK) 
		JOIN lp_common..common_product_rate r (NOLOCK) ON t.product_id = r.product_id AND t.rate_id = r.rate_id
		JOIN lp_common..common_product p (NOLOCK) ON p.product_id = r.product_id			
WHERE 
	p.IsCustom = 0			
	AND LEN(t.rate_id) = 9	

-- create index to speed up searches	
EXEC usp_DailyPricingCreateLegacyRatesIndex	

--	write to log
exec usp_DailyPricingLogInsert_New 3, 8, 'Legacy Rate update: Legacy rate loading completed.', NULL, 0	


-- original
--SELECT DISTINCT 
--	(Case when t.product_id like '%_SS%' then 1 else 0 end) as IsTermRange
--	,t.product_Id
--	,t.rate_id
--	,t.marketID
--	,t.UtilityID
--	,t.ZoneID
--	,t.ServiceClassID
--	,t.Term
--	,t.AccountTypeID
--	,t.ChannelTypeId
--	,t.ProductTypeId
--	,r.Rate_descp
--	,r.Due_Date
--	,r.Contract_eff_start_date
--	,r.Term_Months
--	,r.rate
--FROM 
--	LibertyPower.dbo.product_transition t  (NOLOCK) 
--		JOIN lp_common..common_product_rate r (NOLOCK) ON t.product_id = r.product_id AND t.rate_id = r.rate_id
--		JOIN lp_common..common_product p (NOLOCK) ON p.product_id = r.product_id			
--WHERE 
--	p.IsCustom = 0			
--	AND LEN(t.rate_id) = 9
--ORDER BY 
--	t.product_Id

	
-- Copyright 2010 Liberty Power
End

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricing_GetLegacyRates';

