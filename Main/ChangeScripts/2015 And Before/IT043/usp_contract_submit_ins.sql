USE [lp_contract_renewal]
GO
/****** Object:  StoredProcedure [dbo].[usp_contract_submit_ins]    Script Date: 09/20/2012 17:15:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Modified		5/20/2008
-- Modified By	Rick Deigsler
-- Added code to delete contract from check account table

--	Modified:	7/7/2008 per Douglas
--				SD Ticket # 4434
--				Set contract effective start date to be the next meter read date plus 1 month and 3 days

--exec usp_contract_submit_ins 'libertypower\dmarino', 'Contracto A1'
--exec usp_contract_submit_ins @p_username=N'LIBERTYPOWER\dmarino',@p_contract_nbr=N'0104C483'
-- =============================================
-- Modify		: Jose Munoz
-- Date			: 02/18/2010
-- Description	: Add SSNClear, SSNEncrypted and CreditScoreEncrypted columns to insert.
-- Ticket		: IT002
-- =============================================
-- Modified: George Worthington 4/30/2010
-- added Sales Channel Settings overrided fields
-- Project IT021
-- =============================================
-- Modified: Eric Hernandez 9/8/2010
-- Added "order by" when accessing common_utility_check_type table, so that steps are handled in order.
-- Ticket 17816
-- =============================================
-- Modify		: Lucio Teles /Jose Munoz
-- Date			: 09/21/2010
-- Description	: REMOVE THE @w_contract_eff_start_date CALCULATION 
-- Ticket		: 18209
-- =============================================
-- ===============================================================
-- Modified José Muñoz 01/20/2011
-- Account/ Customer Name should be trimmed when inserting into the Table....  
-- Ticket 20906
-- =============================================
-- Modified Isabelle Tamanini 4/14/2011
-- Adding piece of code that inserts add on accounts in account table
-- Ticket 22541 
-- ===============================================================
-- Modified José Muñoz 06/10/2011
-- Added new table deal_account_address into the query
-- Added new table deal_account_contact into the query
-- Ticket 23125
-- =============================================
-- Modified: Isabelle Tamanini 12/16/2011
-- SR1-4955209
-- Date end will be terms + flow start date - 1 day
-- =============================================
-- Modified: Isabelle Tamanini 05/08/2012
-- SR1-15006521
-- Added utility id to select the account id based on account number
-- =============================================
-- Modified: JAime FOrero 10/4/2012
-- MD084
-- Encapsulated coping of address name and contact data to liberty power
-- using new tables
-- =============================================

ALTER procedure [dbo].[usp_contract_submit_ins]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_application                                     varchar(20) = ' ' output,
 @p_error                                           char(01) = ' ' output,
 @p_msg_id                                          char(08) = ' ' output,
 @p_descp_add                                       varchar(100) = ' ' output)
as
declare @w_error                                   char(01)
	,@w_msg_id                                   char(08)
	,@w_return                                   int
	,@w_descp_add                                varchar(100)
	,@w_duns_number_entity                       varchar(255)
	,@w_account_id                               char(12)
	,@w_account_number                           varchar(30)
	,@w_status                                   varchar(15)
	,@w_sub_status                               varchar(15)
	,@w_entity_id                                char(15)
	,@w_contract_nbr                             char(12)
	,@w_contract_type                            varchar(25)
	,@w_retail_mkt_id                            char(02)
	,@w_utility_id                               char(15)
	,@w_product_id                               char(20)
	,@w_rate_id                                  int
	,@w_rate                                     float
	,@w_account_name_link                        int
	,@w_customer_name_link                       int
	,@w_customer_address_link                    int
	,@w_customer_contact_link                    int
	,@w_billing_address_link                     int
	,@w_billing_contact_link                     int
	,@w_owner_name_link                          int
	,@w_service_address_link                     int
	,@w_business_type                            varchar(35)
	,@w_business_activity                        varchar(35)
	,@w_additional_id_nbr_type                   varchar(10)
	,@w_additional_id_nbr                        varchar(30)
	,@w_contract_eff_start_date                  datetime
	,@w_term_months                              int
	,@w_date_end                                 datetime
	,@w_date_deal                                datetime
	,@w_date_created                             datetime
	,@w_date_submit                              datetime
	,@w_sales_channel_role                       nvarchar(50)
	,@w_username                                 nchar(100)
	,@w_sales_rep                                varchar(100)
	,@w_origin                                   varchar(50)
	,@w_annual_usage                             money
	,@w_date_flow_start                          datetime
	,@w_date_por_enrollment                      datetime
	,@w_date_deenrollment                        datetime
	,@w_date_reenrollment                        datetime
	,@w_tax_status                               varchar(20)
	,@w_tax_float                                int
	,@w_credit_score                             real
	,@w_credit_agency                            varchar(30)
	,@w_por_option                               varchar(03)
	,@w_billing_type                             varchar(15)
	,@w_risk_request_id                          varchar(50)
	,@w_renew									tinyint
	,@w_account_type								varchar(50)
	,@w_check_type                               char(15)
	,@t_account_number                           varchar(30)
	,@w_SSNClear									nvarchar	(100) 	-- IT002
	,@w_SSNEncrypted							nvarchar	(512) 	-- IT002
	,@w_CreditScoreEncrypted					nvarchar	(512) 	-- IT002
	,@w_application                              varchar(20)
	,@w_rowcount                                 int
	,@w_getdate                                  datetime
	,@PriceID									int -- IT106

select @w_error                                     = 'I'
	, @w_msg_id                                    = '00000001'
	, @w_return                                    = 0
	, @w_descp_add                                 = ' ' 


select @w_application                               = 'COMMON'


select @w_getdate                                   = date_submit
from deal_contract with (NOLOCK)
where contract_nbr                                  = @p_contract_nbr
--and   status                                        = 'RUNNING'

select @w_descp_add                                 = ' '



select @w_account_id                                = ''
	,@w_account_number                            = ''
	,@w_entity_id                                 = ''
	,@w_contract_nbr                              = ''
	,@w_contract_type                             = ''
	,@w_retail_mkt_id                             = ''
	,@w_utility_id                                = ''
	,@w_product_id                                = ''
	,@w_rate_id                                   = 0
	,@w_rate                                      = 0
	,@w_account_name_link                         = 0
	,@w_customer_name_link                        = 0
	,@w_customer_address_link                     = 0
	,@w_customer_contact_link                     = 0
	,@w_billing_address_link                      = 0
	,@w_billing_contact_link                      = 0
	,@w_owner_name_link                           = 0
	,@w_service_address_link                      = 0
	,@w_business_type                             = ''
	,@w_business_activity                         = ''
	,@w_additional_id_nbr_type                    = ''
	,@w_additional_id_nbr                         = ''
	,@w_contract_eff_start_date                   = '19000101'
	,@w_term_months                               = 0
	,@w_date_end                                  = '19000101'
	,@w_date_deal                                 = '19000101'
	,@w_date_created                              = '19000101'
	,@w_sales_channel_role                        = ''
	,@w_username                                  = ''
	,@w_sales_rep                                 = ''
	,@w_origin                                    = ''
	,@w_date_submit                               = @w_getdate
	,@w_annual_usage                              = 0
	,@w_date_flow_start                           = '19000101'
	,@w_date_por_enrollment                       = '19000101'
	,@w_date_deenrollment                         = '19000101'
	,@w_date_reenrollment                         = '19000101'
	,@w_tax_status                                = 'FULL'
	,@w_tax_float                                 = 0
	,@w_credit_score                              = 0
	,@w_credit_agency                             = 'NONE'
	,@w_por_option                                = 'NO'
	,@w_renew										= 1

select @w_status                                    = ''
	, @w_sub_status                                = ''
	, @w_entity_id                                 = ''

-- Start: Added for Overridable Sales Channel settings. IT021
declare @w_evergreen_option_id						int
	,@w_evergreen_commission_end					datetime
	,@w_residual_option_id							int
	,@w_residual_commission_end						datetime
	,@w_initial_pymt_option_id						int
	,@w_sales_manager								varchar(100)
	,@w_evergreen_commission_rate					float

select 
	@w_evergreen_option_id				= evergreen_option_id
	,@w_evergreen_commission_end		= evergreen_commission_end
	,@w_evergreen_commission_rate		= evergreen_commission_rate
	,@w_residual_option_id				= residual_option_id							
	,@w_residual_commission_end			= residual_commission_end					
	,@w_initial_pymt_option_id			= initial_pymt_option_id						
	,@w_sales_manager					= sales_manager			
from lp_contract_renewal.dbo.deal_contract with (NOLOCK)
where contract_nbr	=	@p_contract_nbr
-- End: Added for Overridable Sales Channel settings.


-- added 5/20/2008
--delete from lp_enrollment..check_account 
--where contract_nbr = @p_contract_nbr

-- delete any accounts from renewal tables that are not renewing
delete
from	deal_contract_account
where	contract_nbr	= @p_contract_nbr
and		renew			= 0


select @t_account_number                            = ''

set rowcount 1

select @w_account_id                                = account_id,
       @w_account_number                            = account_number,
       @w_contract_type                             = contract_type,
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
       @w_contract_eff_start_date                   = contract_eff_start_date,
       @w_term_months                               = term_months,
       @w_date_end                                  = date_end,
       @w_date_deal                                 = date_deal,
       @w_date_created                              = date_created,
       @w_sales_channel_role                        = sales_channel_role,
       @w_username                                  = username,
       @w_sales_rep                                 = sales_rep,
       @w_origin                                    = origin,
	   @w_annual_usage								= annual_usage,
	   @w_renew										= renew
	   	,@w_SSNClear								= SSNClear				-- IT002
		,@w_SSNEncrypted							= SSNEncrypted			-- IT002
		,@w_CreditScoreEncrypted					= CreditScoreEncrypted	-- IT002
		,@PriceID									= PriceID -- IT106
from deal_contract_account with (NOLOCK)
where contract_nbr                                  = @p_contract_nbr
and   account_number                                > @t_account_number
and  (status                                        = ' '
or	  status                                        = 'DRAFT'
or    status                                        = 'RUNNING')
and	  renew											= 1

select @w_rowcount                                  = @@rowcount

select @w_entity_id                                 = entity_id,
       @w_por_option                                = por_option,
       @w_billing_type                              = billing_type
from lp_common..common_utility b with (NOLOCK)
where utility_id                                    = @w_utility_id

select	top 1 @w_status = case when wait_status is null then '01000' else wait_status end, 
		@w_sub_status = case when wait_sub_status is null then '10' else wait_sub_status end
from	lp_common..common_utility_check_type
where	utility_id									= @w_utility_id
and		contract_type								= @w_contract_type
order by [order]

while @w_rowcount                                  <> 0
begin
   set rowcount 0

   select @t_account_number                         = @w_account_number


		   update deal_contract_account set status = 'RUNNING'
		   where contract_nbr                               = @p_contract_nbr
		   and   account_number                             = @t_account_number

			select @w_account_id                                = account_id,
				   @w_account_number                            = account_number,
				   @w_contract_type                             = contract_type,
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
				   @w_contract_eff_start_date                   = contract_eff_start_date,
				   @w_term_months                               = term_months,
				   @w_date_end                                  = date_end,
				   @w_date_deal                                 = date_deal,
				   @w_date_created                              = date_created,
				   @w_sales_channel_role                        = sales_channel_role,
				   @w_username                                  = username,
				   @w_sales_rep                                 = sales_rep,
				   @w_origin                                    = origin,
				   @w_annual_usage								= annual_usage,
					@PriceID									= PriceID -- IT106
			from deal_contract_account with (NOLOCK)
			where contract_nbr                                  = @p_contract_nbr
			and   account_number                                = @t_account_number
			and	  renew											= 1

			select top 1
				   @w_check_type                                = case when b.check_type is null then 'USAGE ACQUIRE' else b.check_type end
			from deal_contract a with (NOLOCK),
				 lp_common..common_utility_check_type b with (NOLOCK)
			where a.contract_nbr                                = @p_contract_nbr
			and   a.utility_id                                  = b.utility_id
			and   a.contract_type                               = b.contract_type
			and   b.[order]                                     > 1   
			order by [order]

		   begin tran val

		   select @w_descp_add                              = ' '

		   select @w_return                                 = 1

		   if exists(select status
					 from lp_account..account_renewal with (NOLOCK)
					 where account_number                   = @w_account_number
					 and ((ltrim(rtrim(status))             
					 +     ltrim(rtrim(sub_status))         = '0700080')
					 or   (ltrim(rtrim(status))          
					 +     ltrim(rtrim(sub_status))         = '0700090') ))
		   begin
			  select @w_status                              = status,
					 @w_sub_status                          = sub_status,
					 @w_account_id                          = account_id,
					 @w_date_created                        = date_created
			  from lp_account..account_renewal with (NOLOCK)
			  where account_number                          = @w_account_number
			  and utility_id = @w_utility_id --SR1-15006521

			  delete lp_account..account_renewal
			  from lp_account..account_renewal with (NOLOCK)
			  where account_id                              = @w_account_id

			  delete lp_account..account_renewal_additional_info
			  from lp_account..account_renewal_additional_info with (NOLOCK)
			  where account_id                              = @w_account_id

			  delete lp_account..account_renewal_contact
			  from lp_account..account_renewal_contact with (NOLOCK)
			  where account_id                              = @w_account_id

			  delete lp_account..account_renewal_name
			  from lp_account..account_renewal_name with (NOLOCK)
			  where account_id                              = @w_account_id

			  delete lp_account..account_renewal_address
			  from lp_account..account_renewal_address with (NOLOCK)
			  where account_id                              = @w_account_id

		   end

		   select @w_return                                 = 1

		   exec @w_return = lp_account..usp_account_renewal_additional_info_ins @p_username,
																		@w_account_id,
																		' ',
																		' ',
																		' ',
																		' ',
																		' ',
																		' ',
																		' ',
																		' ',
																		' ',
																		' ',
																		' ',
																		' ',
																		' ',
																		' ',
																		' ',
																		@w_error output,
																		@w_msg_id output, 
																		' ',
																		'N'



		   if @w_return                                    <> 0
		   begin
			  rollback tran val
			  select @w_application                         = 'COMMON'
			  select @w_error                               = 'E'
			  select @w_msg_id                              = '00000051'
			  select @w_return                              = 1
			  select @w_descp_add                           = ' (Insert Account Additional Info) '

			  exec usp_contract_error_ins 'RENEWAL',
										  @p_contract_nbr,
										  @w_account_number,
										  @w_application,
										  @w_error,
										  @w_msg_id,
										  @w_descp_add
			  goto goto_select
		   end

		-- =======================================================================================================================================
		-- MD084 changes copy name contact address data to LP
		-- =======================================================================================================================================
		-- REPLACED BY MD084

			--DECLARE @MSG VARCHAR(1000);			
			--SET @MSG = '@w_account_name_link: ' + CAST(@w_account_name_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_customer_name_link: ' + CAST(@w_customer_name_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_owner_name_link: ' + CAST(@w_owner_name_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_customer_address_link: ' + CAST(@w_customer_address_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_billing_address_link: ' + CAST(@w_billing_address_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_service_address_link: ' + CAST(@w_service_address_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_customer_contact_link: ' + CAST(@w_customer_contact_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_billing_contact_link: ' + CAST(@w_billing_contact_link AS VARCHAR) ;
			--INSERT INTO [Libertypower].[dbo].[TraceLog] ([Message], Content) VALUES ('Before AccountID: ' + @w_account_id,@MSG);

			DECLARE @RC INT;
			
			EXECUTE @RC = [lp_contract_renewal].[dbo].[usp_CopyRenewalNameAddressContactDataToLp] 
			   @w_account_id
			  ,@w_account_name_link OUTPUT
			  ,@w_customer_name_link OUTPUT
			  ,@w_owner_name_link OUTPUT
			  ,@w_customer_address_link OUTPUT
			  ,@w_billing_address_link OUTPUT
			  ,@w_service_address_link OUTPUT
			  ,@w_customer_contact_link OUTPUT
			  ,@w_billing_contact_link OUTPUT
			  ,@w_username;


			--SET @MSG = '@w_account_name_link: ' + CAST(@w_account_name_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_customer_name_link: ' + CAST(@w_customer_name_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_owner_name_link: ' + CAST(@w_owner_name_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_customer_address_link: ' + CAST(@w_customer_address_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_billing_address_link: ' + CAST(@w_billing_address_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_service_address_link: ' + CAST(@w_service_address_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_customer_contact_link: ' + CAST(@w_customer_contact_link AS VARCHAR) ;
			--SET @MSG = @MSG + '@w_billing_contact_link: ' + CAST(@w_billing_contact_link AS VARCHAR) ;
			
			--INSERT INTO [Libertypower].[dbo].[TraceLog] ([Message], Content) VALUES ('After AccountID: ' + @w_account_id,@MSG);



/* *
COMMENTED CODE:

		   if not exists(select account_id
						 from lp_account..account_renewal_name with (NOLOCK)
						 where account_id                   = @w_account_id
						 and   name_link                    = @w_account_name_link)
		   begin
		    print 'inserting name now'
			print @w_account_id
			print @w_account_name_link

			  insert into lp_account..account_renewal_name
			  select @w_account_id,
					 @w_account_name_link,
					 LTRIM(RTRIM(full_name)),
					 0
			  from deal_account_name with (nolock)
			  where account_id								= @w_account_id
			  and   name_link                               = @w_account_name_link

			  if @@error                                   <> 0
			  or @@rowcount                                 = 0
			  begin
				 rollback tran val
				 select @w_application                      = 'COMMON'
				 select @w_error                            = 'E'
				 select @w_msg_id                           = '00000051'
				 select @w_return                           = 1
				 select @w_descp_add                        = '(Insert Account Name)'

				 exec usp_contract_error_ins 'RENEWAL',
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
						 from lp_account..account_renewal_name with (NOLOCK)
						 where account_id                   = @w_account_id
						 and   name_link                    = @w_customer_name_link)
		   begin
			  insert into lp_account..account_renewal_name
			  select @w_account_id,
					 @w_customer_name_link,
					 LTRIM(RTRIM(full_name)),
					 0
			  from deal_account_name with (nolock)
			  where account_id								= @w_account_id
			  and   name_link                               = @w_customer_name_link

			  if @@error                                   <> 0
			  or @@rowcount                                 = 0
			  begin
				 rollback tran val
				 select @w_application                      = 'COMMON'
				 select @w_error                            = 'E'
				 select @w_msg_id                           = '00000051'
				 select @w_return                           = 1
				 select @w_descp_add                        = '(Insert Customer Name)'

				 exec usp_contract_error_ins 'RENEWAL',
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
						 from lp_account..account_renewal_name with (NOLOCK)
						 where account_id                   = @w_account_id
						 and   name_link                    = @w_owner_name_link)
		   begin

			  insert into lp_account..account_renewal_name
			  select @w_account_id,
					 @w_owner_name_link,
					 LTRIM(RTRIM(full_name)),
					 0
			  from deal_account_name with (nolock)
			  where account_id								= @w_account_id
			  and   name_link                               = @w_owner_name_link

			  if @@error                                   <> 0
			  or @@rowcount                                 = 0
			  begin
				 rollback tran val
				 select @w_application                      = 'COMMON'
				 select @w_error                            = 'E'
				 select @w_msg_id                           = '00000051'
				 select @w_return                           = 1
				 select @w_descp_add                        = '(Insert Owner Name)'

				 exec usp_contract_error_ins 'RENEWAL',
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
						 from lp_account..account_renewal_address with (NOLOCK)
						 where account_id                   = @w_account_id
						 and   address_link                 = @w_customer_address_link)
		   begin
			  insert into lp_account..account_renewal_address
			  select @w_account_id,
					 @w_customer_address_link,
					 address,
					 suite,
					 city,
					 state,
					 zip,
					 county,
					 state_fips,
					 county_fips,
					 0
			  from deal_account_address with (nolock)
			  where account_id								= @w_account_id
			  and   address_link                            = @w_customer_address_link

			  if @@error                                   <> 0
			  or @@rowcount                                 = 0
			  begin
				 rollback tran val
				 select @w_application                      = 'COMMON'
				 select @w_error                            = 'E'
				 select @w_msg_id                           = '00000051'
				 select @w_return                           = 1
				 select @w_descp_add                        = '(Insert Customer Address)'

				 exec usp_contract_error_ins 'RENEWAL',
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
						 from lp_account..account_renewal_address with (NOLOCK)
						 where account_id                   = @w_account_id
						 and   address_link                 = @w_billing_address_link)
		   begin
			  insert into lp_account..account_renewal_address
			  select @w_account_id,
					 @w_billing_address_link,
					 address,
					 suite,
					 city,
					 state,
					 zip,
					 county,
					 state_fips,
					 county_fips,
					 0
			  from deal_account_address with (nolock)
			  where account_id								= @w_account_id
			  and   address_link                            = @w_billing_address_link

			  if @@error                                   <> 0
			  or @@rowcount                                 = 0
			  begin
				 rollback tran val
				 select @w_application                      = 'COMMON'
				 select @w_error                            = 'E'
				 select @w_msg_id                           = '00000051'
				 select @w_return                           = 1
				 select @w_descp_add                        = '(Insert Billing Address)'

				 exec usp_contract_error_ins 'RENEWAL',
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
						 from lp_account..account_renewal_address with (NOLOCK)
						 where account_id                   = @w_account_id
						 and   address_link                 = @w_service_address_link)
		   begin
			  insert into lp_account..account_renewal_address
			  select @w_account_id,
					 @w_service_address_link,
					 address,
					 suite,
					 city,
					 state,
					 zip,
					 county,
					 state_fips,
					 county_fips,
					 0
			  from deal_account_address with (nolock)
			  where account_id								= @w_account_id
			  and   address_link                            = @w_service_address_link

			  if @@error                                   <> 0
			  or @@rowcount                                 = 0
			  begin
				 rollback tran val
				 select @w_application                      = 'COMMON'
				 select @w_error                            = 'E'
				 select @w_msg_id                           = '00000051'
				 select @w_return                           = 1
				 select @w_descp_add                        = '(Insert Services Address)'

				 exec usp_contract_error_ins 'RENEWAL',
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
						 from lp_account..account_renewal_contact with (NOLOCK)
						 where account_id                   = @w_account_id
						 and   contact_link                 = @w_customer_contact_link)
		   begin

			  insert into lp_account..account_renewal_contact
			  select @w_account_id,
					 @w_customer_contact_link,
					 first_name,
					 last_name,
					 title,
					 phone,
					 fax,
					 email,
					 isnull(birthday, '01/01'),
					 0
			  from deal_account_contact with (nolock)
			  where account_id								= @w_account_id
			  and   contact_link                            = @w_customer_contact_link

			  if @@error                                   <> 0
			  or @@rowcount                                 = 0
			  begin
				 rollback tran val
				 select @w_application                      = 'COMMON'
				 select @w_error                            = 'E'
				 select @w_msg_id                           = '00000051'
				 select @w_return                           = 1
				 select @w_descp_add                        = '(Insert Customer Contact)'

				 exec usp_contract_error_ins 'RENEWAL',
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
						 from lp_account..account_renewal_contact with (NOLOCK)
						 where account_id                   = @w_account_id
						 and   contact_link                 = @w_billing_contact_link)
		   begin

			  insert into lp_account..account_renewal_contact
			  select @w_account_id,
					 @w_billing_contact_link,
					 first_name,
					 last_name,
					 title,
					 phone,
					 fax,
					 email,
					 isnull(birthday, '01/01'),
					 0
			  from deal_account_contact with (nolock)
			  where account_id								= @w_account_id
			  and   contact_link                            = @w_billing_contact_link

			  if @@error                                   <> 0
			  or @@rowcount                                 = 0
			  begin
				 rollback tran val
				 select @w_application                      = 'COMMON'
				 select @w_error                            = 'E'
				 select @w_msg_id                           = '00000051'
				 select @w_return                           = 1
				 select @w_descp_add                        = '(Insert Billing Contact)'

				 exec usp_contract_error_ins 'RENEWAL',
											 @p_contract_nbr,
											 @w_account_number,
											 @w_application,
											 @w_error,
											 @w_msg_id,
											 @w_descp_add
				 goto goto_select
			  end
		   end  




*/


-- =======================================================================================================================================
-- END MD084 changes copy name contact address data to LP
-- =======================================================================================================================================









		   select @w_return                                 = 1

		   exec @w_return = lp_account..usp_account_status_history_ins @w_username,
																	   @w_account_id,
																	   @w_status,
																	   @w_sub_status,
																	   @w_getdate,
																	   'RENEWAL',
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

			  exec usp_contract_error_ins 'RENEWAL',
										  @p_contract_nbr,
										  @w_account_number,
										  @w_application,
										  @w_error,
										  @w_msg_id,
										  @w_descp_add

			  goto goto_select
		   end

		   if (ltrim(rtrim(@w_status))             
		   +   ltrim(rtrim(@w_sub_status))                  = '91100010')
		   or (ltrim(rtrim(@w_status))             
		   +   ltrim(rtrim(@w_sub_status))                  = '99999810') 
		   or (ltrim(rtrim(@w_status))             
		   +   ltrim(rtrim(@w_sub_status))                  = '99999910') 
		   begin

			  if not exists(select contract_nbr
							from lp_enrollment..check_account with (NOLOCK)
							where contract_nbr              = @p_contract_nbr
							and   check_type                = 'TPV')
			  begin

				 insert into lp_account..account_renewal_sales_channel_hist
				 select @w_account_id,
						@w_getdate,
						@w_sales_channel_role,
						'TPV',    
						@w_username,
						0

				 if @@error                                <> 0
				 or @@rowcount                              = 0
				 begin
					rollback tran val
					select @w_application                   = 'COMMON'
					select @w_error                         = 'E'
					select @w_msg_id                        = '00000051'
					select @w_return                        = 1
					select @w_descp_add                     = ' (Insert History Sales Channel) '

					exec usp_contract_error_ins 'RENEWAL',
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
																	   @w_check_type,
																	   'RENEWAL',
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
					select @w_application                   = 'COMMON'
					select @w_error                         = 'E'
					select @w_msg_id                        = '00000051'
					select @w_return                        = 1
					select @w_descp_add                     = ' (Insert Renewal) '

					exec usp_contract_error_ins 'RENEWAL',
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
				  select @w_date_end                              = dateadd(mm, @w_term_months,dateadd(dd, -1, @w_date_flow_start))

				  select @w_duns_number_entity                  = esco
				  from lp_enrollment..load_set_number_accepted with (NOLOCK)
				  where process_status                          = 'C'
				  and   util_acct                               = @w_account_number

				  select @w_entity_id                           = entity_id
				  from lp_common..common_entity with (NOLOCK)
				  where @w_duns_number_entity                like '%' + ltrim(rtrim(duns_number)) + '%'
			   end       
			else
				begin
					select	@w_date_flow_start	= date_flow_start
					from	lp_account..account with (nolock)
					where	account_id			= @w_account_id
					if @w_date_flow_start is null
						begin
							set @w_date_flow_start = getdate()
						end
				end

		   exec	@w_return = lp_common..usp_product_account_type_sel @w_product_id, @w_account_type OUTPUT

			-- if there was an error, default to SMB
			if @w_return <> 0
				set @w_account_type = 'SMB'


			select	top 1 @w_status = case when wait_status is null then '01000' else wait_status end, 
					@w_sub_status = case when wait_sub_status is null then '10' else wait_sub_status end
			from	lp_common..common_utility_check_type
			where	utility_id									= @w_utility_id
			and		contract_type								= @w_contract_type
			order by [order]

			-- added 7/7/2008 per Douglas
			-- SD Ticket # 4434
			-- set contract effective start date to be the next meter read date plus 1 month and 3 days

			-- REMOVE THE @w_contract_eff_start_date CALCULATION 
			-- TICKET 18209 BEGIN
			-- set @w_contract_eff_start_date = dateadd(dd, 3, dateadd(mm, datediff(mm, dateadd(yyyy, datediff(yyyy, @w_date_flow_start, getdate()), @w_date_flow_start), getdate()) + 1, dateadd(yyyy, datediff(yyyy, @w_date_flow_start, getdate()), @w_date_flow_start)))
			-- TICKET 18209 END

			--22541
			IF NOT EXISTS (	SELECT	contract_nbr
						FROM	lp_account..account
						WHERE	account_id = @w_account_id )
			BEGIN
				print 'about to call usp_account_added_ins from usp_contract_account_ins'
				exec @w_return = usp_account_added_ins @p_username, @w_account_number, @w_application output, @w_error output, @w_msg_id output
				print 'after call usp_account_added_ins from usp_contract_account_ins'
				
				if @w_return                                        <> 0
				begin
	 			   goto goto_account_error
				end
			END		

			-- Change made for NJ tax laws.
			DECLARE @Tax FLOAT
			SELECT @Tax = SalesTax
			FROM LibertyPower..Market M
			JOIN LibertyPower..MarketSalesTax MST ON M.ID = MST.MarketID
			WHERE M.MarketCode = @w_retail_mkt_id
			IF @Tax IS NULL
			SET @Tax = 0.0
			SET @w_rate = ROUND(@w_rate / (1 + @Tax),5)
			-- End NJ tax change.

		   exec @w_return = lp_account..usp_account_renewal_ins @p_username,
														@w_account_id,
														@w_account_number,
														@w_account_type,
														@w_status,
														@w_sub_status,
														' ',
														@w_entity_id,
														@p_contract_nbr,
														@w_contract_type,
														@w_retail_mkt_id,
														@w_utility_id,
														@w_product_id,
														@w_rate_id,
														@w_rate,
														@w_account_name_link,
														@w_customer_name_link,
														@w_customer_address_link,
														@w_customer_contact_link,
														@w_billing_address_link,
														@w_billing_contact_link,
														@w_owner_name_link,
														@w_service_address_link,
														@w_business_type,
														@w_business_activity,
														@w_additional_id_nbr_type,
														@w_additional_id_nbr,
														@w_contract_eff_start_date,
														@w_term_months,
														@w_date_end,
														@w_date_deal,
														@w_date_created,
														@w_date_submit,
														@w_sales_channel_role,
														@w_sales_rep,
														@w_origin,
														@w_annual_usage,
														@w_date_flow_start,
														@w_date_por_enrollment,
														@w_date_deenrollment,
														@w_date_reenrollment,
														@w_tax_status,
														@w_tax_float,
														@w_credit_score,
														@w_credit_agency,
														@w_por_option,
														@w_billing_type,
														@w_error output,
														@w_msg_id output, 
														' ',
														'N'
														,@w_SSNClear				-- IT002
														,@w_SSNEncrypted			-- IT002
														,@w_CreditScoreEncrypted	-- IT002
														,@w_evergreen_option_id			-- IT021
														,@w_evergreen_commission_end	-- IT021
														,@w_residual_option_id			-- IT021
														,@w_residual_commission_end		-- IT021
														,@w_initial_pymt_option_id		-- IT021
														,@w_sales_manager				-- IT021
														,@w_evergreen_commission_rate	-- IT021
														,@PriceID						-- IT106
			
           goto_account_error:
		   if @w_return                                    <> 0
		   begin
			  rollback tran val
			  select @w_application                         = 'COMMON'
			  select @w_error                               = 'E'
			  select @w_msg_id                              = '00000051'
			  select @w_return                              = 1
			  select @w_descp_add                           = ' (Insert Account) '

			  exec usp_contract_error_ins 'RENEWAL',
										  @p_contract_nbr,
										  @w_account_number,
										  @w_application,
										  @w_error,
										  @w_msg_id,
										  @w_descp_add
			  goto goto_select
		   end

			insert into	lp_account..account_meters
			select		account_id, meter_number
			from		account_meters with (nolock)
			where		account_id = @w_account_id

			delete from	account_meters
			where		account_id = @w_account_id

		   update deal_contract_account set status = 'SENT'
		   from deal_contract_account with (NOLOCK)
		   where contract_nbr                               = @p_contract_nbr
		   and   account_number                             = @t_account_number

--			set usage_req_status to pending to prepare for updated usage
			update	lp_account..account
			set		usage_req_status	= 'Pending'
			where	account_id			= @w_account_id

		   -- delete account from queue since they are renewing
		   delete from lp_account..account_auto_renewal_queue where account_id = @w_account_id

		   commit tran val

		   set rowcount 1

		   select @w_account_id                             = account_id,
				  @w_account_number                         = account_number,
				  @w_contract_type                          = contract_type,
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
				  @w_renew									= renew,
					@PriceID								= PriceID -- IT106
		   from deal_contract_account with (NOLOCK)
		   where contract_nbr                               = @p_contract_nbr
		   and   account_number                             > @t_account_number
		   and  (status                                     = ' '
		   or	 status                                        = 'DRAFT'
		   or    status                                     = 'RUNNING')
		   and	  renew											= 1

		   select @w_rowcount                               = @@rowcount

			select @w_entity_id                                 = entity_id,
				   @w_por_option                                = por_option,
				   @w_billing_type                              = billing_type
			from lp_common..common_utility b with (NOLOCK)
			where utility_id                                    = @w_utility_id
end

set rowcount 0

begin tran cont


if exists(select contract_nbr
          from lp_enrollment..check_account with (NOLOCK)
          where contract_nbr                        = @p_contract_nbr
          and   check_type                          IN ('TPV','DOCUMENTS'))
begin
   goto goto_sent
end                      

select top 1
       @w_check_type                                = case when b.check_type is null then 'USAGE ACQUIRE' else b.check_type end
from deal_contract a with (NOLOCK),
     lp_common..common_utility_check_type b with (NOLOCK)
where a.contract_nbr                                = @p_contract_nbr
and   a.utility_id                                  = b.utility_id
and   a.contract_type                               = b.contract_type
and   b.[order]                                     > 1   
order by [order]                                   

if @@rowcount                                      <> 0
	begin
	   if exists(select contract_nbr
				 from lp_enrollment..check_account with (NOLOCK)
				 where contract_nbr                     = @p_contract_nbr
				 and   check_type                       = @w_check_type)
	   begin
		  goto goto_sent
	   end
	end
else
	begin
		select top 1
			   @w_check_type                                = case when b.check_type is null then 'USAGE ACQUIRE' else b.check_type end
		from deal_contract_account a with (NOLOCK),
			 lp_common..common_utility_check_type b with (NOLOCK)
		where a.contract_nbr                                = @p_contract_nbr
		and   a.utility_id                                  = b.utility_id
		and   a.contract_type                               = b.contract_type
		and   b.[order]                                     > 1  
		order by [order]

		if @@rowcount                                      <> 0
			begin
			   if exists(select contract_nbr
						 from lp_enrollment..check_account with (NOLOCK)
						 where contract_nbr                     = @p_contract_nbr
						 and   check_type                       = @w_check_type)
			   begin
				  goto goto_sent
			   end
			end  
	end

if @w_check_type                                    = 'PROFITABILITY'
begin

-- PROFITABILITY

   declare @w_request_datetime                     varchar(20)

   declare @w_header_enrollment_1                  varchar(08)
   declare @w_header_enrollment_2                  varchar(08)

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
             'RENEWAL BATCH LOAD',
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

         exec usp_contract_error_ins 'RENEWAL',
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

      exec usp_contract_error_ins 'RENEWAL',
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
                                                         @w_check_type,
                                                         'RENEWAL',
                                                         'PENDING',
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

   if @w_return                                    <> 0
   begin
      rollback tran cont
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = ' (Insert Check Profitability) '

      exec usp_contract_error_ins 'RENEWAL',
                                  @p_contract_nbr,
                                  @w_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add

      goto goto_select
   end

end
else
begin

   select @w_return                                 = 1

   exec @w_return = lp_enrollment..usp_check_account_ins @p_username,
                                                         @p_contract_nbr,
                                                         ' ',
                                                         @w_check_type,
                                                         'RENEWAL',
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

      exec usp_contract_error_ins 'RENEWAL',
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

