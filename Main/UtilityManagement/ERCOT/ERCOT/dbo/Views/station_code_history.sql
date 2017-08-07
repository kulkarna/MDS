create view station_code_history as
select distinct 
	   a.[STATIONCODE]
      ,a.[STARTTIME]
      ,a.[STOPTIME]
      ,a.[UFEZONECODE]
      ,a.[CMZONECODE]
      ,a.[ADDTIME]
      ,a.[SUBUFECODE]
 from 
dbo.STATIONSERVICEHIST a inner join
(select [STATIONCODE],max(starttime) STARTTIME,max(addtime) ADDTIME  
from dbo.STATIONSERVICEHIST group by [STATIONCODE]) b on a.[STATIONCODE]=b.[STATIONCODE] and a.STARTTIME=b.STARTTIME and a.ADDTIME =b.ADDTIME
