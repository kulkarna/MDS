-------------------------------------
--1. Create Frequency table
--2. Add columns Enablecache and FrequencyId to the TabletCaheitem table
--3. Add Template table
--4. Add Audit table
----------------------------------------
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TabletDataCacheItem_TabletDataCacheUpdateFrequency]') AND parent_object_id = OBJECT_ID(N'[dbo].[TabletDataCacheItem]'))
ALTER TABLE [dbo].[TabletDataCacheItem] DROP CONSTRAINT [FK_TabletDataCacheItem_TabletDataCacheUpdateFrequency]
GO


-------------------------
USE [LibertyPower]
GO

/****** Object:  Table [dbo].[TabletDataCacheUpdateFrequency]    Script Date: 04/03/2014 09:12:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TabletDataCacheUpdateFrequency]') AND type in (N'U'))
DROP TABLE [dbo].[TabletDataCacheUpdateFrequency]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[TabletDataCacheUpdateFrequency]    Script Date: 04/03/2014 09:12:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TabletDataCacheUpdateFrequency](
	[TabletDataCacheUpdateFrequencyID] [int] IDENTITY(1,1) NOT NULL,
	[FrequencyinMinutes] [int] NOT NULL,
 CONSTRAINT [PK_TabletDataCacheUpdateFrequency] PRIMARY KEY CLUSTERED 
(
	[TabletDataCacheUpdateFrequencyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON,DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO


--------------------------------------------------------

--2.. Add columns

IF NOT EXISTS( SELECT NULL
            FROM INFORMATION_SCHEMA.COLUMNS
           WHERE table_name = 'TabletDataCacheItem'
             AND column_name = 'EnableCache')  
Begin

  ALTER TABLE TabletDataCacheItem ADD EnableCache bit NOT NULL default '0';
  
END
GO

IF NOT EXISTS( SELECT NULL
            FROM INFORMATION_SCHEMA.COLUMNS
           WHERE table_name = 'TabletDataCacheItem'
             AND column_name = 'TabletDataCacheUpdateFrequencyID')  
Begin

  ALTER TABLE TabletDataCacheItem ADD TabletDataCacheUpdateFrequencyID int NULL;
  
END
GO
---------------------------------------------------------------------
ALTER TABLE [dbo].[TabletDataCacheItem]  WITH CHECK ADD  CONSTRAINT [FK_TabletDataCacheItem_TabletDataCacheUpdateFrequency] FOREIGN KEY([TabletDataCacheUpdateFrequencyID])
REFERENCES [dbo].[TabletDataCacheUpdateFrequency] ([TabletDataCacheUpdateFrequencyID])
GO

ALTER TABLE [dbo].[TabletDataCacheItem] CHECK CONSTRAINT [FK_TabletDataCacheItem_TabletDataCacheUpdateFrequency]
GO

---------------------------------------
---3. Add template table
USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TableDataCacheTemplate_TabletDataCacheItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[TabletDataCacheTemplate]'))
ALTER TABLE [dbo].[TabletDataCacheTemplate] DROP CONSTRAINT [FK_TableDataCacheTemplate_TabletDataCacheItem]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TableDataCacheTemplate_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TabletDataCacheTemplate] DROP CONSTRAINT [DF_TableDataCacheTemplate_Active]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[TabletDataCacheTemplate]    Script Date: 04/03/2014 09:39:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TabletDataCacheTemplate]') AND type in (N'U'))
DROP TABLE [dbo].[TabletDataCacheTemplate]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[TabletDataCacheTemplate]    Script Date: 04/03/2014 09:39:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TabletDataCacheTemplate](
	[TabletDataCacheTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[TabletDataCacheItemId] [int] NOT NULL,
	[SalesChannelId] [int] NULL,
	[Active] [bit] NULL,
	[MaxId] [int] NULL,
	[MaxDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TabletDataCacheTemplate]  WITH CHECK ADD  CONSTRAINT [FK_TableDataCacheTemplate_TabletDataCacheItem] FOREIGN KEY([TabletDataCacheItemId])
REFERENCES [dbo].[TabletDataCacheItem] ([TabletDataCacheItemID])
GO

ALTER TABLE [dbo].[TabletDataCacheTemplate] CHECK CONSTRAINT [FK_TableDataCacheTemplate_TabletDataCacheItem]
GO

ALTER TABLE [dbo].[TabletDataCacheTemplate] ADD  CONSTRAINT [DF_TableDataCacheTemplate_Active]  DEFAULT ((1)) FOR [Active]
GO


-----------------------------------------------------------------------
--Audit table
-----------------------------------------
USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TabletDataCacheAudit_TabletDataCacheItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[TabletDataCacheAudit]'))
ALTER TABLE [dbo].[TabletDataCacheAudit] DROP CONSTRAINT [FK_TabletDataCacheAudit_TabletDataCacheItem]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TabletDataCacheAudit_Updated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TabletDataCacheAudit] DROP CONSTRAINT [DF_TabletDataCacheAudit_Updated]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[TabletDataCacheAudit]    Script Date: 04/03/2014 15:11:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TabletDataCacheAudit]') AND type in (N'U'))
DROP TABLE [dbo].[TabletDataCacheAudit]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[TabletDataCacheAudit]    Script Date: 04/03/2014 15:11:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TabletDataCacheAudit](
	[TabletDataCacheAuditId] [int] IDENTITY(1,1) NOT NULL,
	[TabletDataCacheItemId] [int] NOT NULL,
	[SalesChannelId] [int] NULL,
	[Updated] [bit] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TabletDataCacheAudit]  WITH CHECK ADD  CONSTRAINT [FK_TabletDataCacheAudit_TabletDataCacheItem] FOREIGN KEY([TabletDataCacheItemId])
REFERENCES [dbo].[TabletDataCacheItem] ([TabletDataCacheItemID])
GO

ALTER TABLE [dbo].[TabletDataCacheAudit] CHECK CONSTRAINT [FK_TabletDataCacheAudit_TabletDataCacheItem]
GO

ALTER TABLE [dbo].[TabletDataCacheAudit] ADD  CONSTRAINT [DF_TabletDataCacheAudit_Updated]  DEFAULT ((0)) FOR [Updated]
GO



------------------------------------------------
/*******************************************************************************************************/
--Stored proc  to get the active list of frequencies
-------------------------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetTabletCacheFrequencies_Active]    Script Date: 04/03/2014 09:46:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetTabletCacheFrequencies_Active]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetTabletCacheFrequencies_Active]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetTabletCacheFrequencies_Active]    Script Date: 04/03/2014 09:46:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- CREATED: Sara lakshmanan
-- Date:    4/2/2014
-- Description: Get Enabled cache items and their frequencies
-- =============================================
CREATE PROC [dbo].[usp_GetTabletCacheFrequencies_Active]
AS
BEGIN

    SET NOCOUNT ON;

