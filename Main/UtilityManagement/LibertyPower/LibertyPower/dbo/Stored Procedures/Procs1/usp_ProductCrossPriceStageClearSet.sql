

/*******************************************************************************
 * usp_ProductCrossPriceStageClearSet
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceStageClearSet]  
	@PriceSetId int
AS

	

-- Delete data from stage table
Delete from libertypower..ProductCrossPrice_stage
Where [ProductCrossPriceSetID] = @PriceSetId
	
		

-- Copyright 2010 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCrossPriceStageClearSet';

