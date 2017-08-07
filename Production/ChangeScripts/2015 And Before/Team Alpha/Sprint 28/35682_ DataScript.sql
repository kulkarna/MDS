-------------------------------------------------
--Script to Enable Cache and Set Frequency type ID
--------------------------------------------------


If exists (Select * from Libertypower..TabletDataCacheItem  with (NoLock) where TabletDataCacheItemID=1 
and EnableCache =0  and  TabletDataCacheUpdateFrequencyID IS null)
begin

Update Libertypower..TabletDataCacheItem Set EnableCache=1 , TabletDataCacheUpdateFrequencyID=2
where TabletDataCacheItemID=1 and EnableCache =0  and  TabletDataCacheUpdateFrequencyID IS null
end
go



If exists (Select * from Libertypower..TabletDataCacheItem with (NoLock) where TabletDataCacheItemID=3 
and EnableCache =0  and  TabletDataCacheUpdateFrequencyID IS null)
begin

Update Libertypower..TabletDataCacheItem Set EnableCache=1 , TabletDataCacheUpdateFrequencyID=1
where TabletDataCacheItemID=3 and EnableCache =0  and  TabletDataCacheUpdateFrequencyID IS null

END
go