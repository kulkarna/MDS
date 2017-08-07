/*******************************************************************************
 * usp_ProductConfigurationProductsSelect
 * Gets distinct product in product configuration table
 *
 * History
 *******************************************************************************
 * 6/11/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationProductsSelect]

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	DISTINCT pc.ProductName, pc.ProductTypeID, pc.ProductBrandID, pb.Name, pb.IsCustom, pb.IsMultiTerm
	FROM	LibertyPower..ProductConfiguration pc WITH (NOLOCK)
			INNER JOIN LibertyPower..OfferActivation o WITH (NOLOCK) 
			ON pc.ProductConfigurationID = o.ProductConfigurationID				
			INNER JOIN LibertyPower..ProductBrand pb WITH (NOLOCK)
			ON pc.ProductBrandID = pb.ProductBrandID
	ORDER BY 1		

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
