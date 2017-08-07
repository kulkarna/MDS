



CREATE procedure [dbo].[usp_contract_account_del_all]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12), 
 @p_error                                           char(01) = ' ',
 @p_msg_id                                          char(08) = ' ',
 @p_descp                                           varchar(250) = ' ',
 @p_result_ind                                      char(01) = 'Y')
as

declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
 
select @w_error                                     = 'D'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ' '
select @w_return                                    = 0

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'


if @w_return                                       <> 0
begin
   goto goto_select
end

DELETE FROM account_meters
WHERE		account_id in (	SELECT	account_id 
							FROM	deal_contract_account WITH (NOLOCK)
							WHERE	contract_nbr = @p_contract_nbr
						  )

delete deal_contract_account
from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
where contract_nbr                                  = @p_contract_nbr

if @@error                                         <> 0
or @@rowcount                                       = 0
begin
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000002'
   select @w_return                                 = 1
end

goto_select:

if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output,
                                    @w_application
end
 
if @p_result_ind                                    = 'Y'
begin
   select flag_error                                = @w_error,
          code_error                                = @w_msg_id,
          message_error                             = @w_descp
   goto goto_return
end
 
select @p_error                                     = @w_error,
       @p_msg_id                                    = @w_msg_id,
       @p_descp                                     = @w_descp
 
goto_return:
return @w_return