Select Distinct F.TabletDataCacheUpdateFrequencyID,F.FrequencyinMinutes from  Libertypower..TabletDataCacheUpdateFrequency F With (NoLock) 
Inner Join LIbertypower..TabletDataCacheItem I with (NoLock) on F.TabletDataCacheUpdateFrequencyID=I.TabletDataCacheUpdateFrequencyID
 where  I.EnableCache=1  
     SET NOCOUNT OFF;
     
END
     
GO


-------------------------------------------------------------------------------------------------------
--Procedure to get the cache items based on the frequency
------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheItemSelectByFrequencyId]    Script Date: 04/03/2014 11:16:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TabletDataCacheItemSelectByFrequencyId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TabletDataCacheItemSelectByFrequencyId]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheItemSelectByFrequencyId]    Script Date: 04/03/2014 11:16:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

* PROCEDURE:     [usp_TabletDataCacheItemSelectByFrequencyId]
* PURPOSE:       Fetch the Cache Items based on the frequency
 *******************************************************************************
* 4/3/2014 - Sara lakshmanan
* Created.
*******************************************************************************

*/


CREATE PROCEDURE [dbo].[usp_TabletDataCacheItemSelectByFrequencyId] 
      @p_FrequencyTypeId int
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

            Select CI.TabletDataCacheItemID
                  from  LibertyPower..TabletDataCacheItem CI with (NOLock) 
                            
            where CI.TabletDataCacheUpdateFrequencyID=@p_FrequencyTypeId
      
