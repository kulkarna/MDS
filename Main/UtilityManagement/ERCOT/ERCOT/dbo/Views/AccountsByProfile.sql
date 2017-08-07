
CREATE view [dbo].[AccountsByProfile] as
SELECT distinct
a.account_id, 
b.UIDESIID, 
b.ESIID,
substring(PROFILECODE, 1, charindex('_', PROFILECODE, charindex('_', PROFILECODE) + 1)-1) [Profile], 
c.STARTTIME, 
c.STOPTIME,
c.STATIONCODE, 
zones.ZoneID, 
c.LOSSCODE, 
a.status, 
a.sub_status,
a.product_id,
a.rate
--into 
FROM 
lp_account.dbo.account a INNER JOIN 
ESIID b ON a.account_number = b.ESIID INNER JOIN 
esiid_service_history c ON b.UIDESIID = c.UIDESIID INNER JOIN 
(SELECT 
a.STATIONCODE, 
substring([CMZONENAME],1,Len([CMZONENAME])-4) AS ZoneID
FROM 
STATION a INNER JOIN 
station_code_history b ON a.STATIONCODE = b.STATIONCODE INNER JOIN 
CMZONE c ON b.CMZONECODE = c.CMZONECODE
GROUP BY a.STATIONCODE, substring([CMZONENAME],1,Len([CMZONENAME])-4)) as zones ON c.STATIONCODE = zones.STATIONCODE

