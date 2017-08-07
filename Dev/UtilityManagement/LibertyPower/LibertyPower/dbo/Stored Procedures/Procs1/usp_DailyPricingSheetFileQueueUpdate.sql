/*******************************************************************************
 * usp_DailyPricingSheetFileQueueUpdate
 * Updates queue to sent
 *
 * History
 *******************************************************************************
 * 6/28/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingSheetFileQueueUpdate]
	@DailyPricingSheetFileQueueID	int,
	@FileSent						tinyint,
	@DateSent						datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ID	int

	UPDATE	DailyPricingSheetFileQueue 
	SET		FileSent				= @FileSent,
			DateSent				= @DateSent
	WHERE	ID	= @DailyPricingSheetFileQueueID
	
	SET	@ID = @@IDENTITY
	
	SELECT	ID, DailyPricingSheetFileID, FileSent, DateSent
	FROM	DailyPricingSheetFileQueue WITH (NOLOCK)
	WHERE	ID = @ID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingSheetFileQueueUpdate';

