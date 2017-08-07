
/*******************************************************************************
 * usp_DailyPricingFileTypeGetByChannelID
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricingFileTypeGetByChannelID] 
	@ChannelID	int
As

SELECT FT.[DailyPricingFileTypeID]
      ,FT.[FileType]
      ,FT.[DateCreated]
      ,FT.[CreatedBy]
FROM [LibertyPower].[dbo].[DailyPricingFileType] FT (NOLOCK)
JOIN [LibertyPower].[dbo].[DailyPricingFileTypeSalesChannel] FTSC (NOLOCK) on FTSC.[DailyPricingFileTypeID] = FT.[DailyPricingFileTypeID]
Where FTSC.[ChannelID] = @ChannelID

-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingFileTypeGetByChannelID';

