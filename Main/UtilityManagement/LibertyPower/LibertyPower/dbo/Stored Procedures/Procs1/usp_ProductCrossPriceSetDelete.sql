
/*******************************************************************************
 * usp_ProductCrossPriceSetDelete
 *
 * Deletes cross price set for specified ID
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceSetDelete]  
	@ProductCrossPriceSetID	int
AS

DELETE
FROM	Libertypower..ProductCrossPrice
WHERE	ProductCrossPriceSetID = @ProductCrossPriceSetID
	
-- Copyright 2010 Liberty Power
