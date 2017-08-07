
/*
* History
 *******************************************************************************
 * <Date Created,date,> - <Developer Name,,>
 * Created.
 *******************************************************************************
 *******************************************************************************
 * 07/23/2010 - Jose Munoz
 * Ticket: 17179
   Add validation of the account lenght into process BATCH.
   
   Original
   if  @w_return                                  <> 0
   and @w_process_origin                           = 'ONLINE'
   begin
      select @w_descp_add                          = '(Account Number ' + ltrim(rtrim(@w_account_number)) + ')'
      goto goto_select
   end

	NEW
	if  @w_return                                  <> 0
   and @w_process_origin                           in('ONLINE', 'BATCH')
   begin
      select @w_descp_add                          = '(Account Number ' + ltrim(rtrim(@w_account_number)) + ')'
      goto goto_select
   end

   
 *******************************************************************************
 * 12/01/2010 - Isabelle Tamanini
 * Modified the usp_contract_pricing_val call so that it passes the contract date
 *******************************************************************************
*/
--exec usp_contract_submit_val 'LIBERTYPOWER\Dmarino', 'ONLINE', '646464646'

CREATE procedure [dbo].[usp_contract_submit_val]
(@p_username                                        nchar(100),
 @p_process                                         varchar(15),
 @p_contract_nbr                                    char(12),
 @p_contract_type                                   varchar(15) = ' ',
 @p_application                                     varchar(20) = ' ' output,
 @p_error                                           char(01) = ' ' output,
 @p_msg_id                                          char(08) = ' ' output,
 @p_descp_add                                       varchar(150) = ' ' output)
as

declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(100)

select @w_error                                    = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ' '
select @w_return                                    = 0
select @w_descp_add                                 = ' '

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

declare @w_rowcount                                 int

if @p_contract_type                                 in ('POLR','POWER MOVE')
begin
   goto goto_submit
end

declare @w_account_number                           varchar(30)
declare @w_contract_type                            varchar(15)
declare @w_status                                   varchar(15)
declare @w_username                                 nchar(100)
declare @w_customer_name_link                       int
declare @w_customer_address_link                    int
declare @w_customer_contact_link                    int
declare @w_billing_address_link                     int
declare @w_billing_contact_link                     int
declare @w_owner_name_link                          int
declare @w_service_address_link                     int
declare @w_account_name_link                        int

declare @w_retail_mkt_id                            char(02)
declare @w_utility_id                               char(15)
declare @w_product_id                               char(20)
declare @w_rate_id                                  int
declare @w_rate                                     float
declare @w_business_type                            varchar(35)
declare @w_business_activity                        varchar(35)
declare @w_additional_id_nbr_type                   varchar(10)
declare @w_additional_id_nbr                        varchar(30)
declare @w_term_months                              int
declare @w_date_submit                              datetime
declare @w_sales_channel_role                       nvarchar(50)
declare @w_sales_rep                                varchar(100)
declare @w_origin                                   varchar(50)

declare @w_address                                  char(50)
declare @w_suite                                    char(10)
declare @w_city                                     char(28)
declare @w_state                                    char(02)
declare @w_zip                                      char(10)

declare @w_first_name                               varchar(50)
declare @w_last_name                                varchar(50)
declare @w_title                                    varchar(20)
declare @w_phone                                    varchar(20)
declare @w_fax                                      varchar(20)
declare @w_email                                    nvarchar(256)
declare @w_birthday                                 varchar(05)

declare @w_full_name                                varchar(100)

select @w_contract_type                             = ''
select @w_status                                    = ''
select @w_username                                  = ''
select @w_sales_channel_role                        = ''
select @w_customer_name_link                        = 0
select @w_customer_address_link                     = 0
select @w_customer_contact_link                     = 0
select @w_billing_address_link                      = 0
select @w_billing_contact_link                      = 0
select @w_owner_name_link                           = 0
select @w_service_address_link                      = 0
select @w_retail_mkt_id                             = ''
select @w_utility_id                                = ''
select @w_product_id                                = ''
select @w_rate_id                                   = 0
select @w_rate                                      = 0
select @w_business_type                             = ''
select @w_business_activity                         = ''
select @w_additional_id_nbr_type                    = ''
select @w_additional_id_nbr                         = ''
select @w_term_months                               = 0
select @w_date_submit                               = '19000101'
select @w_sales_channel_role                        = ''
select @w_sales_rep                                 = ''
select @w_address                                   = ''
select @w_suite                                     = ''
select @w_city                                      = ''
select @w_state                                     = ''
select @w_zip                                       = ''

declare @w_enrollment_type                          int
declare @w_requested_flow_start_date                datetime
declare @w_deal_type                                char(20)
declare @w_customer_code                            char(05)
declare @w_customer_group                           char(100)
DECLARE	@PriceID									bigint

select @w_enrollment_type                           = 0
select @w_requested_flow_start_date                 = '19000101'
select @w_deal_type                                 = ''
select @w_customer_code                             = ''
select @w_customer_group                            = ''

declare @w_contract_date datetime
select @w_contract_date = null 

declare @today datetime
select @today = dateadd(dd,datediff(dd, 0, getdate()),0)

select @w_contract_type                             = contract_type,
       @w_status                                    = status,
       @w_username                                  = username,
       @w_sales_channel_role                        = sales_channel_role,
       @w_customer_name_link                        = customer_name_link,
       @w_customer_address_link                     = customer_address_link,
       @w_customer_contact_link                     = customer_contact_link,
       @w_billing_address_link                      = billing_address_link,
       @w_billing_contact_link                      = billing_contact_link,
       @w_owner_name_link                           = owner_name_link,
       @w_service_address_link                      = service_address_link,
       @w_retail_mkt_id                             = retail_mkt_id,
       @w_utility_id                                = utility_id,
       @w_product_id                                = product_id,
       @w_rate_id                                   = rate_id,
       @w_rate                                      = rate,
       @w_business_type                             = business_type,
       @w_business_activity                         = business_activity,
       @w_additional_id_nbr_type                    = additional_id_nbr_type,
       @w_additional_id_nbr                         = additional_id_nbr,
       @w_term_months                               = term_months,
       @w_date_submit                               = date_submit,
       @w_sales_channel_role                        = sales_channel_role,
       @w_sales_rep                                 = sales_rep,
       @w_origin                                    = origin,
       @w_enrollment_type                           = isnull(enrollment_type, 1),
       @w_requested_flow_start_date                 = isnull(requested_flow_start_date, '19000101'),
       @w_deal_type                                 = isnull(deal_type, ''),
       @w_customer_code                             = isnull(customer_code, ''),
       @w_customer_group                            = isnull(customer_group, ''),
       @w_contract_date								= case when date_deal = @today 
													    then null
														else date_deal
													  end,
		@PriceID									= PriceID
from deal_contract with (NOLOCK INDEX = deal_contract_idx)
where contract_nbr                                  = @p_contract_nbr


declare @w_process_origin                           varchar(15)
select @w_process_origin                            = @w_origin


--New Contract - start
if @p_process                                not like 'BATCH_%'
begin
   delete deal_contract_error
   from deal_contract_error with (NOLOCK INDEX = deal_contract_error_idx)
   where contract_nbr                              = @p_contract_nbr

end 

if @p_process                                    like 'BATCH_%'
begin
   select @w_process_origin                         = @p_process
end

--New Contract - end

select @w_descp_add                                 = ' '

select @w_account_number                            = 'CONTRACT'

exec @w_return = usp_contract_val @p_username,
                                  'U',
                                  'ALL',
                                  @p_contract_nbr,
                                  @w_contract_type,
                                  @w_status,
                                  @w_username,
                                  @w_contract_type,
                                  @w_sales_channel_role,
                                  @w_application output,
                                  @w_error output,
                                  @w_msg_id output,
                                  @w_process_origin

--New Contract - start
if  @w_return                                      <> 0
and @p_process                                   like 'BATCH_%'
begin 
   insert into #contract_error
   select @p_contract_nbr,
          @w_account_number,
          @w_application,
          @w_error,
          @w_msg_id,
          @w_descp_add
   goto goto_batch_load
end
--New Contract - end

if  @w_return                                      <> 0
begin
   if @w_process_origin                             = 'BATCH'
   begin
      exec usp_contract_error_ins 'DEAL_CAPTURE',
                                  @p_contract_nbr,
                                  @w_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add
      return 1
   end

   goto goto_select
end

select @w_descp_add                                 = ' '

exec @w_return = usp_contract_link_val @p_contract_nbr,
                                       @w_account_number,
                                       @w_customer_name_link,
                                       @w_customer_address_link,
                                       @w_customer_contact_link,
                                       @w_billing_address_link,
                                       @w_billing_contact_link,
                                       @w_owner_name_link,
                                       @w_service_address_link,
                                       1,
                                       @w_application output,
                                       @w_error output,
                                       @w_msg_id output,
                                       @w_descp_add output,
                                       @w_process_origin


