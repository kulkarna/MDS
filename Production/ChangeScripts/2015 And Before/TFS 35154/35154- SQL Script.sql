USE [LibertyPower]
GO
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
--SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET NUMERIC_ROUNDABORT OFF
SET QUOTED_IDENTIFIER ON


IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'TabletDataCache' AND type_desc = 'USER_TABLE')
DROP table TabletDataCache;
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'TabletDataCacheItem' AND type_desc = 'USER_TABLE')
DROP table TabletDataCacheItem;
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'TabletDataCacheItemType' AND type_desc = 'USER_TABLE')
DROP table TabletDataCacheItemType;
GO

Go
/*******************************************************************************

* Table:   [TabletDataCacheItemType]
* PURPOSE: Tablet data cache item type master table
* HISTORY:       
 *******************************************************************************
* 3/7/2014 - Pradeep Katiyar
* Created.
*******************************************************************************

*/

 
CREATE TABLE [dbo].[TabletDataCacheItemType](
      [TabletDataCacheItemTypeID][int] IDENTITY(1,1) NOT NULL,
      [CacheItemType] Varchar(50)  NOT NULL,
      [CreatedDate] [datetime] NOT NULL,
CONSTRAINT [PK_TabletDataCacheItemType] PRIMARY KEY CLUSTERED 
(
      [TabletDataCacheItemTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION =  PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

Go
ALTER TABLE [dbo].[TabletDataCacheItemType] ADD  CONSTRAINT [DF_TabletDataCacheItemType_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
if not exists (select TOP 1 1  from LibertyPower..TabletDataCacheItemType WITH (NOLOCK) where CacheItemType='Global' )
insert into LibertyPower..TabletDataCacheItemType(CacheItemType,CreatedDate) values('Global',GETDATE())
go
if not exists (select TOP 1 1  from LibertyPower..TabletDataCacheItemType WITH (NOLOCK) where CacheItemType='Sales Channel' )
insert into LibertyPower..TabletDataCacheItemType(CacheItemType,CreatedDate) values('Sales Channel',GETDATE())
Go
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'TabletDataCacheItem' AND type_desc = 'USER_TABLE')
DROP table TabletDataCacheItem;
GO

Go
/*******************************************************************************

* Table:   [TabletDataCacheItem]
* PURPOSE: Tablet data cache item master table
* HISTORY:       
 *******************************************************************************
* 3/7/2014 - Pradeep Katiyar
* Created.
*******************************************************************************

*/
CREATE TABLE [dbo].[TabletDataCacheItem](
      [TabletDataCacheItemID][int] IDENTITY(1,1) NOT NULL,
      [CacheItemName]Varchar(50)   NOT NULL,
      [TabletDataCacheItemTypeID] [int]  Not NULL,
      [CreatedDate] [datetime] Not NULL
CONSTRAINT [PK_TabletDataCacheItem] PRIMARY KEY CLUSTERED 
(
      [TabletDataCacheItemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION =  PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

GO

ALTER TABLE [dbo].[TabletDataCacheItem] ADD  CONSTRAINT [DF_TabletDataCacheItem_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[TabletDataCacheItem]  WITH CHECK ADD  CONSTRAINT [FK_TabletDataCacheItem_CacheItem] FOREIGN KEY([TabletDataCacheItemTypeID])
REFERENCES [dbo].[TabletDataCacheItemType] ([TabletDataCacheItemTypeID])
GO

ALTER TABLE [dbo].[TabletDataCacheItem] CHECK CONSTRAINT [FK_TabletDataCacheItem_CacheItem]
GO
insert into LibertyPower..[TabletDataCacheItem](CacheItemName,TabletDataCacheItemTypeID,CreatedDate) values('Pricing',2,GETDATE())
GO
insert into LibertyPower..[TabletDataCacheItem](CacheItemName,TabletDataCacheItemTypeID,CreatedDate) values('SalesAgents',2,GETDATE())
GO
insert into LibertyPower..[TabletDataCacheItem](CacheItemName,TabletDataCacheItemTypeID,CreatedDate) values('MarketsProducts',2,GETDATE())
GO
insert into LibertyPower..[TabletDataCacheItem](CacheItemName,TabletDataCacheItemTypeID,CreatedDate) values('PromotionCode',2,GETDATE())
GO
insert into LibertyPower..[TabletDataCacheItem](CacheItemName,TabletDataCacheItemTypeID,CreatedDate) values('Documents',1,GETDATE())
GO
insert into LibertyPower..[TabletDataCacheItem](CacheItemName,TabletDataCacheItemTypeID,CreatedDate) values('Utility',1,GETDATE())
GO
insert into LibertyPower..[TabletDataCacheItem](CacheItemName,TabletDataCacheItemTypeID,CreatedDate) values('Zones',1,GETDATE())
GO
insert into LibertyPower..[TabletDataCacheItem](CacheItemName,TabletDataCacheItemTypeID,CreatedDate) values('ServiceClasses',1,GETDATE())
GO
insert into LibertyPower..[TabletDataCacheItem](CacheItemName,TabletDataCacheItemTypeID,CreatedDate) values('ZipCodes',1,GETDATE())
GO
insert into LibertyPower..[TabletDataCacheItem](CacheItemName,TabletDataCacheItemTypeID,CreatedDate) values('Markets',1,GETDATE())
GO
insert into LibertyPower..[TabletDataCacheItem](CacheItemName,TabletDataCacheItemTypeID,CreatedDate) values('SalesAgents',1,GETDATE())
GO
insert into LibertyPower..[TabletDataCacheItem](CacheItemName,TabletDataCacheItemTypeID,CreatedDate) values('ProductBrands',1,GETDATE())
GO
insert into LibertyPower..[TabletDataCacheItem](CacheItemName,TabletDataCacheItemTypeID,CreatedDate) values('Tier',1,GETDATE())
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'TabletDataCache' AND type_desc = 'USER_TABLE')
DROP table TabletDataCache;
GO

Go
/*******************************************************************************

* Table:   [TabletDataCache]
* PURPOSE: Store the Tablet cache data
* HISTORY:       
 *******************************************************************************
* 3/7/2014 - Pradeep Katiyar
* Created.
*******************************************************************************
*/
CREATE TABLE [dbo].[TabletDataCache](
      [TabletDataCacheID][int] IDENTITY(1,1) NOT NULL,
      [TabletDataCacheItemID] [int] NOT  NULL,
      [ChannelID] [int]   NULL,
      [HashValue]uniqueidentifier  NOT NULL,
      [LastChanged] [datetime] NULL,
      [ExpirationDate] [datetime] NULL,
      [DateModified] [datetime] Not NULL,
      [CreatedDate] [datetime] NOT NULL
CONSTRAINT [PK_TabletDataCache] PRIMARY KEY CLUSTERED 
(
      [TabletDataCacheID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION =  PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

GO

ALTER TABLE [dbo].[TabletDataCache] ADD  CONSTRAINT [DF_TabletDataCache_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[TabletDataCache]  WITH CHECK ADD  CONSTRAINT [FK_TabletDataCache_CacheItem] FOREIGN KEY([TabletDataCacheItemID])
REFERENCES [dbo].[TabletDataCacheItem] ([TabletDataCacheItemID])
GO

ALTER TABLE [dbo].[TabletDataCache] CHECK CONSTRAINT [FK_TabletDataCache_CacheItem]
GO
ALTER TABLE [dbo].[TabletDataCache]  WITH CHECK ADD  CONSTRAINT [FK_TabletDataCache_ChannelId] FOREIGN KEY([TabletDataCacheItemID])
REFERENCES [dbo].[TabletDataCacheItem] ([TabletDataCacheItemID])
GO

ALTER TABLE [dbo].[TabletDataCache] CHECK CONSTRAINT [FK_TabletDataCache_CacheItem]
GO
insert into LibertyPower..TabletDataCache(TabletDataCacheItemID,HashValue,DateModified,CreatedDate) 
      select TabletDataCacheItemID,NEWID(),GETDATE(),GETDATE() from LibertyPower..[TabletDataCacheItem] WITH (NOLOCK) 
            where TabletDataCacheItemTypeID=1
GO
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_TabletDataCache_list' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_TabletDataCache_list;
GO

/*******************************************************************************

* PROCEDURE:     [usp_TabletDataCache_list]
* PURPOSE:       Fetch the Tablet Cache Data list for Sales Channel and Global
* HISTORY:       To display the Tablet Cache Data list 
 *******************************************************************************
* 3/19/2014 - Pradeep Katiyar
* Created.
*******************************************************************************

*/


CREATE PROCEDURE [dbo].[usp_TabletDataCache_list] 
      @p_ChannelId int= NULL
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

            Select DC.TabletDataCacheID, CI.CacheItemName,DC.HashValue,DC.LastChanged,DC.ExpirationDate,DC.DateModified
                  from LibertyPower..TabletDataCache DC with (NOLock) 
                        Join LibertyPower..TabletDataCacheItem CI with (NOLock) 
                              on DC.TabletDataCacheItemID=CI.TabletDataCacheItemID
            where isnull(DC.ChannelID,0)=isnull(@p_ChannelId,0)
      
Set NOCOUNT OFF;
END
-- Copyright 3/19/2014 Liberty Power    

Go
--Go
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_TabletDataCacheInsert' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_TabletDataCacheInsert];
GO

/*******************************************************************************

* PROCEDURE:     [usp_TabletDataCacheInsert]
* PURPOSE:       Insert the Cache data for Tablet for particular sales channel
* HISTORY:       
*******************************************************************************
* 3/19/2013 - Pradeep Katiyar
* Created.
*******************************************************************************

*/

CREATE PROCEDURE [dbo].[usp_TabletDataCacheInsert] 
      @p_ChannelId int
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

Begin
delete LibertyPower..TabletDataCache where ChannelID=@p_ChannelId
      insert into LibertyPower..TabletDataCache(TabletDataCacheItemID,ChannelID,HashValue,DateModified,CreatedDate) 
            select TabletDataCacheItemID,@p_ChannelId,NEWID(),GETDATE(),GETDATE() 
                  from LibertyPower..[TabletDataCacheItem] WITH (NOLOCK)  
            where TabletDataCacheItemTypeID=2
            select DC.* from LibertyPower..TabletDataCache DC WITH (NoLock)
            where DC.ChannelID=@p_ChannelId
End
            
Set NOCOUNT OFF;
END
-- Copyright 3/19/2013 Liberty Power

Go
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_TabletDataCacheUpdate' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_TabletDataCacheUpdate];
GO

/*******************************************************************************

* PROCEDURE:     [usp_TabletDataCacheUpdate]
* PURPOSE:       Update the Cache data for Tablet for particular sales channel
* HISTORY:       
*******************************************************************************
* 3/19/2013 - Pradeep Katiyar
* Created.
*******************************************************************************

*/

CREATE PROCEDURE [dbo].[usp_TabletDataCacheUpdate] 
      @p_TabletDataCacheId int,
      @p_HashValue uniqueidentifier,
      @p_LastUpdated datetime = null,
      @p_ExpirationDate datetime = null
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

      update LibertyPower..TabletDataCache set HashValue=@p_HashValue, LastChanged=@p_LastUpdated, ExpirationDate=@p_ExpirationDate, DateModified=GETDATE() 
            where TabletDataCacheID=@p_TabletDataCacheId
      select DC.* from LibertyPower..TabletDataCache DC WITH (NoLock)
            where DC.TabletDataCacheID=@p_TabletDataCacheId

            
Set NOCOUNT OFF;
END
-- Copyright 3/19/2013 Liberty Power

Go
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_TabletDataCacheByHashValue' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_TabletDataCacheByHashValue];
GO

/*******************************************************************************

* PROCEDURE:     [usp_TabletDataCacheByHashValue]
* PURPOSE:       Check if HashValue already exists
* HISTORY:       
*******************************************************************************
* 3/19/2013 - Pradeep Katiyar
* Created.
*******************************************************************************

*/

CREATE PROCEDURE [dbo].[usp_TabletDataCacheByHashValue]
      @p_TabletDataCacheId int,
      @p_HashValue uniqueidentifier
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

            select DC.* from LibertyPower..TabletDataCache DC WITH (NoLock)
                                    where DC.TabletDataCacheID<>@p_TabletDataCacheId  
                                          and DC.HashValue=@p_HashValue
                                                
            
Set NOCOUNT OFF;
END
-- Copyright 3/19/2013 Liberty Power