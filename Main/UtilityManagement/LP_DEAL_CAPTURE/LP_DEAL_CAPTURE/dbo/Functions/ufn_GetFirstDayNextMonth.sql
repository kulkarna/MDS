/*******************************************************************************
 * ufn_GetFirstDayNextMonth
 * Advances specified date to beginning of next month
 *
 * History
 *******************************************************************************
 * 7/15/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE FUNCTION [dbo].[ufn_GetFirstDayNextMonth]
(
	@Date	datetime
)
RETURNS datetime
AS
BEGIN
	DECLARE	@Year		int,
			@Month		int,
			@NewDate	datetime
			
	SET	@Year	= DATEPART(yyyy, GETDATE())
	SET	@Month	= DATEPART(mm, GETDATE())
	
	IF	@Month = 12
		BEGIN
			SET	@Month	= 1
			SET	@Year	= @Year + 1
		END
	ELSE
		BEGIN
			SET	@Month = @Month + 1
		END
		
	SET	@NewDate = CAST(@Year AS varchar(4)) + '-' + CAST(@Month AS varchar(2)) + '-01'

	RETURN @NewDate

END
-- Copyright 2010 Liberty Power
