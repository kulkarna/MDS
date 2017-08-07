

/*******************************************************************************
 * usp_FileMgrGetAllFileContexts
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_FileMgrGetAllFileContexts]  
	@ContextKey	varchar(256)                                                                                 
AS
DECLARE @ID INT
SET @ID = (SELECT ID FROM FileManager WHERE ContextKey = @ContextKey)


SELECT FileContext.FileGuid, FileManager.ContextKey, ManagerRoot.Root, ManagedBin.RelativePath, FileContext.FileName, FileContext.OriginalFileName, FileContext.CreationTime, FileContext.UserID
FROM FileContext  
LEFT JOIN ManagedBin ON FileContext.ManagedBinID = ManagedBin.[ID]
INNER JOIN ManagerRoot ON ManagedBin.ManagerRootID = ManagerRoot.[ID]
INNER JOIN FileManager ON ManagerRoot.FileManagerID = FileManager.ID
WHERE FileManager.ID = @ID 

                                                                                                                                          
-- Copyright 2009 Liberty Power

