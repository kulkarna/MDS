USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheItembySalesChannelIdandCacheitemName]    Script Date: 04/09/2014 16:40:56 ******/

IF EXISTS(SELECT *
            FROM sys.objects
            WHERE object_id = OBJECT_ID(N'[dbo].[usp_TabletDataCacheItembySalesChannelIdandCacheitemName]')
              AND type IN(N'P', N'PC'))
    BEGIN
        DROP PROCEDURE dbo.usp_TabletDataCacheItembySalesChannelIdandCacheitemName
    END;
GO

USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheItembySalesChannelIdandCacheitemName]    Script Date: 04/09/2014 16:40:56 ******/

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

/*******************************************************************************
* PROCEDURE:     [usp_TabletDataCacheItembySalesChannelIdandCacheitemName]
* PURPOSE:       Get the Tablet Cache Details for a given CacheitemId and SalesChannel
* SalesChannelId is used if the itemType is for each salesChannel else it is considered to be global 
and we will give top 1 order by modified date for a given cacheitemID
*******************************************************************************
* 4/9/2014
* Created.
*******************************************************************************
exec dbo.usp_TabletDataCacheItembySalesChannelIdandCacheitemName @p_TabletDataCacheItemName='Pricing', 
                                                                           @p_SalesChannelID=1218
*/

CREATE PROCEDURE dbo.usp_TabletDataCacheItembySalesChannelIdandCacheitemName @p_TabletDataCacheItemName varchar(100), 
                                                                           @p_SalesChannelID int
AS
BEGIN
    -- set nocount on and default isolation level
    SET NOCOUNT ON;
    --SET NO_BROWSETABLE OFF

    DECLARE @CacheItemType int;
     DECLARE @CacheItemId int;

    SELECT @CacheItemType=I.TabletDataCacheItemTypeID,
    @CacheItemId= ISNULL(I.TabletDataCacheItemID,0)
      FROM Libertypower..TabletDataCacheItem I WITH (NoLock)
            WHERE I.CacheItemName like @p_TabletDataCacheItemName;

--//2- For each SalesChannel
--1= Global
If (@CacheItemId>0)
BEGIN
    IF @CacheItemType = 2
        BEGIN

            SELECT TOP 1 *
              FROM LIbertypower..TabletDataCache T WITH (NoLock)
              WHERE T.TabletDataCacheItemID = @CacheItemId
                AND T.ChannelID = @p_SalesChannelID
              ORDER BY T.DateModified DESC;

        END;
    ELSE
        BEGIN
            SELECT TOP 1 *
              FROM LIbertypower..TabletDataCache T WITH (NoLock)
              WHERE T.TabletDataCacheItemID = @CacheItemId
               AND T.ChannelID is NULL
              ORDER BY T.DateModified DESC;
        END;

END


    SET NOCOUNT OFF;
END;

GO


