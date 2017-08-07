/*******************************************************************************
 * usp_UtilityClassMappingResultants
 * Gets utility class mapping resultants for specified determinants id
 *
 * History
 *******************************************************************************
 * 11/22/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityClassMappingResultantsSelect]
	@DeterminantsID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, DeterminantsID, Result
    FROM	UtilityClassMappingResultants WITH (NOLOCK)
    WHERE	DeterminantsID = @DeterminantsID


    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
