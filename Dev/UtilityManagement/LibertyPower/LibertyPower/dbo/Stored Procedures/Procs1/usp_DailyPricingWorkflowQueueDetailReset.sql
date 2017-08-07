/*******************************************************************************
 * usp_DailyPricingWorkflowQueueDetailReset
 * Resets detail record for re-run
 *
 * History
 *******************************************************************************
 * 3/17/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueDetailReset]
	@Identity	int,
	@Status		tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE	DailyPricingWorkflowQueueDetail
    SET		[Status]		= @Status,
			ItemsProcessed	= 0,
			TotalItems		= 0,
			DateStarted		= NULL,
			DateCompleted	= NULL
	WHERE	ID				= @Identity
    
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowQueueDetailReset';

