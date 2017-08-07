

CREATE view [dbo].[esiid_service_history] as 
select distinct a.[UIDESIID]
      ,a.[SERVICECODE]
      ,a.[STARTTIME]
      ,a.[STOPTIME]
      ,a.[REPCODE]
      ,a.[STATIONCODE]
      ,a.[PROFILECODE]
      ,a.[LOSSCODE]
      ,a.[ADDTIME]
      ,a.[DISPATCHFL]
      ,a.[MRECODE]
      ,a.[TDSPCODE]
      ,a.[REGIONCODE]
      ,a.[DISPATCHASSETCODE]
      ,a.[STATUS]
      ,a.[ZIP]
      ,a.[PGCCODE]
      ,a.[DISPATCHTYPE] 
      ,a.Cancelled
      from 
dbo.ESIIDSERVICEHIST a inner join
(select uidesiid,max(starttime) STARTTIME,max(addtime) ADDTIME  
from dbo.ESIIDSERVICEHIST where Cancelled =0 group by uidesiid) b on a.uidesiid=b.uidesiid and a.STARTTIME=b.STARTTIME and a.ADDTIME =b.ADDTIME

