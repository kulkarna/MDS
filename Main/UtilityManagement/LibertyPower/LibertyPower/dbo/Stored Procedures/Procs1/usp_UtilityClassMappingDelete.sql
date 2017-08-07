/*******************************************************************************
 * usp_UtilityClassMappingDelete
 * Deletes utility class mapping for specified record identity
 *
 * History
 *******************************************************************************
 * 12/3/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityClassMappingDelete]
	@ID	int
AS
BEGIN
    SET NOCOUNT ON;
     
    DELETE FROM	UtilityClassMapping
    WHERE		ID	= @ID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
