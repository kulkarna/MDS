/*******************************************************************************
 * usp_DailyPricingSheetFileQueueInsert
 * Inserts daily pricing sheet file ID in queue
 *
 * History
 *******************************************************************************
 * 6/28/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingSheetFileQueueInsert]
	@DailyPricingSheetFileID	int,
	@FileSent					tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ID	int

	INSERT INTO	DailyPricingSheetFileQueue (DailyPricingSheetFileID, FileSent)
	VALUES		(@DailyPricingSheetFileID, @FileSent)
	
	SET	@ID = @@IDENTITY
	
	SELECT	ID, DailyPricingSheetFileID, FileSent, DateSent
	FROM	DailyPricingSheetFileQueue WITH (NOLOCK)
	WHERE	ID = @ID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingSheetFileQueueInsert';

