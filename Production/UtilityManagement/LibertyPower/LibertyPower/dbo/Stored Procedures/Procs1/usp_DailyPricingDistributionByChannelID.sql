
/*******************************************************************************
 * usp_DailyPricingDistributionByChannelID
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricingDistributionByChannelID] 
	@ChannelID	int
As

SELECT 
	[DailyPricingDistributionID]
    ,[ChannelID]
    ,[Email]
    ,[DateCreated]
    ,[CreatedBy]
FROM 
	[LibertyPower].[dbo].[DailyPricingDistribution] (NOLOCK)
Where 
	[ChannelID] = @ChannelID

-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingDistributionByChannelID';

