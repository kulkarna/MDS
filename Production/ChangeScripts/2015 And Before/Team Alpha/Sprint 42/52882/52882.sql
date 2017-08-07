------Script for 52882 Oct 21 2014



If exists (Select * from Libertypower..TabletDataCacheItem (NoLock) where TabletDataCacheItemID=9 and TabletDataCacheUpdateFrequencyID is NULL) 
Begin
Update Libertypower..TabletDataCacheItem Set TabletDataCacheUpdateFrequencyID=1 where TabletDataCacheItemID=9 and TabletDataCacheUpdateFrequencyID is NULL
End
Go

If not exists (Select * from Libertypower..TabletDataCacheTemplate (NOLock) where TabletDataCacheItemId=1 and SalesChannelId=1283)
begin
Insert into LIbertyPower..TabletDataCacheTemplate (TabletDataCacheItemId,SalesChannelId,Active,MaxId,MaxDate,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Values (1,1283,1,1,'1/1/2014',1982,GETDATE(),1982,GETDATE())
END
GO


