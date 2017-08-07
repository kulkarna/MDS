begin tran
update libertypower..AccountContractRate 
set RateID              = '1000000278'
,LegacyProductID        = 'PECO_FX'
,PriceID                = 2081621874
from libertypower..AccountContractRate ACR with (nolock)
inner join Libertypower..AccountContract AC with (nolock)
on AC.AccountContractId            = ACR.AccountContractID
inner join LibertyPower..Account   AA With (Nolock)
on AA.CurrentContractID            = AC.ContractID
and AA.AccountId                    =  AC.AccountID
where AA.AccountNumber             in ('5593301504','6835200500')
commit tran



