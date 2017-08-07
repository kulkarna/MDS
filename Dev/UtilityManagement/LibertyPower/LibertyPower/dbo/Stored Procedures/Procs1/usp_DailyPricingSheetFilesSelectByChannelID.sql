/*******************************************************************************
 * usp_DailyPricingSheetFilesSelectByChannelID
 * Gets the latest pricing sheet file data for specified date and Sales Channel
 *
 * History
 *******************************************************************************
 * 7/21/2010 - George Worthington
 * Created.
 * 9/2/2010 Updated - George Worthington 
 * Updated to only display files that are marked as "sent"
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingSheetFilesSelectByChannelID]
	@ChannelID	int
AS
BEGIN
    SET NOCOUNT ON;

DECLARE @FileDate	datetime

    SELECT	@FileDate = MAX( FileDate)
	FROM	LIBERTYPOWER.dbo.DailyPricingSheetFile f WITH (NOLOCK)
		Join LIBERTYPOWER.dbo.DailyPricingSheetFileQueue q WITH (NOLOCK) on f.Id = q.DailyPricingSheetFileId
	Where q.FileSent = 1	
	--WHERE	SalesChannelID = @ChannelID

	SELECT	f.ID, FileGuid, [File], OriginalFileName, SalesChannelID, FileDate
	FROM	LIBERTYPOWER.dbo.DailyPricingSheetFile f WITH (NOLOCK)
		JOIN	LIBERTYPOWER.dbo.DailyPricingSheetFileQueue q WITH (NOLOCK) on f.Id = q.DailyPricingSheetFileId
	WHERE	FileDate = @FileDate
	AND		SalesChannelID = @ChannelID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingSheetFilesSelectByChannelID';

