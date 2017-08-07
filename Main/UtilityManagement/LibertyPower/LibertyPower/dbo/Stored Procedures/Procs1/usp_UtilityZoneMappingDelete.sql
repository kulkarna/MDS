/*******************************************************************************
 * usp_UtilityZoneMappingDelete
 * Deletes utility zone mapping record
 *
 * History
 *******************************************************************************
 * 12/6/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityZoneMappingDelete]
	@ID			int
AS
BEGIN
    SET NOCOUNT ON;
     
    DELETE FROM	UtilityZoneMapping
	WHERE		ID	= @ID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
