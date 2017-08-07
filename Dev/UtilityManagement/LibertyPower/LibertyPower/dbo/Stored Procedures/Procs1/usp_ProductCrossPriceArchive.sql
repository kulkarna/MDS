
/*******************************************************************************
 * usp_ProductCrossPriceArchive
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceArchive]  
	
AS
return
--1) Archive/copy data to history table
insert into libertypower..ProductCrossPrice_History
Select * from libertypower..ProductCrossPrice (NoLock)
Where CostRateExpirationDate < getdate()

IF @@ERROR = 0
	BEGIN
		--2) Delete data copied data from production table
		Delete from libertypower..ProductCrossPrice
		Where CostRateExpirationDate < getdate()	
	END
	
-- Copyright 2010 Liberty Power

