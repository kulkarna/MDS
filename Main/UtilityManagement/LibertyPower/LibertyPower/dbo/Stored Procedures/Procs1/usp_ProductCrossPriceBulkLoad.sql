

/*******************************************************************************
 * usp_ProductCrossPriceBulkLoad
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceBulkLoad]  
	@PriceSetId int
AS

	

--1) Load/copy data from stage table to production table
insert into libertypower..ProductCrossPrice
Select * from libertypower..ProductCrossPrice_stage (NoLock)
Where [ProductCrossPriceSetID] = @PriceSetId

--2) Delete data copied data from stage table
Delete from libertypower..ProductCrossPrice_stage
Where [ProductCrossPriceSetID] = @PriceSetId
	
		

-- Copyright 2010 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCrossPriceBulkLoad';

