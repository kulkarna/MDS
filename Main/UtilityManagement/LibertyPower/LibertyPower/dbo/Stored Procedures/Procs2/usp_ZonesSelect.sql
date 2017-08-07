/*******************************************************************************
 * usp_ZonesSelect
 * Gets zones
 *
 * History
 *******************************************************************************
 * 12/22/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ZonesSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, ZoneCode
    FROM	Zone WITH (NOLOCK)	

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
