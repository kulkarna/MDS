﻿/*******************************************************************************
 * usp_DailyPricingWorkflowQueueDetailSetStarted
 * Sets detail record to started with time stamp
 *
 * History
 *******************************************************************************
 * 2/23/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueDetailSetStarted]
	@Identity		int,
	@Status			tinyint,
	@DateStarted	datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE	DailyPricingWorkflowQueueDetail
    SET		DateStarted	= @DateStarted,
			[Status]	= @Status
	WHERE	ID			= @Identity
    
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowQueueDetailSetStarted';

