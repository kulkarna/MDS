
/*******************************************************************************
 * usp_ProductCostRuleGetById
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCostRuleGetById]  
	@ProductCostRuleID					int
AS
	SELECT [ProductCostRuleID]
	  ,[ProductCostRuleSetID]
	  ,[CustomerTypeID]
	  ,[MarketID]
	  ,[UtilityID]
	  ,[ServiceClassID]
	  ,[ZoneID]
	  ,[ProductTypeID]
	  ,[StartDate]
	  ,[Term]
	  ,[Rate]
	  ,[CreatedBy]
	  ,[DateCreated]
	  ,[PriceTier]
	FROM [LibertyPower].[dbo].[ProductCostRule] WITH (NOLOCK)
	WHERE [ProductCostRuleID] = @ProductCostRuleID                                                                                                                                 
	
-- Copyright 2010 Liberty Power

