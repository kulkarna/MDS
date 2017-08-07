/********************************************************************************
 * usp_GetTabletCacheItemExpirationDate
 * Return a tablet cache item expiration date based on the tablet data cache 
 * item id.
 *
 * History
 *******************************************************************************
 * <Date Created,date,> - Unknown
 * Created.
 *******************************************************************************
 * 05/29/2015 - Fernando Alves
 * PBI 73366 - Return a tablet cache item expiration date based on the tablet 
 * data cache item id.
 *
 * Example: exec usp_GetTabletCacheItemExpirationDate 1
 *******************************************************************************
 */
USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTabletCacheItemExpirationDate]    Script Date: 05/27/2015 09:35:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (select 1 from sys.objects where name='usp_GetTabletCacheItemExpirationDate' and type='P')
BEGIN
    DROP PROCEDURE [usp_GetTabletCacheItemExpirationDate]
END
GO
CREATE PROCEDURE [dbo].usp_GetTabletCacheItemExpirationDate
	@CacheItemID INT
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT 
		TabletDataCacheItemID, 
		CacheItemName, 
		TabletDataCacheItemTypeID, 
		CreatedDate, 
		EnableCache, 
		TabletDataCacheUpdateFrequencyID, 
		ExpirationDate 
	FROM 
		TabletDataCacheItem WITH (NOLOCK) 
	WHERE
		TabletDataCacheItemID = @CacheItemID
END
