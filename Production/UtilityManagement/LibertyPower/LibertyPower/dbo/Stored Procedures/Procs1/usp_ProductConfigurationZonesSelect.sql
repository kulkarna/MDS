/*******************************************************************************
 * usp_ProductConfigurationZonesSelect
 * Gets distinct zones in product configuration table
 *
 * History
 *******************************************************************************
 * 6/10/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationZonesSelect]

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	DISTINCT p.ZoneID, z.utility_id + ' - ' + z.zone zone
	FROM	LibertyPower..ProductConfiguration p WITH (NOLOCK)
			INNER JOIN lp_common..zone z  WITH (NOLOCK) 
			ON p.ZoneID = z.zone_id
			INNER JOIN LibertyPower..OfferActivation o WITH (NOLOCK) 
			ON p.ProductConfigurationID = o.ProductConfigurationID
	ORDER BY 2			

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductConfigurationZonesSelect';

