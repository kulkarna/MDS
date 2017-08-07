

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--exec usp_contract_submit_ins 'libertypower\dmarino', 'Contracto A1'
--exec usp_contract_submit_ins @p_username=N'LIBERTYPOWER\dmarino',@p_contract_nbr=N'0104483'

-- Modified      5/20/2008
-- Modified By   Rick Deigsler
-- Added code to delete contract from check account table

-- =============================================
-- Modify		: Diogo Lima
-- Date			: 04/13/2010
-- Description	: Added a Utility filter
-- Ticket		: 14366
-- =============================================
-- Modify		: Jose Munoz
-- Date			: 02/18/2010
-- Description	: Add SSNEncrypted columns to process.
-- Ticket		: IT002
-- =============================================
-- Modified: Jose Munoz 1/14/2010
-- add HeatIndexSourceID and HeatRate for updates in the tables 
-- deal_contract, deal_contract_account and deal_pricing_detail
-- Project IT037
-- =============================================
-- =============================================
-- Modified: George Worthington 4/30/2010
-- added Sales Channel Settings overrided fields
-- Project IT021
-- =============================================
-- =============================================
-- Modified: Jose Munoz 5/20/2010
-- Ticket : 15959
-- Problem : inserted duplicate rows in account_info table
-- =============================================
-- =============================================
-- Modified: Jose Munoz 5/20/2010
-- Ticket :17130
-- Problem : Fixe a problem with status 911000 and deenrollment date
-- =============================================
-- =============================================
-- Modified: Jose Munoz 8/17/2010
-- Ticket :17675
-- Problem : Fixe a problem with New contracts appear to be going 
--  to check account as the first step in deal screening process  
-- =============================================
-- Modified: Eric Hernandez 9/8/2010
-- Ticket :17816
-- Problem : Fixed a problem steps being out of order.  Added "order by" clause on common_utility_check_type queries.
-- =============================================
-- ===============================================================
-- Modified José Muñoz 01/20/2011
-- Account/ Customer Name should be trimmed when inserting into the Table....  
-- Ticket 20906
-- ===============================================================
-- ===============================================================
-- Modified Sofia Melo 02/21/2011
-- Added tracking to identify how many times this procedure is called.
-- using usp_zcheck_account_tracking_ins call
-- ===============================================================
-- Modified Gabor Kovacs 05/9/2012
-- Added a null to the insertion of account_contact, account_address, and account_name.
-- The null is required since those are no longer tables, but views which have an extra field.
-- =============================================
 
CREATE procedure [dbo].[usp_genie_contract_submit_ins]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_application                                     varchar(20) = ' ' output,
 @p_error                                           char(01) = ' ' output,
 @p_msg_id                                          char(08) = ' ' output,
 @p_descp_add                                       varchar(100) = ' ' output)
as
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_return                                   int
declare @w_descp_add                                varchar(100)

select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_return                                    = 0
select @w_descp_add                                 = ' ' 

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

declare @w_rowcount                                 int
declare @w_getdate                                  datetime

DECLARE	@EstimatedAnnualUsage						int,	-- Project IT106
		@PriceID									bigint	-- Project IT106
		
SET	@EstimatedAnnualUsage							= 0		

select @w_getdate                                   = date_submit
from deal_contract with (NOLOCK)
where contract_nbr                           = @p_contract_nbr
--and   status                                        = 'RUNNING'

select @w_descp_add                                 = ' '

declare @w_duns_number_entity                       varchar(255)

declare @w_account_id                               char(12)
declare @w_account_number                           varchar(30)
declare @w_status                                   varchar(15)
declare @w_sub_status                               varchar(15)
declare @w_entity_id                                char(15)
declare @w_contract_nbr                             char(12)
declare @w_contract_type                            varchar(15)
declare @w_retail_mkt_id                            char(02)
declare @w_utility_id                               char(15)
declare @w_product_id                               char(20)
declare @w_rate_id                                  int
declare @w_rate                                     float
declare @w_account_name_link                        int
declare @w_customer_name_link                       int
declare @w_customer_address_link                    int
declare @w_customer_contact_link                    int
declare @w_billing_address_link                     int
declare @w_billing_contact_link                     int
declare @w_owner_name_link                          int
declare @w_service_address_link                     int
declare @w_business_type                            varchar(35)
declare @w_business_activity                        varchar(35)
declare @w_additional_id_nbr_type                   varchar(10)
declare @w_additional_id_nbr                        varchar(30)
declare @w_contract_eff_start_date                  datetime
declare @w_term_months                              int
declare @w_date_end                                 datetime
declare @w_date_deal                                datetime
declare @w_date_created                             datetime
declare @w_date_submit                              datetime
declare @w_sales_channel_role                       nvarchar(50)
declare @w_username                                 nchar(100)
declare @w_sales_rep                                varchar(100)
declare @w_origin                                   varchar(50)
declare @w_annual_usage                             money
declare @w_date_flow_start                          datetime
declare @p_future_enroll_date                       datetime
declare @p_enrollment_type                          int
declare @w_date_por_enrollment                      datetime
declare @w_date_deenrollment                        datetime
declare @w_date_reenrollment                        datetime
declare @w_tax_status                               varchar(20)
declare @w_tax_float                                int
declare @w_credit_score                             real
declare @w_credit_agency                            varchar(30)
declare @w_por_option                               varchar(03)
declare @w_billing_type                             varchar(15)
declare @w_date_comment                             datetime
declare @w_comment                                  varchar(max)
declare @w_account_type                             varchar(50)

declare @w_risk_request_id                          varchar(50)
declare @w_process_id                               varchar(50)

declare @w_add_info                                 bit

declare @w_HeatIndexSourceID						int				-- Project IT037
		,@w_HeatRate								decimal	(9,2)	-- Project IT037            

select @w_account_id                                = ''
select @w_account_number                            = ''
select @w_entity_id                                 = ''
select @w_contract_nbr                              = ''
select @w_contract_type                             = ''
select @w_retail_mkt_id                             = ''
select @w_utility_id                                = ''
select @w_product_id                                = ''
select @w_rate_id                                   = 0
select @w_rate                                      = 0
select @w_account_name_link                         = 0
select @w_customer_name_link                        = 0
select @w_customer_address_link                     = 0
select @w_customer_contact_link                     = 0
select @w_billing_address_link                      = 0
select @w_billing_contact_link                      = 0
select @w_owner_name_link                           = 0
select @w_service_address_link                      = 0
select @w_business_type                             = ''
select @w_business_activity                         = ''
select @w_additional_id_nbr_type                    = ''
select @w_additional_id_nbr                         = ''
select @w_contract_eff_start_date                   = '19000101'
select @w_term_months                               = 0
select @w_date_end                                  = '19000101'
select @w_date_deal                                 = '19000101'
select @w_date_created                              = '19000101'
select @w_sales_channel_role                        = ''
select @w_username                                  = ''
select @w_sales_rep                                 = ''
select @w_origin                                    = ''
select @w_date_submit                               = @w_getdate
select @w_annual_usage                              = 0
select @w_date_flow_start                           = '19000101'
select @w_date_por_enrollment                       = '19000101'
select @p_future_enroll_date                        = '19000101'
select @p_enrollment_type                           = 1
select @w_date_deenrollment                         = '19000101'
select @w_date_reenrollment                         = '19000101'
select @w_tax_status                                = 'FULL'
select @w_tax_float                                 = 0
select @w_credit_score                              = 0
select @w_credit_agency                             = 'NONE'
select @w_por_option                                = 'NO'

