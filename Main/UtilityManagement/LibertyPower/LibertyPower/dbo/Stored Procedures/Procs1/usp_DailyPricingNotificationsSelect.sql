/*******************************************************************************
 * usp_DailyPricingNotificationsSelect
 * Gets notification list
 *
 * History
 *******************************************************************************
 * 3/10/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingNotificationsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	ID, Name, Email, Phone, NotifyProcessComplete, NotifyAllProcessesComplete
	FROM	DailyPricingNotification WITH (NOLOCK)
	ORDER BY Name

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingNotificationsSelect';

