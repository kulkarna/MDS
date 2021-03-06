USE [LibertyPower];
GO
IF NOT EXISTS(SELECT NULL
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE table_name = 'TabletDataCacheUpdateFrequency'
                  AND column_name = 'CronSchedule')
    BEGIN

        ALTER TABLE TabletDataCacheUpdateFrequency
        ADD CronSchedule nvarchar(50)NULL;

    END;
GO



IF EXISTS(SELECT *
            FROM LIbertyPower..TabletDataCacheUpdateFrequency WITH (NOLock)
            WHERE TabletDataCacheUpdateFrequencyID = 1
              AND CronSchedule IS NULL)
    BEGIN
        UPDATE LIbertyPower..TabletDataCacheUpdateFrequency
        SET CronSchedule='0 0 0/6 * * ? *'
          WHERE TabletDataCacheUpdateFrequencyID = 1
            AND CronSchedule IS NULL;
    END;
GO

IF EXISTS(SELECT *
            FROM LIbertyPower..TabletDataCacheUpdateFrequency WITH (NOLock)
            WHERE TabletDataCacheUpdateFrequencyID = 2
              AND CronSchedule IS NULL)
    BEGIN
        UPDATE LIbertyPower..TabletDataCacheUpdateFrequency
        SET CronSchedule='0 0 0/4 * * ? *'
          WHERE TabletDataCacheUpdateFrequencyID = 2
            AND CronSchedule IS NULL;
    END;
GO

IF EXISTS(SELECT *
            FROM LIbertyPower..TabletDataCacheUpdateFrequency WITH (NOLock)
            WHERE TabletDataCacheUpdateFrequencyID = 3
              AND CronSchedule IS NULL)
    BEGIN
        UPDATE LIbertyPower..TabletDataCacheUpdateFrequency
        SET CronSchedule='0 0 0/2 * * ? *'
          WHERE TabletDataCacheUpdateFrequencyID = 3
            AND CronSchedule IS NULL;
    END;
GO


IF NOT EXISTS(SELECT *
            FROM LIbertyPower..TabletDataCacheUpdateFrequency WITH (NOLock)
            WHERE TabletDataCacheUpdateFrequencyID = 4
              )
    BEGIN
       Insert into  LIbertyPower..TabletDataCacheUpdateFrequency
        (FrequencyinMinutes,CronSchedule) Values ( 100,'0 0/5 * * * ? *')
        
    END;
GO


USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_GetTabletCacheFrequencies_Active]    Script Date: 04/24/2014 13:10:23 ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================
-- CREATED: Sara lakshmanan
-- Date:    4/2/2014
-- Description: Get Enabled cache items and their frequencies
--April 24  2014- Added CronSchedule
-- =============================================
ALTER PROC dbo.usp_GetTabletCacheFrequencies_Active
AS
BEGIN

    SET NOCOUNT ON;

    SELECT DISTINCT F.TabletDataCacheUpdateFrequencyID, 
                    F.FrequencyinMinutes, 
                    F.CronSchedule
      FROM Libertypower..TabletDataCacheUpdateFrequency F WITH (NoLock)
           INNER JOIN LIbertypower..TabletDataCacheItem I WITH (NoLock)
           ON F.TabletDataCacheUpdateFrequencyID = I.TabletDataCacheUpdateFrequencyID
      WHERE I.EnableCache = 1;
    SET NOCOUNT OFF;

END;
GO
     


USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMaxPromotionandQualifiersValues]    Script Date: 04/24/2014 13:42:10 ******/

IF EXISTS(SELECT *
            FROM sys.objects
            WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetMaxPromotionandQualifiersValues]')
              AND type IN(N'P', N'PC'))
    BEGIN
        DROP PROCEDURE dbo.usp_GetMaxPromotionandQualifiersValues
    END;
GO

USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMaxPromotionandQualifiersValues]    Script Date: 04/24/2014 13:42:10 ******/

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- =============================================
-- CREATED: Sara lakshmanan
-- Date:     4/24/2014
-- Description: Added to find if the PromotionCode- Qualifiers has changed
-- =============================================
CREATE PROC dbo.usp_GetMaxPromotionandQualifiersValues(@SalesChannelID int=NULL)
AS
BEGIN

    SET NOCOUNT ON;

    SELECT MAX(CreatedDate)MaxDate, 
           COUNT(QualifierId)MaxId
      FROM LibertyPower..Qualifier Q WITH (noLock)
      WHERE SalesChannelId = @SalesChannelID
         OR SalesChannelId IS NULL;

    SET NOCOUNT OFF;

END;


GO


IF EXISTS(SELECT *
            FROM Libertypower..TabletDataCacheItem WITH (NoLock)
            WHERE TabletDataCacheItemID = 2)
    BEGIN

        UPDATE Libertypower..TabletDataCacheItem
        SET EnableCache=1, 
            TabletDataCacheUpdateFrequencyID=2
          WHERE TabletDataCacheItemID = 2;

    END;
GO


IF EXISTS(SELECT *
            FROM Libertypower..TabletDataCacheItem WITH (NoLock)
            WHERE TabletDataCacheItemID = 4
              AND EnableCache = 0)
    BEGIN

        UPDATE Libertypower..TabletDataCacheItem
        SET EnableCache=1, 
            TabletDataCacheUpdateFrequencyID=3
          WHERE TabletDataCacheItemID = 4
            AND EnableCache = 0;

    END;
GO


------------------------------
IF NOT EXISTS(SELECT *
                FROM LIbertypower..TabletDataCacheItem
                WHERE CacheItemName = 'SalesChannel')
    BEGIN
        INSERT INTO LibertyPower..TabletDataCacheItem(CacheItemName, 
                                                      TabletDataCacheItemTypeID, 
                                                      CreatedDate, 
                                                      EnableCache, 
                                                      TabletDataCacheUpdateFrequencyID)
        VALUES('SalesChannel', 
               2, 
               GETDATE(), 
               1, 
               2);

    END;
  GO
-----------------------------------------


USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheUpdateforCacheItem]    Script Date: 04/25/2014 16:23:31 ******/
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

*/

ALTER PROCEDURE [dbo].[usp_TabletDataCacheUpdateforCacheItem] 
      @p_TabletDataCacheItemID int,
      @p_HashValue uniqueidentifier= null,
      @p_SalesChannelID int=null,
      @p_LastUpdated datetime = null,
      @p_ExpirationDate datetime = null
      
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

If exists(Select T.TabletDataCacheID from Libertypower..TabletDataCache T with (NoLock)
 where T.TabletDataCacheItemID= @p_TabletDataCacheItemID and (T.ChannelID= @p_SalesChannelID or
@p_SalesChannelID is NULL)  )
Begin

If (@p_HashValue is NULL)
Begin
  update LibertyPower..TabletDataCache set LastChanged=@p_LastUpdated, ExpirationDate=@p_ExpirationDate, 
  DateModified=GETDATE() 
           where TabletDataCacheItemID= @p_TabletDataCacheItemID and (ChannelID= @p_SalesChannelID or
@p_SalesChannelID is NULL)

End
Else
Begin

  update LibertyPower..TabletDataCache set HashValue=@p_HashValue, LastChanged=@p_LastUpdated, ExpirationDate=@p_ExpirationDate, 
  DateModified=GETDATE() 
           where TabletDataCacheItemID= @p_TabletDataCacheItemID and (ChannelID= @p_SalesChannelID or
@p_SalesChannelID is NULL)
END


END
Else
BEGIN

Declare @currentDate Datetime= getdate();

exec [usp_TabletDataCacheInsertforCacheItem] @p_TabletDataCacheItemID,@p_SalesChannelID,@p_HashValue,@currentDate,@currentDate
END
     
     
Select * from  LibertyPower..TabletDataCache With (NoLock) 
           where TabletDataCacheItemID= @p_TabletDataCacheItemID and (ChannelID= @p_SalesChannelID or
@p_SalesChannelID is NULL)     
            
Set NOCOUNT OFF;
END
-- Copyright 3/19/2013 Liberty Power
GO
USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheUpdateforCacheItem]    Script Date: 04/30/2014 16:51:37 ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO


/*******************************************************************************

* PROCEDURE:     [usp_TabletDataCacheUpdateforCacheItem]
* PURPOSE:       Update the Cache data for Tablet 
* HISTORY:       
*******************************************************************************
* 4/2/2014 Sara
* Created.
* Modified- added condition for Pricing- If pricing value didn't change then, we update only the DateModified
*******************************************************************************

*/

ALTER PROCEDURE dbo.usp_TabletDataCacheUpdateforCacheItem @p_TabletDataCacheItemID int, 
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
            EXEC usp_TabletDataCacheInsertforCacheItem @p_TabletDataCacheItemID, @p_SalesChannelID, @p_HashValue, @currentDate, @currentDate;
        END;


    SELECT *
      FROM LibertyPower..TabletDataCache WITH (NoLock)
      WHERE TabletDataCacheItemID = @p_TabletDataCacheItemID
        AND (ChannelID = @p_SalesChannelID
          OR @p_SalesChannelID IS NULL);

    SET NOCOUNT OFF;
END
GO


