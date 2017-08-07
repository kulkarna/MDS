

/*******************************************************************************
 * usp_ProductCostRuleInsert
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCostRuleInsert]  
	@ProductCostRuleSetID 	int
	,@CustomerTypeID		int
	,@MarketID				int
	,@UtilityID				int
	,@ServiceClassID		int
	,@ZoneID				int
	,@ProductTypeID				int
	,@StartDate				datetime
	,@Term					int
	,@Rate					Decimal(18,10)
	,@CreatedBy				int
	,@PriceTier				tinyint
AS

Declare @ProductCostRuleID int

INSERT INTO [LibertyPower].[dbo].[ProductCostRule]
           ([ProductCostRuleSetID]
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
           ,[PriceTier])
     VALUES
           (@ProductCostRuleSetID 	
			,@CustomerTypeID		
			,@MarketID		
			,@UtilityID		
			,@ServiceClassID	
			,@ZoneID		
			,@ProductTypeID		
			,@StartDate		
			,@Term
			,@Rate	
			,@CreatedBy		
			,getDate()
			,@PriceTier)

SET @ProductCostRuleID = @@IDENTITY

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
	
-- Copyright 2009 Liberty Power
