/*******************************************************************************
 * usp_DailyPricingSheetFileInsert
 * Gets pricing sheet file data for specified date
 *
 * History
 *******************************************************************************
 * 6/28/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingSheetFileInsert]
	@FileGuid			varchar(100),
	@File				varchar(200),
	@OriginalFileName	varchar(200),
	@SalesChannelID		int,
	@FileDate	datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ID	int
    
    INSERT INTO	DailyPricingSheetFile (FileGuid, [File], OriginalFileName, SalesChannelID, FileDate)
    VALUES		(@FileGuid, @File, @OriginalFileName, @SalesChannelID, @FileDate)
    
    SET		@ID = @@IDENTITY

	SELECT	ID, FileGuid, [File], OriginalFileName, SalesChannelID, FileDate
	FROM	DailyPricingSheetFile WITH (NOLOCK)
	WHERE	ID = @ID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingSheetFileInsert';

