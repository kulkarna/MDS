/*******************************************************************************
 * usp_AccountManagedFileSelect
 * Gets latest account managed file record for specified parameters.
 *
 * History
 *******************************************************************************
 * 5/19/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountManagedFileSelect]
	@AccountNumber	varchar(50),
	@UtilityCode	varchar(50),
	@FileType		tinyint
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	TOP 1 ID, AccountNumber, UtilityCode, FileType, FileGuid
	FROM	dbo.AccountManagedFiles WITH (NOLOCK)
	WHERE	AccountNumber	= @AccountNumber
	AND		UtilityCode		= @UtilityCode
	AND		FileType		= @FileType
	ORDER BY ID DESC

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