select @w_status                                    = ''
select @w_sub_status                                = ''
select @w_entity_id                                 = ''

declare @t_account_number                           varchar(30)
select @t_account_number                            = ''

declare @w_contract_is_amendment                  varchar(5)

declare @w_contract_nbr_amend                     char(12)
declare @w_contract_type_amend                    varchar(15)
declare @w_status_amend                           varchar(15)
declare @w_sub_status_amend                       varchar(15)

declare @w_check_type                               char(30)
declare @w_check_type_new_contract                  char(30) -- Add Ticket 17675

declare @w_requested_flow_start_date                datetime
declare @w_deal_type                                char(20)
declare @w_customer_code                            char(05)
declare @w_customer_group                           char(100)

declare @w_transaction_id                           varchar(50)
select @w_transaction_id                            = 'DEAL_CAPTURE' 
                                                    + '_' 
                                                    + convert(char(08), getdate(), 112) 
                                                    + '_'
                                                    + ltrim(rtrim(replace(convert(char(12), getdate(), 114), ':', '')))

declare @w_full_name                                varchar(100)
select @w_full_name                                 = ''

declare @w_service_address                          char(50)
declare @w_service_suite                            char(50)
declare @w_service_city                             char(50)
declare @w_service_state                            char(02)
declare @w_service_zip                              char(10)

select @w_service_address                           = ''
select @w_service_suite                             = ''
select @w_service_city                              = ''
select @w_service_state                             = ''
select @w_service_zip                               = ''

declare @w_billing_address                          char(50)
declare @w_billing_suite                            char(50)
declare @w_billing_city                             char(50)
declare @w_billing_state                            char(02)
declare @w_billing_zip                              char(10)

select @w_billing_address                           = ''
select @w_billing_suite                             = ''
select @w_billing_city                              = ''
select @w_billing_state                             = ''
select @w_billing_zip                               = ''

-- Start: Added for Overridable Sales Channel settings.
declare @w_evergreen_option_id						int
declare @w_evergreen_commission_end					datetime
declare @w_residual_option_id						int
declare @w_residual_commission_end					datetime
declare @w_initial_pymt_option_id					int
declare @w_sales_manager							varchar(100)
declare @w_evergreen_commission_rate				float

--Begin Ticket 18703
declare	@w_TaxStatus								int
--End Ticket 18703

select 
	@w_evergreen_option_id				= evergreen_option_id
	,@w_evergreen_commission_end		= evergreen_commission_end
	,@w_evergreen_commission_rate		= evergreen_commission_rate
	,@w_residual_option_id				= residual_option_id							
	,@w_residual_commission_end			= residual_commission_end					
	,@w_initial_pymt_option_id			= initial_pymt_option_id						
	,@w_sales_manager					= sales_manager								
from deal_contract with (NOLOCK)
where contract_nbr	=	@p_contract_nbr
-- End: Added for Overridable Sales Channel settings.

--IT043
-- added 5/20/2008
--delete from lp_enrollment..check_account 
--where contract_nbr = @p_contract_nbr

select top 1
       @w_check_type                                = b.check_type
from deal_contract a with (NOLOCK),
     lp_common..common_utility_check_type b with (NOLOCK)
where a.contract_nbr                                = @p_contract_nbr
and   a.utility_id                                  = b.utility_id
and   case when a.contract_type = 'PRE-PRINTED' 
           then 'PAPER' 
           else a.contract_type 
      end                                           = b.contract_type
and   b.[order]                                     > 1   
order by b.[order]


--Added for IT002
declare @w_SSNEncrypted nvarchar(512) -- change to varchar(512) Jose Munoz.
----

set rowcount 1

select @w_account_id                                = account_id,
       @w_account_number                            = account_number,
       @w_contract_type                             = case when contract_type = 'PRE-PRINTED' then 'PAPER' else contract_type end,
       @w_retail_mkt_id                             = retail_mkt_id,
       @w_utility_id                                = utility_id,
       @w_product_id                                = product_id,
       @w_rate_id                                   = rate_id,
       @w_rate                                      = rate,
       @w_account_name_link                         = account_name_link,
       @w_customer_name_link                        = customer_name_link,
       @w_customer_address_link                     = customer_address_link,
       @w_customer_contact_link                     = customer_contact_link,
       @w_billing_address_link                      = billing_address_link,
       @w_billing_contact_link                      = billing_contact_link,
       @w_owner_name_link                           = owner_name_link,
       @w_service_address_link                      = service_address_link,
       @w_business_type                             = business_type,
       @w_business_activity                         = business_activity,
       @w_additional_id_nbr_type                    = additional_id_nbr_type,
       @w_additional_id_nbr                         = additional_id_nbr,
       @p_enrollment_type                           = enrollment_type,
       @w_contract_eff_start_date                   = contract_eff_start_date,
       @w_term_months                               = term_months,
       @w_date_end                                  = date_end,
       @w_date_deal                                 = date_deal,
       @w_date_created                              = date_created,
       @w_sales_channel_role                        = sales_channel_role,
       @w_username                                  = username,
       @w_sales_rep                                 = sales_rep,
       @w_origin                                    = origin,
       @w_requested_flow_start_date                 = isnull(requested_flow_start_date, '19000101'),
       @w_deal_type                                 = isnull(deal_type, ''),
       @w_customer_code                             = isnull(customer_code, ''),
       @w_customer_group                            = isnull(customer_group, ''),
       @w_SSNEncrypted								= SSNEncrypted --Added for IT002
	  ,@w_HeatIndexSourceID							= HeatIndexSourceID		-- Project IT037            
	  ,@w_HeatRate									= HeatRate				-- Project IT037            
        ,@w_evergreen_option_id				= isnull(evergreen_option_id,@w_evergreen_option_id)				-- Added for IT021
		,@w_evergreen_commission_end		= isnull(evergreen_commission_end, @w_evergreen_commission_end)		-- Added for IT021
		,@w_evergreen_commission_rate		= isnull(evergreen_commission_rate, @w_evergreen_commission_rate)	-- Added for IT021
		,@w_residual_option_id				= isnull(residual_option_id, @w_residual_option_id)					-- Added for IT021				
		,@w_residual_commission_end			= isnull(residual_commission_end, @w_residual_commission_end)		-- Added for IT021					
		,@w_initial_pymt_option_id			= isnull(initial_pymt_option_id, @w_initial_pymt_option_id)			-- Added for IT021								
		--Begin Ticket 18703
		,@w_TaxStatus = TaxStatus
		--End Ticket 18703
		,@PriceID									= PriceID
		
from deal_contract_account with (NOLOCK)
where contract_nbr                                  = @p_contract_nbr
and   account_number                                > @t_account_number
and  (status                                        = ' '
or    status                                        = 'RUNNING')

select   @w_rowcount                                  = @@rowcount

--Begin Ticket 18703
if @w_TaxStatus = 1 
begin 
	insert into lp_account..account_comments values (@w_account_id,GETDATE(),'DEAL ENTRY','Account was originally submitted as Tax Exempt.',@p_username,0)
	if exists(select *
									from lp_documents..document_history with (nolock)
									where document_type_id = 9 -- tax exempt doc
									and (account_id = @w_account_id or contract_nbr = @p_contract_nbr))
	begin 
		select @w_tax_status = 'EXEMPT'		
	end
end
else 
begin
	select @w_tax_status = 'FULL'			
end
--End Ticket 18703

-- tracking to identify how many times this procedure is called.
EXEC lp_enrollment..usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @w_account_id, @w_account_number, '', '', 'INSERT', 'usp_check_account_ins', 1, '@w_utility_id', @w_utility_id

select @w_entity_id                                 = entity_id,
       @w_por_option                                = por_option,
       @w_billing_type                              = billing_type,
       @w_date_por_enrollment                       = dateadd(d, -enrollment_lead_days, @w_requested_flow_start_date) --WV 2010/01/12
from lp_common..common_utility b with (NOLOCK)
where utility_id                                    = @w_utility_id

