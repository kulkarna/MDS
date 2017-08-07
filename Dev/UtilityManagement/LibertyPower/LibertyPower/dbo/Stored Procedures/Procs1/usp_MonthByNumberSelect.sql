/*******************************************************************************
 * usp_MonthByNumberSelect
 * Get month by numeric value - Took a looong time for this description!
 *
 * History
 *******************************************************************************
 * 8/27/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_MonthByNumberSelect]
@MonthNumber	int
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	MonthText, MonthNumber
	FROM	[Month] WITH (NOLOCK)
	WHERE	MonthNumber = @MonthNumber
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
