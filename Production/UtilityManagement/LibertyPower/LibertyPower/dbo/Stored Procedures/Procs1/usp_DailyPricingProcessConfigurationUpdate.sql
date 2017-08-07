/*******************************************************************************
 * usp_DailyPricingProcessConfigurationUpdate
 * Updates daily pricing process configuration for specified process ID
 *
 * History
 *******************************************************************************
 * 3/1/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingProcessConfigurationUpdate]
	@ProcessId			int,
	@ScheduledRunTime	varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

	UPDATE	DailyPricingProcessConfiguration
	SET		ScheduledRunTime	= @ScheduledRunTime
	WHERE	ProcessId			= @ProcessId

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingProcessConfigurationUpdate';

