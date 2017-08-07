






CREATE procedure [dbo].[usp_contract_error_ins]
(@p_process_id                                      varchar(15),
 @p_contract_nbr                                    varchar(25),
 @p_contract_number                                 varchar(30),
 @p_application                                     varchar(20),
 @p_error                                           char(01),
 @p_msg_id                                          char(08),
 @p_descp_add                                       varchar(100) = ' ')
as
insert deal_contract_error
select @p_process_id,
       @p_contract_nbr,
       @p_contract_number,
       @p_application,
       @p_error,
       @p_msg_id,
       @p_descp_add

update deal_contract set status = 'DRAFT - ERROR'
from deal_contract with (NOLOCK INDEX = deal_contract_idx)
where contract_nbr                                  = @p_contract_nbr


      