while @w_rowcount                                  <> 0
begin
   set rowcount 0

   select @w_add_info                               = 0

   select @t_account_number                         = @w_account_number

   update deal_contract_account set status = 'RUNNING'
   where contract_nbr                               = @p_contract_nbr
   and   account_number                             = @t_account_number

   begin tran val

   -- begin set amendment variables  ------------------------
   select @w_contract_is_amendment                  = 'FALSE'

   if @w_contract_type                              = 'AMENDMENT' 
   begin
      -- set amendment flag
      select @w_contract_is_amendment               = 'TRUE'

      -- get contract number to be amended
      select @w_contract_nbr_amend                  = contract_nbr_amend 
      from deal_contract_amend with (nolock)
      where   contract_nbr                            = @p_contract_nbr

      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         select @w_application                      = 'DEAL'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000049'
         select @w_return                           = 1
         select @w_descp_add                        = ''
         goto goto_select
      end

      -- get contract type of contract to be amended
      select top 1 
             @w_contract_type_amend                 = contract_type
      from lp_account..account  with (nolock)
      where contract_nbr                            = @w_contract_nbr_amend

      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         select @w_application                      = 'DEAL'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000049'
         select @w_return                           = 1
         select @w_descp_add                        = ''
         goto goto_select
      end

      -- get status and sub status of contract to be amended
      select top 1 
             @w_status_amend                        = status, 
             @w_sub_status_amend                    = sub_status
      from   lp_account..account with (nolock)
      where   contract_nbr = @w_contract_nbr_amend
      order by status

      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         select @w_application                      = 'DEAL'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000049'
         select @w_return                           = 1
         select @w_descp_add                        = ''
         goto goto_select
      end

      -- if account is enrolled or pending enrollment (confirmed), set status pending enrollment
      if @w_status_amend                           in ('05000','06000','07000','08000','09000','905000','906000')
      begin
         if (select   top 1 
                    ltrim(rtrim(por_option))
             from lp_account..account with (nolock)
             where contract_nbr                     = @w_contract_nbr_amend ) = 'NO'
         begin
            set @w_status_amend                     = '05000'
         end
         else
         begin
            set @w_status_amend                     = '06000'
         end      
         set @w_sub_status_amend                    = '10'      
      end
   end
   -- end set amendment variables  --------------------------

   select @w_process_id                             = case when @w_contract_is_amendment = 'TRUE' 
                                                           then 'CONTRACT AMENDMENT' 
                                                           else 'DEAL CAPTURE' 
                                                      end

   select @w_contract_nbr                           = case when @w_contract_is_amendment = 'TRUE' 
                                                           then @w_contract_nbr_amend 
                                                           else @p_contract_nbr 
                                                      end

   if @w_contract_is_amendment = 'TRUE'
   begin
      set @w_status                                 = @w_status_amend
      set @w_sub_status                             = @w_sub_status_amend
   end
   else
   begin
      select top 1 
             @w_status                              = case when wait_status is null 
                                                           then '01000' 
                                                           else wait_status 
                                                      end, 
             @w_sub_status                          = case when @w_check_type = 'SCRAPER RESPONSE' 
                                                           then '20' 
                                                           when wait_sub_status is null 
                                                           then '10' 
                                                           else wait_sub_status 
                                                      end
      from lp_common..common_utility_check_type with (nolock)
      where utility_id                              = @w_utility_id 
      and   contract_type                           = @w_contract_type 
      and   wait_status                            <> '*'
      order by [order]
   end

   select @w_descp_add                              = ' '

   select @w_return                                 = 1

   if exists(select a.status
             from lp_account..account a with (NOLOCK),
                  lp_account..ufn_account_check(@p_username) b
             where a.account_number                 = @w_account_number
             and   a.utility_id			            = @w_utility_id 
             and   ltrim(rtrim(a.status))             
             +     ltrim(rtrim(a.sub_status))       = b.status_substatus)
   begin

      select @w_add_info                            = 1

      select @w_status                              = case when @w_contract_is_amendment = 'TRUE' 
                                                           then @w_status_amend 
                                                           else status 
                                                      end,
             @w_sub_status                          = case when @w_contract_is_amendment = 'TRUE' 
                                                           then @w_sub_status_amend 
                                                           else sub_status 
                                                      end,
             @w_account_id                          = account_id,
             @w_date_created                        = date_created
      from lp_account..account with (NOLOCK)
      where account_number                          = @w_account_number
      and   utility_id					            = @w_utility_id 

	  -- MD084 Commented out the contact , name, and address since they are views now

      --delete lp_account..account_contact
      --from lp_account..account_contact with (NOLOCK)
      --where account_id                              = @w_account_id

      --delete lp_account..account_name
      --from lp_account..account_name with (NOLOCK)
      --where account_id                              = @w_account_id

      --delete lp_account..account_address
      --from lp_account..account_address with (NOLOCK)
      --where account_id                              = @w_account_id

   end

   select @w_return = 1
   
   if @w_add_info                                   = 0
   begin

   
      print 'About to run usp_account_additional_info_ins from usp_contract_submit_ins'
      exec @w_return = lp_account..usp_account_additional_info_ins @p_username,
                                                                   @w_account_id,
                                                                   '',
                                                                   '',
                               '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   '',
                                                                   @w_error output,
                                                                   @w_msg_id output, 
                                                                   ' ',
                                                                   'N'
      print 'Finished running usp_account_additional_info_ins from usp_contract_submit_ins'



   if @w_return                                    <> 0
   begin
      rollback tran val
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = ' (Insert Account Additional Info) '

      exec usp_contract_error_ins 'ENROLLMENT',
                                  @p_contract_nbr,
                                  @w_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add
      goto goto_select
      end
   end


   -- begin comments
   if not exists(select account_id
                 from lp_account..account_comments with (NOLOCK)
                 where account_id                   = @w_account_id
                 and   process_id                   = @w_process_id)
   begin
      select @w_date_comment                        = date_comment, 
             @w_comment                             = comment
      from deal_contract_comment with (nolock)
      where contract_nbr                            = @p_contract_nbr

      if len(ltrim(rtrim(@w_comment)))              > 0
      begin
         insert into lp_account..account_comments      
         select @w_account_id, 
                @w_date_comment, 
                @w_process_id, 
                @w_comment, 
                @w_username, 0

         if @@error                                <> 0
         or @@rowcount                              = 0
         begin
            rollback tran val
            select @w_application                   = 'COMMON'
            select @w_error                         = 'E'
            select @w_msg_id                        = '00000051'
            select @w_return                        = 1
            select @w_descp_add                     = '(Insert Billing Contact)'

            exec usp_contract_error_ins 'ENROLLMENT',
                                        @p_contract_nbr,
                                        @w_account_number,
                                        @w_application,
                                        @w_error,
                                        @w_msg_id,
                                        @w_descp_add
            goto goto_select
         end
      end
   end  
   -- end comments


   select @w_return                                 = 1

   exec @w_return = lp_account..usp_account_status_history_ins @w_username,
                                                               @w_account_id,
                                                               @w_status,
                                                               @w_sub_status,
                                                               @w_getdate,
                                                               @w_process_id,
                                                               @w_utility_id,
                                                               ' ',
                                                               ' ',
                                                               ' ',
                                                               ' ',
                                                               ' ',
                                                               ' ',
                                                               ' ',
                                                               @w_getdate,
                                                               @w_error output,
                                                               @p_msg_id output,
                                                               ' ',
                                                               'N'

   if @w_return                                    <> 0
   begin
      rollback tran val
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = ' (Insert History Account) '

      exec usp_contract_error_ins 'ENROLLMENT',
                                  @p_contract_nbr,
                                  @w_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add

      goto goto_select
   end

   if  exists(select status_substatus
              from lp_account..ufn_account_check(@p_username) 
              where status_substatus                = ltrim(rtrim(@w_status))             
                                                    + ltrim(rtrim(@w_sub_status)))
   and @w_contract_is_amendment                     = 'FALSE'
   begin
		/* Ticket 17675 begin */
		if not exists (select 1 from lp_account..account with (nolock)
					where account_id = @w_account_id)
		begin
			select @w_check_type_new_contract = ch.Check_Type
			from lp_common..common_utility_check_type ch with (nolock)
			where ch.contract_type		= @w_contract_type
			and	ch.utility_id			= @w_utility_id
			and ch.[order]				= (select min([order]) 
											from lp_common..common_utility_check_type chm with (nolock)
											where chm.contract_type		= ch.contract_type
											and chm.utility_id			= ch.utility_id
											and chm.Check_Type			<> 'CHECK ACCOUNT')
			order by [order]					
		end			
		else
		begin
			set @w_check_type_new_contract = 'CHECK ACCOUNT'
		end 
		
		/* Ticket 17675 end */
		
      if not exists(select contract_nbr
                    from lp_enrollment..check_account with (NOLOCK)
                    where contract_nbr              = @p_contract_nbr
                    and   check_type                = @w_check_type_new_contract)
      begin

         insert into lp_account..account_sales_channel_hist
         select @w_account_id,
                @w_getdate,
                @w_sales_channel_role,
                @w_check_type_new_contract,	---'CHECK ACCOUNT',    
                @w_username,
                0

         if @@error                                <> 0
         or @@rowcount                              = 0
         begin
            rollback tran val
            select @w_application                 = 'COMMON'
            select @w_error                         = 'E'
            select @w_msg_id                        = '00000051'
            select @w_return                        = 1
            select @w_descp_add                     = ' (Insert History Sales Channel) '

            exec usp_contract_error_ins 'ENROLLMENT',
                                        @p_contract_nbr,
                                        @w_account_number,
                                        @w_application,
                                        @w_error,
                                        @w_msg_id,
                                        @w_descp_add
 
            goto goto_select
         end
                                              
         select @w_return                           = 1

         exec @w_return = lp_enrollment..usp_check_account_ins @p_username,
                                                               @p_contract_nbr,
                                                               ' ',
                                                               @w_check_type_new_contract, --'CHECK ACCOUNT', ADD Ticket 17675
                                                               'ENROLLMENT',
                                                               'PENDING',
                                                               @w_getdate,
                                                               ' ',
                                                               '19000101',
                                                               'ONLINE',
                                                               ' ',
                                                               ' ',
                                                               '19000101',
                                                               ' ',
                                                               '19000101',
                                                               '19000101',
                                                               0,
                                                               @w_error output,
                                                               @w_msg_id output, 
                                                               ' ',
                                                               'N'
   
         if @w_return                              <> 0
         begin
            rollback tran val
            select @w_application       = 'COMMON'
            select @w_error                         = 'E'
            select @w_msg_id                        = '00000051'
            select @w_return                        = 1
            select @w_descp_add                     = ' (Insert ' + ltrim(rtrim(@w_check_type_new_contract)) + ') '

            exec usp_contract_error_ins 'ENROLLMENT',
                                        @p_contract_nbr,
                                        @w_account_number,
                                        @w_application,
                                        @w_error,
                                        @w_msg_id,
                                        @w_descp_add
 
            goto goto_select
         end
      end
   end

   select @w_return                                 = 1

   if @w_contract_type                              = 'POWER MOVE' 
   begin
      select @w_date_flow_start                       = @w_date_end
      select @w_date_end                              = dateadd(mm, @w_term_months,@w_date_flow_start)

      select @w_duns_number_entity                  = esco
      from lp_enrollment..load_set_number_accepted with (NOLOCK)
      where process_status                          = 'C'
      and   util_acct                               = @w_account_number

      select @w_entity_id                           = entity_id
      from lp_common..common_entity with (NOLOCK)
      where @w_duns_number_entity                like '%' + ltrim(rtrim(duns_number)) + '%'
   end              
   select @w_contract_type                          = case when @w_contract_is_amendment = 'TRUE' 
                                                           then @w_contract_type_amend 
                                                           else @w_contract_type 
                                                      end

   exec @w_return = lp_common..usp_product_account_type_sel @w_product_id, 
                                                            @w_account_type OUTPUT

   -- if there was an error, default to SMB
   if @w_return <> 0
   begin
      set @w_account_type = 'SMB'
   end

	/* Ticket 17130 begin */
	if @w_status = '911000' and  @w_sub_status = '10' and @w_date_deenrollment = '19000101'
		set @w_status = '01000'
	/* Ticket 17130 End */	
	
	/* Ticket 17675 begin */
	if not exists (select 1 from lp_account..account with (nolock)
				where account_id = @w_account_id)
	begin
		select @w_status				= wait_status
			,@w_sub_status				= wait_sub_status
			,@w_check_type_new_contract = ch.Check_Type
		from lp_common..common_utility_check_type ch with (nolock)
		where ch.contract_type		= @w_contract_type
		and	ch.utility_id			= @w_utility_id
		and ch.[order]				= (select min([order]) 
										from lp_common..common_utility_check_type chm with (nolock)
										where chm.contract_type		= ch.contract_type
										and chm.utility_id			= ch.utility_id
										and chm.Check_Type			<> 'CHECK ACCOUNT')
		order by [order]
	end			
	/* Ticket 17675 end */
	PRINT('About to execute lp_account..usp_account_ins inside Deal_capture..usp_contract_submit_ins')	
	
    exec @w_return = lp_account..[usp_genie_account_ins] @p_username				= @p_username,
                                                @p_account_id				= @w_account_id,
                                                @p_account_number			= @w_account_number,
                                                @p_account_type				= @w_account_type,
                                                @p_status					= @w_status,
                                                @p_sub_status				= @w_sub_status,
                                                @p_customer_id				= ' ',
                                                @p_entity_id				= @w_entity_id,
                                                @p_contract_nbr				= @w_contract_nbr,
                                                @p_contract_type			= @w_contract_type,
                                                @p_retail_mkt_id			= @w_retail_mkt_id,
                                                @p_utility_id				= @w_utility_id,
                                                @p_product_id				= @w_product_id,
                                                @p_rate_id					= @w_rate_id,
                                                @p_rate						= @w_rate,
                                                @p_account_name_link		= @w_account_name_link,
                                                @p_customer_name_link		= @w_customer_name_link,
                                                @p_customer_address_link	= @w_customer_address_link,
                                                @p_customer_contact_link	= @w_customer_contact_link,
                                                @p_billing_address_link		= @w_billing_address_link,
                                                @p_billing_contact_link		= @w_billing_contact_link,
                                                @p_owner_name_link			= @w_owner_name_link,
                                                @p_service_address_link		= @w_service_address_link,
                                                @p_business_type			= @w_business_type,
                                                @p_business_activity		= @w_business_activity,
                                                @p_additional_id_nbr_type	= @w_additional_id_nbr_type,
                                                @p_additional_id_nbr		= @w_additional_id_nbr,
                                                @p_contract_eff_start_date	= @w_contract_eff_start_date,
                                                @p_term_months				= @w_term_months,
                                                @p_date_end					= @w_date_end,
                                                @p_date_deal				= @w_date_deal,
                                                @p_date_created				= @w_date_created,
                                                @p_date_submit				= @w_date_submit,
                                                @p_sales_channel_role		= @w_sales_channel_role,
                                                @p_sales_rep				= @w_sales_rep,
                                                @p_origin					= @w_origin,
                                                @p_annual_usage				= @w_annual_usage,
                                                @p_date_flow_start			= @w_date_flow_start,
                                                @p_date_por_enrollment		= @w_date_por_enrollment,
                                                @p_date_deenrollment		= @w_date_deenrollment,
                                                @p_date_reenrollment		= @w_date_reenrollment,
                                                @p_tax_status				= @w_tax_status,
                                                @p_tax_float				= @w_tax_float,
                                                @p_credit_score				= @w_credit_score,
                                                @p_credit_agency			= @w_credit_agency,
                                                @p_por_option				= @w_por_option,
                                                @p_billing_type				= @w_billing_type,
												@p_zone						= '',
												@p_service_rate_class		= '',
												@p_stratum_variable			= '',
												@p_billing_group			= '',
												@p_icap						= '',
												@p_tcap						= '',
												@p_load_profile				= '',
												@p_loss_code				= '',
												@p_meter_type				= '',
                                                @p_requested_flow_start_date = @w_requested_flow_start_date,
                                                @p_deal_type				= @w_deal_type,
												@p_enrollment_type			= @p_enrollment_type,
                                                @p_customer_code			= @w_customer_code,
                                                @p_customer_group			= @w_customer_group,
                                                @p_error					= @w_error output,
                                                @p_msg_id					= @w_msg_id output, 
                                                @p_descp					= ' ',
                                                @p_result_ind				= 'N',
                                                @p_paymentTerm				= 0,
											    @p_SSNEncrypted				= @w_SSNEncrypted --Added for IT002
												,@p_HeatIndexSourceID		= @w_HeatIndexSourceID  -- Project IT037
												,@p_HeatRate				= @w_HeatRate,			-- Project IT037 
												@p_sales_manager			= @w_sales_manager,
                                                @p_evergreen_option_id		= @w_evergreen_option_id ,				--Added for IT021
												@p_evergreen_commission_end = @w_evergreen_commission_end ,		--Added for IT021
												@p_evergreen_commission_rate = @w_evergreen_commission_rate ,	--Added for IT021
												@p_residual_option_id		= @w_residual_option_id ,					--Added for IT021
												@p_residual_commission_end	= @w_residual_commission_end ,		--Added for IT021
												@p_initial_pymt_option_id	= @w_initial_pymt_option_id, 			--Added for IT021
												@p_original_tax_designation = @w_TaxStatus,
												@EstimatedAnnualUsage		= @EstimatedAnnualUsage,
												@PriceID					= @PriceID												

	PRINT('Finished execute lp_account..usp_account_ins inside Deal_capture..usp_contract_submit_ins')	
	






