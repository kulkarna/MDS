USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductGreenRuleSetInsert]    Script Date: 03/15/2013 15:47:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductGreenRuleSetInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductGreenRuleSetInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductGreenRuleSetInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
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
' 
END
GO
