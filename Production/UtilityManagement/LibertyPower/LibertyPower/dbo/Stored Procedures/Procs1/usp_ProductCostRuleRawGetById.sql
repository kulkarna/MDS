
/*******************************************************************************
 * [usp_ProductCostRuleRawGetById]
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCostRuleRawGetById]  
	@ProductCostRuleRawID					int
AS
	SELECT  [ProductCostRuleRawID]
      ,[ProductCostRuleSetID]
      ,[ProspectCustomerType]
      ,[Product]
      ,[MarketCode]
      ,[UtilityCode]
      ,[Zone]
      ,[UtilityServiceClass]
      ,[ServiceClassName]
      ,[StartDate]
      ,[Term]
      ,[Rate]
      ,[PriceTier]
	FROM [LibertyPower].[dbo].[ProductCostRuleRaw] WITH (NOLOCK)
	WHERE [ProductCostRuleRawID] = @ProductCostRuleRawID                                                                                                                                 
	
-- Copyright 2010 Liberty Power