/*

---NAME -------------------------------------------------------------------------------------------------------------------------

   if not exists(select account_id
                 from lp_account..account_name with (NOLOCK)
                 where account_id                   = @w_account_id
                 and   name_link                    = @w_account_name_link)
   begin

		-- MD084 CHANGES
		EXEC lp_deal_capture.dbo.[usp_GenieNameCopy] @p_contract_nbr, @w_account_id, @w_account_name_link ;
		-- MD084 CHANGES END
		
      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         rollback tran val
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Insert Account Name)'

         exec usp_contract_error_ins 'ENROLLMENT',
                                     @p_contract_nbr,
                                     @w_account_number,
                         @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
         goto goto_select
      end
   end

   if not exists(select account_id
                 from lp_account..account_name with (NOLOCK)
                 where account_id                   = @w_account_id
                 and   name_link                    = @w_customer_name_link)
   begin
  
		-- MD084 CHANGES
		EXEC lp_deal_capture.dbo.[usp_GenieNameCopy] @p_contract_nbr, @w_account_id, @w_customer_name_link ;
		-- MD084 CHANGES END

      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         rollback tran val
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Insert Customer Name)'

         exec usp_contract_error_ins 'ENROLLMENT',
                                     @p_contract_nbr,
                                     @w_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
         goto goto_select
      end
   end

   if not exists(select account_id
                 from lp_account..account_name with (NOLOCK)
                 where account_id                   = @w_account_id
                 and   name_link                    = @w_owner_name_link)
   begin


		-- MD084 CHANGES
		EXEC lp_deal_capture.dbo.[usp_GenieNameCopy] @p_contract_nbr, @w_account_id, @w_owner_name_link ;
		-- MD084 CHANGES END

      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         rollback tran val
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Insert Owner Name)'

         exec usp_contract_error_ins 'ENROLLMENT',
                                     @p_contract_nbr,
                                     @w_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
         goto goto_select
      end
   end


-- ADDRESS --------------------------------------------------------------------------------------------------------------------------


   if not exists(select account_id
                 from lp_account..account_address with (NOLOCK)
                 where account_id                   = @w_account_id
                 and   address_link                 = @w_customer_address_link)
   begin
	
		-- MD084 changes
		EXEC lp_deal_capture.[dbo].[usp_GenieAddressCopy] @p_contract_nbr, @w_account_id, @w_customer_address_link;
		-- MD084 changes end


      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         rollback tran val
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Insert Customer Address)'

         exec usp_contract_error_ins 'ENROLLMENT',
                                     @p_contract_nbr,
                                     @w_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
         goto goto_select
      end
   end

   if not exists(select account_id
                 from lp_account..account_address with (NOLOCK)
                 where account_id                   = @w_account_id
                 and   address_link                 = @w_billing_address_link)
   begin
		-- MD084 changes
		EXEC lp_deal_capture.[dbo].[usp_GenieAddressCopy] @p_contract_nbr, @w_account_id, @w_billing_address_link;
		-- MD084 changes end


      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         rollback tran val
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Insert Billing Address)'

         exec usp_contract_error_ins 'ENROLLMENT',
                                     @p_contract_nbr,
                                     @w_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
         goto goto_select
      end
   end

   if not exists(select account_id
                 from lp_account..account_address with (NOLOCK)
                 where account_id                   = @w_account_id
                 and   address_link                 = @w_service_address_link)
   begin
  
		-- MD084 changes
		EXEC lp_deal_capture.[dbo].[usp_GenieAddressCopy] @p_contract_nbr, @w_account_id, @w_service_address_link;
		-- MD084 changes end
		
      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         rollback tran val
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Insert Services Address)'

         exec usp_contract_error_ins 'ENROLLMENT',
                                     @p_contract_nbr,
                                     @w_account_number,
                                     @w_application,
                       @w_error,
                                     @w_msg_id,
                                     @w_descp_add
         goto goto_select
      end
   end

-- CONTACT --------------------------------------------------------------------------------------------------------------------------

   print 'Starting to insert contacts from usp_contract_submit_ins'

   if not exists(select account_id
                 from lp_account..account_contact with (NOLOCK)
                 where account_id                   = @w_account_id
                 and   contact_link                 = @w_customer_contact_link)
   begin
		
		-- MD084 CHANGES
		EXEC lp_deal_capture.dbo.usp_GenieContactCopy @p_contract_nbr, @w_account_id, @w_customer_contact_link ;
		-- MD084 CHANGES END
		
      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         rollback tran val
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Insert Customer Contact)'

         exec usp_contract_error_ins 'ENROLLMENT',
                                     @p_contract_nbr,
                                     @w_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
         goto goto_select
      end
   end  

   if not exists(select account_id
                 from lp_account..account_contact with (NOLOCK)
                 where account_id                   = @w_account_id
                 and   contact_link                 = @w_billing_contact_link)
   begin

		-- MD084 CHANGES
		EXEC lp_deal_capture.dbo.usp_GenieContactCopy @p_contract_nbr, @w_account_id, @w_billing_contact_link ;
		-- MD084 CHANGES END

      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         rollback tran val
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Insert Billing Contact)'

         exec usp_contract_error_ins 'ENROLLMENT',
                                     @p_contract_nbr,
                                     @w_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
         goto goto_select
      end
   end  

   print 'Starting to insert comments from usp_contract_submit_ins'


----------------------------------------------------------------------------------------------------------------------------



*/


   if @w_return                                    <> 0
   begin
      rollback tran val
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = ' (Insert Account) '

      exec usp_contract_error_ins 'ENROLLMENT',
                                  @p_contract_nbr,
                                  @w_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add
      goto goto_select
   end
   
	-- IT106 add product rate and history if it does not exists. (will occur when coming from Genie)
	DECLARE	@PriceIDMapping		bigint,
			@RateDescription	varchar(250),
			@GrossMargin		decimal(18,10),
			@ExpirationDate		datetime,
			@ZoneID				int,
			@ServiceClassID		int,
			@Today				datetime
			
	SET		@Today	= GETDATE()
			   
	SELECT	@PriceIDMapping = ISNULL(PriceID, 0), @RateDescription = ISNULL(RateDescription, '''')
	FROM	Libertypower..GeniePriceMapping WITH (NOLOCK)
	WHERE	ProductID			= @w_product_id
	AND		RateID				= @w_rate_id

	IF @PriceIDMapping > 0
		BEGIN
			SELECT	@GrossMargin = ISNULL(GrossMargin, 0), @ExpirationDate = CostRateExpirationDate,
					@ZoneID = ZoneID, @ServiceClassID = ServiceClassID
			FROM	Libertypower..Price WITH(NOLOCK)
			WHERE	ID = @PriceIDMapping
			
			print 'Product ID: ' + @w_product_id
			print 'Rate ID: ' + cast(@w_rate_id as varchar(20))
			
			EXEC lp_common..usp_ProductRateAdd	@ProductId		= @w_product_id,
												@RateId			= @w_rate_id,
												@Rate			= @w_rate,
												@Description	= @RateDescription,
												@Term			= @w_term_months,
												@GrossMargin	= @GrossMargin,
												@IndexType		= '''',
												@BillingTypeID	= 0,
												@StartDate		= @w_date_flow_start,
												@EffDate		= @w_contract_eff_start_date,
												@DueDate		= @ExpirationDate,
												@GracePeriod	= 365,
												@ZoneID			= @ZoneID,
												@ServiceClassID	= @ServiceClassID,
												@ActiveDate		= @Today,
												@DateCreated	= @Today,
												@Username		= @p_username
									
			IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRAN val
					SELECT @w_application                      = 'COMMON'
					SELECT @w_error                            = 'E'
					SELECT @w_msg_id                           = '00000051'
					SELECT @w_return                           = 1
					SELECT @w_descp_add                        = '(Insert Product Rate)'

					EXEC usp_contract_error_ins 'ENROLLMENT',
											 @p_contract_nbr,
											 @w_account_number,
											 @w_application,
											 @w_error,
											 @w_msg_id,
											 @w_descp_add
					GOTO goto_select
				END				
		END						
  ---------------------------------------------------------------------------------------------------------------   
  
   if len(ltrim(rtrim(@w_customer_code)))          <> 0
   begin
	  /* Ticket : 15959 begin */
	  if exists (select 1 from lp_account..account_info with (nolock)
				where account_id = @w_account_id)
	  begin
			update lp_account..account_info
			set utility_id			= @w_utility_id
				,name_key			= @w_customer_code 
			where account_id		= @w_account_id
	  end
	  else
	  begin	
		  insert into lp_account..account_info
		  select @w_account_id,
				 @w_utility_id,
				 @w_customer_code,
				 '',
				 @w_date_created
				 ,suser_sname()
				 ,null
				 ,null
				 ,null
				 ,null
				 ,null
				 ,null
	  end			 
	  /* Ticket : 15959 End */
	  
      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         rollback tran val
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Insert Account Info)'

         exec usp_contract_error_ins 'ENROLLMENT',
                                     @p_contract_nbr,
                                     @w_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
         goto goto_select
      end
   end

   

   select @w_full_name                              = full_name
   from deal_name with (NOLOCK)
   where contract_nbr                               = @p_contract_nbr
   and   name_link                                  = @w_account_name_link

   select @w_service_address                        = address,
          @w_service_suite                          = suite,
          @w_service_city                           = city,
          @w_service_state                          = state,
          @w_service_zip                            = zip
   from deal_address with (nolock)
   where contract_nbr                               = @p_contract_nbr
   and   address_link                               = @w_service_address_link

   select @w_billing_address                        = address,
          @w_billing_suite                          = suite,
          @w_billing_city                           = city,
          @w_billing_state                          = state,
          @w_billing_zip                            = zip
   from deal_address with (nolock)
   where contract_nbr                               = @p_contract_nbr
   and   address_link                               = @w_billing_address_link

   exec @w_return = lp_deal_capture..usp_contract_tracking_details_ins @p_username,
                                                                       @w_transaction_id,
                                                                       @w_account_number,
                                                                       @w_full_name,
                                                                       @w_retail_mkt_id,
                                                                       @w_utility_id,
                                                                       @w_entity_id,
                                                                       @w_product_id,
                                                                       @w_rate_id,
                                                                       @w_rate,
                                                                       @w_por_option,
                                                                       @w_account_type,
                                                                       @w_business_activity,
                                                                       '',
                                                                       @w_contract_type,
                                                                       @w_contract_nbr,
                                                                       @w_sales_rep,
                                                                       @w_sales_channel_role,
                                                                       @w_contract_eff_start_date,
                                                                       @w_date_end,
                                                                       @w_term_months,
                                                                       @w_date_deal,
                                                                       @w_date_submit,
                                                                       @w_date_flow_start,
                                                                       @p_enrollment_type,
                                                                       @w_tax_status,
                                                                       @w_tax_float,
                                                                       @w_annual_usage,
                                                                       @w_getdate,
                                                                       @w_service_address,
                                                                       @w_service_suite,
                                                                       @w_service_city,
                                                                       @w_service_state,
                                                                       @w_service_zip,
                                                                       @w_billing_address,
                                                                       @w_billing_suite,
                                                                       @w_billing_city,
                                                                       @w_billing_state,
                                                                       @w_billing_zip,
                                                                       'DEAL CAPTURE',
                                                                       'COMPLETE'

   if @w_return                                    <> 0
   begin
      rollback tran val
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = ' (Insert Account Traking) '

      exec usp_contract_error_ins 'ENROLLMENT',
                                  @p_contract_nbr,
                                  @w_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add
      goto goto_select
   end

   insert into lp_account..account_meters
   select account_id, 
          meter_number
   from lp_deal_capture..account_meters with (NOLOCK)
   where account_id                                 = @w_account_id

   delete from account_meters
   where account_id                                 = @w_account_id

   update deal_contract_account set status = 'SENT'
   from deal_contract_account with (NOLOCK)
   where contract_nbr                               = @p_contract_nbr
   and   account_number                             = @t_account_number

   commit tran val

   set rowcount 1

   select @w_account_id                             = account_id,
          @w_account_number                         = account_number,
          @w_contract_type                          = case when contract_type = 'PRE-PRINTED' 
                                                           then 'PAPER' 
                                                           else contract_type 
                                                      end,
          @w_retail_mkt_id                          = retail_mkt_id,
          @w_utility_id                             = utility_id,
          @w_product_id                             = product_id,
          @w_rate_id                                = rate_id,
          @w_rate                                   = rate,
          @w_account_name_link                      = account_name_link,
          @w_customer_name_link                     = customer_name_link,
          @w_customer_address_link                  = customer_address_link,
          @w_customer_contact_link                  = customer_contact_link,
          @w_billing_address_link                   = billing_address_link,
          @w_billing_contact_link                   = billing_contact_link,
          @w_owner_name_link                        = owner_name_link,
          @w_service_address_link                   = service_address_link,
          @w_business_type                          = business_type,
          @w_business_activity                      = business_activity,
          @w_additional_id_nbr_type                 = additional_id_nbr_type,
          @w_additional_id_nbr                      = additional_id_nbr,
          @w_contract_eff_start_date                = contract_eff_start_date,
          @w_term_months                            = term_months,
          @w_date_end                               = date_end,
          @w_date_deal                              = date_deal,
          @w_date_created                           = date_created,
          @w_sales_channel_role                     = sales_channel_role,
          @w_username                               = username,
          @w_sales_rep                              = sales_rep,
          @w_origin                                 = origin,
          @w_requested_flow_start_date              = isnull(requested_flow_start_date, '19000101'),
          @w_deal_type                              = isnull(deal_type, ''),
          @w_customer_code                          = isnull(customer_code, ''),
          @w_customer_group                         = isnull(customer_group, ''),
		  @PriceID									= PriceID          
   from deal_contract_account with (NOLOCK)
   where contract_nbr                               = @p_contract_nbr
   and   account_number                             > @t_account_number
   and  (status                                     = ' '
   or    status                                     = 'RUNNING')

   select @w_rowcount                               = @@rowcount

end

set rowcount 0

begin tran cont


if exists(select contract_nbr
          from lp_enrollment..check_account with (NOLOCK)
          where contract_nbr                        = @w_contract_nbr
          and   check_type                          = 'CHECK ACCOUNT')
begin
   goto goto_sent
end                      

select top 1
       @w_check_type                                = b.check_type
from deal_contract a with (NOLOCK),
     lp_common..common_utility_check_type b with (NOLOCK)
where a.contract_nbr                                = @p_contract_nbr
and   a.utility_id                                  = b.utility_id
and   case when a.contract_type = 'PRE-PRINTED' 
           then 'PAPER' 
           else a.contract_type 
      end                                           = b.contract_type
and   b.[order]                                     > 1     
order by b.[order]                                 

if @@rowcount                                      <> 0
begin
   if exists(select contract_nbr
             from lp_enrollment..check_account with (NOLOCK)
             where contract_nbr                     = @w_contract_nbr
             and   check_type                       = @w_check_type)
   begin
      goto goto_sent
   end
end

if  @w_check_type                                   = 'PROFITABILITY' 
and @w_contract_is_amendment                        = 'FALSE'
begin

-- PROFITABILITY

   declare @w_request_datetime                      varchar(20) 

   declare @w_header_enrollment_1                   varchar(08)
   declare @w_header_enrollment_2                   varchar(08)

   select @w_header_enrollment_1                   = header_enrollment_1,
          @w_header_enrollment_2                   = header_enrollment_2
   from deal_config

   declare @w_getdate_h                             varchar(08)
   select @w_getdate_h                              = convert(varchar(08), getdate(), 108)

   declare @w_getdate_d                             varchar(08)
   select @w_getdate_d                              = convert(varchar(08), getdate(), 112)

   if @w_getdate_h                                  > @w_header_enrollment_2
   begin
      select @w_getdate_h                           = @w_header_enrollment_1
      select @w_getdate_d                           = convert(varchar(08), dateadd(dd, 1, @w_getdate_d), 112)
   end

   if @w_getdate_h                                 <= @w_header_enrollment_1
   begin
      select @w_request_datetime                    = @w_getdate_d
                                                    + ' '
                                                    + @w_header_enrollment_1
      select @w_risk_request_id                     = upper('DEAL-CAPTURE-' + @w_request_datetime)
   end
   else
   begin
      select @w_request_datetime                    = @w_getdate_d
                                                    + ' '
                                                    + @w_header_enrollment_2
      select @w_risk_request_id                     = upper('DEAL-CAPTURE-' + @w_request_datetime)
   end

   if not exists(select request_id
                 from lp_risk..web_header_enrollment with (NOLOCK)
                 where request_id                   = @w_risk_request_id)
   begin
      insert into lp_risk..web_header_enrollment
      select @w_risk_request_id,
             @w_request_datetime,
             'BATCH',
             'DEAL CAPTURE BATCH LOAD',
             getdate(),
             @p_username

      if  @@error                                  <> 0
      and @@rowcount                                = 0
      begin
         rollback tran cont
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = ' (Insert Scraper Header) '

         exec usp_contract_error_ins 'ENROLLMENT',
                                     @p_contract_nbr,
                                     @w_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
         goto goto_select
      end
   end

   insert into lp_risk..web_detail
   select @w_risk_request_id,
          account_number,
          'BATCH'
   from deal_contract_account with (NOLOCK)
   where contract_nbr                               = @p_contract_nbr

   if  @@error                                     <> 0
   and @@rowcount                                   = 0
   begin
      rollback tran cont
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = ' (Insert Scraper Detail) '

      exec usp_contract_error_ins 'ENROLLMENT',
                                  @p_contract_nbr,
                                  @w_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add

      goto goto_select
   end

   select @w_return                                 = 1
   
   exec @w_return = lp_enrollment..usp_check_account_ins @p_username,
                                                         @p_contract_nbr,
                                                         ' ',
                                                         'PROFITABILITY',
                                                         'ENROLLMENT',
                                                         'AWSCR',
                                                         @w_getdate,
                                                         ' ',
                                                         '19000101',
                                                         'ONLINE',
                                                         ' ',
                                                         @w_risk_request_id,
                                                         '19000101',
                                                         ' ',
                                                         '19000101',
                                                         '19000101',
                                                         0,
                                                         @w_error output,
                                                         @w_msg_id output, 
                                                         ' ',
                                                         'N'

   if @w_return                     <> 0
   begin
      rollback tran cont
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = ' (Insert Check Profitability) '

      exec usp_contract_error_ins 'ENROLLMENT',
                                  @p_contract_nbr,
                                  @w_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add

      goto goto_select
   end

