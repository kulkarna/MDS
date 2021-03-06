USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheUpdateforCacheItem]    Script Date: 06/23/2014 12:54:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

* PROCEDURE:     [usp_TabletDataCacheUpdateforCacheItem]
* PURPOSE:       Update the Cache data for Tablet 
* HISTORY:       
*******************************************************************************
* 4/2/2014 Sara
* Created.
*******************************************************************************
6/23/2014  Sara modified 
Added ExpirationDate, input Parameter for procedure  [usp_TabletDataCacheInsertforCacheItem]
*******************************************************************************
*/

ALTER PROCEDURE [dbo].[usp_TabletDataCacheUpdateforCacheItem] @p_TabletDataCacheItemID int, 
                                                          @p_HashValue uniqueidentifier=NULL, 
                                                          @p_SalesChannelID int=NULL, 
                                                          @p_LastUpdated datetime=NULL, 
                                                          @p_ExpirationDate datetime=NULL
AS
BEGIN
    -- set nocount on and default isolation level
    SET NOCOUNT ON;
    --SET NO_BROWSETABLE OFF

    IF EXISTS(SELECT T.TabletDataCacheID
                FROM Libertypower..TabletDataCache T WITH (NoLock)
                WHERE T.TabletDataCacheItemID = @p_TabletDataCacheItemID
                  AND (T.ChannelID = @p_SalesChannelID
                    OR @p_SalesChannelID IS NULL))
        BEGIN

            IF @p_HashValue IS NULL
                BEGIN
                    IF @p_TabletDataCacheItemID = 1
                        BEGIN
                            UPDATE LibertyPower..TabletDataCache
                            SET DateModified=GETDATE()
                              WHERE TabletDataCacheItemID = @p_TabletDataCacheItemID
                                AND (ChannelID = @p_SalesChannelID
                                  OR @p_SalesChannelID IS NULL);

                        END;
                    ELSE
                        BEGIN
                            UPDATE LibertyPower..TabletDataCache
                            SET LastChanged=@p_LastUpdated, 
                                ExpirationDate=@p_ExpirationDate, 
                                DateModified=GETDATE()
                              WHERE TabletDataCacheItemID = @p_TabletDataCacheItemID
                                AND (ChannelID = @p_SalesChannelID
                                  OR @p_SalesChannelID IS NULL);

                        END;


                END;
            ELSE
                BEGIN

                    UPDATE LibertyPower..TabletDataCache
                    SET HashValue=@p_HashValue, 
                        LastChanged=@p_LastUpdated, 
                        ExpirationDate=@p_ExpirationDate, 
                        DateModified=GETDATE()
                      WHERE TabletDataCacheItemID = @p_TabletDataCacheItemID
                        AND (ChannelID = @p_SalesChannelID
                          OR @p_SalesChannelID IS NULL);
                END;


        END;
    ELSE
        BEGIN

            DECLARE @currentDate datetime=GETDATE();
            EXEC usp_TabletDataCacheInsertforCacheItem @p_TabletDataCacheItemID, @p_SalesChannelID, @p_HashValue, @currentDate, @currentDate,@p_ExpirationDate;
        END;


    SELECT *
      FROM LibertyPower..TabletDataCache WITH (NoLock)
      WHERE TabletDataCacheItemID = @p_TabletDataCacheItemID
        AND (ChannelID = @p_SalesChannelID
          OR @p_SalesChannelID IS NULL);

    SET NOCOUNT OFF;
END