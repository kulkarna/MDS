
/*******************************************************************************
 * usp_DailyPricingFileTypeGetAll
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricingFileTypeGetAll] 

As

SELECT [DailyPricingFileTypeID]
      ,[FileType]
      ,[DateCreated]
      ,[CreatedBy]
FROM [LibertyPower].[dbo].[DailyPricingFileType] (NOLOCK)
ORDER BY [FileType]

-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingFileTypeGetAll';

