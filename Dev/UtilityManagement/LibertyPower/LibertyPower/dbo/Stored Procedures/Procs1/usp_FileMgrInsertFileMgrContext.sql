
/*******************************************************************************
 * usp_FileMgrInsertFileMgrContext
 *
 *
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_FileMgrInsertFileMgrContext]  
	@ContextKey				varchar(50),                                                                                  
	@BusinessPurpose	varchar(128),
	@UserID						INT 
AS

IF NOT EXISTS (SELECT ContextKey FROM FileManagerContext WHERE ContextKey = @ContextKey)
BEGIN 
		
	INSERT INTO	FileManagerContext (ContextKey, BusinessPurpose, UserID)
	VALUES		(@ContextKey, @BusinessPurpose, @UserID)
			
END

SELECT ID, ContextKey, BusinessPurpose 
FROM FileManagerContext
WHERE ContextKey = @ContextKey

                                                                                                                                          
-- Copyright 2009 Liberty Power




