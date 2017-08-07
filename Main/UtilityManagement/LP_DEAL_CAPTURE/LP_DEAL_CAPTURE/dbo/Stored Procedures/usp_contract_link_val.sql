














CREATE procedure [dbo].[usp_contract_link_val]
(@p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30),
 @p_customer_name_link                              int,
 @p_customer_address_link                           int,
 @p_customer_contact_link                           int,
 @p_billing_address_link                            int,
 @p_billing_contact_link                            int,
 @p_owner_name_link                                 int,
 @p_service_address_link                            int,
 @p_account_name_link                               int,
 @p_application                                     varchar(20) output,
 @p_error                                           char(01) output,
 @p_msg_id                                          char(08) output,
 @p_descp_add                                       varchar(100) output,
 @p_process                                         varchar(15) = 'ONLINE')
as

declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_application                              varchar(20)
declare @w_return                                   int
declare @w_descp_add                                varchar(100)
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_application                               = 'COMMON'
select @w_return                                    = 0
select @w_descp_add                                 = ' '

select @w_descp_add                                 = case when @p_account_number = 'CONTRACT'
                                                           then '(Customer Contract)'
                                                           else '(Customer Account Number ' + ltrim(rtrim(@p_account_number)) + ')'
                                                      end

if @p_customer_name_link                            = 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000039'
   select @w_return                                 = 1
   if @p_process                                    = 'BATCH'
   begin
      exec usp_contract_error_ins @p_contract_nbr,
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

if @p_customer_address_link                         = 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000037'
   select @w_return                                 = 1
   if @p_process                                    = 'BATCH'
   begin
      exec usp_contract_error_ins @p_contract_nbr,
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

if @p_customer_contact_link                         = 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000038'
   select @w_return                                 = 1

   if @p_process                                    = 'BATCH'
   begin
      exec usp_contract_error_ins @p_contract_nbr,
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

select @w_descp_add                                 = case when @p_account_number = 'CONTRACT'
                                                           then '(Billing Contract)'
                                                           else '(Billing Account Number ' + ltrim(rtrim(@p_account_number)) + ')'
                                                      end

if @p_billing_address_link                          = 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000037'
   select @w_return                                 = 1
   if @p_process                                    = 'BATCH'
   begin
      exec usp_contract_error_ins @p_contract_nbr,
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

if @p_billing_contact_link                          = 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000038'
   select @w_return                                 = 1
   if @p_process                                    = 'BATCH'
   begin
      exec usp_contract_error_ins @p_contract_nbr,
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

select @w_descp_add                                 = case when @p_account_number = 'CONTRACT'
                                                           then '(Owner Contract)'
                                                           else '(Owner Account Number ' + ltrim(rtrim(@p_account_number)) + ')'
                                                      end

if @p_owner_name_link                               = 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000039'
   select @w_return                                 = 1
   if @p_process                                    = 'BATCH'
   begin
      exec usp_contract_error_ins @p_contract_nbr,
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

select @w_descp_add                                 = case when @p_account_number = 'CONTRACT'
                                                           then '(Service Contract)'
                                                           else '(Service Account Number ' + ltrim(rtrim(@p_account_number)) + ')'
                                                      end

if @p_service_address_link                          = 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000037'
   select @w_return                                 = 1
   if @p_process                                    = 'BATCH'
   begin
      exec usp_contract_error_ins @p_contract_nbr,
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

select @w_descp_add                                 = case when @p_account_number = 'CONTRACT'
                                                           then '(Account Contract)'
                                                           else '(Account Number ' + ltrim(rtrim(@p_account_number)) + ')'
                                                      end

if @p_account_name_link                             = 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000039'
   select @w_return                                 = 1
   if @p_process                                    = 'BATCH'
   begin
      exec usp_contract_error_ins @p_contract_nbr,
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

goto_select:

select @p_error                                     = @w_error
select @p_msg_id                                    = @w_msg_id
select @p_application                               = @w_application
select @p_descp_add                                 = @w_descp_add

return @w_return








