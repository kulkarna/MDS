USE LibertyPower
GO

-- Transferred to production
SELECT *
INTO #MissingZones0130
FROM OPENQUERY("ISTA_SQL2", 'select * from DW_workspace.dbo.MissingZones0130')

GO

-- Check how many accounts are missing a zone
select * from #MissingZones0130

--Get the zones from ISTA

select distinct z.*, x.Zone as NewZone
into #NewZones
from 
	(
	select DISTINCT
	s.esiid as AccountNumber
	, u.ID as UtilityID
	, u.UtilityCode
	, h.TransactionDate
	, Zone = case when s.LBMPZone <>'' then s.LBMPZone
				  when s.PowerRegion <> '' then s.PowerRegion
				--  when u.WholeSaleMktID ='ERCOT' then tx.ZoneID
				  else stationid 
			 end
	, Recent = row_number() OVER (Partition By ESIID ORDER BY transactiondate DESC)
	from ISTA..tbl_814_header (nolock) h
	left join ISTA..tbl_814_Service (nolock) s  on s.[814_key]=h.[814_key]
	left join ISTA..tbl_814_Service_Account_Change (nolock) f on s.Service_key=f.Service_key 
	left join LibertyPower..utility (nolock) u on h.tdspduns=u.dunsnumber
	left join ERCOT..vwqryStationZone_New tx on s.StationId=tx.STATIONCODE
	where 1=1 
	and h.Direction=1
	and h.ActionCode in ('e','c','5')
	and s.actioncode not in ('r')
	and case  when s.LBMPZone <>'' then s.LBMPZone
			  when s.PowerRegion <> '' then s.PowerRegion
			  when u.WholeSaleMktID ='ERCOT' then tx.ZoneID
			  else stationid 
		 end is not null
	) x
Right	join #MissingZones0130 z
on		x.AccountNumber = z.AccountNumber
and		x.UtilityCode = z.UtilityCode
where	Recent = 1
OR		Recent IS NULL

SELECT	*
from	#NewZones
--where	ISO = 'ERCOT'

-- Standardizing some zone names in EDI before using them for update.
UPDATE #NewZones
SET		NewZone = CASE
				WHEN UtilityCode = 'MECO' AND NewZone = 'NEMASSBOST' THEN 'NEMASS'
				WHEN UtilityCode = 'NSTAR-BOS' AND NewZone = 'NEMASSBOST' THEN 'NEMASS'
				--WHEN UtilityCode = 'CL&P' AND Zone = 'CONNECTICUT' THEN 'CT'
				WHEN UtilityCode = 'UI' AND NewZone = 'CONNECTICUT' THEN 'CT'
				--WHEN UtilityCode = 'NECO' AND Zone = 'RHODEISLAND' THEN 'RI'
				ELSE NewZone
				END
Where	UtilityCode in ('MECO', 'NSTAR-BOS', 'UI')

--For all the other accounts wihtout a zone, apply the default zone when applicable
UPDATE #NewZones
SET		NewZone = CASE
				WHEN UtilityCode = 'PENNPR' THEN 'ATSI'
				WHEN UtilityCode = 'CL&P' THEN 'CT'
				WHEN UtilityCode = 'AMEREN' THEN 'AMIL'
				WHEN UtilityCode = 'PECO' THEN 'PECO'
				WHEN UtilityCode = 'BANGOR' THEN 'ME'
				ELSE NewZone
				END
Where	UtilityCode in ('PENNPR', 'CL&P', 'AMEREN', 'PECO','BANGOR')
ANd		ISNULL(NewZone,'') = ''

-- Update the Zones
UPDATE a
SET		Zone = t.NewZone
--select	a.Zone, t.NewZone
FROM	LibertyPower..Account a
inner	Join #NewZones t
on		a.AccountID = t.accountID
WHERE 	a.Zone <> t.NewZone AND t.NewZone <> ''

