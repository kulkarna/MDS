/*******************************************************************************
 * usp_DailyPricingSheetFilesSelect
 * Gets pricing sheet file data for specified date
 *
 * History
 *******************************************************************************
 * 6/28/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingSheetFilesSelect]
	@FileDate	datetime
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	ID, FileGuid, [File], OriginalFileName, SalesChannelID, FileDate
	FROM	DailyPricingSheetFile WITH (NOLOCK)
	WHERE	FileDate = @FileDate

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingSheetFilesSelect';

