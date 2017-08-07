/*******************************************************************************
 * usp_DailyPricingNotificationPhonesSelect
 * Gets phone notifications
 *
 * History
 *******************************************************************************
 * 3/10/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingNotificationPhonesSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	ID, Name, Email, Phone
	FROM	DailyPricingNotification WITH (NOLOCK)
	WHERE	LEN(Phone) > 0
	ORDER BY Name

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingNotificationPhonesSelect';