Set NOCOUNT OFF;
END
-- Copyright 3/19/2014 Liberty Power    



GO
----------------------------------------------------------
-- Find if the cache item is active in template
USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_IsTabletDataCacheUpdateforItemActive]    Script Date: 04/03/2014 11:33:55 ******/

IF EXISTS(SELECT *
            FROM sys.objects
            WHERE object_id = OBJECT_ID(N'[dbo].[usp_IsTabletDataCacheUpdateforItemActive]')
              AND type IN(N'P', N'PC'))
    BEGIN
        DROP PROCEDURE dbo.usp_IsTabletDataCacheUpdateforItemActive
    END;
GO

USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_IsTabletDataCacheUpdateforItemActive]    Script Date: 04/03/2014 11:33:55 ******/

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- =============================================
-- CREATED: Sara lakshmanan
-- Date:     3/25/2014
-- Description: Added to find if Tablet Cache has to be updated in TabletDataCache table
-- =============================================
CREATE PROC dbo.usp_IsTabletDataCacheUpdateforItemActive(@p_TabletDataCacheItemId int, 
                                                         @p_SalesChannelId int=NULL)
AS
BEGIN
SET NOCOUNT ON
    DECLARE @IsTabletDataCacheItemActive int=0;
    DECLARE @activeItems int;
--//if sales Channel Id is null  and row exists for cacheItem and is Active then return active
    IF @p_SalesChannelId IS NULL
        BEGIN

            SELECT @activeItems=COUNT(*)
              FROM LibertyPower..TabletDataCacheTemplate T WITH (NOLOCK)
              WHERE TabletDataCacheitemid = @p_TabletDataCacheItemId and T.Active=1;
            IF @activeItems > 0
                BEGIN
                    SET @IsTabletDataCacheItemActive=1;
                END;
        END;
    ELSE
        BEGIN
            SELECT @IsTabletDataCacheItemActive=ISNULL(T.Active, 1)
              FROM LibertyPower..TabletDataCacheTemplate T WITH (NOLOCK)
              WHERE TabletDataCacheitemid = @p_TabletDataCacheItemId
                AND SalesChannelId = @p_SalesChannelId;
        END;
    SELECT @IsTabletDataCacheItemActive;
    SET NOCOUNT OFF;
END;

GO

-----------------------------------------------------------
--Get the tempalte details by itemId and SalesChannelID
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheItemTemplateSelectByItemidandSalesChannelId]    Script Date: 04/03/2014 13:45:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TabletDataCacheItemTemplateSelectByItemidandSalesChannelId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TabletDataCacheItemTemplateSelectByItemidandSalesChannelId]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheItemTemplateSelectByItemidandSalesChannelId]    Script Date: 04/03/2014 13:45:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

* PROCEDURE:     usp_TabletDataCacheItemTemplateSelectByItemidandSalesChannelId
* PURPOSE:       Get the templater Data by Cacheitem and salesChannelId
 *******************************************************************************
* 4/3/2014 - Sara lakshmanan
* Created.
*******************************************************************************

*/

Create PROCEDURE [dbo].[usp_TabletDataCacheItemTemplateSelectByItemidandSalesChannelId]
      @p_TabletDataCacheItemId int
      ,@p_SalesChannelId int= null
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

            Select T.*
                  from  LibertyPower..TabletDataCacheTemplate T with (NOLock) 
                            
            where T.TabletDataCacheItemId=@p_TabletDataCacheItemId 
            and(T.SalesChannelId= @p_SalesChannelId or @p_SalesChannelId is NULL)
      
Set NOCOUNT OFF;
END

GO

