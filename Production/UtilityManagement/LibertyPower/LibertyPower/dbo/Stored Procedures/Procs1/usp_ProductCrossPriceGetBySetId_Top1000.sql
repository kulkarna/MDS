
/*******************************************************************************
 * usp_ProductCrossPriceGetBySetId_Top1000
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceGetBySetId_Top1000]  
	@ProductCrossPriceSetID					int
AS
	SELECT TOP 1000 [ProductCrossPriceID]
      ,[ProductCrossPriceSetID]
      ,[ProductMarkupRuleID]
      ,[ProductCostRuleID]
      ,[ProductTypeID]
      ,[MarketID]
      ,[UtilityID]
      ,[SegmentID]
      ,[ZoneID]
      ,[ServiceClassID]
      ,[ChannelTypeID]
      ,[ChannelGroupID]
      ,[CostRateEffectiveDate]
      ,[StartDate]
      ,[Term]
      ,[CostRateExpirationDate]
      ,[MarkupRate]
      ,[CostRate]
      ,[CommissionsRate]
      ,[POR]
	  ,[GRT]
      ,[SUT]
      ,[Price]
      ,[CreatedBy]
      ,[DateCreated]
      ,[RateCodeID]
	FROM [LibertyPower].[dbo].[ProductCrossPrice] WITH (NOLOCK)
	WHERE [ProductCrossPriceSetID] = @ProductCrossPriceSetID                                                                                                                              
	
-- Copyright 2010 Liberty Power

