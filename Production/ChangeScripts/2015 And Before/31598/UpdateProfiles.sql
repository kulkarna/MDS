USE Libertypower

GO

SELECT *
INTO #MissingProfiles
FROM OPENQUERY("ISTA_SQL2", 'select * from DW_workspace.dbo.ComedMissingProfiles')

GO

-- Remove the accounts that have a profile
DELETE	P
from	Account a (nolock)
Inner	Join #MissingProfiles p
On		p.AccountNumber = a.AccountNumber
ANd		a.UtilityID = 17
where	a.LoadProfile <> ''

-- get the profile value from EDI
SELECt	distinct p.Accountnumber, p.UtilityCode,a.AccountID,e.LoadProfile, i.ID as LoadProfileRefId
INTO	#P
from	Account a (nolock)
Inner	Join #MissingProfiles p
On		p.AccountNumber = a.AccountNumber
ANd		a.UtilityID = 17
Inner	Join lp_transactions..EdiAccount e  (nolock)
On		a.AccountNumber = e.AccountNumber
and		e.UtilityCode = 'COMED'
AND		e.LoadProfile <> ''
Inner	Join PropertyInternalRef i  (nolock)
on		'COMED-'+e.LoadProfile = i.Value
and		i.PropertyId=2
where	a.LoadProfile = ''

-- Update the account table
UPDATE	a
SET		a.LoadProfile = p.LoadProfile,
		a.LoadProfileRefID = p.LoadProfileRefId
FRom	Account a
INNER	Join #P p
ON		a.AccountID = p.AccountID
