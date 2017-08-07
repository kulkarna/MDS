/*******************************************************************************
 * usp_ZonesForUtilitySelect
 * Gets the zones for specified utility
 *
 * History
 *******************************************************************************
 * 12/27/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ZonesForUtilitySelect]
	@UtilityID	int
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	DISTINCT z.ID, z.ZoneCode
	FROM	LibertyPower..UtilityZone uz WITH (NOLOCK)
			INNER JOIN LibertyPower..Zone z WITH (NOLOCK) ON uz.ZoneID = z.ID
			INNER JOIN LibertyPower..Utility u WITH (NOLOCK) ON uz.UtilityID = u.ID
	WHERE	u.ID = @UtilityID
	ORDER BY z.ZoneCode

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
