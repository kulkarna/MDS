/*******************************************************************************
 * usp_ProductConfigurationChannelTypesSelect
 * Gets distinct channel types in product configuration table
 *
 * History
 *******************************************************************************
 * 6/10/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationChannelTypesSelect]

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	DISTINCT c.ID, c.Name, c.[Description]
	FROM	LibertyPower..ProductConfiguration p WITH (NOLOCK)
			INNER JOIN LibertyPower..ChannelType c  WITH (NOLOCK) 
			ON p.ChannelTypeID = c.ID
			INNER JOIN LibertyPower..OfferActivation o WITH (NOLOCK) 
			ON p.ProductConfigurationID = o.ProductConfigurationID				

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductConfigurationChannelTypesSelect';

