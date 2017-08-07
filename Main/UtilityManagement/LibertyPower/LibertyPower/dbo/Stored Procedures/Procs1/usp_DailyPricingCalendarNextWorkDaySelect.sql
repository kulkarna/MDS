/*******************************************************************************
 * usp_DailyPricingCalendarNextWorkDaySelect
 * Gets the next daily pricing calendar day after specified date
 *
 * History
 *******************************************************************************
 * 2/21/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingCalendarNextWorkDaySelect]
	@Date	datetime
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	ID, [Date], IsWorkDay, IsInQueue
	FROM	DailyPricingCalendar WITH (NOLOCK)
	WHERE	[Date]		> @Date
	AND		IsWorkDay	= 1

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingCalendarNextWorkDaySelect';

