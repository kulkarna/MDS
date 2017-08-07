/*******************************************************************************
 * usp_ProductGreenRuleSetInsert
 * Inserts green rule set
 *
 * History
 *******************************************************************************
 * 3/13/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductGreenRuleSetInsert]
	@FileGuid		uniqueidentifier,
	@UploadedBy		int,
	@UploadStatus	int
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE	@ProductGreenRuleSetID int

	INSERT INTO	ProductGreenRuleSet( FileGuid, UploadedBy, UploadedDate, UploadStatus)
	VALUES		( @FileGuid, @UploadedBy, GETDATE(), @UploadStatus)

	SET	@ProductGreenRuleSetID = SCOPE_IDENTITY()

	SELECT	ProductGreenRuleSetID, FileGuid, UploadedBy, UploadedDate, UploadStatus
	FROM	LibertyPower..ProductGreenRuleSet WITH (NOLOCK)
	WHERE	ProductGreenRuleSetID = @ProductGreenRuleSetID  

    SET NOCOUNT OFF;
END
-- Copyright 2013 Liberty Power
