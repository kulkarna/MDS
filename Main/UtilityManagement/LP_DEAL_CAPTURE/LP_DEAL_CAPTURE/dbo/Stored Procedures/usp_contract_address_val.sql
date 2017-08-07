
CREATE procedure [dbo].[usp_contract_address_val]
(@p_username		nchar(100),
 @p_action          char(01),
 @p_edit_type       varchar(100),
 @p_contract_nbr    char(12),
 @p_account_number  varchar(30),
 @p_address         char(50),
 @p_city            char(28),
 @p_state           char(02),
 @p_zip             char(10),
 @p_application     varchar(20) output,
 @p_error           char(01) output,
 @p_msg_id          char(08) output,
 @p_descp_add       varchar(150) output,
 @p_process         varchar(15) = 'ONLINE',
 @p_address_type    varchar(20) = ' ')
as

 
declare @w_error		char(01)
declare @w_msg_id		char(08)
declare @w_descp		varchar(250)
declare @w_return		int
declare @w_descp_add	varchar(150)
 
select @w_error = 'I', @w_msg_id = '00000001', @w_descp = ' ', @w_return = 0, @w_descp_add = ' '
 
declare @w_application	varchar(20)
select @w_application	= 'COMMON'

exec @w_return = usp_contract_express_val @p_action,
                                          @p_contract_nbr,
                                          @p_account_number,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output

if @w_return <> 0
begin
   if @p_process = 'BATCH'
   begin
      select @w_descp_add = '(' + ltrim(rtrim(@p_address_type)) 
                                + case when @p_account_number = 'CONTRACT' then ' ' else ' Account Number ' end
                                + ltrim(rtrim(@p_account_number)) + ')'

      exec usp_contract_error_ins 'DEAL_CAPTURE', @p_contract_nbr, @p_account_number, @w_application, @w_error, @w_msg_id, @w_descp_add
   end
   else
      goto goto_select
end

if @p_edit_type = 'ALL' or @p_edit_type = 'ADDRESS'
begin
   if @p_address is null or @p_address = ' '
   begin
      select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000011', @w_return = 1

      if @p_process = 'BATCH'
      begin
         select @w_descp_add = '(' + ltrim(rtrim(@p_address_type)) 
                                   + case when @p_account_number = 'CONTRACT' then ' ' else ' Account Number ' end
                                   + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE', @p_contract_nbr, @p_account_number, @w_application, @w_error, @w_msg_id, @w_descp_add
      end
      else
         goto goto_select
   end
end

if @p_edit_type = 'ALL' or @p_edit_type = 'CITY'
begin
   if @p_city is null or @p_city = ' '
   begin
      select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000013', @w_return = 1

      if @p_process = 'BATCH'
      begin
         select @w_descp_add = '(' + ltrim(rtrim(@p_address_type)) 
                                   + case when @p_account_number = 'CONTRACT' then ' ' else ' Account Number ' end
                                   + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE', @p_contract_nbr, @p_account_number, @w_application, @w_error, @w_msg_id, @w_descp_add
      end
      else
         goto goto_select
   end
 
end

if @p_edit_type = 'ALL' or @p_edit_type = 'STATE'
begin
   if @p_state is null or @p_state = ' '
   begin
      select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000014', @w_return = 1

      if @p_process = 'BATCH'
      begin
         select @w_descp_add = '(' + ltrim(rtrim(@p_address_type))
                                   + case when @p_account_number = 'CONTRACT' then ' ' else ' Account Number ' end
                                   + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE', @p_contract_nbr, @p_account_number, @w_application, @w_error, @w_msg_id, @w_descp_add
      end
      else
         goto goto_select
   end
 
end

if @p_edit_type = 'ALL' or @p_edit_type = 'ZIP'
begin
   if @p_zip is null or @p_zip = ' '
   begin
      select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000015', @w_return = 1

      if @p_process = 'BATCH'
      begin
         select @w_descp_add = '(' + ltrim(rtrim(@p_address_type)) 
                                   + case when @p_account_number = 'CONTRACT' then ' ' else ' Account Number ' end
                                   + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE', @p_contract_nbr, @p_account_number, @w_application, @w_error, @w_msg_id, @w_descp_add
      end
      else
         goto goto_select
   end
 
end

declare @w_datapath varchar(250)

select @w_datapath = verify_address_directory
from lp_common..common_config

exec @w_return = lp_common..usp_verify_address ' ',
                                               @p_address,
                                               ' ',
                                               @p_city,
                                               @p_state,
                                               @p_zip,
                                               @w_datapath,
                                               @w_application output,
                                               @w_error output,
                                               @w_msg_id output,
                                               @w_descp_add output 

if  @p_process = 'BATCH' and @w_return <> 1
begin
   select @w_return = 1

   select @w_descp_add = '(' + ltrim(rtrim(@p_address_type))
                             + case when @p_account_number = 'CONTRACT' then ' ' else ' Account Number ' end
                             + ltrim(rtrim(@p_account_number)) + ')'
         
   exec usp_contract_error_ins 'DEAL_CAPTURE', @p_contract_nbr, @p_account_number, @w_application, @w_error, @w_msg_id, @w_descp_add
end

goto_select:

select @p_error = @w_error, @p_msg_id = @w_msg_id, @p_application = @w_application, @p_descp_add = @w_descp_add

return @w_return



