/*******************************************************************************
 * usp_DailyPricingProcessConfigurationsSelect
 * Gets daily pricing process configurations
 *
 * History
 *******************************************************************************
 * 2/18/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingProcessConfigurationsSelect]

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	ID, ProcessId, ScheduledRunTime
	FROM	DailyPricingProcessConfiguration WITH (NOLOCK)
	ORDER BY ProcessId

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingProcessConfigurationsSelect';

