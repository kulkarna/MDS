Use	Libertypower
GO

-- Get the stratum variable and rate class
SELECT	AccountID, ServiceRateClass, CAST (StratumVariable AS FLOAT) AS StratumVariable
into	#Account
FROM	Account (nolock)
Where	UtilityID = 18
AND		isnumeric(LTRIM(RTRIM(ISNULL(StratumVariable,'')))) = 1

-- get the stratum end
SELECT	a.AccountId, m.LoadShapeServiceClass as ServiceMappingId, MIN(StratumEnd) as StratumEnd
Into	#St
from	#Account a
INNER	Join UtilityStratumServiceClassMapping m (nolock)
ON		a.ServiceRateClass = m.CustomerServiceClass
INNER	Join UtilityStratumRange s  (nolock)
ON		m.LoadShapeServiceClass = s.ServiceRateClass
and		a.StratumVariable <= s.StratumEnd
and		s.UtilityId = 18
Group	by a.AccountID, m.LoadShapeServiceClass
order	by a.AccountID, m.LoadShapeServiceClass

--get the profile ID
SELECt	AccountID, ServiceMappingId + '-' + CAST (CAST( StratumEnd AS INT)AS VARCHAR(50)) as LoadProfile, p.ID as LoadProfileRefId
into	#toUpdate
FROM	#St s
Inner	Join PropertyInternalRef p (nolock)
on		ServiceMappingId + '-' + CAST (CAST( StratumEnd AS INT)AS VARCHAR(50)) = p.Value

-- Update the account table
Update	a
SET		a.LoadProfile = u.LoadProfile,
		a.LoadProfileRefID = u.LoadProfileRefId,
		a.Modified = GETDATE()
FRom	Account a
Inner	Join #toUpdate u
on		a.AccountID = u.AccountID

-- Update all the other accounts with 0 values
Update	a
SET		a.LoadProfile = NULL,
		a.LoadProfileRefID = 0,
		a.Modified = GETDATE()
FRom	Account a
LEFT	Join #toUpdate u
on		a.AccountID = u.AccountID
WHERE	u.AccountID IS NULL
AND		a.UtilityID = 18
