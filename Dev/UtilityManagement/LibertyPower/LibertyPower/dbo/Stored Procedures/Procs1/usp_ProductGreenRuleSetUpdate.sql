/*******************************************************************************
 * usp_ProductGreenRuleSetUpdate
 * Updates green rule set
 *
 * History
 *******************************************************************************
 * 3/15/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductGreenRuleSetUpdate]
	@ProductGreenRuleSetID	int,
	@FileGuid				uniqueidentifier,
	@UploadedBy				int,
	@UploadStatus			int
AS
BEGIN
    SET NOCOUNT ON;

	UPDATE	ProductGreenRuleSet
	SET		FileGuid				= @FileGuid, 
			UploadedBy				= @UploadedBy, 
			UploadedDate			= GETDATE(), 
			UploadStatus			= @UploadStatus
	WHERE	ProductGreenRuleSetID	= @ProductGreenRuleSetID  
	
	SELECT	ProductGreenRuleSetID, FileGuid, UploadedBy, UploadedDate, UploadStatus
	FROM	LibertyPower..ProductGreenRuleSet WITH (NOLOCK)
	WHERE	ProductGreenRuleSetID = @ProductGreenRuleSetID  	

    SET NOCOUNT OFF;
END
-- Copyright 2013 Liberty Power
