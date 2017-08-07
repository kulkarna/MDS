

/*******************************************************************************
 * usp_ProductCrossPriceSetGetByDate
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceSetGetByDate]  
	@EffectiveDate			DateTime
AS
	SELECT TOP 1 [ProductCrossPriceSetID]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[DateCreated]
      ,[CreatedBy]
	FROM [LibertyPower].[dbo].[ProductCrossPriceSet]  WITH (NOLOCK)
	WHERE @EffectiveDate BETWEEN [EffectiveDate] AND [ExpirationDate]
	ORDER BY [ProductCrossPriceSetID] DESC

	
-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCrossPriceSetGetByDate';

