/*******************************************************************************
 * usp_DailyPricingWorkflowQueueHeaderByWorkDaySelect
 * Gets header record for specified work day
 *
 * History
 *******************************************************************************
 * 3/24/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueHeaderByWorkDaySelect]
	@WorkDay	datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, DailyPricingCalendarIdentity, EffectiveDate, ExpirationDate, WorkDay, 
			DateCreated, CreatedBy, [Status], DateStarted, DateCompleted
    FROM	DailyPricingWorkflowQueueHeader WITH (NOLOCK)    
    WHERE	WorkDay = @WorkDay

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowQueueHeaderByWorkDaySelect';

