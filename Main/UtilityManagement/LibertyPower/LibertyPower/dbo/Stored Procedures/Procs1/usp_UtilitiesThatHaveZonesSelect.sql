/*******************************************************************************
 * usp_UtilitiesThatHaveZonesSelect
 * Gets utilities that have zones
 *
 * History
 *******************************************************************************
 * 12/26/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilitiesThatHaveZonesSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	DISTINCT m.UtilityID, u.UtilityCode, u.FullName, u.MarketID
	FROM	UtilityZoneMapping m WITH (NOLOCK)
			INNER JOIN LibertyPower..UtilityZone uz WITH (NOLOCK) ON m.UtilityZoneID = uz.ID
			INNER JOIN LibertyPower..Zone z WITH (NOLOCK) ON uz.ZoneID = z.ID
			INNER JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID
	ORDER BY u.UtilityCode    

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
