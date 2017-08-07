/*******************************************************************************
 * usp_DailyPricingWorkflowQueueDetailInsert
 * Inserts detail record, returning inserted data with record identifier
 *
 * History
 *******************************************************************************
 * 2/18/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueDetailInsert]
	@WorkflowHeaderID	int,
	@ProcessId			int,
	@ScheduledRunTime	datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ID	int
    
    UPDATE	DailyPricingWorkflowQueueDetail
    SET		ScheduledRunTime	= @ScheduledRunTime
	WHERE	WorkflowHeaderID	= @WorkflowHeaderID
	AND		ProcessId			= @ProcessId
    
	SET	@ID = SCOPE_IDENTITY()
    
    IF @ID IS NULL
		BEGIN
			INSERT INTO	DailyPricingWorkflowQueueDetail (WorkflowHeaderID, ProcessId, 
						ScheduledRunTime, Status, ItemsProcessed, TotalItems)
			VALUES		(@WorkflowHeaderID, @ProcessId, @ScheduledRunTime, 0, 0, 0)
			
			SET	@ID = SCOPE_IDENTITY()
    	END    
    
    SELECT	ID, WorkflowHeaderID, ProcessId, ScheduledRunTime, Status, ItemsProcessed, TotalItems, DateStarted, DateCompleted
    FROM	DailyPricingWorkflowQueueDetail WITH (NOLOCK)
    WHERE	ID = @ID


    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowQueueDetailInsert';

