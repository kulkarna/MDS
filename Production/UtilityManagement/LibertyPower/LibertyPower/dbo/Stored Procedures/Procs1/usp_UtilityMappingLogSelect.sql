/*******************************************************************************
 * usp_UtilityMappingLogSelect
 * Gets utility mapping record for specified record identifier
 *
 * History
 *******************************************************************************
 * 6/6/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityMappingLogSelect]
	@Identity	int
AS
BEGIN
    SET NOCOUNT ON;
	
	SELECT	ID, AccountNumber, UtilityID, [Message], SeverityLevel, LpcApplication, DateCreated
	FROM	UtilityMappingLog WITH (NOLOCK)
	WHERE	ID = @Identity
	
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
