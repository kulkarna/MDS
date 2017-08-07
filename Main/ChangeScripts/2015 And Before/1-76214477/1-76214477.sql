

begin tran

-- select a.AccountID, a.AccountNumber, a.BillingTypeID, bt.[Type], u.BillingType, u.UtilityCode, bt2.*
update a
set BillingTypeID = bt2.BillingTypeID
from LibertyPower.dbo.Account a with (nolock) 
join LibertyPower.dbo.BillingType bt with (nolock) on a.BillingTypeID = bt.BillingTypeID
join LibertyPower.dbo.Utility u with (nolock)  on a.UtilityID = u.ID
join LibertyPower.dbo.BillingType bt2 with (nolock) on u.BillingType = bt2.Type
where a.AccountNumber in
('08019779280000899497','08019779280000898313','08019779260000898312','08019779280000897923','08019779280000897922'
,'08019779280000618169','08019779280003155216','08019779280000909009','08019779280000900377','08016212820000216768'
,'08013607730000407530','08018977140000748050','08001506690000136533','08019269420000522787','0522801601','5491600206'
,'8744681032','9053810020','5948801408','9349955021','4362523013','9120700705','5950089027','2871000306','1320926020'
,'1953023063','0696106055','8256003075','1095033089','5379105053','0658764008','4681101608','8083701000','3445100101'
,'3754400700','4410200906','0689504032','1000201603','6574901909','00040621071367252','00040621066779725','00040621014148544',
'00040621095931161','00040621038233655','00040621021659412','00040621014915682','00040621076488673','3379570880','00040621086274030',
'00140060728107570','00140060721563435','00140060759036535')
and bt.[Type] !=  u.BillingType

-- rollback
commit

-- Commented for future reference
--select COUNT(*) -- a.AccountID, a.AccountNumber, a.BillingTypeID, bt.[Type], u.BillingType, u.UtilityCode
--from LibertyPower.dbo.Account a with (nolock) 
--join LibertyPower.dbo.AccountContract ac with (nolock) on a.AccountID = ac.ContractID
--join LibertyPower.dbo.AccountStatus ast with (nolock) on ac.AccountContractID = ast.AccountContractID and ast.Status = '905000' and ast.SubStatus = '10'
--join LibertyPower.dbo.BillingType bt with (nolock) on a.BillingTypeID = bt.BillingTypeID
--join LibertyPower.dbo.Utility u with (nolock)  on a.UtilityID = u.ID
--where bt.[Type] !=  u.BillingType

