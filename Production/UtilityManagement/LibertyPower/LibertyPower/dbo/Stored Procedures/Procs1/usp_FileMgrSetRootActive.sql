
/*******************************************************************************
*	usp_FileMgrSetRootActive
*
*
********************************************************************************/
CREATE PROCEDURE [dbo].[usp_FileMgrSetRootActive]  
	@ContextKey	varchar(50) ,
	@Root	varchar(512)                                                                                   
AS
BEGIN TRANSACTION

DECLARE @ID int
SET @ID = 0
SET @ID = (      SELECT ID  FROM FileManager WHERE ContextKey =  @ContextKey			)

UPDATE ManagerRoot SET IsActive = 0 WHERE FileManagerID = @ID AND  IsActive = 1

UPDATE ManagerRoot SET IsActive = 1 WHERE FileManagerID = @ID AND Root = @Root

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
WHERE     ManagerRoot.IsActive = 1 AND  ManagerRoot.FileManagerID = @ID	


if @@ERROR = 0
	COMMIT                                                                                                                                       
ELSE
	ROLLBACK

-- Copyright 2009 Liberty Power

