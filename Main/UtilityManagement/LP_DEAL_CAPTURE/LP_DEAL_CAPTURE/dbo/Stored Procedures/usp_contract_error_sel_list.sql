


CREATE procedure [dbo].[usp_contract_error_sel_list]
(@p_contract_nbr                                    varchar(25))
as

select distinct 
       a.process_id,
       a.contract_nbr,
       a.account_number,
       message_error                                = ltrim(rtrim(b.msg_descp))
                                                    + ' '
                                                    + ltrim(rtrim(a.descp_add))
from deal_contract_error a with (NOLOCK INDEX = deal_contract_error_idx),
     lp_common..common_messages  b with (NOLOCK INDEX = common_messages_idx)
where a.contract_nbr                                = @p_contract_nbr
and   a.application                                 = b.application
and   a.msg_id                                      = b.msg_id



