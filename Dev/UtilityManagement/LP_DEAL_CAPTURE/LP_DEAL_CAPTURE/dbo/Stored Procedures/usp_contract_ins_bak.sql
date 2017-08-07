
--exec usp_contract_ins 'WVILCHEZ', '2006-0000121', 'PRINT--exec usp_contract_ins 'WVILCHEZ', '20060405 - W', 'VOICE'

-- =====================================================
-- Modified 1/25/2008 Gail Mangaroo 
-- added @p_contract_rate_type parameter - indicates whether contract is single/multi or custom rate 
-- =====================================================
-- Modified: Jose Munoz 1/14/2010
-- add HeatIndexSourceID and HeatRate for updates in the tables 
-- deal_contract, deal_contract_account and deal_pricing_detail
-- Project IT037
-- =====================================================
-- =====================================================
-- Modified: George Worthington 4/30/2010
-- added Sales Channel Settings overrided fields
-- Project IT021
-- =====================================================
-- Modified: Isabelle Tamanini 12/16/2011
-- SR1-4955209
-- Date end will be terms + eff start date - 1 day
-- =============================================

CREATE procedure [dbo].[usp_contract_ins_bak]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_contract_nbr_amend                              char(12)		= 0,
 @p_contract_type                                   varchar(30),
 @p_error                                           char(01)		= ' ',
 @p_msg_id                                          char(08)		= ' ',
 @p_descp                                           varchar(250)	= ' ',
 @p_result_ind                                      char(01)		= 'Y',
 @p_contract_rate_type                             varchar(50) = '' 
)
as
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(20)

select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ' '
select @w_return                                    = 0
select @w_descp_add                                 = ' '

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

declare @w_rowcount                                 int

select @p_contract_nbr                              = upper(@p_contract_nbr)

declare @w_user_id                                  int
declare @w_username                                 nchar(100)
declare @w_sales_channel_role                       nvarchar(50)
select @w_sales_channel_role                        = ' '

declare @w_retail_mkt_id                            char(02)
declare @w_utility_id                               char(15)
declare @w_product_id                               char(20)
declare @w_rate_id                                  int
declare @w_rate                                     float
declare @w_date_deal                                datetime
declare @w_date_created                             datetime
declare @w_contract_eff_start_date                  datetime
declare @w_term_months                              int
declare @w_contract_type                            varchar(15)
declare @w_grace_period                             int
declare @w_contract_rate_type						varchar(50)
 
select @w_retail_mkt_id                             = 'NN'
select @w_utility_id                                = 'NONE'
select @w_product_id                                = 'NONE'
select @w_rate_id                                   = 999999999
select @w_rate                                      = 0
select @w_date_deal                                 = getdate()
select @w_date_created                              = @w_date_deal
select @w_contract_eff_start_date                   = dbo.ufn_GetFirstDayNextMonth(GETDATE())
select @w_term_months                               = 0
select @w_username                                  = @p_username
select @w_sales_channel_role                        = ''
select @w_contract_type                             = ''
select @w_grace_period                              = 0
select @w_contract_rate_type						= @p_contract_rate_type


declare @w_status                                   varchar(15)
select @w_status                                    = 'DRAFT'

declare @w_action                                   char(01)
select @w_action                                    = 'U'

if len(rtrim(rtrim(@p_contract_nbr)))               > 12
begin
   select @w_application                            = 'COMMON'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00001014'
   select @w_return                                 = 1
   select @w_descp_add                              = ' (12 is Max)'
   goto goto_select
end

select @p_contract_nbr                              = substring(@p_contract_nbr, 1, 12)

select @w_contract_type                             = contract_type,
       @w_status                                    = status,
       @w_retail_mkt_id                             = retail_mkt_id,
       @w_utility_id                                = utility_id,
       @w_product_id                                = product_id, 
       @w_rate_id                                   = rate_id,
       @w_rate                                      = rate,
       @w_date_created                              = date_created,
       @w_contract_eff_start_date                   = contract_eff_start_date,
       @w_term_months                               = term_months,
       @w_username                                  = username,
       @w_sales_channel_role                        = sales_channel_role,
       @w_grace_period                              = grace_period,
	   @w_contract_rate_type						= case when isnull(contract_rate_type, '') = '' and isnull(@p_contract_rate_type, '') <> '' then @p_contract_rate_type else contract_rate_type end 

from deal_contract with (NOLOCK INDEX = deal_contract_idx)
where contract_nbr                                  = @p_contract_nbr 

select @w_rowcount                                  = @@rowcount

select @w_action                                    = case when @w_rowcount = 0
                                                           then 'I'
                                                           else 'V'
                                                      end

exec @w_return = usp_contract_val @p_username,
                                  @w_action,
                                  'ALL',
                                  @p_contract_nbr,
                                  @p_contract_type,
                                  @w_status,
                                  @w_username,
                                  @w_contract_type,
                                  @w_sales_channel_role,
                                  @w_application output,
                                  @w_error output,
                                  @w_msg_id output 

if @w_return                                       <> 0
begin
   goto goto_select
end

