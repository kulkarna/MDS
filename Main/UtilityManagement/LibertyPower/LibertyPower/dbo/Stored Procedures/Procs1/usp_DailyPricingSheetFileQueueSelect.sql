/*******************************************************************************
 * usp_DailyPricingSheetFileQueueSelect
 * Gets daily pricing sheet files in queue
 *
 * History
 *******************************************************************************
 * 6/28/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingSheetFileQueueSelect]
	@FileSent	tinyint
AS
BEGIN
    SET NOCOUNT ON;
	
	SELECT	ID, DailyPricingSheetFileID, FileSent, DateSent
	FROM	DailyPricingSheetFileQueue WITH (NOLOCK)
	WHERE	FileSent = @FileSent

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingSheetFileQueueSelect';

