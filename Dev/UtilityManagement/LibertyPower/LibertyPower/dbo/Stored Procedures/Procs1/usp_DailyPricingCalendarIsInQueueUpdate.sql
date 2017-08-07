/*******************************************************************************
 * usp_DailyPricingCalendarIsInQueueUpdate
 * Gets daily pricing calendar is in queue flag for specified date
 *
 * History
 *******************************************************************************
 * 2/21/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingCalendarIsInQueueUpdate]
	@ID			int,
	@IsInQueue	tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
	UPDATE	DailyPricingCalendar
	SET		IsInQueue	= @IsInQueue
	WHERE	ID			= @ID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingCalendarIsInQueueUpdate';

