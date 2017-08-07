

/*******************************************************************************
 * usp_UtilityFileDelimitersSelect
 * Gets row and field delimiters for Edi files
 *
 * History
 *******************************************************************************
 * 3/29/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityFileDelimitersSelect]

AS
BEGIN
    SET NOCOUNT ON;

    SELECT	ID, UtilityCode, RowDelimiter, FieldDelimiter
    FROM	UtilityFileDelimiters WITH (NOLOCK)
    ORDER BY 2

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