------------------------------------------------------------------------
---Get Max priocing

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMaxDailyPricingValues]    Script Date: 04/03/2014 14:00:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetMaxDailyPricingValues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetMaxDailyPricingValues]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMaxDailyPricingValues]    Script Date: 04/03/2014 14:00:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- CREATED: Sara lakshmanan
-- Date:     3/20/2014
-- Description: Added to find if the daily pricing has changed
-- =============================================
CREATE PROC [dbo].[usp_GetMaxDailyPricingValues](@SalesChannelID int=NULL)
AS
BEGIN

    SET NOCOUNT ON;
    DECLARE @MaxID int;
    DECLARE @ProductCrossPriceSetId int;
    DECLARE @ExpirationDate datetime;
    DECLARE @LastChanged datetime;
    DECLARE @MaxDate datetime;


    SELECT @ProductCrossPriceSetId=MAX(p.ProductCrossPriceSetID)
      FROM LibertyPower..ProductCrossPriceSet P WITH (NOLOCK);

    SELECT @ProductCrossPriceSetId=p.ProductCrossPriceSetID, 
           @ExpirationDate=P.ExpirationDate, 
           @LastChanged=P.DateCreated, 
           @MaxDate=P.EffectiveDate
      FROM LibertyPower..ProductCrossPriceSet P WITH (NOLOCK)
      WHERE P.ProductCrossPriceSetID = @ProductCrossPriceSetId;

    SELECT 1 AS TabletDataCacheItemId, 
           @SalesChannelID AS SalesChannelId, 
           @ProductCrossPriceSetId MaxId, 
           @MaxDate AS MaxDate, 
           @ExpirationDate AS ExpirationDate, 
           @LastChanged AS LastChanged, 
          1 AS ItemChanged;

SET NOCOUNT OFF;

END;


GO


-------------------------------------------------
---------------------------------------------------------------------------------
--Get max market and products

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMaxMarketProductsValues]    Script Date: 04/03/2014 14:00:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetMaxMarketProductsValues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetMaxMarketProductsValues]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMaxMarketProductsValues]    Script Date: 04/03/2014 14:00:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- CREATED: Sara lakshmanan
-- Date:     3/28/2014
-- Description: Added to find if the MarketProducts has changed
-- =============================================
CREATE PROC [dbo].[usp_GetMaxMarketProductsValues](@SalesChannelID int=NULL)
AS
BEGIN

    SET NOCOUNT ON;
    DECLARE @MarketProductsChanged int;
    SET @MarketProductsChanged=0;

    CREATE TABLE #TabletSalesChannelTable(SalesChannelID int);
    --//Get the list of SalesChannells that have tablet and save to temptable #TabletSalesChannelTable
    IF @SalesChannelID IS NULL
        BEGIN
            INSERT INTO #TabletSalesChannelTable
            SELECT ChannelID
              FROM SalesChannel With (NOLOCK)
              WHERE Tablet = 1;
        END;
    ELSE
        BEGIN
            INSERT INTO #TabletSalesChannelTable
            SELECT @SalesChannelID;

        END;

    --Select * from #TabletSalesChannelTable

    CREATE TABLE #TabletSalesChannelMarketProducts(SalesChannelID int, 
                                                   MaxDate datetime, 
                                                   MaxId int);
    --Create another temptable #TabletSalesChannelMarketProducts to hold the max(createddate) 
    --for each salesChannel from the SalesChannelSelectedProducts tables
    INSERT INTO #TabletSalesChannelMarketProducts
    SELECT ChannelID, 
           MAX(CreatedDate), 
           COUNT(ChannelID)
      FROM LibertyPower..SalesChannelSelectedProducts SCSP WITH (noLock)
      WHERE ChannelID IN(SELECT SalesChannelID
                           FROM #TabletSalesChannelTable)
      GROUP BY ChannelID;


    SELECT 3 AS TabletDataCacheItemId, 
           SalesChannelID, 
           MaxId, 
           MaxDate, 
           NULL AS ExpirationDate, 
           MaxDate AS LastChanged, 
           1 AS ItemChanged
      FROM #TabletSalesChannelMarketProducts;

    IF OBJECT_ID('tempdb..#TabletSalesChannelTable')IS NOT NULL
        BEGIN
            DROP TABLE #TabletSalesChannelTable;
        END;

    IF OBJECT_ID('tempdb..#TabletSalesChannelMarketProducts')IS NOT NULL
        BEGIN
            DROP TABLE #TabletSalesChannelMarketProducts;
        END;


END;

GO


-----------------------------------------------------------
-- Insert into cache table
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheInsertforCacheItem]    Script Date: 04/03/2014 14:10:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TabletDataCacheInsertforCacheItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TabletDataCacheInsertforCacheItem]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheInsertforCacheItem]    Script Date: 04/03/2014 14:10:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

