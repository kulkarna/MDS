
/*******************************************************************************
 * usp_DailyPricingLogByDate
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricingLogByDate]  
	@LogDate			DateTime
AS

Declare @LogStartDate DateTime
Declare @LogEndDate DateTime

Set @LogStartDate = Cast( convert(varchar(20), getDate(), 101) as DateTime)
Set @LogEndDate = DateAdd(dd, 1, @LogStartDate)


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
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingLogByDate';

