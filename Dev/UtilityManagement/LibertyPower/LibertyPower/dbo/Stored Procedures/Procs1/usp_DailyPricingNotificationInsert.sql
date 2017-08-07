/*******************************************************************************
 * usp_DailyPricingNotificationInsert
 * Inserts notification record returning inserted data with record identity
 *
 * History
 *******************************************************************************
 * 3/10/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingNotificationInsert]
	@Name						varchar(200),
	@Email						varchar(200),
	@Phone						varchar(50),
	@NotifyProcessComplete		tinyint,
	@NotifyAllProcessesComplete	tinyint	
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@Identity	int
    
    INSERT INTO	DailyPricingNotification (Name, Email, Phone, NotifyProcessComplete, NotifyAllProcessesComplete)
    VALUES		(@Name, @Email, @Phone, @NotifyProcessComplete, @NotifyAllProcessesComplete)
    
    SET	@Identity = SCOPE_IDENTITY()
    
	SELECT	ID, Name, Email, Phone, NotifyProcessComplete, NotifyAllProcessesComplete
	FROM	DailyPricingNotification WITH(NOLOCK)
	WHERE	ID = @Identity

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingNotificationInsert';

