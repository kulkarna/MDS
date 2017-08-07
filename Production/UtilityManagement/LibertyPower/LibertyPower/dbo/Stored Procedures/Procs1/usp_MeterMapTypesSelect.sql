/*******************************************************************************
 * usp_MeterMapTypesSelect
 * Gets all meter types for utility mapping
 *
 * History
 *******************************************************************************
 * 12/2/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_MeterMapTypesSelect]

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	ID, MeterTypeCode
	FROM	MeterType
	ORDER BY MeterTypeCode

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
