/*******************************************************************************
 * usp_DailyPricingWorkflowQueueDetailStatusUpdate
 * Updates detail record status
 *
 * History
 *******************************************************************************
 * 3/7/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueDetailStatusUpdate]
	@Identity	int,
	@Status		tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE	DailyPricingWorkflowQueueDetail
    SET		[Status]	= @Status
	WHERE	ID			= @Identity
    
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowQueueDetailStatusUpdate';

