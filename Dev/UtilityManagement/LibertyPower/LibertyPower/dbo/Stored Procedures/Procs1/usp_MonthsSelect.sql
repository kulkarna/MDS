/*******************************************************************************
 * usp_MonthsSelect
 * Gets months - Took a looong time for this description!
 *
 * History
 *******************************************************************************
 * 8/5/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_MonthsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	MonthText, MonthNumber
	FROM	[Month] WITH (NOLOCK)
	ORDER BY MonthNumber
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
