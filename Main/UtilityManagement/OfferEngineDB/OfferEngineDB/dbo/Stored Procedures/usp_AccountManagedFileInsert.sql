/*******************************************************************************
 * usp_AccountManagedFileInsert
 * Inserts account managed file record returning inserted data with record identifier.
 *
 * History
 *******************************************************************************
 * 5/19/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountManagedFileInsert]
	@AccountNumber	varchar(50), 
	@UtilityCode	varchar(50), 
	@FileType		tinyint, 
	@FileGuid		uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ID	int
    
	INSERT INTO	dbo.AccountManagedFiles
				(AccountNumber, UtilityCode, FileType, FileGuid, DateCreated)
	VALUES		(@AccountNumber, @UtilityCode, @FileType, @FileGuid, GETDATE())    
	
	SET	@ID = SCOPE_IDENTITY()
	
	SELECT	ID, AccountNumber, UtilityCode, FileType, FileGuid
	FROM	dbo.AccountManagedFiles WITH (NOLOCK)
	WHERE	ID = @ID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

