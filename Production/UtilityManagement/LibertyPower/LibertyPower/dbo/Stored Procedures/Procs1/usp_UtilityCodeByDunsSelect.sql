/*******************************************************************************
 * usp_UtilityCodeByDunsSelect
 * Get utility code by utility duns number
 *
 * History
 *******************************************************************************
 * 10/22/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE usp_UtilityCodeByDunsSelect
	@UtilityDuns	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	UtilityCode
	FROM	UtilityDunsMapping WITH (NOLOCK)
	WHERE	UtilityDuns = @UtilityDuns
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
