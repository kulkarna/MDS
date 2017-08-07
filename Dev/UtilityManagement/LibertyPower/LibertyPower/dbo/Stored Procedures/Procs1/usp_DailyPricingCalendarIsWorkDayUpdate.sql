/*******************************************************************************
 * usp_DailyPricingCalendarIsWorkDayUpdate
 * Updates daily pricing calendar work day flag for specified date
 *
 * History
 *******************************************************************************
 * 2/21/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingCalendarIsWorkDayUpdate]
	@Date			datetime,
	@IsWorkDay		tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
	UPDATE	DailyPricingCalendar
	SET		IsWorkDay	= @IsWorkDay
	WHERE	[Date]		= @Date

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingCalendarIsWorkDayUpdate';

