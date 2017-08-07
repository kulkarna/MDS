

/*******************************************************************************
 * usp_FileMgrGetActiveRoot
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_FileMgrGetActiveRoot]  
	@ContextKey	varchar(50)                                                                               
AS
SELECT     
ManagerRoot.ID, 
ManagerRoot.FileManagerID,
FileManager.ContextKey,
ManagerRoot.Root, 
ManagerRoot.IsActive,
ManagerRoot.CreationTime,
ManagerRoot.UserID
FROM         ManagerRoot LEFT JOIN
                    FileManager 
ON ManagerRoot.FileManagerID = FileManager.ID
WHERE     FileManager.ContextKey = @ContextKey  
AND ManagerRoot.IsActive = 1

