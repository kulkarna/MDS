begin tran
update libertypower..AccountContractRate 
set RateID              = '1000000092'
,PriceID                = 2102542827
from libertypower..AccountContractRate ACR with (nolock)
inner join Libertypower..AccountContract AC with (nolock)
on AC.AccountContractId            = ACR.AccountContractID
inner join LibertyPower..Account   AA With (Nolock)
on AA.CurrentContractID            = AC.ContractID
and AA.AccountId                    =  AC.AccountID
where AA.AccountNumber             in ('5049741977')
commit tran
