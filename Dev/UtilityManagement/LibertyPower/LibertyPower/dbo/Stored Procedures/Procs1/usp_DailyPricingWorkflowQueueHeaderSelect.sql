/*******************************************************************************
 * usp_DailyPricingWorkflowQueueHeaderSelect
 * Gets all header records
 *
 * History
 *******************************************************************************
 * 3/3/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueHeaderSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, DailyPricingCalendarIdentity, EffectiveDate, ExpirationDate, WorkDay, 
			DateCreated, CreatedBy, [Status], DateStarted, DateCompleted
    FROM	DailyPricingWorkflowQueueHeader WITH (NOLOCK)    
    ORDER BY WorkDay DESC

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowQueueHeaderSelect';

