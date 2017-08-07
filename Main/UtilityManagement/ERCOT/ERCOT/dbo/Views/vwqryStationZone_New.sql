CREATE view [dbo].[vwqryStationZone_New] as
/* 11/22/2010 Douglas Marino - Added union query to reflect changes from the nodal compliance
   1/7/2011 Douglas Marino - Had to add a temp solution until Alberto deploys the changes on the table STATIONSERVICEHIST since the [UIDSETLPOINT] is missing*/

SELECT
s.STATIONCODE,
substring(z.CMZONENAME,1,Len(z.CMZONENAME)-4) AS ZoneID,
substring(z.CMZONENAME,Len(z.CMZONENAME)-3,4) as [ZoneYear] 
FROM 
dbo.STATION s WITH (NOLOCK)  INNER JOIN 
dbo.STATIONSERVICEHIST  h WITH (NOLOCK) ON s.STATIONCODE = h.STATIONCODE INNER JOIN 
dbo.CMZONE z WITH (NOLOCK) ON h.CMZONECODE = z.CMZONECODE --where z.[STARTTIME]>'20101130'
WHERE
(((h.STOPTIME) Is Null))
and substring(z.CMZONENAME,Len(z.CMZONENAME)-3,4)= cast(year(getdate()) as varchar(4))--added 10/13/2008 to take only current year zones
--GROUP BY s.STATIONCODE, substring([CMZONENAME],1,Len([CMZONENAME])-4);											 --converted year(getdate()) to varchar - Alejandro Iturbe 9/16/2010
UNION
--SELECT
--s.STATIONCODE,
--z.CMZONENAME AS ZoneID,
--'' as [ZoneYear]
--FROM
--dbo.STATION s WITH (NOLOCK)  INNER JOIN --dbo.STATIONSERVICEHIST  h WITH (NOLOCK) ON s.STATIONCODE = h.STATIONCODE INNER JOIN --dbo.CMZONE z WITH (NOLOCK) ON h.CMZONECODE = z.CMZONECODE --Where z.starttime>='20101201' AND z.stoptime is null 
SELECT DISTINCT 
s.STATIONCODE, 
B.CMZONECODE AS ZoneID, 
'' as [ZoneYear] 
FROM 
ERCOT..STATION s WITH (NOLOCK)  INNER JOIN 
ERCOT..STATIONSERVICEHIST  h WITH (NOLOCK) ON s.STATIONCODE = h.STATIONCODE INNER JOIN 
(select STATIONCODE,Max(STARTTIME) AS STARTTIME from ERCOT..STATIONSERVICEHIST WITH (NOLOCK) where  1=1 and STOPTIME is null group by STATIONCODE) c on h.STATIONCODE=C.STATIONCODE and h.STARTTIME=c.STARTTIME inner join
ERCOT..SETTLEMENTPOINT a WITH (NOLOCK) ON H.UIDSETLPOINT=A.UIDSETLPOINT inner join 
ERCOT..SETLPOINTHISTORY b WITH (NOLOCK) ON a.UIDSETLPOINT=b.UIDSETLPOINT 