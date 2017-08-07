/*******************************************************************************
 * usp_UtilityClassMappingDeterminantsSelect
 * Gets utility class mapping determinants for specified utility id
 *
 * History
 *******************************************************************************
 * 11/22/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityClassMappingDeterminantsSelect]
	@UtilityID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, UtilityID, Driver
    FROM	UtilityClassMappingDeterminants WITH (NOLOCK)
    WHERE	UtilityID = @UtilityID


    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
