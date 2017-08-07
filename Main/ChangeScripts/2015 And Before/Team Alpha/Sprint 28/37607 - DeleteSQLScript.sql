USE [LibertyPower]
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Delete  [LibertyPower]..TabletDataCache 
	where TabletDataCacheItemID =(Select TabletDataCacheItemID from [TabletDataCacheItem] where CacheItemName='SalesAgents' and TabletDataCacheItemTypeID=1)
Go
Delete  [LibertyPower]..[TabletDataCacheItem] where CacheItemName='SalesAgents' and TabletDataCacheItemTypeID=1
