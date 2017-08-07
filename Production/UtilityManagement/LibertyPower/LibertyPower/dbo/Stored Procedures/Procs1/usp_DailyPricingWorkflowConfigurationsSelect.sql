/*******************************************************************************
 * usp_DailyPricingWorkflowConfigurationsSelect
 * Gets daily pricing workflow configuration data
 *
 * History
 *******************************************************************************
 * 2/28/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowConfigurationsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	ID, [Key], Value
	FROM	DailyPricingWorkflowConfiguration WITH (NOLOCK)

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowConfigurationsSelect';

