CREATE view [dbo].[vwqryAccountsByProfile_New] as
SELECT distinct 
a.account_id, 
e.UIDESIID, 
e.ESIID, 
substring([PROFILECODE],1,charindex('_',[PROFILECODE],charindex('_',[PROFILECODE])+1)-1) AS ProfileID, 
h.STARTTIME, --Was producing duplicates see history for 10443720005272528 for example taken out 5/18/2011 
h.STATIONCODE, 
q.ZoneID, 
h.LOSSCODE, 
a.status, 
a.sub_status,
a.date_flow_start,
a.product_id,
a.rate
FROM 
lp_account.dbo.account a (nolock) INNER JOIN 
dbo.ESIID e WITH (NOLOCK) ON a.account_number = e.ESIID INNER JOIN 
[esiid_service_history] h WITH (NOLOCK) ON e.UIDESIID = h.UIDESIID INNER JOIN 
vwqryStationZone_New q WITH (NOLOCK) ON h.STATIONCODE = q.STATIONCODE
WHERE 
--(((h.STOPTIME) Is Null) AND 
h.Cancelled=0 -- false