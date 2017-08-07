
/*******************************************************************************
 * usp_FileMgrInsertManagedBin
 *
 *
 ******************************************************************************/
 CREATE PROCEDURE [dbo].[usp_FileMgrInsertManagedBin]
	@ContextKey				varchar(50),   
	@Root							varchar(512),                                                                                 
	@RelativePath				varchar(256),
	@UserID						INT
AS
BEGIN TRANSACTION

DECLARE @FileManagerID INT
DECLARE @ManagerRootID INT

SET @FileManagerID = (SELECT ID FROM FileManager WHERE ContextKey = @ContextKey )
SET @ManagerRootID = (SELECT ID FROM  ManagerRoot WHERE  FileManagerID = @FileManagerID AND  root = @Root)

INSERT INTO  ManagedBin (ManagerRootID, RelativePath, ItemCount, UserID)
VALUES (@ManagerRootID, @RelativePath, 0, @UserID);

DECLARE @ID INT
SET @ID = SCOPE_IDENTITY()     

SELECT 
ManagedBin.ID,
FileManager.ContextKey,
ManagerRoot.Root,
ManagedBin.RelativePath,
ManagedBin.ItemCount,
ManagedBin.CreationTime,
ManagedBin.UserId
FROM ManagedBin LEFT JOIN ManagerRoot ON ManagedBin.ManagerRootID = ManagerRoot.ID
INNER JOIN FileManager ON ManagerRoot.FileManagerID = FileManager.ID
WHERE ManagedBin.[ID] = @ID
ORDER BY ManagedBin.ItemCount, ManagedBin.ID desc  


IF @@ERROR = 0
	COMMIT
ELSE
	ROLLBACK

