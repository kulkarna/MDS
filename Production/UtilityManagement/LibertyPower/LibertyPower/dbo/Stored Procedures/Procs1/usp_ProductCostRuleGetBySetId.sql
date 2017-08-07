

/*******************************************************************************
 * usp_ProductCostRuleGetBySetId
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCostRuleGetBySetId]  
	@ProductCostRuleSetID					int
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
	  ,ISNULL([PriceTier], 0) AS PriceTier
	FROM [LibertyPower].[dbo].[ProductCostRule] WITH (NOLOCK)
	WHERE [ProductCostRuleSetID] = @ProductCostRuleSetID
	ORDER BY 
		[ProductCostRuleID]
		  
-- Copyright 2010 Liberty Power
