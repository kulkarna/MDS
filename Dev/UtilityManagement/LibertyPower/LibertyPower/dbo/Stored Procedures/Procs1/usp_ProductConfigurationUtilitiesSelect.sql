/*******************************************************************************
 * usp_ProductConfigurationUtilitiesSelect
 * Gets distinct utilities in product configuration table
 *
 * History
 *******************************************************************************
 * 6/10/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationUtilitiesSelect]

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	DISTINCT p.UtilityID, u.UtilityCode
	FROM	LibertyPower..ProductConfiguration p WITH (NOLOCK)
			INNER JOIN LibertyPower..Utility u  WITH (NOLOCK) 
			ON p.UtilityID = u.ID
			INNER JOIN LibertyPower..OfferActivation o WITH (NOLOCK) 
			ON p.ProductConfigurationID = o.ProductConfigurationID				
	ORDER BY 2
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductConfigurationUtilitiesSelect';

