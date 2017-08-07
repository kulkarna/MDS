

/*******************************************************************************
 * usp_FileMgrGetAllFileRoots
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_FileMgrGetAllFileMgrRoots]  
	@ContextKey	varchar(256)                                                                                 
AS
DECLARE @ID int
SET @ID = (SELECT ID FROM FileManager WHERE ContextKey = @ContextKey)

SELECT ManagerRoot.ID, FileManager.ContextKey, FileManager.BusinessPurpose, 
ManagerRoot.Root, ManagerRoot.IsActive, ManagerRoot.CreationTime, 
ManagerRoot.UserID
FROM         ManagerRoot LEFT JOIN FileManager 
ON ManagerRoot.FileManagerID = FileManager.ID

                                                                                                                                          
-- Copyright 2009 Liberty Power

