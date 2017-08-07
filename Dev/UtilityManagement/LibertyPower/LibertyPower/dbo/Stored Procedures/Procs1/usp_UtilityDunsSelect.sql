
/*******************************************************************************
 * usp_UtilityDunsSelect
 * Selects utility code and duns numbers
 *
 * History
 *******************************************************************************
 * 4/7/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityDunsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	UtilityCode, DunsNumber, MarketCode
	FROM	UtilityDuns WITH (NOLOCK)
	ORDER BY UtilityCode

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