end
else if @w_contract_is_amendment = 'FALSE'
begin

   select @w_return                                 = 1
	
	/* Add Ticket 17675 begin */
	if @w_check_type_new_contract is null or @w_check_type_new_contract = ''
		set @w_check_type_new_contract = @w_check_type
	/* Add Ticket 17675  end */
	
   exec @w_return = lp_enrollment..usp_check_account_ins @p_username,
                                                         @p_contract_nbr,
                                                         ' ',
                                                         @w_check_type_new_contract, --@w_check_typ Add Ticket 17675,
                                                         'ENROLLMENT',
                                                         'PENDING',
                                                         @w_getdate,
                                                         ' ',
                                                         '19000101',
                                                         'ONLINE',
                                                         ' ',
                                                         ' ',
                                                         '19000101',
                                                         ' ',
                                                         '19000101',
                                                         '19000101',
                                                         0,
                                                         @w_error output,
                                                         @w_msg_id output, 
                                                         ' ',
                                                         'N'

   if @w_return                                    <> 0
   begin
      rollback tran cont
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = ' (Insert Credit Check) '

      exec usp_contract_error_ins 'ENROLLMENT',
                                  @p_contract_nbr,
                                  @w_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add

      goto goto_select
   end
end

goto_sent:

set rowcount 0

