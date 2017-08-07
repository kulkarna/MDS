
/*******************************************************************************
 * usp_DailyPricingLogByDateRange
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricingLogByDateRange]  
	@LogStartDate			DateTime,
	@LogEndDate				DateTime
AS
	SELECT [DailyPricingLogID]
      ,[MessageType]
      ,[DailyPricingModule]
      ,[Message]
      ,[DateCreated]
	FROM [LibertyPower].[dbo].[DailyPricingLog] (NOLOCK)
	WHERE [DateCreated] >= @LogStartDate 
		AND [DateCreated] < @LogEndDate 
	ORDER BY [DateCreated] Desc
		
	
-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingLogByDateRange';

