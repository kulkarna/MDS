/********************************************************************************
 * Creates the ExpirationDate column in TabletDataCacheItem table if not 
 * existing.
 *
 * History
 *******************************************************************************
 * 05/26/2015 - Fernando Alves
 * PBI 73366 - Adds a ExpirationDate column in the TabletDataCacheItem table to
 * allow custom expiration dates for cache items. If NULL end of current day is 
 * used as expiration date.
 *******************************************************************************
 */
USE Libertypower;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

BEGIN TRY
    BEGIN TRANSACTION
		IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TabletDataCacheItem' AND COLUMN_NAME = 'ExpirationDate') 
			BEGIN
				ALTER TABLE TabletDataCacheItem ADD ExpirationDate DATETIME NULL;
			END
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    RAISERROR (N'Error while adding TabletDataCacheItem.ExpirationDate column', 1, 1);
END CATCH;
GO
