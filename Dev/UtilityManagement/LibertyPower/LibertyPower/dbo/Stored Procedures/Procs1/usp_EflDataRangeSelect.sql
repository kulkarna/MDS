/*******************************************************************************
 * usp_EflDataRangeSelect
 * To get data ranges for EFL validation
 *
 * History
 *******************************************************************************
 * 7/20/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EflDataRangeSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	TermMin, TermMax, RateMin, RateMax, LpFixedMin, LpFixedMax
	FROM	EflDataRange
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
