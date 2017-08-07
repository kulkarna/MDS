/*******************************************************************************
 * usp_DailyPricingSheetFilesSelectByChannelID
 * Gets the latest pricing sheet file data for specified date and Sales Channel
 * and by date
 * History
 *******************************************************************************
 * 9/4/2012 - Al Tafur
 * Created.
 * 9/2/2010 Updated - George Worthington 
 * Updated to only display files that are marked as "sent"
EXEC [usp_DailyPricingSheetFilesSelectByChannelIDByDate] 27,'2010-07-27 00:00:00.000' 

SELECT TOP 1 * 
FROM	LIBERTYPOWER.dbo.DailyPricingSheetFile f WITH (NOLOCK)
		JOIN	LIBERTYPOWER.dbo.DailyPricingSheetFileQueue q WITH (NOLOCK) on f.Id = q.DailyPricingSheetFileId
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingSheetFilesSelectByChannelIDByDate]
	@ChannelID	int,
	@PriceSheetDate DateTime
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	f.ID, FileGuid, [File], OriginalFileName, SalesChannelID, FileDate
	FROM	LIBERTYPOWER.dbo.DailyPricingSheetFile f WITH (NOLOCK)
		JOIN	LIBERTYPOWER.dbo.DailyPricingSheetFileQueue q WITH (NOLOCK) on f.Id = q.DailyPricingSheetFileId
	WHERE	FileDate = @PriceSheetDate
	AND		SalesChannelID = @ChannelID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power