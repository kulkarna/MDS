
--------------------------------------------------------------
--35684- Enable Data Cache update for Documents
--------------------------------------------------------
Use LibertyPower
Go

IF EXISTS(SELECT *
            FROM Libertypower..TabletDataCacheItem WITH (NoLock)
            WHERE TabletDataCacheItemID = 5
              AND EnableCache = 0)
    BEGIN

        UPDATE Libertypower..TabletDataCacheItem
        SET EnableCache=1, 
            TabletDataCacheUpdateFrequencyID=3
          WHERE TabletDataCacheItemID = 5
            AND EnableCache = 0;

    END;
GO
