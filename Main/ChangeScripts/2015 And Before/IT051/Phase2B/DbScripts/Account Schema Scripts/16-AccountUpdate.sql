Use LibertyPower
GO


-- Zones
UPDATE	a
SET		a.DeliveryLocationRefID = p.ID
FROM	Account a
Inner	Join Utility u
ON		a.UtilityId = u.ID
INNER	JOIN PropertyInternalRef p
ON		u.UtilityCode + '-' + a.Zone = p.Value
WHERE	p.PropertyID = 1
and		(a.DeliveryLocationRefID = 0 OR a.DeliveryLocationRefID  IS NULL)

UPDATE	a
SET		a.DeliveryLocationRefID = p.ID
FROM	Account a
Inner	Join Utility u
ON		a.UtilityId = u.ID
INNER	Join PropertyValue pr
ON		a.Zone = pr.Value
INNER	JOIN PropertyInternalRef p
ON		pr.InternalRefID = p.ID
AND		p.Value LIKE u.UtilityCode + '-%'
WHERE	p.PropertyID = 1
and		(a.DeliveryLocationRefID = 0 OR a.DeliveryLocationRefID  IS NULL)

Update	Account
SET		DeliveryLocationRefID = 0
WHERE	DeliveryLocationRefID IS NULL

--Profiles
UPDATE	a
SET		a.LoadProfileRefID = p.ID
FROM	Libertypower..Account a
Inner	Join Libertypower..Utility u
ON		a.UtilityId = u.ID
INNER	JOIN LibertyPower..PropertyInternalRef p
ON		u.UtilityCode + '-' + a.LoadProfile = p.Value
WHERE	p.PropertyID = 2
and		(a.LoadProfileRefID = 0 OR a.LoadProfileRefID  IS NULL)

UPDATE	a
SET		a.LoadProfileRefID = p.ID
FROM	Account a
Inner	Join Utility u
ON		a.UtilityId = u.ID
INNER	Join PropertyValue pr
ON		a.LoadProfile = pr.Value
INNER	Join ExternalEntityValue eev
ON		eev.PropertyValueID = pr.id
INNER	Join ExternalEntity ee
on		eev.ExternalEntityID = ee.ID
ANd		ee.EntityTypeID = 2
AND		ee.EntityKey = u.ID
INNER	JOIN PropertyInternalRef p
ON		pr.InternalRefID = p.ID

WHERE	p.PropertyID = 2
and		(a.LoadProfileRefID = 0 OR a.LoadProfileRefID  IS NULL)

--ERCOT PROFILES
UPDATE	a
SET		a.LoadProfileRefID = p.ID
FROM	Account a
Inner	Join Utility u
ON		a.UtilityId = u.ID
INNER	Join PropertyValue pr
ON		SUBSTRING(a.LoadProfile, 0, CHARINDEX('_', a.LoadProfile, CHARINDEX('_',a.loadProfile,0)+1)) = pr.Value
INNER	Join ExternalEntityValue eev
ON		eev.PropertyValueID = pr.id
INNER	Join ExternalEntity ee
on		eev.ExternalEntityID = ee.ID
ANd		ee.EntityTypeID = 2
AND		ee.EntityKey = u.ID
INNER	JOIN PropertyInternalRef p
ON		pr.InternalRefID = p.ID

WHERE	p.PropertyID = 2
and		u.WholeSaleMktID = 'ERCOT'
and		(a.LoadProfileRefID = 0 OR a.LoadProfileRefID  IS NULL)

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

UPDATE	a
SET		a.LoadProfileRefID = p.ID
from	#P p
Inner	Join Account a
On		p.RoValue = a.LoadProfile
Inner	Join Libertypower..Utility u
ON		a.UtilityId = u.ID
And		u.UtilityCode = 'CONED'
Where	(a.LoadProfileRefID = 0 OR a.LoadProfileRefID  IS NULL)


Update	Account
SET		LoadProfileRefID = 0
WHERE	LoadProfileRefID IS NULL

/*************************** S E R V I C E    C L A S S **********************************/

Update	Account
SET		ServiceClassRefID = 0
WHERE	ServiceClassRefID IS NULL


