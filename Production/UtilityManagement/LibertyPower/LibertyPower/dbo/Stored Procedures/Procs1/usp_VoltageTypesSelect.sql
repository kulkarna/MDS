/*******************************************************************************
 * usp_VoltageTypesSelect
 * Gets all voltage types
 *
 * History
 *******************************************************************************
 * 12/2/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_VoltageTypesSelect]

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	ID, VoltageCode COLLATE sql_latin1_general_cp1_cs_as AS VoltageCode
	FROM	Voltage
	ORDER BY VoltageCode

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
