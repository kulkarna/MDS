

CREATE procedure [dbo].[usp_contract_duplicate] 
as
declare @w_day_max                                  int
select @w_day_max                                   = 10

declare @w_getdate                                  datetime
select @w_getdate                                   = getdate()

declare @w_contract_nbr                             char(12)
declare @w_account_number                           varchar(30) 
declare @w_utility_id                               varchar(15) 
declare @w_account_name                             varchar(100) 
declare @w_customer_name                            varchar(100) 
declare @w_customer_type                            varchar(255) 
declare @w_id_number                                varchar(30) 
declare @w_id_number_type                           varchar(30) 
declare @w_business_type                            varchar(35) 
declare @w_service_street                           char(50) 
declare @w_service_city                             char(28) 
declare @w_service_state                            varchar(10) 
declare @w_service_zip                              char(10) 
declare @w_billing_street                           char(50) 
declare @w_billing_city                             char(28) 
declare @w_billing_state                            varchar(10) 
declare @w_billing_zip                              char(10) 
declare @w_contact_name                             varchar(50) 
declare @w_contact_last_name                        varchar(50) 
declare @w_contact_title                            varchar(20) 
declare @w_contact_phone                            varchar(20) 
declare @w_contact_fax                              varchar(20) 
declare @w_contact_email                            nvarchar(256) 
declare @w_contact_birthday                         varchar(10) 
declare @w_account_level_contact_name               varchar(50) 
declare @w_account_level_contact_last_name          varchar(50)  
declare @w_account_level_contact_phone              varchar(20) 
declare @w_contract_type                            varchar(30) 
declare @w_contract_number                          char(12) 
declare @w_contract_term                            varchar(10) 
declare @w_product                                  varchar(20) 
declare @w_sales_channel                            nchar(100) 
declare @w_sales_rep                                varchar(100) 
declare @w_submit_date                              varchar(10) 
declare @w_rate_id                                  int 
declare @w_date_created                             datetime 
declare @w_process_status                           char(01) 
declare @w_msg_id                                   char(08) 
declare @w_msg_desc                                 varchar(255) 
declare @w_username                                 nchar(100)
declare @w_application                              varchar(20)
declare @w_customer_name_link                       int

declare @w_account_name_link                        int
declare @w_customer_address_link                    int
declare @w_customer_contact_link                    int
declare @w_billing_address_link                     int
declare @w_billing_contact_link                     int
declare @w_owner_name_link                          int


create table #contract
(contract_nbr                                       char(12),
 account_number                                     varchar(30),
 contract_type                                      varchar(15),
 utility_id                                         char(15),
 product_id                                         char(20),
 rate_id                                            int,
 business_type                                      varchar(35),
 sales_channel_role                                 nvarchar(50),
 additional_id_nbr                                  varchar(30),
 additional_id_nbr_type                             varchar(10),
 username                                           nchar(100),
 sales_rep                                          varchar(100),
 submit_date                                        varchar(10),
 term_months                                        int,
 date_created                                       datetime,
 application                                        varchar(20),
 msg_id                                             varchar(50))

insert into #contract
select distinct
       a.contract_nbr,
       'CONTRACT',
       a.contract_type,
       a.utility_id,
       a.product_id,
       a.rate_id,
       a.business_type,
       a.sales_channel_role,
       a.additional_id_nbr,
       a.additional_id_nbr_type,
       a.username,
       a.sales_rep,
       a.date_submit,
       a.term_months,
       a.date_created,
       b.application,
       b.msg_id       
from lp_deal_capture..deal_contract a with (NOLOCK index = deal_contract_idx),
     lp_deal_capture..deal_contract_error b with (NOLOCK index = deal_contract_error_idx)
where a.contract_nbr                                = b.contract_nbr
and   b.process_id                                  = 'DEAL_CAPTURE'
and   a.status                                      = 'DRAFT - ERROR'
and   b.application                                 = 'DEAL'
and   b.msg_id                                      = '00000010'

insert into #contract
select distinct
       a.contract_nbr,
       'CONTRACT',
       a.contract_type,
       a.utility_id,
       a.product_id,
       a.rate_id,
       a.business_type,
       a.sales_channel_role,
       a.additional_id_nbr,
       a.additional_id_nbr_type,
       a.username,
       a.sales_rep,
       a.date_submit,
       a.term_months,
       a.date_created,
       b.application,
       b.msg_id       
from lp_deal_capture..deal_contract a with (NOLOCK index = deal_contract_idx),
     lp_deal_capture..deal_contract_error b with (NOLOCK index = deal_contract_error_idx)
where a.contract_nbr                                = b.contract_nbr
and   b.process_id                                  = 'DEAL_CAPTURE'
and   a.status                                      = 'DRAFT - ERROR'
and   b.application                                 = 'COMMON'
and   b.msg_id                                      = '00001013'
and   a.contract_nbr                           not in (select contract_nbr
                                                       from #contract
                                                       where contract_nbr = a.contract_nbr)

insert into #contract
select distinct
       a.contract_nbr,
       'CONTRACT',
       a.contract_type,
       a.utility_id,
       a.product_id,
       a.rate_id,
       a.business_type,
       a.sales_channel_role,
       a.additional_id_nbr,
       a.additional_id_nbr_type,
       a.username,
       a.sales_rep,
       a.date_submit,
       a.term_months,
       a.date_created,
       'COMMON',
       '00001022'       
from lp_deal_capture..deal_contract a with (NOLOCK index = deal_contract_idx1)
where a.status                                      = 'DRAFT - ERROR'
and   abs(datediff(dd, a.date_submit, @w_getdate)) >= @w_day_max
and   a.contract_nbr                           not in (select contract_nbr
                                                       from #contract
                                                       where contract_nbr = a.contract_nbr)


insert into #contract
select distinct
       a.contract_nbr,
       b.account_number,
       b.contract_type,
       b.utility_id,
       b.product_id,
       b.rate_id,
       b.business_type,
       b.sales_channel_role,
       b.additional_id_nbr,
       b.additional_id_nbr_type,
       b.username,
       b.sales_rep,
       b.date_submit,
       b.term_months,
       b.date_created,
       a.application,
       a.msg_id       
from #contract a,
     lp_deal_capture..deal_contract_account b with (NOLOCK index = deal_contract_account_idx)
where a.contract_nbr                                = b.contract_nbr
and   ltrim(rtrim(a.contract_nbr))
    + ltrim(rtrim(b.account_number))           not in (select ltrim(rtrim(a.contract_nbr))
                                                            + ltrim(rtrim(a.account_number))
                                                       from #contract
                                                       where contract_nbr   = a.contract_nbr
                                                       and   account_number = b.account_number)


create table #contract_distinct
(contract_nbr                                       char(12))

insert into #contract_distinct
select distinct 
       contract_nbr
from #contract

set rowcount 1

select @w_contract_number                           = contract_nbr,
       @w_account_number                            = account_number,
       @w_contract_type                             = contract_type,
       @w_utility_id                                = utility_id,
       @w_product                                   = product_id,
       @w_rate_id                                   = rate_id,
       @w_business_type                             = business_type,
       @w_sales_channel                             = sales_channel_role,
       @w_id_number                                 = additional_id_nbr,
       @w_id_number_type                            = additional_id_nbr_type,
       @w_username                                  = username,
       @w_sales_rep                                 = sales_rep,
       @w_submit_date                               = submit_date,
       @w_contract_term                             = convert(varchar(10), term_months),
       @w_date_created                              = date_created,
       @w_application                               = application,
       @w_msg_id                                    = msg_id
from #contract

while @@rowcount                                   <> 0
begin
   set rowcount 0

   select @w_account_name                           = ''
   select @w_customer_name                          = ''
   select @w_customer_type                          = ''
   select @w_service_street                         = ''
   select @w_service_city                           = ''
   select @w_service_state                          = ''
   select @w_service_zip                            = ''
   select @w_billing_street                         = ''
   select @w_billing_city                           = ''
   select @w_billing_state                          = ''
   select @w_billing_zip                            = ''
   select @w_contact_name                           = ''
   select @w_contact_last_name                      = ''
   select @w_contact_title                          = ''
   select @w_contact_phone                          = ''
   select @w_contact_fax                            = ''
   select @w_contact_email                          = ''
   select @w_contact_birthday                       = ''
   select @w_account_level_contact_name             = ''
   select @w_account_level_contact_last_name        = ''
   select @w_account_level_contact_phone            = ''
   select @w_process_status                         = ''
   select @w_msg_desc                               = '' 


   if @w_account_number                             = 'CONTRACT'
   begin
       select @w_customer_name_link                 = customer_name_link,
              @w_customer_address_link              = customer_address_link,
              @w_customer_contact_link              = customer_contact_link,
              @w_billing_address_link               = billing_address_link,
              @w_billing_contact_link               = billing_contact_link,
              @w_owner_name_link                    = owner_name_link
       from lp_deal_capture..deal_contract with (NOLOCK INDEX = deal_contract_idx)
       where contract_nbr                           = @w_contract_nbr

       select @w_customer_name                          = full_name
       from lp_deal_capture..deal_name with (NOLOCK INDEX = deal_name_idx)
       where contract_nbr                               = @w_contract_nbr
       and   name_link                                  = @w_customer_name_link
 
   end
   else
   begin
       select @w_account_name_link                  = account_name_link,
              @w_customer_name_link                 = customer_name_link,
              @w_customer_address_link              = customer_address_link,
              @w_customer_contact_link              = customer_contact_link,
              @w_billing_address_link               = billing_address_link,
              @w_billing_contact_link               = billing_contact_link,
              @w_owner_name_link                    = owner_name_link
       from lp_deal_capture..deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
       where contract_nbr                           = @w_contract_nbr

       select @w_account_name                       = full_name
       from lp_deal_capture..deal_name with (NOLOCK INDEX = deal_name_idx)
       where contract_nbr                           = @w_contract_nbr
       and   name_link                              = @w_account_name_link

   end

   select @w_customer_name                          = full_name
   from lp_deal_capture..deal_name with (NOLOCK INDEX = deal_name_idx)
   where contract_nbr                               = @w_contract_nbr
   and   name_link                                  = @w_customer_name_link
   
   select @w_service_street                         = address,
          @w_service_city                           = city,
          @w_service_state                          = state,
          @w_service_zip                            = zip
   from lp_deal_capture..deal_address with (NOLOCK INDEX = deal_address_idx)
   where contract_nbr                               = @w_contract_nbr
   and   address_link                               = @w_customer_address_link

   select @w_billing_street                         = address,
          @w_billing_city                           = city,
          @w_billing_state                          = state,
          @w_billing_zip                            = zip
   from lp_deal_capture..deal_address with (NOLOCK INDEX = deal_address_idx)
   where contract_nbr                               = @w_contract_nbr
   and   address_link                               = @w_billing_address_link
             
   select @w_contact_name                           = first_name,
          @w_contact_last_name                      = last_name, 
          @w_contact_title                          = title,
          @w_contact_phone                          = phone,
          @w_contact_fax                            = fax,
          @w_contact_email                          = email,
          @w_contact_birthday                       = birthday
   from lp_deal_capture..deal_contact with (NOLOCK INDEX = deal_contact_idx)
   where contract_nbr                               = @w_contract_nbr
   and   contact_link                               = @w_customer_contact_link

   select @w_msg_desc                               = msg_descp
   from lp_common..common_messages with (NOLOCK INDEX = common_messages_idx)
   where application                                = @w_application
   and   msg_id                                     = @w_msg_id

   insert into lp_enrollment..duplicated_deals
   select @w_account_number,
          @w_utility_id,
          @w_account_name,
          @w_customer_name,
          @w_customer_type,
          @w_id_number,
          @w_id_number_type,
          @w_business_type,
          @w_service_street,
          @w_service_city,
          @w_service_state,
          @w_service_zip,
          @w_billing_street,
          @w_billing_city,
          @w_billing_state,
          @w_billing_zip,
          @w_contact_name,
          @w_contact_last_name,
          @w_contact_title,
          @w_contact_phone,
          @w_contact_fax,
          @w_contact_email,
          @w_contact_birthday,
          @w_account_level_contact_name,
          @w_account_level_contact_last_name,
          @w_account_level_contact_phone,
          @w_contract_type,
          @w_contract_number,
          @w_contract_term,
          @w_product,
          @w_sales_channel,
          @w_sales_rep,
          @w_submit_date,
          @w_rate_id,
          @w_date_created,
          @w_process_status,
          @w_msg_id,
          @w_msg_desc,
          @w_username,
          0
      

--- process

   set rowcount 1

   delete #contract
   where contract_nbr                               = @w_contract_number   
   and   account_number                             = @w_account_number 

   select @w_contract_number                        = contract_nbr,
          @w_account_number                         = account_number,
          @w_contract_type                          = contract_type,
          @w_utility_id                             = utility_id,
          @w_product                                = product_id,
          @w_rate_id                                = rate_id,
          @w_business_type                          = business_type,
          @w_sales_channel                          = sales_channel_role,
          @w_id_number                              = additional_id_nbr,
          @w_id_number_type                         = additional_id_nbr_type,
          @w_username                               = username,
          @w_sales_rep                              = sales_rep,
          @w_submit_date                            = submit_date,
          @w_contract_term                          = convert(varchar(10), term_months),
          @w_date_created                           = date_created,
          @w_application                            = application,
          @w_msg_id                                 = msg_id
    from #contract

end

set rowcount 0

delete deal_contract
from deal_contract a with (NOLOCK INDEX = deal_contract_idx),
     #contract_distinct b
where a.contract_nbr                                = b.contract_nbr

delete deal_contract_account
from deal_contract_account a with (NOLOCK INDEX = deal_contract_account_idx),
     #contract_distinct b
where a.contract_nbr                                = b.contract_nbr

delete deal_address
from deal_address a with (NOLOCK INDEX = deal_address_idx),
     #contract_distinct b
where a.contract_nbr                                = b.contract_nbr

delete deal_contact
from deal_contact a with (NOLOCK INDEX = deal_contact_idx),
     #contract_distinct b
where a.contract_nbr                                = b.contract_nbr

delete deal_name
from deal_name a with (NOLOCK INDEX = deal_name_idx),
     #contract_distinct b
where a.contract_nbr                                = b.contract_nbr

delete deal_contract_error
from deal_contract_error a with (NOLOCK INDEX = deal_contract_error_idx),
     #contract_distinct b
where a.contract_nbr                                = b.contract_nbr


