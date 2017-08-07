/*******************************************************************************
 * usp_DailyPricingWorkflowQueueDetailByHeaderIDSelect
 * Gets all detail records for specified header ID
 *
 * History
 *******************************************************************************
 * 3/3/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueDetailByHeaderIDSelect]
	@WorkflowHeaderID	int
AS
BEGIN
    SET NOCOUNT ON;  
    
    SELECT	ID, WorkflowHeaderID, ProcessId, ScheduledRunTime, 
			[Status], ItemsProcessed, TotalItems, DateStarted, DateCompleted
    FROM	DailyPricingWorkflowQueueDetail WITH (NOLOCK) 
    WHERE	WorkflowHeaderID = @WorkflowHeaderID
    ORDER BY ProcessId

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowQueueDetailByHeaderIDSelect';

