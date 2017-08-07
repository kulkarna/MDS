




--exec usp_contract_contact_sel 'WVILCHEZ', '2006-0000121', 'BILLING', '123456'

create procedure [dbo].[usp_contract_contact_sel_bylink]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_contact_link                                    int)
as


select contact_link,
       first_name,
       last_name,
       title,
       phone,
       fax,
       email,
       birthday
from deal_contact with (NOLOCK INDEX = deal_contact_idx)
where contract_nbr                                  = @p_contract_nbr
and   contact_link                                  = @p_contact_link