if @w_rowcount                                      = 0
begin
   if @p_contract_type                              = 'PAPER'
   or @p_contract_type								= 'PRE-PRINTED'
   begin
      select @w_retail_mkt_id                       = retail_mkt_id,
             @w_utility_id                          = utility_id,
             @w_product_id                          = product_id, 
             @w_rate_id                             = rate_id,
             @w_rate                                = rate,
             @w_date_created                        = case when @p_contract_type = 'PRE-PRINTED' then getdate() else date_created end,
             @w_contract_eff_start_date             = case when @p_contract_type = 'PRE-PRINTED' then getdate() else contract_eff_start_date end,
             @w_term_months                         = term_months,
             @w_grace_period                        = grace_period,
			 @w_contract_rate_type					= contract_rate_type   --  case when isnull(contract_rate_type, '') = '' and isnull(@p_contract_rate_type, '') <> '' then @p_contract_rate_type else contract_rate_type end 

      from deal_contract_print with (NOLOCK INDEX = deal_contract_print_idx1)
      where contract_nbr                            = @p_contract_nbr 

	if @@rowcount = 0
		begin
			 select @w_error                            = 'E'
			 select @w_msg_id                           = '00000003'
			 select @w_application                      = 'DEAL'
			 select @w_return                           = 1
			 goto goto_select
		end
   end

   declare @w_sales_channel_prefix                  varchar(100)

   select @w_sales_channel_prefix                   = sales_channel_prefix
   from lp_common..common_config with (NOLOCK)

   select @w_user_id                                = UserID
   from lp_portal..Users with (NOLOCK INDEX = IX_Users)
   where Username                                   = @p_username

   select top 1 
          @w_sales_channel_role                      = b.RoleName 
          from lp_portal..UserRoles a with (NOLOCK INDEX = IX_UserRoles),
          lp_portal..Roles b with (NOLOCK INDEX = IX_RoleName)
          where a.UserID                             = @w_user_id
          and   a.RoleID                             = b.RoleID
          and   b.RoleName                        like ltrim(rtrim(@w_sales_channel_prefix)) + '%'


	-- added 11/9/2007 RD
	-- if product is flexible, enter rate of 0,
	-- essentially forcing sales channel to enter contracted rate
	if ( SELECT	is_flexible FROM lp_common..common_product WHERE product_id = @w_product_id ) = 1
		set @w_rate = 0


   insert into deal_contract
   (contract_nbr, contract_type,status, retail_mkt_id,utility_id,account_type,product_id,rate_id,rate,
	customer_name_link, customer_address_link, customer_contact_link, billing_address_link, billing_contact_link,
	owner_name_link, service_address_link, business_type, business_activity, additional_id_nbr_type, additional_id_nbr,	
	contract_eff_start_date, enrollment_type, term_months, date_end, date_deal, date_created,date_submit,
	sales_channel_role,username,sales_rep,origin,grace_period, chgstamp,contract_rate_type, requested_flow_start_date,
	deal_type,customer_code,customer_group
	, SSNClear, SSNEncrypted, CreditScoreEncrypted, HeatIndexSourceID, HeatRate
	,evergreen_option_id,evergreen_commission_end, residual_option_id,
	residual_commission_end, initial_pymt_option_id, sales_manager, evergreen_commission_rate)	
	
   select @p_contract_nbr,
          @p_contract_type,
          'DRAFT',
          @w_retail_mkt_id,
          @w_utility_id,
          null, -- account_type
          @w_product_id,
          @w_rate_id,
          @w_rate,
          0, --Cust_name_link
          0, --cust_address_link
          0, --cust_contact_link 
          0, --bill_address_link
          0, --bill_contact_link
          0, --owner_name_link
          0, -- service_addr_link
          'NONE', --business_type
          'NONE', --business_activity
          'NONE', --additional_id_nbr_tpye
          '', --additional_id_nbr
          @w_contract_eff_start_date,
          0, --enroll_Type
          @w_term_months, 
          dateadd(mm, @w_term_months, dateadd(dd, -1, @w_contract_eff_start_date)), --dateend
          getdate(), --date_deal
          @w_date_created, 
          getdate(), --date submit
          @w_sales_channel_role, 
          @p_username,
          '', --salesrep
          'ONLINE', --origin
          @w_grace_period, 
          0, --changestmp
		  @w_contract_rate_type,
          dbo.ufn_GetFirstDayNextMonth(GETDATE()), --requested flow start dt
          '', --deal_type
          '', --cust_code
          '', --cust group
          NULL,  --SSNClear
          NULL,  --SSNEncrypted
          NULL,   --CreditScoreEncrypted
          0, -- HeatIndexSourceID	-- Project IT037
          0, -- HeatRate			-- Project IT037
          null, --overrideable field: evergreen_option_id
          null, --overrideable field: evergreen_commission_end
          null, --overrideable field: residual_option_id
          null, --overrideable field: residual_commission_end
          null, --overrideable field: initial_pymt_option_id
          null, --overrideable field: sales_manager
          null --overrideable field: evergreen_commission_rate          


   if @@error                                      <> 0
   or @@rowcount                                    = 0
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = '(Contract)'
      goto goto_select
   end

	if @p_contract_type                              = 'AMENDMENT'
	and not exists (	select	null
						from	deal_contract_amend
						where	contract_nbr		= @p_contract_nbr
						and		contract_nbr_amend	= @p_contract_nbr_amend )
		begin
			insert into	deal_contract_amend
			select		@p_contract_nbr, @p_contract_nbr_amend
		end

end

select @w_return                                    = 0

goto_select:

if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output,
                                    @w_application
   select @w_descp                                  = ltrim(rtrim(@w_descp))
                                                    + ' '
                                                    + @w_descp_add 
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
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON



