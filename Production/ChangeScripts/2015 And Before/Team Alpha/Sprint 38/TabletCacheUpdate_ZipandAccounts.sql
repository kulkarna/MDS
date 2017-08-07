-------------------------------------------------------------------------
--TabletDataCacheUpdate Service
--Adding cache update logic to Zip and ExistingAccount CacheItems
--Aug 21 2014
--
-----------------------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMaxZipCode]    Script Date: 08/21/2014 11:00:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetMaxZipCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetMaxZipCode]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMaxZipCode]    Script Date: 08/21/2014 11:00:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- CREATED: Sara lakshmanan
-- Date:     8/18/2014
-- Description: Added to find if the ZipCode records have changed
-- =============================================
CREATE PROC [dbo].[usp_GetMaxZipCode]
AS
BEGIN

    SET NOCOUNT ON;
    DECLARE @ZipCodeChanged int;
    SET @ZipCodeChanged=0;

    SELECT 9 AS TabletDataCacheItemId, 
           NULL AS SalesChannelID, 
           COUNT(*)AS MaxID, 
           MAX(ModifiedDate)AS MaxDate, 
           NULL AS ExpirationDate, 
           MAX(ModifiedDate) AS LastChanged, 
           1 AS ItemChanged
      FROM LibertyPower..Zip WITH (noLock);

    SET NOCOUNT OFF;
END;


GO

---------------------------------------------------------------------

If not exists (Select * from LIbertypower..TabletDataCacheItem T (NoLock) where T.CacheItemName like 'ApplicationPackage' )
Begin
insert into LIbertyPower..TabletDataCacheItem (CacheItemName,TabletDataCacheItemTypeID,CreatedDate,EnableCache,TabletDataCacheUpdateFrequencyID)
Values  ('ApplicationPackage',1,GETDATE(),0,1)
End
GO

If not exists (Select * from LIbertypower..TabletDataCacheItem T (NoLock) where T.CacheItemName like 'ExistingAccounts' )
Begin
insert into LIbertyPower..TabletDataCacheItem (CacheItemName,TabletDataCacheItemTypeID,CreatedDate,EnableCache,TabletDataCacheUpdateFrequencyID)
Values  ('ExistingAccounts',1,GETDATE(),1,1)
End
GO

If exists (Select * from LIbertypower..TabletDataCacheItem T (NoLock) where T.CacheItemName like 'ZipCodes' )
Begin
Update  LIbertyPower..TabletDataCacheItem Set EnableCache=1 where  CacheItemName like 'ZipCodes'
End
GO


