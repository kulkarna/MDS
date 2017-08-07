USE LibertyPower
GO

-- Transferred to production
SELECT *
INTO #MissingZones
FROM OPENQUERY("ISTA_SQL2", 'select * from DW_workspace.dbo.NYCOMEDMissingZones')

/*
select	*
from	#MissingZones
*/

SELECT	distinct a.AccountNumber, a.UtilityID, u.UtilityCode, a.AccountID, '' as Zone, null as DeliveryPointId
INTO	#Accounts
FROM	Libertypower..Account a (nolock)
INNER	Join Libertypower..Utility u (nolock)
ON		a.UtilityId = u.ID
INNER	JOIN #MissingZones z
ON		a.AccountNumber = z.[Account #]
AND		u.UtilityCode = z.Utility
WHERE	a.Zone = ''
OR		a.Zone IS NULL

/*
SELECT	*
from	#Accounts

SELECT	distinct a.*, e.ZoneCode, p.ID as DeliveryLocationRefID
FROM	#Accounts a
Inner	Join lp_transactions..EdiAccount e(nolock)
on		a.AccountNumber = e.AccountNumber
and		a.UtilityCode = e.UtilityCode
AND		e.ZoneCode <> ''
Inner	Join PropertyInternalRef p (nolock)
ON		a.UtilityCode + '-' + e.ZoneCode = p.Value
*/


-- UPDATE NYCONED MISSING ZONES in the TEMP table
UPDATE	a
SET		a.Zone = e.ZoneCode,
		DeliveryPointId = p.ID
FROM	#Accounts a
Inner	Join lp_transactions..EdiAccount e(nolock)
on		a.AccountNumber = e.AccountNumber
and		a.UtilityCode = e.UtilityCode
AND		e.ZoneCode <> ''
Inner	Join PropertyInternalRef p (nolock)
ON		a.UtilityCode + '-' + e.ZoneCode = p.Value

-- UPDATE NYCONED MISSING ZONES in the Account table
UPDATE	a
SET		a.Zone = t.Zone,
		a.DeliveryLocationRefID = t.DeliveryPointId
FROM	Libertypower..Account a
INNER	Join #Accounts t
ON		a.AccountID = t.AccountID
AND		t.Zone <> ''

--FIX AMEREN ZONES-DeliveryLocationId
UPDATE	Account
SET		DeliveryLocationRefID = 9
Where	UtilityID = 11
AND		Zone IN ('RATE ZONE II', 'RATE ZONE II', 'RATE ZONE III')
AND		DeliveryLocationRefID <> 9

--FIX CONNECTICUT ZONES-DeliveryLocationId
UPDATE	Account
SET		DeliveryLocationRefID = 94
Where	UtilityID = 46
AND		Zone IN ('CONNECTICUT')
AND		DeliveryLocationRefID <> 94

--FIX PENNPR ZONES-DeliveryLocationId
UPDATE	Account
SET		DeliveryLocationRefID = 72
Where	UtilityID = 51
AND		Zone IN ('ATSI', 'PP01')
AND		DeliveryLocationRefID <> 72

--FIX ERCOT ZONES-DeliveryLocationId
UPDATE	a
SET		a.Zone = m.DCZone,
		a.DeliveryLocationRefID = p.ID
FROM	Account a
INNER	JOIN Utility u
on		a.UtilityID = u.ID
INNEr	JOIN ERCOT..AccountInfoSettlement s
ON		a.Zone = s.Substation
INNER	JOIN ERCOT..AccountInfoZoneMapping m
ON		s.SettlementLoadZone = m.ErcotZone
INNER	JOIN PropertyInternalRef p
on		u.UtilityCode + '-' + m.DCZone = p.Value
Where	WholeSaleMktID = 'ERCOT'
AND		Zone NOT IN ('HOUSTON', 'NORTH', 'SOUTH', 'WEST', '')

UPDATE	a
SET		a.DeliveryLocationRefID = p.ID
from	Account a
INNER	JOIN Utility u
on		a.UtilityID = u.ID
INNER	JOIN PropertyInternalRef p
on		u.UtilityCode + '-' + a.Zone = p.Value
Where	WholeSaleMktID = 'ERCOT'
AND		Zone IN ('HOUSTON', 'NORTH', 'SOUTH', 'WEST', '')
and		a.DeliveryLocationRefID <> p.ID

--SET DeliveryLocationRefID to 0 where there is no zone
UPDATE	a
SET		DeliveryLocationRefID = 0
FROM	Account a
Where	(Zone = '' OR	Zone IS NULL)
ANd		DeliveryLocationRefID <> 0