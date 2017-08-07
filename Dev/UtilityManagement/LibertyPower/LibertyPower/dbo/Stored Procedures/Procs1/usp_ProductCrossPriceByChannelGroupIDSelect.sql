/*******************************************************************************
 * usp_ProductCrossPriceByChannelGroupIDSelect
 * Gets current cross product prices by channel group
 *
 * History
 *******************************************************************************
 * 4/21/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceByChannelGroupIDSelect]  
	@ChannelGroupID			int,
	@ProductCrossPriceSetID	int
AS
	SELECT	[ProductCrossPriceID], [ProductCrossPriceSetID], [ProductMarkupRuleID], [ProductCostRuleID], [ProductTypeID],
			[MarketID], [UtilityID], [SegmentID], [ZoneID], [ServiceClassID], [ChannelTypeID], [ChannelGroupID],
			[CostRateEffectiveDate], [StartDate], [Term], [CostRateExpirationDate], [MarkupRate], [CostRate],
			[CommissionsRate], [POR], [GRT], [SUT], 
			  CASE WHEN MarketID = 9 AND ChannelTypeID = 1 THEN --temporary fix for NJ SUT
					([Price] * .07) + [Price]
				ELSE
					[Price]
				END AS Price			
			, [CreatedBy], [DateCreated], [RateCodeID], [PriceTier]
	FROM	[LibertyPower].[dbo].[ProductCrossPrice] WITH (NOLOCK)
	WHERE	[ProductCrossPriceSetID]	= @ProductCrossPriceSetID  
	AND		[ChannelGroupID]			= @ChannelGroupID
	
-- Copyright 2010 Liberty Power

