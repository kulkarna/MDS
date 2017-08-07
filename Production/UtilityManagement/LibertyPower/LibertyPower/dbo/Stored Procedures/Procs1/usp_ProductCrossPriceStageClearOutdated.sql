

/*******************************************************************************
 * usp_ProductCrossPriceStageClearOutdated
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceStageClearOutdated]  
	@MaxCreatedDate DateTime
AS

	

Delete from libertypower..ProductCrossPrice_stage
Where DateCreated < @MaxCreatedDate
	
		

-- Copyright 2010 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCrossPriceStageClearOutdated';

