USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductGreenRuleSetGetAll]    Script Date: 03/14/2013 17:04:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductGreenRuleSetGetAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductGreenRuleSetGetAll]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductGreenRuleSetGetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
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
' 
END
GO
