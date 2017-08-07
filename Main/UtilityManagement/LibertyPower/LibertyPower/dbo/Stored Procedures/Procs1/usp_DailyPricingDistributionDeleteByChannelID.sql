
/*******************************************************************************
 * usp_DailyPricingDistributionDeleteByChannelID
 *
 *
 ******************************************************************************/
Create PROCEDURE [dbo].[usp_DailyPricingDistributionDeleteByChannelID] 
	@ChannelID	int
As

Delete
FROM [LibertyPower].[dbo].[DailyPricingDistribution]
Where [ChannelID] = @ChannelID

-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingDistributionDeleteByChannelID';

