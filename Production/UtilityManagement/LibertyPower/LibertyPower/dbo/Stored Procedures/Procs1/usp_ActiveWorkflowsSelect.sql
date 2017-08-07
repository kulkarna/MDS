/*******************************************************************************
 * usp_ActiveWorkflowsSelect
 * Gets workflows that have not been completed
 *
 * History
 *******************************************************************************
 * 2/22/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ActiveWorkflowsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, DailyPricingCalendarIdentity, EffectiveDate, ExpirationDate, 
			WorkDay, DateCreated, CreatedBy, Status, DateStarted, DateCompleted
	FROM	LibertyPower..DailyPricingWorkflowQueueHeader WITH (NOLOCK)
	WHERE	Status IN (0, 1) -- Active or Running


    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
