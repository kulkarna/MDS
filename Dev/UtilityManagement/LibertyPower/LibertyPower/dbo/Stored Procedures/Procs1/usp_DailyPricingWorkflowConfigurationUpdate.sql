/*******************************************************************************
 * usp_DailyPricingWorkflowConfigurationUpdate
 * Updates daily pricing workflow configuration data for specified key
 *
 * History
 *******************************************************************************
 * 2/18/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowConfigurationUpdate]
	@Key	int,
	@Value	varchar(200)
AS
BEGIN
    SET NOCOUNT ON;
    
	UPDATE	DailyPricingWorkflowConfiguration
	SET		Value	= @Value
	WHERE	[Key]	= @Key

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowConfigurationUpdate';

