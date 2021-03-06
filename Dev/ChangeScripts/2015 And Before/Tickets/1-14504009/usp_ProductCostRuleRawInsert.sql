USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCostRuleRawInsert]    Script Date: 09/05/2012 14:04:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCostRuleRawInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCostRuleRawInsert]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCostRuleRawInsert]    Script Date: 09/05/2012 14:04:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCostRuleRawInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

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

' 
END
GO
