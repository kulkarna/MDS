
/*******************************************************************************
 * usp_DailyPricingSheetFileQueueClearUnsent
 * Deletes all unsent files from the Queue
 *
 * History
 *******************************************************************************
 * 7/28/2010 - George Worthington
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingSheetFileQueueClearUnsent]
	
AS
BEGIN
    SET NOCOUNT ON;
	
	Delete
	FROM	DailyPricingSheetFileQueue 
	WHERE	FileSent = 0

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingSheetFileQueueClearUnsent';

