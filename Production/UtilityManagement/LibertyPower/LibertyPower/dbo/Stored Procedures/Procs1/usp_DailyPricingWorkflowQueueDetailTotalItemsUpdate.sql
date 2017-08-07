/*******************************************************************************
 * usp_DailyPricingWorkflowQueueDetailTotalItemsUpdate
 * Updates total items
 *
 * History
 *******************************************************************************
 * 3/8/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueDetailTotalItemsUpdate]
	@Identity		int,
	@TotalItems		int
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE	DailyPricingWorkflowQueueDetail
    SET		TotalItems	= @TotalItems
	WHERE	ID				= @Identity
    
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowQueueDetailTotalItemsUpdate';

