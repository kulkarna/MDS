USE [lp_contract_renewal]
GO
/****** Object:  StoredProcedure [dbo].[usp_contract_submit_transfer_ins]    Script Date: 04/27/2012 09:55:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--exec usp_contract_submit_ins 'libertypower\dmarino', 'Contracto A1'
--exec usp_contract_submit_ins @p_username=N'LIBERTYPOWER\dmarino',@p_contract_nbr=N'0104483'

-- ===============================================================
-- Modified José Muñoz 01/20/2011
-- Account/ Customer Name should be trimmed when inserting into the Table....  
-- Ticket 20906
-- =============================================
-- Modified José Muñoz 06/10/2011
-- Added new table deal_account_address into the query
-- Added new table deal_account_contact into the query
-- Ticket 23125
-- =============================================
-- Modified Isabelle Tamanini 4/27/2012
-- Adding logic to make contract go through check and approval
-- SR1-4112671
-- =============================================

ALTER procedure [dbo].[usp_contract_submit_transfer_ins]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_enrollment_type									int,
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

select @w_getdate                                   = date_submit
from deal_contract with (NOLOCK)
where contract_nbr                                  = @p_contract_nbr
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
declare @w_date_por_enrollment                      datetime
declare @w_date_deenrollment                        datetime
declare @w_date_reenrollment                        datetime
declare @w_tax_status                               varchar(20)
declare @w_tax_float                                int
declare @w_credit_score                             real
declare @w_credit_agency                            varchar(30)
declare @w_por_option                               varchar(03)
declare @w_billing_type                             varchar(15)
declare @w_risk_request_id                          varchar(50)
declare @w_renew									tinyint
declare	@w_account_type								varchar(50)
declare @w_check_type                               char(15)

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
select @w_date_deenrollment                         = '19000101'
select @w_date_reenrollment                         = '19000101'
select @w_tax_status                                = 'FULL'
select @w_tax_float                                 = 0
select @w_credit_score                              = 0
select @w_credit_agency                             = 'NONE'
select @w_por_option                                = 'NO'
select @w_renew										= 1

select @w_status                                    = ''
select @w_sub_status                                = ''
select @w_entity_id                                 = ''
select @w_check_type								= ''


-- delete any accounts from tables that are not transfering
delete
from	deal_contract_account
where	contract_nbr	= @p_contract_nbr
and		renew			= 0


declare @t_account_number                           varchar(30)
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

--SR1-4112671
select top 1 @w_status = case when wait_status is null then '01000' else wait_status end, 
		@w_sub_status = case when wait_sub_status is null then '10' else wait_sub_status end,
		@w_check_type = case when check_type is null then 'USAGE ACQUIRE' else check_type end
from	lp_common..common_utility_check_type
where	utility_id									= @w_utility_id
and		contract_type								= @w_contract_type
and     check_type <> 'CHECK ACCOUNT'
order by [order]
--IF @w_por_option = 'NO'
--    BEGIN
--        SET @w_status = '05000'
--        SET @w_sub_status = '10'
--    END
--ELSE
--    BEGIN
--        SET @w_status = '06000'
--        SET @w_sub_status = '10'
--    END

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
				   @w_annual_usage								= annual_usage
			from deal_contract_account with (NOLOCK)
			where contract_nbr                                  = @p_contract_nbr
			and   account_number                                = @t_account_number
			and	  renew											= 1

		   begin tran val

		   select @w_descp_add                              = ' '

-- additional info  ------------------------------------------------------------------------
		   select @w_return                                 = 0

		if exists ( select null from lp_account..account_additional_info where account_id = @w_account_id)
			begin
				update	lp_account..account
				set		enrollment_type = @p_enrollment_type, chgstamp = chgstamp + 1
					where	account_id = @w_account_id
			end
		--else
		--	begin 
		--	   exec @w_return = lp_account..usp_account_additional_info_ins 
		--			select	@p_username, @w_account_id, '', '', '', '', '', '', 
		--					'', '', '', '', '', '', '', '', '', @p_enrollment_type
		--	end


		   if @w_return										<> 0
			or @@error										<> 0
		   begin
			  rollback tran val
			  select @w_application                         = 'COMMON'
			  select @w_error                               = 'E'
			  select @w_msg_id                              = '00000051'
			  select @w_return                              = 1
			  select @w_descp_add                           = ' (Insert Account Additional Info) '

			  exec usp_contract_error_ins 'TRANSER',
										  @p_contract_nbr,
										  @w_account_number,
										  @w_application,
										  @w_error,
										  @w_msg_id,
										  @w_descp_add
			  goto goto_select
		   end

-- account name  ------------------------------------------------------------------------
		   if not exists(select account_id
						 from lp_account..account_name with (NOLOCK)
						 where account_id                   = @w_account_id
						 and   name_link                    = @w_account_name_link)
		   begin

			  insert into lp_account..account_name
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

				 exec usp_contract_error_ins 'TRANSFER',
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
			  insert into lp_account..account_name
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

				 exec usp_contract_error_ins 'TRANSFER',
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

			  insert into lp_account..account_name
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

				 exec usp_contract_error_ins 'TRANSFER',
											 @p_contract_nbr,
											 @w_account_number,
											 @w_application,
											 @w_error,
											 @w_msg_id,
											 @w_descp_add
				 goto goto_select
			  end
		   end

-- account address  ------------------------------------------------------------------------
		   if not exists(select account_id
						 from lp_account..account_address with (NOLOCK)
						 where account_id                   = @w_account_id
						 and   address_link                 = @w_customer_address_link)
		   begin
			  insert into lp_account..account_address
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

				 exec usp_contract_error_ins 'TRANSFER',
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
			  insert into lp_account..account_address
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

				 exec usp_contract_error_ins 'TRANSFER',
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
			  insert into lp_account..account_address
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

				 exec usp_contract_error_ins 'TRANSFER',
											 @p_contract_nbr,
											 @w_account_number,
											 @w_application,
											 @w_error,
											 @w_msg_id,
											 @w_descp_add
				 goto goto_select
			  end
		   end

-- account contact  ------------------------------------------------------------------------
		   if not exists(select account_id
						 from lp_account..account_contact with (NOLOCK)
						 where account_id                   = @w_account_id
						 and   contact_link                 = @w_customer_contact_link)
		   begin

			  insert into lp_account..account_contact
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

				 exec usp_contract_error_ins 'TRANSFER',
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

			  insert into lp_account..account_contact
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

				 exec usp_contract_error_ins 'TRANSFER',
											 @p_contract_nbr,
											 @w_account_number,
											 @w_application,
											 @w_error,
											 @w_msg_id,
											 @w_descp_add
				 goto goto_select
			  end
		   end  


		   select @w_return                                 = 1

		   exec @w_return = lp_account..usp_account_status_history_ins @w_username,
																	   @w_account_id,
																	   @w_status,
																	   @w_sub_status,
																	   @w_getdate,
																	   'TRANSFER',
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

			  exec usp_contract_error_ins 'TRANSFER',
										  @p_contract_nbr,
										  @w_account_number,
										  @w_application,
										  @w_error,
										  @w_msg_id,
										  @w_descp_add

			  goto goto_select
		   end
		   
		   --SR1-4112671
		   select @w_return                           = 1

		   exec @w_return = lp_enrollment..usp_check_account_ins @p_username,
															     @p_contract_nbr,
															     ' ',
															     @w_check_type,
															     'ESIID TRANSFER',
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
			  select @w_descp_add                     = ' (Insert Transfer) '

			  exec usp_contract_error_ins 'RENEWAL',
										  @p_contract_nbr,
										  @w_account_number,
										  @w_application,
									   	  @w_error,
										  @w_msg_id,
										  @w_descp_add
 
			  goto goto_select
		   end
/*
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

					exec usp_contract_error_ins 'TRANSFER',
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
																	   'TPV',
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
*/
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
			else
				begin
					select	@w_date_flow_start	= date_flow_start
					from	lp_account..account
					where	account_id			= @w_account_id
					if @w_date_flow_start is null
						begin
							set @w_date_flow_start = '19000101'
						end
				end

		   exec	@w_return = lp_common..usp_product_account_type_sel @w_product_id, @w_account_type OUTPUT

		   if @w_return                                    <> 0
		   begin
			  rollback tran val
			  select @w_application                         = 'COMMON'
			  select @w_error                               = 'E'
			  select @w_msg_id                              = '00000051'
			  select @w_return                              = 1
			  select @w_descp_add                           = ' (Insert Account) '

			  exec usp_contract_error_ins 'TRANSFER',
										  @p_contract_nbr,
										  @w_account_number,
										  @w_application,
										  @w_error,
										  @w_msg_id,
										  @w_descp_add
			  goto goto_select
		   end

-- account  ---------------------------------------------------------------------------------------
			UPDATE	lp_account..account
			SET		account_type = @w_account_type, status = @w_status, sub_status = @w_sub_status,entity_id = @w_entity_id, 
					contract_nbr = @p_contract_nbr, contract_type = @w_contract_type, retail_mkt_id = @w_retail_mkt_id, 
					utility_id = @w_utility_id, product_id = @w_product_id, rate_id = @w_rate_id, rate = @w_rate, 
					account_name_link = @w_account_name_link, customer_name_link = @w_customer_name_link, customer_address_link = @w_customer_address_link, 
					customer_contact_link = @w_customer_contact_link, billing_address_link = @w_billing_address_link, billing_contact_link = @w_billing_contact_link, 
					owner_name_link = @w_owner_name_link, service_address_link = @w_service_address_link, business_type = @w_business_type, 
					business_activity = @w_business_activity, additional_id_nbr_type = @w_additional_id_nbr_type, additional_id_nbr = @w_additional_id_nbr, 
					contract_eff_start_date = @w_contract_eff_start_date, term_months = @w_term_months, date_end = @w_date_end, date_deal = @w_date_deal, 
					date_created = @w_date_created, date_submit = @w_date_submit, sales_channel_role = @w_sales_channel_role, username = @p_username, 
					sales_rep = @w_sales_rep, origin = @w_origin, por_option = @w_por_option, billing_type = @w_billing_type,
					credit_score = 0, credit_agency = 'NONE', annual_usage = 0, usage_req_status = 'PENDING'
			WHERE	account_id = @w_account_id


		   if @@error                                    <> 0
		   begin
			  rollback tran val
			  select @w_application                         = 'COMMON'
			  select @w_error                               = 'E'
			  select @w_msg_id                              = '00000051'
			  select @w_return                              = 1
			  select @w_descp_add                           = ' (Insert Account) '

			  exec usp_contract_error_ins 'TRANSFER',
										  @p_contract_nbr,
										  @w_account_number,
										  @w_application,
										  @w_error,
										  @w_msg_id,
										  @w_descp_add
			  goto goto_select
		   end

		if exists (select meter_number from account_meters where account_id = @w_account_id)
			begin
					delete from	lp_account..account_meters
					where		account_id = @w_account_id

					insert into	lp_account..account_meters
					select		account_id, meter_number
					from		account_meters with (nolock)
					where		account_id = @w_account_id

					delete from	account_meters
					where		account_id = @w_account_id
			end

		   update deal_contract_account set status = 'SENT'
		   from deal_contract_account with (NOLOCK)
		   where contract_nbr                               = @p_contract_nbr
		   and   account_number                             = @t_account_number

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
				  @w_renew									= renew
		   from deal_contract_account with (NOLOCK)
		   where contract_nbr                               = @p_contract_nbr
		   and   account_number                             > @t_account_number
		   and  (status                                     = ' '
		   or	 status                                        = 'DRAFT'
		   or    status                                     = 'RUNNING')
		   and	  renew											= 1

		   select @w_rowcount                               = @@rowcount
end

set rowcount 0

begin tran cont
                

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