* PROCEDURE:     [usp_TabletDataCacheInsertforCacheItem]
* PURPOSE:       Insert the Cache data for Tablet 
* HISTORY:       
*******************************************************************************
* 3/19/2013 - Pradeep Katiyar
* Created.
*******************************************************************************

*/

CREATE PROCEDURE [dbo].[usp_TabletDataCacheInsertforCacheItem] 
      @p_TabletDataCacheItemID int,
      @p_ChannelId int,
      @p_HashValue Uniqueidentifier,
      @p_DateModified Datetime,
      @p_CreatedDate datetime
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

Begin
      insert into LibertyPower..TabletDataCache(TabletDataCacheItemID,ChannelID,HashValue,DateModified,CreatedDate) 
            select @p_TabletDataCacheItemID,@p_ChannelId,@p_HashValue,@p_DateModified,@p_CreatedDate 

End
            
Set NOCOUNT OFF;
END



GO


------------------------------------------------------------------
--Update into cache table
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheUpdateforCacheItem]    Script Date: 04/03/2014 14:06:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TabletDataCacheUpdateforCacheItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TabletDataCacheUpdateforCacheItem]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheUpdateforCacheItem]    Script Date: 04/03/2014 14:06:00 ******/
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

CREATE PROCEDURE [dbo].[usp_TabletDataCacheUpdateforCacheItem] 
      @p_TabletDataCacheItemID int,
      @p_HashValue uniqueidentifier,
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
  update LibertyPower..TabletDataCache set HashValue=@p_HashValue, LastChanged=@p_LastUpdated, ExpirationDate=@p_ExpirationDate, 
  DateModified=GETDATE() 
           where TabletDataCacheItemID= @p_TabletDataCacheItemID and (ChannelID= @p_SalesChannelID or
@p_SalesChannelID is NULL)


END
Else
BEGIN

Declare @currentDate Datetime= getdate();

exec [usp_TabletDataCacheInsertforCacheItem] @p_TabletDataCacheItemID,@p_SalesChannelID,@p_HashValue,@currentDate,@currentDate
END
     
     
Select * from  LibertyPower..TabletDataCache With (NOLock)
           where TabletDataCacheItemID= @p_TabletDataCacheItemID and (ChannelID= @p_SalesChannelID or
@p_SalesChannelID is NULL)     
            
Set NOCOUNT OFF;
END
-- Copyright 3/19/2013 Liberty Power


GO


-------------------------------------------------
--Insert to Template table
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheTemplate_Insert]    Script Date: 04/03/2014 14:31:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TabletDataCacheTemplate_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TabletDataCacheTemplate_Insert]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheTemplate_Insert]    Script Date: 04/03/2014 14:31:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

* PROCEDURE:     [usp_TabletDataCacheTemplate_Insert]
* PURPOSE:       Insert the Cache data for Template Table
* HISTORY:       
*******************************************************************************
* 4/3/2014
* Created.
*******************************************************************************

*/

CREATE PROCEDURE [dbo].[usp_TabletDataCacheTemplate_Insert] 
      @p_TabletDataCacheItemID int,
      @p_Active bit,
      @p_MaxId int,
      @p_MaxDate DateTime,
      @p_SalesChannelID int=null,
      @p_ModifiedBy int = null,
      @p_ModifiedDate datetime = null
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

Begin

      insert into LibertyPower..TabletDataCacheTemplate
      (TabletDataCacheItemId,SalesChannelId,Active,MaxId,MaxDate,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) 
            select @p_TabletDataCacheItemID,@p_SalesChannelID,@p_Active,@p_MaxId,@p_MaxDate,@p_ModifiedBy,@p_ModifiedDate,
            @p_ModifiedBy,@p_ModifiedDate  
               

		            
End
            
Set NOCOUNT OFF;
END




GO


------------------------------
--Update to template table

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheTemplate_Update]    Script Date: 04/03/2014 14:32:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TabletDataCacheTemplate_Update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TabletDataCacheTemplate_Update]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheTemplate_Update]    Script Date: 04/03/2014 14:32:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

* PROCEDURE:     [usp_TabletDataCacheTemplate_Update]
* PURPOSE:       Update the Cache data for Tablet 
* HISTORY:       
*******************************************************************************
* 4/2/2014 Sara
* Created.
*******************************************************************************

*/

CREATE PROCEDURE [dbo].[usp_TabletDataCacheTemplate_Update] 
      @p_TabletDataCacheItemId int,
      @p_MaxId int,
      @p_MaxDate DateTime,
      @p_SalesChannelID int=null,
      @p_ModifiedBy int = null,
      @p_ModifiedDate datetime = null
      
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

If exists(Select T.TabletDataCacheTemplateId from Libertypower..TabletDataCacheTemplate T with (NoLock)
 where T.TabletDataCacheItemID= @p_TabletDataCacheItemID and (T.SalesChannelId= @p_SalesChannelID or
@p_SalesChannelID is NULL)  )
Begin
  update LibertyPower..TabletDataCacheTemplate set
  SalesChannelId=@p_SalesChannelID,MaxId=@p_MaxId,MaxDate=@p_MaxDate,
 ModifiedBy=@p_ModifiedBy,ModifiedDate=@p_ModifiedDate
           where TabletDataCacheItemID= @p_TabletDataCacheItemID and (SalesChannelId= @p_SalesChannelID or
@p_SalesChannelID is NULL)


END
Else
Begin
exec [usp_TabletDataCacheTemplate_Insert] @p_TabletDataCacheItemID,1,@p_MaxId,@p_MaxDate,@p_SalesChannelID,@p_ModifiedBy,@p_ModifiedDate
END

Select * from LibertyPower..TabletDataCacheTemplate WITH (NOLOCK)
           where TabletDataCacheItemID= @p_TabletDataCacheItemID and (SalesChannelId= @p_SalesChannelID or
@p_SalesChannelID is NULL)
            
Set NOCOUNT OFF;
END
-- Copyright 3/19/2013 Liberty Power



GO


------------------------------------------------------------------------------


USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheAudit_Insert]    Script Date: 04/03/2014 14:44:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TabletDataCacheAudit_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TabletDataCacheAudit_Insert]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheAudit_Insert]    Script Date: 04/03/2014 14:44:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

* PROCEDURE:     usp_TabletDataCacheAudit_Insert
* PURPOSE:       Insert the Cache data to audit table
* HISTORY:       
*******************************************************************************
* 4/3/2014
* Created.
*******************************************************************************

*/

CREATE PROCEDURE [dbo].[usp_TabletDataCacheAudit_Insert] 
      @p_TabletDataCacheItemID int,
      @p_SalesChannelID int=null,
      @p_updated bit,
      @p_CreatedBy int = null,
      @p_CreatedDate datetime = null
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;

Declare @TabletDataCacheAuditId int;
      insert into LibertyPower..TabletDataCacheAudit (TabletDataCacheItemId,SalesChannelId,Updated,CreatedBy,CreatedDate)
            select @p_TabletDataCacheItemID,@p_SalesChannelID,@p_updated,@p_CreatedBy,@p_CreatedDate
      
		SET @TabletDataCacheAuditId = SCOPE_IDENTITY() 
		Select * from    LibertyPower..TabletDataCacheAudit With (NoLock) where TabletDataCacheAuditId=   @TabletDataCacheAuditId              
            
Set NOCOUNT OFF;
END


GO


--------------------------------------------------------------------------------

---insert scripts

USE [LibertyPower]
GO
/****** Object:  Table [dbo].[TabletDataCacheUpdateFrequency]    Script Date: 04/03/2014 15:25:10 ******/
SET IDENTITY_INSERT [dbo].[TabletDataCacheUpdateFrequency] ON
INSERT [dbo].[TabletDataCacheUpdateFrequency] ([TabletDataCacheUpdateFrequencyID], [FrequencyinMinutes]) VALUES (1, 120)
INSERT [dbo].[TabletDataCacheUpdateFrequency] ([TabletDataCacheUpdateFrequencyID], [FrequencyinMinutes]) VALUES (2, 360)
INSERT [dbo].[TabletDataCacheUpdateFrequency] ([TabletDataCacheUpdateFrequencyID], [FrequencyinMinutes]) VALUES (3, 720)
SET IDENTITY_INSERT [dbo].[TabletDataCacheUpdateFrequency] OFF
/****** Object:  Table [dbo].[TabletDataCacheTemplate]    Script Date: 04/03/2014 15:25:10 ******/
SET IDENTITY_INSERT [dbo].[TabletDataCacheTemplate] ON
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (1, 1, 821, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (2, 1, 1194, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (3, 1, 1197, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (4, 1, 1218, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (5, 1, 1219, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (6, 1, 1226, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (7, 1, 1248, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (8, 1, 1255, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (9, 1, 1258, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (10, 3, 821, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (11, 3, 1194, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (12, 3, 1197, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (13, 3, 1218, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (14, 3, 1219, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (15, 3, 1226, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (16, 3, 1248, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (17, 3, 1255, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
INSERT [dbo].[TabletDataCacheTemplate] ([TabletDataCacheTemplateId], [TabletDataCacheItemId], [SalesChannelId], [Active], [MaxId], [MaxDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (18, 3, 1258, 1, NULL, NULL, 1982, CAST(0x0000A30200000000 AS DateTime), 1982, CAST(0x0000A30200000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[TabletDataCacheTemplate] OFF
-----------------------------------------------

--Add Created Date for SalesChannelSelectedProducts to handle the cache update process
-------------------------------------------
USE [LibertyPower]
GO
IF NOT EXISTS( SELECT NULL
            FROM INFORMATION_SCHEMA.COLUMNS
           WHERE table_name = 'SalesChannelSelectedProducts'
             AND column_name = 'CreatedDate')  
Begin

  ALTER TABLE SalesChannelSelectedProducts ADD CreatedDate Datetime  NULL default Getdate();
  
END
GO

If exists (Select  * from LIbertypower..SalesChannelSelectedProducts with (NoLock) where CreatedDate is NULL)
Begin
Update SalesChannelSelectedProducts set CreatedDate=GETDATE() where CReatedDate is NULL
End
GO


USE [LibertyPower]
GO
IF NOT EXISTS( SELECT NULL
            FROM INFORMATION_SCHEMA.COLUMNS
           WHERE table_name = 'SalesChannelSelectedProducts'
             AND column_name = 'CreatedBy')  
Begin

  ALTER TABLE SalesChannelSelectedProducts ADD CreatedBy int  NULL ;
  
END
GO

If exists (Select  * from LIbertypower..SalesChannelSelectedProducts with (NoLock) where CreatedBy is NULL)
Begin
Update SalesChannelSelectedProducts set Createdby=1982 where CreatedBy is NULL
End
GO

-----------------------------------------


USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelSelectedProductInsert]    Script Date: 04/08/2014 15:38:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Markus Geiger	
-- Create date: 1/10/2014
-- Description:	Inserts a selected product for a specific sales channel and market
-------------------------------------------------------------
-- Author:		Sara lakshmanan
-- Modified date: 4/8/2014
-- Description:	Added createdBY and CreatedDate
-- =============================================
ALTER PROCEDURE [dbo].[usp_SalesChannelSelectedProductInsert] 
	@ChannelID int = null,
	@MarketID int = null,
	@ProductBrandID int = null,
	@CreatedBy int= null,
	@CreatedDate Datetime= null
AS
BEGIN
	
	SET NOCOUNT ON;

    IF(@ChannelID IS NOT NULL)
    BEGIN
		IF(@MarketID IS NOT NULL)
		BEGIN
			IF(@ProductBrandID IS NOT NULL)
			BEGIN
				IF(NOT EXISTS(SELECT * FROM LibertyPower..SalesChannelSelectedProducts WITH (NOLOCK) WHERE ChannelID = @ChannelID AND MarketID = @MarketID AND ProductBrandID = @ProductBrandID))
				BEGIN
					INSERT INTO LibertyPower..SalesChannelSelectedProducts
					(ChannelID, MarketID, ProductBrandID,CreatedBy, CreatedDate)
					VALUES(@ChannelID, @MarketID, @ProductBrandID,@CreatedBy,@CreatedDate);
				END
			END
		END
    END
    
    SET NOCOUNT OFF;
END
GO



  



