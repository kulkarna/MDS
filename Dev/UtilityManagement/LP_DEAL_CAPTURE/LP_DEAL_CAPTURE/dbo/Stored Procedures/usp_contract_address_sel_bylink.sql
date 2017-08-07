






--exec usp_contract_address_sel 'WVILCHEZ', '2006-0000121', 'BILLING', '123456'

create procedure [dbo].[usp_contract_address_sel_bylink]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_address_link                                    int)
as

select address_link,
       address,
       suite,
       city,
       state,
       zip
from deal_address with (NOLOCK INDEX = deal_address_idx)
where contract_nbr                                  = @p_contract_nbr
and   address_link                                  = @p_address_link
