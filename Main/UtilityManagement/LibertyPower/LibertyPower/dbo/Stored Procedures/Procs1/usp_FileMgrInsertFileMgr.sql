

/*******************************************************************************
 * usp_FileMgrInsertFileMgr
 *
 *
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_FileMgrInsertFileMgr]  
	@ContextKey				varchar(50),                                                                                  
	@BusinessPurpose	varchar(128),
	@Root							varchar(512),
	@UserID						INT
	
	
AS
BEGIN TRANSACTION

IF NOT EXISTS (SELECT ContextKey FROM FileManager WHERE ContextKey = @ContextKey)
BEGIN 
		
	INSERT INTO	FileManager (ContextKey, BusinessPurpose, UserID)
	VALUES		(@ContextKey, @BusinessPurpose, @UserID)
	
	DECLARE @ID INT
	SET @ID = SCOPE_IDENTITY()
	
	INSERT INTO ManagerRoot(FileManagerID, [Root], IsActive, UserID)
	VALUES (@ID, @Root, 1, @UserID)
			
END

SELECT FileManager.ID, FileManager.BusinessPurpose, FileManager.ContextKey, FileManager.CreationTime, FileManager.UserID,
ManagerRoot.ID, ManagerRoot.Root, ManagerRoot.IsActive, ManagerRoot.CreationTime, ManagerRoot.UserID
FROM FileManager LEFT JOIN ManagerRoot ON FileManager.ID = ManagerRoot.FileManagerID
WHERE ContextKey = @ContextKey

if @@ERROR = 0 
	COMMIT                                                                                                                                       
ELSE
	ROLLBACK
                                                                                                                                          
-- Copyright 2009 Liberty Power

