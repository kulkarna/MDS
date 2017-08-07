SELECT	DISTINCT
		u.WholeSaleMktID, u.UtilityCode, u.ShortName, a.Zone, 
		Min(a.AccountNumber) AS AccountNumber1,
		MAX(a.AccountNumber) AS AccountNumber2

FROM	AccountStatus ast

INNER	JOIN AccountContract ac
ON		ast.AccountContractID = ac.AccountContractID

INNER	JOIN Account a
ON		a.AccountID = ac.AccountID
AND		a.CurrentContractID = ac.ContractID

INNER	JOIN Utility u
ON		a.UtilityID = u.ID

WHERE	ast.Status = '911000' 

GROUP	BY u.WholeSaleMktID, u.UtilityCode, u.ShortName, a.Zone
ORDER	BY u.WholeSaleMktID, u.UtilityCode, a.Zone

/********************************************************************************/
SELECT	DISTINCT
		u.WholeSaleMktID, u.UtilityCode, u.ShortName, a.LoadProfile, a.Zone, 
		Min(a.AccountNumber) AS AccountNumber1,
		MAX(a.AccountNumber) AS AccountNumber2

FROM	AccountStatus ast

INNER	JOIN AccountContract ac
ON		ast.AccountContractID = ac.AccountContractID

INNER	JOIN Account a
ON		a.AccountID = ac.AccountID
AND		a.CurrentContractID = ac.ContractID

INNER	JOIN Utility u
ON		a.UtilityID = u.ID

WHERE	ast.Status = '911000' 
--AND		u.UtilityCode like'%PEPCO%'
AND		u.UtilityCode like'%O&R%'

GROUP	BY u.WholeSaleMktID, u.UtilityCode, u.ShortName, a.LoadProfile, a.Zone
ORDER	BY u.WholeSaleMktID, u.UtilityCode, a.Zone
