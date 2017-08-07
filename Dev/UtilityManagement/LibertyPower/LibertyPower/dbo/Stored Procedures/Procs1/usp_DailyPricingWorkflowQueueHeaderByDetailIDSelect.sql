/*******************************************************************************
 * usp_DailyPricingWorkflowQueueHeaderByDetailIDSelect
 * Gets header record for specified detail record identifier
 *
 * History
 *******************************************************************************
 * 3/17/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueHeaderByDetailIDSelect]
	@DetailIdentity	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	h.ID, h.DailyPricingCalendarIdentity, h.EffectiveDate, h.ExpirationDate, h.WorkDay, 
			h.DateCreated, h.CreatedBy, h.[Status], h.DateStarted, h.DateCompleted
    FROM	DailyPricingWorkflowQueueHeader h WITH (NOLOCK)   
			INNER JOIN DailyPricingWorkflowQueueDetail d  WITH (NOLOCK)
			ON h.ID = d.WorkflowHeaderID
    WHERE	d.ID = @DetailIdentity

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowQueueHeaderByDetailIDSelect';

