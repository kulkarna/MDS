
/*******************************************************************************
 * usp_ProductCrossPriceSetGetById
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceSetGetById]  
	@ProductCrossPriceSetID					int
AS
	SELECT [ProductCrossPriceSetID]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[DateCreated]
      ,[CreatedBy]
	FROM [LibertyPower].[dbo].[ProductCrossPriceSet]  WITH (NOLOCK)
	WHERE [ProductCrossPriceSetID] = @ProductCrossPriceSetID                                                                                                                                
	
-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCrossPriceSetGetById';

