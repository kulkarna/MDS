/*******************************************************************************
 * usp_DailyPricingWorkflowQueueDetailItemsProcessedUpdate
 * Updates items processed
 *
 * History
 *******************************************************************************
 * 3/8/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueDetailItemsProcessedUpdate]
	@Identity		int,
	@ItemsProcessed	int
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE	DailyPricingWorkflowQueueDetail
    SET		ItemsProcessed	= @ItemsProcessed
	WHERE	ID				= @Identity
    
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowQueueDetailItemsProcessedUpdate';

