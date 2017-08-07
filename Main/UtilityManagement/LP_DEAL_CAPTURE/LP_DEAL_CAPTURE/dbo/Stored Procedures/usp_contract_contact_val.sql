﻿


















CREATE procedure [dbo].[usp_contract_contact_val]
(@p_username                                        nchar(100),
 @p_action                                          char(01),
 @p_edit_type                                       varchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30),
 @p_first_name                                      varchar(50),
 @p_last_name                                       varchar(50),
 @p_title                                           varchar(20),
 @p_phone                                           varchar(20),
 @p_fax                                             varchar(20),
 @p_email                                           nvarchar(256),
 @p_birthday                                        char(05),
 @p_application                                     varchar(20) output,
 @p_error                                           char(01) output,
 @p_msg_id                                          char(08) output,
 @p_process                                         varchar(15) = 'ONLINE',
 @p_contact_type                                    varchar(20) = ' ')
as
 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(150)
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ' '
select @w_return                                    = 0
select @w_descp_add                                 = ' '
 
declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

exec @w_return = usp_contract_express_val @p_action,
                                          @p_contract_nbr,
                                          @p_account_number,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output

if @w_return                                       <> 0
begin

   if @p_process                                    = 'BATCH'
   begin

      select @w_descp_add                           = '(' + ltrim(rtrim(@p_contact_type))
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'


      exec usp_contract_error_ins 'DEAL_CAPTURE',
                                  @p_contract_nbr,
                                  @p_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add
   end
   else
   begin
      goto goto_select
   end
end
 
if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'FIRST_NAME'
begin
 
   if @p_first_name                                is null
   or @p_first_name                                 = ' '
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000071'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin

         select @w_descp_add                        = '(' + ltrim(rtrim(@p_contact_type))
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'


         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         goto goto_select
      end
   end
end
 
if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'LAST_NAME'
begin
 
   if @p_last_name                                 is null
   or @p_last_name                                  = ' '
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000072'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin

         select @w_descp_add                        = '(' + ltrim(rtrim(@p_contact_type))
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'


         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         goto goto_select
      end
   end

end
 
if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'TITLE'
begin
 
   if @p_title                                     is null
   or @p_title                                      = ' '
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000073'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin

         select @w_descp_add                        = '(' + ltrim(rtrim(@p_contact_type))
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'


         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         goto goto_select
      end
   end
 
end
 
if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'PHONE'
begin
 
   if @p_phone                                     is null
   or @p_phone                                      = ' '
   or len(ltrim(rtrim(@p_phone)))                   < 10
   or (isnumeric(@p_phone)                          = 1
   and convert(money, @p_phone)                     = 0)
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000074'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin

         select @w_descp_add                        = '(' + ltrim(rtrim(@p_contact_type))
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'


         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         goto goto_select
      end
   end
 
end

/*  do not validate birthday

if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'BIRTHDAY'
begin
 
   if @p_birthday                                  is null
   or @p_birthday                                   = ' '
   or @p_birthday                                   = 'NONE'
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000077'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin

         select @w_descp_add                        = '(' + ltrim(rtrim(@p_contact_type))
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                   + ltrim(rtrim(@p_account_number)) + ')'


         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         goto goto_select
      end
   end
 
end

*/

goto_select:

select @p_error                                     = @w_error
select @p_msg_id                                    = @w_msg_id
select @p_application                               = @w_application

return @w_return
 
 



















