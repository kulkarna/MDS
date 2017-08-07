
/*******************************************************************************
 * usp_ProductCrossPriceGetById
 *
 * Modified 4/10/13 - Rick Deigsler
 * Added green rate field
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceGetById]  
	@ProductCrossPriceID					int
AS
	SELECT [ProductCrossPriceID]
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
      ,[PriceTier]
      ,[ProductBrandID]
      ,[GreenRate]
	FROM [LibertyPower].[dbo].[ProductCrossPrice] WITH (NOLOCK)
	WHERE [ProductCrossPriceID] = @ProductCrossPriceID                                                                                                                                
	
-- Copyright 2010 Liberty Power

