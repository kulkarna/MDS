





--exec usp_contract_name_sel 'WVILCHEZ', '2006-0000121', 'CUSTOMER', '123456'

create procedure [dbo].[usp_contract_name_sel_bylink]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_name_link                                       int)
as

select name_link,
       full_name
from deal_name with (NOLOCK INDEX = deal_name_idx)
where contract_nbr                                  = @p_contract_nbr
and   name_link                                     = @p_name_link
