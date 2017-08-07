/*******************************************************************************
 * usp_ProductConfigurationPriceTiersDelete
 * Deletes price tiers for product configuration
 *
 * History
 *******************************************************************************
 * 4/10/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationPriceTiersDelete]
	@ProductConfigurationID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM	ProductConfigurationPriceTiers
    WHERE		ProductConfigurationID = @ProductConfigurationID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
