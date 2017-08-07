/*******************************************************************************
 * usp_DailyPricingWorkflowQueueDetailSelect
 * Gets detail record for specified record identifier
 *
 * History
 *******************************************************************************
 * 3/8/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueDetailSelect]
	@Identity	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, WorkflowHeaderID, ProcessId, ScheduledRunTime, Status, ItemsProcessed, TotalItems, DateStarted, DateCompleted
    FROM	DailyPricingWorkflowQueueDetail WITH (NOLOCK)
	WHERE	ID	= @Identity
    
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowQueueDetailSelect';

