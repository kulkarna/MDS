/*******************************************************************************
 * usp_DailyPricingSheetFilesOnDemandSelectByChannelID
 * Gets the latest pricing sheet file data for specified Sales Channel
 *
 * History
 *******************************************************************************
 * 5/3/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingSheetFilesOnDemandSelectByChannelID]
	@ChannelID	int
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @FileDate	datetime,
			@Name		varchar(200)
			
	DECLARE	@FileNames	TABLE (Name varchar(200))
	DECLARE	@FileIDs	TABLE (ID int)

		SELECT	@FileDate = MAX( FileDate)
		FROM	LIBERTYPOWER.dbo.DailyPricingSheetFile f WITH (NOLOCK)
			Join LIBERTYPOWER.dbo.DailyPricingSheetFileQueue q WITH (NOLOCK) on f.Id = q.DailyPricingSheetFileId
		WHERE	SalesChannelID	= @ChannelID
		AND		q.FileSent		= 0
		
		INSERT INTO @FileNames
		SELECT	DISTINCT OriginalFileName
		FROM	LIBERTYPOWER.dbo.DailyPricingSheetFile f WITH (NOLOCK)
			JOIN	LIBERTYPOWER.dbo.DailyPricingSheetFileQueue q WITH (NOLOCK) on f.Id = q.DailyPricingSheetFileId
		WHERE	FileDate		= @FileDate
		AND		SalesChannelID	= @ChannelID
		AND		q.FileSent		= 0		
		
		WHILE (SELECT COUNT(Name) FROM @FileNames) > 0
			BEGIN
				SELECT TOP 1 @Name = Name FROM @FileNames
				
				INSERT INTO @FileIDs
				SELECT	MAX(ID)
				FROM	LIBERTYPOWER.dbo.DailyPricingSheetFile WITH (NOLOCK)
				WHERE	OriginalFileName = @Name
				
				DELETE FROM @FileNames WHERE Name = @Name
			END
				
		SELECT	f.ID, FileGuid, [File], OriginalFileName, SalesChannelID, FileDate
		FROM	LibertyPower..DailyPricingSheetFile f WITH (NOLOCK)
				INNER JOIN	LibertyPower..DailyPricingSheetFileQueue q WITH (NOLOCK) on f.Id = q.DailyPricingSheetFileId
		WHERE	f.ID IN (SELECT ID FROM @FileIDs)

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power