/*******************************************************************************
 * usp_MarketsThatHaveZonesSelect
 * Gets markets that have zones
 *
 * History
 *******************************************************************************
 * 12/24/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_MarketsThatHaveZonesSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	DISTINCT u.MarketID, mkt.MarketCode, mkt.RetailMktDescp
	FROM	UtilityZoneMapping m WITH (NOLOCK)
			INNER JOIN LibertyPower..UtilityZone uz WITH (NOLOCK) ON m.UtilityZoneID = uz.ID
			INNER JOIN LibertyPower..Zone z WITH (NOLOCK) ON uz.ZoneID = z.ID
			INNER JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID
	ORDER BY mkt.MarketCode    

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
