/*******************************************************************************
 * usp_DailyPricingCalendarDaySelect
 * Gets daily pricing calendar day for specified date and workflow status
 *
 * History
 *******************************************************************************
 * 2/22/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingCalendarDaySelect]
	@Date	datetime
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	c.ID, c.[Date], c.IsWorkDay, c.IsInQueue, h.[Status] AS WorkflowStatus
	FROM	DailyPricingCalendar c WITH (NOLOCK)
			LEFT JOIN DailyPricingWorkflowQueueHeader h  WITH (NOLOCK)
			ON c.ID = h.DailyPricingCalendarIdentity
	WHERE	[Date] = @Date

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingCalendarDaySelect';