delete deal_contract
from deal_contract with (NOLOCK)
where contract_nbr                                  = @p_contract_nbr

delete deal_contract_account
from deal_contract_account with (NOLOCK)
where contract_nbr                                  = @p_contract_nbr

delete deal_address
from deal_address with (NOLOCK)
where contract_nbr                                  = @p_contract_nbr

delete deal_contact
from deal_contact with (NOLOCK)
where contract_nbr                                  = @p_contract_nbr

delete deal_name
from deal_name with (NOLOCK)
where contract_nbr                                  = @p_contract_nbr

delete deal_contract_error
from deal_contract_error with (NOLOCK)
where contract_nbr                                  = @p_contract_nbr

delete
from   deal_contract_comment
where   contract_nbr = @p_contract_nbr

delete
from   deal_contract_amend
where   contract_nbr      = @p_contract_nbr
and      contract_nbr_amend   = @w_contract_nbr_amend

commit tran cont

goto_select:

set rowcount 0

update deal_contract set status = 'DRAFT - ERROR'
from deal_contract with (NOLOCK)
where contract_nbr                                  = @p_contract_nbr

select @p_application                               = @w_application,
       @p_error                                     = @w_error,
       @p_msg_id                                    = @w_msg_id,
       @p_descp_add                                 = @w_descp_add

return @w_return

---- End of procedure [dbo].[usp_contract_submit_ins] -----------------------------------------------------------
