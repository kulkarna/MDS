
/*******************************************************************************
 * usp_FileMgrGetFileContextByGuid
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_FileMgrGetFileContextByGuid]  
	@FileGuid	UNIQUEIDENTIFIER
AS

SELECT 
FileContext.FileGuid, 
FileManager.ContextKey,
ManagerRoot.Root, 
ManagedBin.RelativePath, 
FileContext.FileName, 
FileContext.OriginalFileName, 
FileContext.CreationTime, 
FileContext.UserID
FROM FileContext  
LEFT JOIN ManagedBin 
ON FileContext.ManagedBinID = ManagedBin.[ID]
INNER JOIN ManagerRoot 
ON ManagedBin.ManagerRootID = ManagerRoot.[ID]
INNER JOIN FileManager
ON ManagerRoot.FileManagerID = FileManager.ID
WHERE FileContext.FileGuid = @FileGuid

                                                                                                                                          
-- Copyright 2009 Liberty Power
