
/*******************************************************************************
 * usp_ProductCostRuleRawGetBySetId
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCostRuleRawGetBySetId]  
	@ProductCostRuleSetID					int
AS
	/****** Script for SelectTopNRows command from SSMS  ******/
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
	WHERE [ProductCostRuleSetID] = @ProductCostRuleSetID                                                                                                                                 
	
-- Copyright 2010 Liberty Power
