

/*******************************************************************************
 * usp_DailyPricingLogByDate_New
 *
 * History
 *******************************************************************************
 * 3/31/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingLogByDate_New]  
	@LogDate			DateTime
AS

Declare @LogStartDate DateTime
Declare @LogEndDate DateTime

Set @LogStartDate = Cast( convert(varchar(20), getDate(), 101) as DateTime)
Set @LogEndDate = DateAdd(dd, 1, @LogStartDate)


	SELECT	l.DailyPricingLogID, l.MessageType, l.DailyPricingModule, l.[Message], l.DateCreated, 
			ISNULL(REPLACE(u.UserName, 'libertypower\', ''), 'System') AS UserName
	FROM	LibertyPower..DailyPricingLog_New l WITH (NOLOCK)
			LEFT JOIN LibertyPower..[User] u WITH (NOLOCK)
			ON l.CreatedBy	= u.UserID
	WHERE	l.DateCreated BETWEEN @LogStartDate AND @LogEndDate 
	ORDER BY l.DateCreated DESC
	
-- Copyright 2010 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingLogByDate_New';

