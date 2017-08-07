/*******************************************************************************
 * usp_ProductConfigurationProductTypesSelect
 * Gets distinct product types in product configuration table
 *
 * History
 *******************************************************************************
 * 6/10/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationProductTypesSelect]

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	DISTINCT pc.ProductTypeID, p.Name
	FROM	LibertyPower..ProductConfiguration pc WITH (NOLOCK)
			INNER JOIN LibertyPower..ProductType p  WITH (NOLOCK) 
			ON pc.ProductTypeID = p.ProductTypeID
			INNER JOIN LibertyPower..OfferActivation o WITH (NOLOCK) 
			ON pc.ProductConfigurationID = o.ProductConfigurationID				

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductConfigurationProductTypesSelect';

