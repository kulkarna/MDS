/*******************************************************************************
 * usp_ProductConfigurationPriceTierInsert
 * Inserts price tier for product configuration
 *
 * History
 *******************************************************************************
 * 4/10/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationPriceTierInsert]
	@ProductConfigurationID	int,
	@PriceTierID			int
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO	ProductConfigurationPriceTiers (ProductConfigurationID, PriceTierID)
    VALUES		(@ProductConfigurationID, @PriceTierID)

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
