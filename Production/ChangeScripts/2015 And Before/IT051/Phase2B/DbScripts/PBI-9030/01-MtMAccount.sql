USE lp_MtM
GO

ALTER TABLE MtMAccount ADD SettlementLocationRefID INT 
GO

ALTER TABLE MtMAccount ADD LoadProfileRefID INT 

GO

sp_RENAME 'MtMAccount.ProxiedZone' , 'ProxiedLocation', 'COLUMN'


GO

DROP INDEX idx_MtMAccount_Zone ON MtMAccount

GO

CREATE NONCLUSTERED INDEX [idx_MtMAccount_SettlementLocationRefID] ON [dbo].[MtMAccount] 
(
	SettlementLocationRefID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO

/****************  M I G R A T E    T H E     D A T A ***************************/
-- Zones
UPDATE	m
SET		m.SettlementLocationRefID = p.ID
FROM	MtMAccount m
INNER	Join Libertypower..Account a
on		a.AccountID = m.AccountID
Inner	Join Libertypower..Utility u
ON		a.UtilityId = u.ID
INNER	JOIN LibertyPower..PropertyInternalRef p
ON		u.UtilityCode + '-' + m.Zone = p.Value
WHERE	p.PropertyID = 1
and		(m.SettlementLocationRefID = 0 OR m.SettlementLocationRefID  IS NULL)

UPDATE	m
SET		m.SettlementLocationRefID = p.ID
FROM	MtMAccount m
INNER	Join Libertypower..Account a
on		a.AccountID = m.AccountID
Inner	Join Libertypower..Utility u
ON		a.UtilityId = u.ID
INNER	Join LibertyPower..PropertyValue pr
ON		m.Zone = pr.Value
INNER	JOIN LibertyPower..PropertyInternalRef p
ON		pr.InternalRefID = p.ID
AND		p.Value LIKE u.UtilityCode + '-%'
WHERE	p.PropertyID = 1
and		(m.SettlementLocationRefID = 0 OR m.SettlementLocationRefID  IS NULL)

--Profiles
UPDATE	m
SET		m.LoadProfileRefID = p.ID
FROM	MtMAccount m
INNER	Join Libertypower..Account a
on		a.AccountID = m.AccountID
Inner	Join Libertypower..Utility u
ON		a.UtilityId = u.ID
INNER	JOIN LibertyPower..PropertyInternalRef p
ON		u.UtilityCode + '-' + m.LoadProfile = p.Value
WHERE	p.PropertyID = 2

UPDATE	m
SET		m.LoadProfileRefID = eem.InternalRefId
FROM	MtMAccount m
INNER	Join Libertypower..Account a
on		a.AccountID = m.AccountID
Inner	Join LibertyPower..Utility u
ON		a.UtilityId = u.ID
INNER	Join LibertyPower..vw_ExternalEntityMapping eem
ON		m.LoadProfile = eem.ExtEntityValue
AND		eem.ExtEntityID = u.ID
ANd		eem.ExtEntityTypeID = 2

WHERE	eem.InternalRefPropertyID = 2
and		(m.LoadProfileRefID = 0 OR m.LoadProfileRefID  IS NULL)

--Coned Profiles

SELECT	pir.ID, pir.Value as InternalValue, pv.Value as RoValue
INTO	#P
FROM	LibertyPower..PropertyInternalRef pir (NOLOCK) 
INNER	JOIN LibertyPower..PropertyValue pv (NOLOCK) 
ON		pir.ID = pv.InternalRefID
INNER	JOIN LibertyPower..ExternalEntityValue eev (NOLOCK) 
ON		eev.PropertyValueID = pv.ID
WHERE	pir.PropertyID = 2
AND		eeV.ExternalEntityID = 8
AND		(eev.Inactive = 0)
AND		(pv.Inactive = 0 )
AND		(pir.Inactive = 0 )

UPDATE	m
SET		m.LoadProfileRefID = p.ID
from	#P p
Inner	Join MtMAccount m
On		p.RoValue = m.LoadProfile
INNER	Join Libertypower..Account a
on		a.AccountID = m.AccountID
Inner	Join Libertypower..Utility u
ON		a.UtilityId = u.ID
And		u.UtilityCode = 'CONED'
Where	(m.LoadProfileRefID = 0 OR m.LoadProfileRefID  IS NULL)


--ERCOT PROFILES
UPDATE	m
SET		m.LoadProfileRefID = eem.InternalRefId
from	MtMAccount m
INNER	Join Libertypower..Account a
on		a.AccountID = m.AccountID
Inner	Join Libertypower..Utility u
ON		a.UtilityId = u.ID
AND		u.WholeSaleMktID = 'ERCOT'
INNER	Join LibertyPower..vw_ExternalEntityMapping eem
ON		SUBSTRING(m.LoadProfile, 0, CHARINDEX('_', m.LoadProfile, CHARINDEX('_',m.loadProfile,0)+1)) = eem.ExtEntityValue
AND		eem.ExtEntityID = u.ID
ANd		eem.ExtEntityTypeID = 2
AND		eem.InternalRefPropertyID = 2

WHERE	(m.LoadProfileRefID = 0 OR m.LoadProfileRefID  IS NULL)

/*
select	DISTINCT m.Zone, u.UTilityCode, zz.ZainetZone
from	MtMAccount m
INNER	Join Libertypower..Account a
on		a.AccountID = m.AccountID
Inner	Join Libertypower..Utility u
ON		a.UtilityId = u.ID
INNEr	join MtMZainetZones zz
on		u.ID = zz.UtilityID
and		m.Zone = zz.Zone
Inner	join lp_common..Zone z
on		z.Utility_id = u.UtilityCode
and		m.Zone = z.Zone
where	SettlementLocationRefID IS NULL
Order	by Zone


SELECT	*
from	Libertypower..PropertyValue
where	PropertyTypeId = 1
and		Value = 'CT'

select	DISTINCT m.LoadProfile, u.UTilityCode, m.*
from	MtMAccount m
INNER	Join Libertypower..Account a
on		a.AccountID = m.AccountID
Inner	Join Libertypower..Utility u
ON		a.UtilityId = u.ID
where	m.LoadProfileRefID IS NULL
Order	by m.LoadProfile

*/

/****************  D R O P    T H E   O L D    C O L U M N S *******************/
/*
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMAccount]') AND name = N'idx_MtMAccount_Zone')
DROP INDEX [idx_MtMAccount_Zone] ON [dbo].[MtMAccount] WITH ( ONLINE = OFF )

ALTER TABLE MtMAccount DROP COLUMN Zone

ALTER TABLE MtMAccount DROP COLUMN LoadProfile


*/

