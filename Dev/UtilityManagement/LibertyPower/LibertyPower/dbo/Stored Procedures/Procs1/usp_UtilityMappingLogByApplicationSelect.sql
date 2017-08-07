/*******************************************************************************
 * usp_UtilityMappingLogByApplicationSelect
 * Gets utility mapping records for LPC application from date specified
 *
 * History
 *******************************************************************************
 * 6/6/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityMappingLogByApplicationSelect]
	@LpcApplication	int,
	@DateFrom		datetime
AS
BEGIN
    SET NOCOUNT ON;
	
	SELECT	ID, AccountNumber, UtilityID, [Message], SeverityLevel, LpcApplication, DateCreated
	FROM	UtilityMappingLog WITH (NOLOCK)
	WHERE	LpcApplication	= @LpcApplication
	AND		DateCreated		>= @DateFrom
	
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
