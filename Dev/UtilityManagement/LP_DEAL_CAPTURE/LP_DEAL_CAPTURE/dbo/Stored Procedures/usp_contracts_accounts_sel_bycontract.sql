




-- exec usp_contracts_accounts_sel_bycontract 'admin', '2006-0000121'

 
CREATE procedure [dbo].[usp_contracts_accounts_sel_bycontract] 
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12))
as

select a.option_id,
       a.return_value
from (select seq                                    = '0',
             option_id                              = 'Contract',
             return_value                           = 'CONTRACT'
      union
      select seq                                    = account_id,
             option_id                              = 'Account # ' + account_number,
             return_value                           = account_number
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx) 
      where contract_nbr                            = @p_contract_nbr) a
order by a.seq

 






