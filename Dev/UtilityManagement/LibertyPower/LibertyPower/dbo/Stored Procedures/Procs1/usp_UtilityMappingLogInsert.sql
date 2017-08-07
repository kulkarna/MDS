/*******************************************************************************
 * usp_UtilityMappingLogInsert
 * Inserts utility mapping record, returning inserted data with record identifier
 *
 * History
 *******************************************************************************
 * 6/6/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityMappingLogInsert]
	@AccountNumber	varchar(50),
	@UtilityID		int,
	@Message		varchar(4000),
	@SeverityLevel	tinyint,
	@LpcApplication	tinyint,
	@DateCreated	datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@Identity	int
    
	INSERT INTO	UtilityMappingLog (AccountNumber, UtilityID, [Message], SeverityLevel, LpcApplication, DateCreated)
	VALUES		(@AccountNumber, @UtilityID, @Message, @SeverityLevel, @LpcApplication, @DateCreated)
	
	SET	@Identity = SCOPE_IDENTITY()
	
	SELECT	ID, AccountNumber, UtilityID, [Message], SeverityLevel, LpcApplication, DateCreated
	FROM	UtilityMappingLog WITH (NOLOCK)
	WHERE	ID = @Identity
	
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
