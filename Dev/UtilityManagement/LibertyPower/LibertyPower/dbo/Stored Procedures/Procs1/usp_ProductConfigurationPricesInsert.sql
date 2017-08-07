/*******************************************************************************
 * usp_ProductConfigurationPricesInsert
 * Inserts product confoguration and price mapping record
 *
 * History
 *******************************************************************************
 * 9/17/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationPricesInsert]
	@ProductConfigurationID	int,
	@PriceID				bigint
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ID	bigint
    
    INSERT INTO	ProductConfigurationPrices (ProductConfigurationID, PriceID)
    VALUES		(@ProductConfigurationID, @PriceID)
    
    SET	@ID = SCOPE_IDENTITY()
    
    SELECT	ID, ProductConfigurationID, PriceID
    FROM	ProductConfigurationPrices WITH (NOLOCK)
    WHERE	ID = @ID
    
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
