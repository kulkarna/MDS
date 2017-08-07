

/*******************************************************************************
 * usp_usp_FileMgrInsertRoot
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_FileMgrInsertRoot]  
	@ContextKey				varchar(50),                                                                                  
	@Root							varchar(512),
	@IsActive						BIT,
	@UserID						INT 

AS
BEGIN TRANSACTION

	IF EXISTS (SELECT ContextKey FROM FileManager WHERE ContextKey = @ContextKey)
	BEGIN
		DECLARE @ID INT
		SET @ID = (SELECT ID FROM FileManager WHERE ContextKey = @ContextKey)

		IF NOT EXISTS (SELECT Root FROM ManagerRoot WHERE FileManagerID = @ID  AND  Root = @Root)
		BEGIN
			
			 --begin comment: using this to guarantee at least 1 is active after this insert
			DECLARE @Active BIT 
			IF(@IsActive = 0)
				SET @Active = 0
			ELSE
				SET @Active = 1

			IF @Active = 0						
			BEGIN
				DECLARE @ACTIVECOUNT INT
				SET @ACTIVECOUNT = (SELECT  COUNT(IsActive) FROM  ManagerRoot WHERE FileManagerID = @ID )
				IF (@ACTIVECOUNT = 0 AND @Active = 0 )
				BEGIN
					SET @Active = 1
				END
			END
			-- end comment: using this to guarantee at least 1 is active after this insert
			
			UPDATE ManagerRoot SET IsActive = 0
						
			INSERT INTO	 ManagerRoot (FileManagerID, Root, IsActive, UserID )
			VALUES		(@ID, @Root, @Active, @UserID)
			
		END
		
		SELECT ManagerRoot.ID, FileManager.ContextKey, FileManager.BusinessPurpose, ManagerRoot.Root, ManagerRoot.IsActive, ManagerRoot.CreationTime, ManagerRoot.UserID
			FROM         ManagerRoot LEFT JOIN FileManager 
			ON ManagerRoot.FileManagerID = FileManager.ID
				WHERE     (ManagerRoot.Root = @Root AND FileManager.ID = ManagerRoot.FileManagerID) 	
	END

IF @@ERROR = 0         
	COMMIT
ELSE
	ROLLBACK
	                                                                                                                                
-- Copyright 2009 Liberty Power

