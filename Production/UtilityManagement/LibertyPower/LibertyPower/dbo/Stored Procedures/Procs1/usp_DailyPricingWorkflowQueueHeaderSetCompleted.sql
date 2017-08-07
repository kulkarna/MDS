/*******************************************************************************
 * usp_DailyPricingWorkflowQueueHeaderSetCompleted
 * Sets header record to complete with time stamp
 *
 * History
 *******************************************************************************
 * 2/23/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueHeaderSetCompleted]
	@Identity		int,
	@Status			tinyint,
	@DateCompleted	datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE	DailyPricingWorkflowQueueHeader
    SET		Status			= @Status,
			DateCompleted	= @DateCompleted
	WHERE	ID				= @Identity

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowQueueHeaderSetCompleted';

