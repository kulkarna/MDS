

/*******************************************************************************
 * [usp_ProductCostRuleRawInsert]
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCostRuleRawInsert]  
	@ProductCostRuleSetID 	int
	,@CustomerType		varchar(50)
	,@Market				varchar(50)
	,@Utility				varchar(50)
	,@UtilityServiceClass	varchar(50)
	,@Zone					varchar(50)
	,@Product				varchar(50)
	,@StartDate				datetime
	,@Term					int
	,@Rate					Decimal(18,10)
	,@CreatedBy				int
	,@PriceTier				tinyint
AS

Declare @ProductCostRuleRawID int

INSERT INTO [LibertyPower].[dbo].[ProductCostRuleRaw]
           ([ProductCostRuleSetID]
			  ,[ProspectCustomerType]
			  ,[Product]
			  ,[MarketCode]
			  ,[UtilityCode]
			  ,[Zone]
			  ,[UtilityServiceClass]
			  ,[StartDate]
			  ,[Term]
			  ,[Rate]
			  ,CreatedBy		
			  ,CreatedDate
			  ,PriceTier)
     VALUES
           (@ProductCostRuleSetID 	
			,@CustomerType	
			,@Product	
			,@Market		
			,@Utility	
			,@Zone	
			,@UtilityServiceClass
			,@StartDate		
			,@Term	
			,@Rate		
			,@CreatedBy		
			,getdate()
			,@PriceTier)

SET @ProductCostRuleRawID = @@IDENTITY

SELECT	@ProductCostRuleRawID AS ProductCostRuleRawID

--SELECT  [ProductCostRuleRawID]
--      ,[ProductCostRuleSetID]
--      ,[ProspectCustomerType]
--      ,[Product]
--      ,[MarketCode]
--      ,[UtilityCode]
--      ,[Zone]
--      ,[UtilityServiceClass]
--      ,[ServiceClassName]
--      ,[StartDate]
--      ,[Term]
--      ,[Rate]
--      ,[PriceTier]
--	FROM [LibertyPower].[dbo].[ProductCostRuleRaw] WITH (NOLOCK)
--WHERE [ProductCostRuleRawID] = @ProductCostRuleRawID                                                                                                                                 
	
-- Copyright 2010 Liberty Power