if  @w_return                                      <> 0
and @w_process_origin                               = 'ONLINE'
begin
   goto goto_select
end

select @w_descp_add                                 = ' '

exec @w_return = usp_contract_general_val @p_username,
                                          'V',
                                          'ALL',
                                          @p_contract_nbr,
                                          @w_account_number,
                                          @w_business_type,
                                          @w_business_activity,
                                          @w_additional_id_nbr_type,
                                          @w_additional_id_nbr,
                                          @w_date_submit,
                                          @w_sales_channel_role,
                                          @w_sales_rep,
                                          @w_deal_type,
                                          @w_utility_id,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output,
                                          @w_process_origin


if  @w_return                                      <> 0
and @w_process_origin                               = 'ONLINE'
begin
   goto goto_select
end

exec @w_return = usp_contract_pricing_val @p_username,
                                          'V',
                                          'ALL',
                                          @p_contract_nbr,
                                          @w_account_number,
                                          @w_retail_mkt_id,
                                          @w_utility_id,
                                          @w_product_id,
                                          @w_rate_id,
                                          @w_rate,
                                          @w_term_months,
                                          @w_enrollment_type,
                                          @w_requested_flow_start_date,
                                          @w_contract_date,
                                          @w_customer_code,
                                          @w_customer_group,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output,
                                          @w_process_origin,
                                          @PriceID

if  @w_return                                      <> 0
and @w_process_origin                               = 'ONLINE'
begin
   goto goto_select
end

declare @w_address_type                             varchar(20)
declare @w_address_link                             int

select @w_descp_add                                 = ' '
if  @w_customer_address_link                        = 0
and @w_billing_address_link                         = 0
and @w_service_address_link                         = 0
begin
   goto goto_contact
end

select @w_address_type                              = 'CUSTOMER'
select @w_address_link                              = @w_customer_address_link

while @w_address_type                              <> ' '
begin

   if @w_address_link                               = 0
   begin
      goto goto_address_link
   end

   select @w_address                                = ''
   select @w_suite                                  = ''
   select @w_city                                   = ''
   select @w_state                                  = ''
   select @w_zip                                    = ''

   select @w_address                                = address,
          @w_suite                                  = suite,
          @w_city                                   = city,
          @w_state                                  = state,
          @w_zip                                    = zip
   from deal_address with (NOLOCK INDEX = deal_address_idx)
   where contract_nbr                               = @p_contract_nbr
   and   address_link                               = @w_address_link

   select @w_descp_add                              = ' '

   -- This will check the Customer, Billing, and Service addresses for the contract
--   exec @w_return = usp_contract_address_val @p_username,
--                                             'V',
--                                             'ALL',
--                                             @p_contract_nbr,
--                                             @w_account_number,
--                                             @w_address,
--                                             @w_city,
--                                             @w_state,
--                                             @w_zip,
--                                             @w_application output,
--                                             @w_error output,
--                                             @w_msg_id output,
--                                             @w_process_origin,
--                                             @w_address_type


   if  @w_return                                   <> 0
   and @w_process_origin                            = 'ONLINE'
   begin
      select @w_descp_add                           = '(' + ltrim(rtrim(@w_address_type)) + ' ' + ltrim(rtrim(@w_account_number)) + ')'
      goto goto_select
   end

   goto_address_link:

   select @w_address_link                           = case when @w_address_type = 'CUSTOMER'
                                                           then @w_billing_address_link
                                                           when @w_address_type = 'BILLING'
                                                           then @w_service_address_link
                                                           else 0
                                                      end

   select @w_address_type                           = case when @w_address_type = 'CUSTOMER'
                                                           then 'BILLING'
                                                           when @w_address_type = 'BILLING'
                                                           then 'SERVICE'
                                                           else ' '
                                                      end
   
end

declare @w_contact_type                             varchar(20)
declare @w_contact_link                             int

goto_contact:

if  @w_customer_contact_link                        = 0
and @w_billing_contact_link                         = 0
begin
   goto goto_name
end

select @w_contact_type                              = 'CUSTOMER'
select @w_contact_link                              = @w_customer_contact_link

while @w_contact_type                              <> ' '
begin

   if @w_contact_link                               = 0
   begin
      goto goto_contact_link
   end

   select @w_first_name                             = ''
   select @w_last_name                              = ''
   select @w_title                                  = ''
   select @w_phone                                  = ''
   select @w_fax                                    = ''
   select @w_email                                  = ''
   select @w_birthday                               = ''

   select @w_first_name                             = first_name,
          @w_last_name                              = last_name,
          @w_title                                  = title,
          @w_phone                                  = phone,
          @w_fax                                    = fax,
          @w_email                                  = email,
          @w_birthday                               = birthday   
   from deal_contact with (NOLOCK INDEX = deal_contact_idx)
   where contract_nbr                               = @p_contract_nbr
   and   contact_link                               = @w_contact_link

   select @w_descp_add                              = ' '

   exec @w_return = usp_contract_contact_val @p_username,
                                             'V',
                                             'ALL',
                                             @p_contract_nbr,
                                             @w_account_number,
                                             @w_first_name,
                                             @w_last_name,
                                             @w_title,
                                             @w_phone,
                                             @w_fax,
                                             @w_email,
                                             @w_birthday,
                                             @w_application output,
                                             @w_error output,
                                             @w_msg_id output,
                                             @w_process_origin,
                                             @w_contact_type

--New Contract - start
   if  @w_return                                   <> 0
   and @p_process                                like 'BATCH_%'
   begin 
      insert into #contract_error
      select @p_contract_nbr,
             @w_account_number,
             @w_application,
             @w_error,
             @w_msg_id,
             ' (' + lower(ltrim(rtrim(@w_contact_type))) + ' contact)'

   end
--New Contract - end

   if  @w_return                                   <> 0
   and @w_process_origin                            = 'ONLINE'
   begin
      select @w_descp_add                           = '(' + ltrim(rtrim(@w_contact_type)) + ' ' + ltrim(rtrim(@w_account_number)) + ')'
      goto goto_select
   end

   goto_contact_link:

   select @w_contact_link                           = case when @w_contact_type = 'CUSTOMER'
                                                           then @w_billing_contact_link
                                                           else 0
                                                      end

   select @w_contact_type                           = case when @w_contact_type = 'CUSTOMER'
                                                           then 'BILLING'
                                                           else ' '
                                                      end
   
end

goto_name:

declare @w_name_type                                varchar(20)
declare @w_name_link                                int

if  @w_customer_name_link                           = 0
and @w_owner_name_link                              = 0
begin
   goto goto_acc
end

select @w_name_type                                 = 'CUSTOMER'
select @w_name_link                                 = @w_customer_name_link

while @w_name_type                                 <> ' '
begin

   if @w_name_link                               = 0
   begin
      goto goto_name_link
   end

   select @w_full_name                              = ''

   select @w_full_name                              = full_name
   from deal_name with (NOLOCK INDEX = deal_name_idx)
   where contract_nbr                               = @p_contract_nbr
   and   name_link                                  = @w_name_link

   select @w_descp_add                              = ' '

   exec @w_return = usp_contract_name_val @p_username,
                                          'V',
                                          'ALL',
                                          @p_contract_nbr,
                                          @w_account_number,
                                          @w_full_name,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output,
                                          @w_process_origin,
                                          @w_name_type

--New Contract - start
   if  @w_return                                   <> 0
   and @p_process                                like 'BATCH_%'
   begin 
      insert into #contract_error
      select @p_contract_nbr,
             @w_account_number,
             @w_application,
             @w_error,
             @w_msg_id,
             ' (' + lower(ltrim(rtrim(@w_name_type))) + ' name)'
   end
--New Contract - end


   if  @w_return                                   <> 0
   and @w_process_origin                            = 'ONLINE'
   begin
      select @w_descp_add                           = '(' + ltrim(rtrim(@w_name_type)) + ' ' + ltrim(rtrim(@w_account_number)) + ')'
      goto goto_select
   end

   goto_name_link:

   select @w_name_link                              = case when @w_name_type = 'CUSTOMER'
                                                           then @w_owner_name_link
                                                           else 0
                                                      end

   select @w_name_type                              = case when @w_name_type = 'CUSTOMER'
                                                           then 'OWNER'
                                                           else ' '
                                                      end
   
end

goto_acc:

create table #account
(account_number                                     varchar(30))

insert into #account
select account_number
from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
where contract_nbr                                  = @p_contract_nbr

set rowcount 1

select @w_account_number                            = account_number
from #account

select @w_rowcount                                  = @@rowcount

if @w_rowcount                                      = 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000040'
   select @w_return                                 = 1
   select @w_descp_add                              = ' '

--New Contract - start
   if @p_process                                 like 'BATCH_%'
   begin 
      insert into #contract_error
      select @p_contract_nbr,
             @w_account_number,
             @w_application,
             @w_error,
             @w_msg_id,
             @w_descp_add
      goto goto_batch_load
   end
--New Contract - end

   if @w_process_origin                             = 'BATCH'
   begin
      exec usp_contract_error_ins 'DEAL_CAPTURE',
                                  @p_contract_nbr,
                                  @w_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add
      return 1

   end
   goto goto_select
end

while @w_rowcount                                  <> 0
begin
   set rowcount 0

   select @w_contract_type                          = ''
   select @w_status                                 = ''
   select @w_username                               = ''
   select @w_sales_channel_role                     = ''
   select @w_customer_name_link                     = 0
   select @w_customer_address_link                  = 0
   select @w_customer_contact_link                  = 0
   select @w_billing_address_link                   = 0
   select @w_billing_contact_link                   = 0
   select @w_owner_name_link                        = 0
   select @w_service_address_link                   = 0
   select @w_retail_mkt_id                          = ''
   select @w_utility_id                             = ''
   select @w_product_id                             = ''
   select @w_rate_id                                = 0
   select @w_rate                                   = 0
   select @w_business_type                          = ''
   select @w_business_activity                      = ''
   select @w_additional_id_nbr_type                 = ''
   select @w_additional_id_nbr                      = ''
   select @w_term_months                            = 0
   select @w_date_submit                            = '19000101'
   select @w_sales_channel_role                     = ''
   select @w_sales_rep                              = ''
   select @w_requested_flow_start_date              = '19000101'
   select @w_deal_type                              = ''
   select @w_customer_code                          = ''
   select @w_customer_group                         = ''

   select @w_contract_type                          = contract_type,
          @w_status                                 = status,
          @w_username                               = username,
          @w_sales_channel_role                     = sales_channel_role,
          @w_customer_name_link                     = customer_name_link,
          @w_customer_address_link                  = customer_address_link,
          @w_customer_contact_link                  = customer_contact_link,
          @w_billing_address_link                   = billing_address_link,
          @w_billing_contact_link                   = billing_contact_link,
          @w_owner_name_link                        = owner_name_link,
          @w_service_address_link                   = service_address_link,
          @w_account_name_link                      = account_name_link,
          @w_retail_mkt_id                          = retail_mkt_id,
          @w_utility_id                             = utility_id,
          @w_product_id                             = product_id,
          @w_rate_id                                = rate_id,
          @w_rate                                   = rate,
          @w_business_type                          = business_type,
          @w_business_activity                      = business_activity,
          @w_additional_id_nbr_type                 = additional_id_nbr_type,
          @w_additional_id_nbr                      = additional_id_nbr,
          @w_term_months                            = term_months,
          @w_date_submit                            = date_submit,
          @w_sales_channel_role                     = sales_channel_role,
          @w_sales_rep                              = sales_rep,
          @w_requested_flow_start_date              = isnull(requested_flow_start_date, '19000101'),
          @w_deal_type                              = isnull(deal_type, ''),
          @w_customer_code                          = isnull(customer_code, ''),
          @w_customer_group                         = isnull(customer_group, ''),
          @PriceID									= PriceID
   from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
   where contract_nbr                               = @p_contract_nbr

   select @w_descp_add                              = ' '

   exec @w_return = usp_contract_account_val @p_username,
                                             'V',
                                             'ALL',
                                             @p_contract_nbr,
                                             @w_account_number,
                                             @w_application output,
                                             @w_error output,
                                             @w_msg_id output,
                                             @w_process_origin


   if  @w_return                                  <> 0
   and @w_process_origin                           in('ONLINE', 'BATCH') -- ADD TICKET 17179
   begin
      select @w_descp_add                          = '(Account Number ' + ltrim(rtrim(@w_account_number)) + ')'
      goto goto_select
   end

   select @w_descp_add                             = ' '

   exec @w_return = usp_contract_link_val @p_contract_nbr,
                                          @w_account_number,
                                          @w_customer_name_link,
                                          @w_customer_address_link,
                                          @w_customer_contact_link,
                                          @w_billing_address_link,
                                          @w_billing_contact_link,
                                          @w_owner_name_link,
                                          @w_service_address_link,
                                          @w_account_name_link,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output,
                                          @w_descp_add output,
                                          @w_process_origin

   if  @w_return                                   <> 0
   and @w_process_origin                            = 'ONLINE'
   begin
      goto goto_select
   end

   select @w_descp_add                             = ' '

   exec @w_return = usp_contract_general_val @p_username,
                                             'V',
                                             'ALL',
                                             @p_contract_nbr,
                                             @w_account_number,
                                             @w_business_type,
                                             @w_business_activity,
                                             @w_additional_id_nbr_type,
                                             @w_additional_id_nbr,
                                             @w_date_submit,
                                             @w_sales_channel_role,
                                             @w_sales_rep,
                                             @w_deal_type,
                                             @w_utility_id,
                                             @w_application output,
                                             @w_error output,
                                             @w_msg_id output,
                                             @w_process_origin

   if  @w_return                                   <> 0
   and @w_process_origin                            = 'ONLINE'
   begin
      select @w_descp_add                           = '(Account Number ' + ltrim(rtrim(@w_account_number)) + ')'
      goto goto_select
   end

   exec @w_return = usp_contract_pricing_val @p_username,
                                             'V',
                                             'ALL',
                                             @p_contract_nbr,
                                             @w_account_number,
                                             @w_retail_mkt_id,
                                             @w_utility_id,
                                             @w_product_id,
                                             @w_rate_id,
                                             @w_rate,
                                             @w_term_months,
                                             @w_enrollment_type,
                                             @w_requested_flow_start_date,
                                             @w_contract_date,
                                             @w_customer_code,
                                             @w_customer_group,
                                             @w_application output,
                                             @w_error output,
                                             @w_msg_id output,
                                             @w_process_origin,
                                             @PriceID

   if  @w_return                                   <> 0 
   and @w_process_origin                            = 'ONLINE'
   begin
      goto goto_select
   end

   select @w_address_type                           = 'CUSTOMER'
   select @w_address_link                           = @w_customer_address_link

   if  @w_customer_address_link                     = 0
   and @w_billing_address_link                      = 0
   and @w_service_address_link                      = 0
   begin
      goto goto_contact_acc
   end

   while @w_address_type                           <> ' '
   begin

      if @w_address_link                            = 0
      begin
         goto goto_address_link_acc
      end

      select @w_address                             = ''
      select @w_suite                               = ''
      select @w_city                                = ''
      select @w_state                               = ''
      select @w_zip                                 = ''

      select @w_address                             = address,
             @w_suite                               = suite,
             @w_city                                = city,
             @w_state                               = state,
             @w_zip                                 = zip
      from deal_address with (NOLOCK INDEX = deal_address_idx)
      where contract_nbr                            = @p_contract_nbr
      and   address_link                            = @w_address_link

      select @w_descp_add                           = ' '

      -- This will check the Customer, Billing, and Service addresses for the contract accounts.
--      exec @w_return = usp_contract_address_val @p_username,
--                                                'V',
--                                                'ALL',
--                                                @p_contract_nbr,
--                                                @w_account_number,
--                                                @w_address,
--                                                @w_city,
--                                                @w_state,
--                                                @w_zip,
--                                                @w_application output,
--                                                @w_error output,
--                                                @w_msg_id output,
--                                                @w_process_origin,
--                                                @w_address_type

      if  @w_return                                <> 0
      and @w_process_origin                         = 'ONLINE'
      begin
         select @w_descp_add                        = '(Account Number ' + ltrim(rtrim(@w_account_number)) + ')'
         goto goto_select
      end

      goto_address_link_acc:

      select @w_address_link                        = case when @w_address_type = 'CUSTOMER'
                                                           then @w_billing_address_link
                                                           when @w_address_type = 'BILLING'
                                                           then @w_service_address_link
                                                           else 0
                                                      end

      select @w_address_type                        = case when @w_address_type = 'CUSTOMER'
                                                           then 'BILLING'
                                                           when @w_address_type = 'BILLING'
                                                           then 'SERVICE'
                                                           else ' '
                                                      end
   
   end

   goto_contact_acc:

   if  @w_customer_contact_link                     = 0
   and @w_billing_contact_link                      = 0
   begin
      goto goto_name_acc
   end

   select @w_contact_type                           = 'CUSTOMER'
   select @w_contact_link                           = @w_customer_contact_link

   while @w_contact_type                           <> ' '
   begin

      if @w_contact_link                            = 0
      begin
         goto goto_contact_link_acc
      end

      select @w_first_name                          = ''
      select @w_last_name                           = ''
      select @w_title                               = ''
      select @w_phone                               = ''
      select @w_fax                                 = ''
      select @w_email                               = ''
      select @w_birthday                            = ''


      select @w_first_name                          = first_name,
             @w_last_name                           = last_name,
             @w_title                               = title,
             @w_phone                               = phone,
             @w_fax                                 = fax,
             @w_email                               = email,
             @w_birthday                            = birthday
      from deal_contact with (NOLOCK INDEX = deal_contact_idx)
      where contract_nbr                            = @p_contract_nbr
      and   contact_link                            = @w_contact_link

      select @w_descp_add                           = ' '

      exec @w_return = usp_contract_contact_val @p_username,
                                                'V',
                                                'ALL',
                                                @p_contract_nbr,
                                                @w_account_number,
                                                @w_first_name,
                                                @w_last_name,
                                                @w_title,
                                                @w_phone,
                                                @w_fax,
                                                @w_email,
                                                @w_birthday,
                                                @w_application output,
                                                @w_error output,
                                                @w_msg_id output,
                                                @w_process_origin,
                                                @w_contact_type

      if  @w_return                                <> 0
      and @w_process_origin                         = 'ONLINE'
      begin
         select @w_descp_add                        = '(' + ltrim(rtrim(@w_address_type)) + ' Account Number ' + ltrim(rtrim(@w_account_number)) + ')'
         goto goto_select
      end

      goto_contact_link_acc:

      select @w_contact_link                        = case when @w_contact_type = 'CUSTOMER'
                                                           then @w_billing_contact_link
                                                           else 0
                                                      end

      select @w_contact_type                        = case when @w_contact_type = 'CUSTOMER'
                                                           then 'BILLING'
                                                           else ' '
                                                      end
   
   end

   goto_name_acc:

   if  @w_account_name_link                         = 0
   and @w_customer_name_link                        = 0
   and @w_owner_name_link                           = 0
   begin
      goto goto_next_acc
   end

   select @w_name_type                              = 'ACCOUNT'
   select @w_name_link                              = @w_account_name_link

   while @w_name_type                              <> ' '
   begin

      if @w_name_link                               = 0
      begin
         goto goto_name_link_acc
      end

      select @w_full_name                           = ''

      select @w_full_name                           = full_name
      from deal_name with (NOLOCK INDEX = deal_name_idx)
      where contract_nbr                            = @p_contract_nbr
      and   name_link                               = @w_name_link
  
      select @w_descp_add                           = ' '

      exec @w_return = usp_contract_name_val @p_username,
                                             'V',
                                             'ALL',
                                             @p_contract_nbr,
                                             @w_account_number,
                                             @w_full_name,
                                             @w_application output,
                                             @w_error output,
                                             @w_msg_id output,
                                             @w_process_origin,
                                             @w_name_type

      if  @w_return                                <> 0
      and @w_process_origin                         = 'ONLINE'
      begin
         select @w_descp_add                        = '(' + ltrim(rtrim(@w_name_type)) + ' Account Number ' + ltrim(rtrim(@w_account_number)) + ')'
         goto goto_select
      end
 
      goto_name_link_acc:

      select @w_name_link                           = case when @w_name_type = 'ACCOUNT'
                                                           then @w_customer_name_link
                                                           when @w_name_type = 'CUSTOMER'
                                                           then @w_owner_name_link
                                                           else 0
                                                      end

      select @w_name_type                           = case when @w_name_type = 'ACCOUNT'
                                                           then 'CUSTOMER'
                                                           when @w_name_type = 'CUSTOMER'
                                                           then 'OWNER'
                                                           else ' '
                                                      end
   
   end

   goto_next_acc:

   set rowcount 1

   delete #account

   select @w_account_number                         = account_number
   from #account

   select @w_rowcount                               = @@rowcount

end


select @w_descp_add                                 = ' '

--New Contract - start
if @p_process                                    like 'BATCH_%'
begin 
   goto goto_batch_load
end
--New Contract - end

if exists(select contract_nbr
          from deal_contract_error with (NOLOCK INDEX = deal_contract_error_idx)
          where contract_nbr                        = @p_contract_nbr)
begin
   return 1
end

select @w_descp_add                                 = ' '

declare @w_getdate                                  datetime
select @w_getdate                                   = getdate()

update deal_contract set date_submit = @w_getdate,
                         status = 'RUNNING'
from deal_contract with (NOLOCK INDEX = deal_contract_idx)
where contract_nbr                                  = @p_contract_nbr

if @@error                                         <> 0
or @@rowcount                                       = 0
begin

   select @w_application                            = 'COMMON'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000051'
   select @w_return                                 = 1
   select @w_descp_add                              = '(Update Contract)'

   if @w_process_origin                             = 'BATCH'
   begin
      exec usp_contract_error_ins 'DEAL_CAPTURE',
                                  @p_contract_nbr,
                                  'CONTRACT',
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add
      return 1
   end
   goto goto_select
end

--New Contract - start
goto_batch_load:
if @p_process                                    like 'BATCH_%'
begin 
   if exists(select top 1
                    contract_nbr
             from #contract_error)  
   begin
      return 1
   end
   return 0
end
--New Contract - end

select @w_application                               = 'COMMON'
select @w_descp                                     = ' '
select @w_return                                    = 0
select @w_descp_add                                 = ' '

if (exists (select origin
            from deal_contract with (NOLOCK INDEX = deal_contract_idx)
            where contract_nbr                      = @p_contract_nbr
            and   origin                            = 'BATCH')
and @p_process                                      = 'ONLINE')
begin

   declare @w_request_id                            char(50)
   declare @w_exec_sql                              varchar(max)
   declare @w_dbname                                nvarchar(128)
   declare @w_server_name                           varchar(128)
   declare @w_job_name                              varchar(128)
   declare @w_dateexec                              datetime

   select @w_request_id                             = 'DEAL_CAPTURE-ACCOUNT'
                                                    + ltrim(rtrim(@p_contract_nbr))
   select @w_dbname                                 = 'lp_deal_capture'
   select @w_server_name                            = @@servername
   select @w_job_name                               = @w_request_id

   select @w_exec_sql                               = 'exec'
                                                    + ' '
                                                    + 'usp_contract_submit_ins'
                                                    + ' '
                                                    + '''' + ltrim(rtrim(@p_username)) + ''''
                                                    + ', '
                                                    + '''' + ltrim(rtrim(@p_contract_nbr)) + ''''


   select @w_return                                 = 0

   exec @w_return = lp_common..usp_summit_job @p_username,
                                              @w_request_id,
                                              @w_exec_sql,
                                              @w_dbname,
                                              @w_server_name,
                                              @w_job_name,
                                              @w_dateexec,
                                              @w_error output,
                                              @w_msg_id output

end
else
begin

   goto_submit:

   select @w_return                                 = 0
	--Delete Later-----------------------------------------------------------
	Print('Executing usp_contract_submit_ins inside usp_contract_submit_val')
	Print('@p_username => ' + @p_username)
	Print('@p_contract_nbr => ' + @p_contract_nbr)
	Print ('@p_contract_type => ' + @p_contract_type)
	-------------------------------------------------------------------------
	
	IF @p_contract_type = 'POWER MOVE'
		exec @w_return = usp_contract_submit_ins_POWERMOVE 
												@p_username, 
												@p_contract_nbr,
												@w_application output,
												@w_error output,
												@w_msg_id output,
												@w_descp_add output
	ELSE
		exec @w_return = usp_contract_submit_ins @p_username, 
												@p_contract_nbr,
												@w_application output,
												@w_error output,
												@w_msg_id output,
												@w_descp_add output

    --Delete Later----------------------------------------------------------                                      
    Print('Finished usp_contract_submit_ins inside usp_contract_submit_val')
    ------------------------------------------------------------------------
end

if @w_return                                       <> 0
begin
   if @w_process_origin                             = 'BATCH'
   begin
      exec usp_contract_error_ins 'DEAL_CAPTURE',
                                  @p_contract_nbr,
                                  'CONTRACT',
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add
      return 1
   end
   goto goto_select
end  

goto_select:

if @w_error                                         = 'E'
begin
   update deal_contract set status = 'DRAFT - ERROR'
   from deal_contract with (NOLOCK INDEX = deal_contract_idx)
   where contract_nbr                           = @p_contract_nbr
end

select @p_application                               = @w_application,
       @p_error                                     = @w_error,
       @p_msg_id                                    = @w_msg_id,
       @p_descp_add                                 = @w_descp_add

return @w_return


