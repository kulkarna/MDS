

/*******************************************************************************
 * usp_FileMgrGetAllFileContextsByRelativePath
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_FileMgrGetAllFileContextsByRelativePath]  
	@ContextKey	varchar(256),
	@Root varchar(512),
	@RelativePath varchar(1024)                                                                                 
AS
DECLARE @FileManagerID INT
SET @FileManagerID = (SELECT ID FROM FileManager WHERE ContextKey = @ContextKey)

DECLARE @ManagerRootID INT
SET @ManagerRootID  = (SELECT ID FROM ManagerRoot WHERE FileManagerID =  @FileManagerID AND  [ROOT] = @Root)

DECLARE @ManagedBinID INT
SET @ManagedBinID = (SELECT ID FROM  ManagedBin WHERE  ManagerRootID = @ManagerRootID AND RelativePath = @RelativePath)

SELECT FileContext.FileGuid, FileManager.ContextKey, ManagerRoot.Root, ManagedBin.RelativePath, FileContext.FileName, FileContext.OriginalFileName, FileContext.CreationTime, FileContext.UserID
FROM FileContext  
LEFT JOIN ManagedBin ON FileContext.ManagedBinID = ManagedBin.[ID]
INNER JOIN ManagerRoot ON ManagedBin.ManagerRootID = ManagerRoot.[ID]
INNER JOIN FileManager ON ManagerRoot.FileManagerID = FileManager.ID
WHERE FileManager.ID = @FileManagerID AND ManagedBin.ManagerRootID = @ManagerRootID AND FileContext.ManagedBinID = @ManagedBinID 

                                                                                                                                          
-- Copyright 2009 Liberty Power

