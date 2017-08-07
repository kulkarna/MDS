

/*******************************************************************************
 * usp_FileMgrSelectFileMgr
 *
 *
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_FileMgrSelectFileMgr]  
	@ContextKey				varchar(50)                                                                                 

	
AS

SELECT FileManager.ID, FileManager.BusinessPurpose, FileManager.ContextKey, FileManager.CreationTime, FileManager.UserID,
ManagerRoot.ID, ManagerRoot.Root, ManagerRoot.IsActive, ManagerRoot.CreationTime, ManagerRoot.UserID
FROM FileManager LEFT JOIN ManagerRoot ON FileManager.ID = ManagerRoot.FileManagerID
WHERE ContextKey = @ContextKey AND ManagerRoot.IsActive = 1


                                                                                                                                          
-- Copyright 2009 Liberty Power

