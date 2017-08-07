/*******************************************************************************
 * usp_ProductGreenRuleSetGetCurrent
 * Gets current green rule set
 *
 * History
 *******************************************************************************
 * 3/13/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductGreenRuleSetGetCurrent]

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	TOP 1 ProductGreenRuleSetID, FileGuid, UploadedBy, UploadedDate, UploadStatus
	FROM	LibertyPower..ProductGreenRuleSet WITH (NOLOCK)
	WHERE	UploadStatus = 2
	ORDER BY 1 DESC

    SET NOCOUNT OFF;
END
-- Copyright 2013 Liberty Power
