/*******************************************************************************
 * usp_ProductGreenRuleSetGetAll
 * Gets all green rule sets
 *
 * History
 *******************************************************************************
 * 3/14/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductGreenRuleSetGetAll]

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	ProductGreenRuleSetID, FileGuid, UploadedBy, UploadedDate, UploadStatus
	FROM	LibertyPower..ProductGreenRuleSet WITH (NOLOCK)
	ORDER BY UploadedDate DESC

    SET NOCOUNT OFF;
END
-- Copyright 2013 Liberty Power
