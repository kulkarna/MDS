/*******************************************************************************
 * usp_AccountTypesSelect
 * Gets account types
 *
 * History
 *******************************************************************************
 * 8/5/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountTypesSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	[ID], AccountType, [Description]
	FROM	AccountType WITH (NOLOCK)
	ORDER BY AccountType
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
