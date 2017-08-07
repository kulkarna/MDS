/*******************************************************************************
 * usp_DailyPricingSheetHistorySelect
 * Gets the pricing sheet file generation history data for specified date range
 *
 * History
 *******************************************************************************
 * 7/21/2010 - George Worthington
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingSheetHistorySelect]
	@DateFrom		datetime,
	@DateTo			datetime
AS 
   SELECT [DailyPricingSheetFileGenerationHistoryID]
      ,[FileCount]
      ,[DateGenerated]
      ,[GeneratedBy]
   FROM [LibertyPower].[dbo].[DailyPricingSheetFileGenerationHistory]
   WHERE [DateGenerated] >= @DateFrom
   AND  [DateGenerated] <= @DateTo
   ORDER BY [DateGenerated] DESC

-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingSheetHistorySelect';

