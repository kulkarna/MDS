/*******************************************************************************
 * usp_YearsSelect
 * Gets year values
 *
 * History
 *******************************************************************************
 * 8/5/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_YearsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	YearNumber
	FROM	[Year] WITH (NOLOCK)
	ORDER BY YearNumber
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
