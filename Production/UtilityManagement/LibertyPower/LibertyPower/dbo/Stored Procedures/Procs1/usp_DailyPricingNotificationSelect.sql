/*******************************************************************************
 * usp_DailyPricingNotificationSelect
 * Gets notification for specified record identity
 *
 * History
 *******************************************************************************
 * 3/10/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingNotificationSelect]
	@Identity	int
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	ID, Name, Email, Phone
	FROM	DailyPricingNotification WITH (NOLOCK)
	WHERE	ID = @Identity

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingNotificationSelect';

