/*******************************************************************************
 * usp_DailyPricingNotificationUpdate
 * Updates notification for specified record identity
 *
 * History
 *******************************************************************************
 * 3/10/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingNotificationUpdate]
	@Identity					int,
	@Name						varchar(200),
	@Email						varchar(200),
	@Phone						varchar(50),
	@NotifyProcessComplete		tinyint,
	@NotifyAllProcessesComplete	tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
	UPDATE	DailyPricingNotification
	SET		Name						= @Name,
			Email						= @Email,
			Phone						= @Phone,
			NotifyProcessComplete		= @NotifyProcessComplete, 
			NotifyAllProcessesComplete	= @NotifyAllProcessesComplete
	WHERE	ID							= @Identity

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingNotificationUpdate';

