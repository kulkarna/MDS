/********************************************************************************
 * Updates the ExpirationDate column for the following cache items in the 
 * TabletDataCacheItem table, so that data will only expire in the 06/08/2015
 * due to a system scheduled intervention:
 * Documents, ExistingAccounts, MarketProducts, Pricing, 
 * PromotionCodeandQualifiers, SalesAgents, SalesChannel, ZipCode.
 *
 * History
 *******************************************************************************
 * 06/05/2015 - Fernando Alves
 * PBI 73366 - The Tablet cache update service should be able to set the 
 * expiration of all the cache items for any given date.
 *******************************************************************************
 */
USE Libertypower;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

BEGIN TRY
    BEGIN TRANSACTION
		SET NOCOUNT ON;
		
		DECLARE @ExpirationDate VARCHAR(23);
		SET @ExpirationDate = '2015-06-08 23:59:59.000'; -- Expiration date for this scheduled system intervention

		UPDATE LibertyPower..TabletDataCacheItem SET ExpirationDate=@ExpirationDate WHERE TabletDataCacheItemID=5;	-- Documents
		UPDATE LibertyPower..TabletDataCacheItem SET ExpirationDate=@ExpirationDate WHERE TabletDataCacheItemID=16; -- ExistingAccounts
		UPDATE LibertyPower..TabletDataCacheItem SET ExpirationDate=@ExpirationDate WHERE TabletDataCacheItemID=3;  -- MarketProducts
		UPDATE LibertyPower..TabletDataCacheItem SET ExpirationDate=@ExpirationDate WHERE TabletDataCacheItemID=1;  -- Pricing
		UPDATE LibertyPower..TabletDataCacheItem SET ExpirationDate=@ExpirationDate WHERE TabletDataCacheItemID=4;  -- PromotionCodeandQualifiers
		UPDATE LibertyPower..TabletDataCacheItem SET ExpirationDate=@ExpirationDate WHERE TabletDataCacheItemID=2;  -- SalesAgents
		UPDATE LibertyPower..TabletDataCacheItem SET ExpirationDate=@ExpirationDate WHERE TabletDataCacheItemID=14; -- SalesChannel
		UPDATE LibertyPower..TabletDataCacheItem SET ExpirationDate=@ExpirationDate WHERE TabletDataCacheItemID=9;  -- ZipCode
		
		SET NOCOUNT OFF;
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    RAISERROR (N'Error while updating TabletDataCacheItem.ExpirationDate column', 1, 1);
END CATCH;
GO
