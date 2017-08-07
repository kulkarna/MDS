
/*******************************************************************************
 * usp_ProductCrossPriceGetBySetId
 *
 * Modified 4/10/13 - Rick Deigsler
 * Added green rate field 
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceGetBySetId]  
	@ProductCrossPriceSetID					int
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
	  ,CASE WHEN MarketID = 9 AND ChannelTypeID = 1 THEN --temporary fix for NJ SUT
			([Price] * .07) + [Price]
		ELSE
			[Price]
		END AS Price
	  ,[CreatedBy]
	  ,[DateCreated]
	  ,[RateCodeID]
	  ,[PriceTier]
      ,[ProductBrandID]
      ,[GreenRate]	  
	FROM LibertyPower..ProductCrossPrice WITH (NOLOCK)
	WHERE [ProductCrossPriceSetID] = @ProductCrossPriceSetID  
                                                                                                                           
	
-- Copyright 2010 Liberty Power
