
--exec usp_contract_sel 'LAPTOPSALMEIRAO\Marcio Salmeirao', '2006-0000320', 'CONTRACT'

-- ============================================
-- Modified Gail Mangaroo 1/25/2008
-- Added contract_rate_type	feild to select
-- ============================================
-- Modify		: Jose Munoz
-- Date			: 02/18/2010
-- Description	: Add SSNClear, SSNEncrypted columns to SELECT.
-- Ticket		: IT002
-- =============================================
-- =============================================
-- Modified: George Worthington 4/30/2010
-- added Sales Channel Settings overrided fields
-- Project IT021
-- =============================================
-- Modified: Lev Rosenblum at 10/10/2012
-- added TaxExempt in output
-- PBI1007(MD084)
-- =============================================

CREATE procedure [dbo].[usp_contract_sel]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30) = ' ')
as

declare @w_contract_nbr                             varchar(12)
declare @w_account_number                           varchar(30)
declare @w_account_type                             int
declare @w_status                                   varchar(15)
declare @w_account_id                               varchar(12)
declare @w_retail_mkt_id                            varchar(15)
declare @w_utility_id                               varchar(15)
declare @w_product_id                               varchar(20)
declare @w_rate_id                                  int
declare @w_rate                                     float

declare @w_account_name_link                        int
declare @w_account_name                             varchar(100)
 
declare @w_customer_name_link                       int
declare @w_customer_name                            varchar(100)

declare @w_customer_address_link                    int
declare @w_customer_address                         varchar(50)
declare @w_customer_suite                           varchar(10)
declare @w_customer_city                            varchar(28)
declare @w_customer_state                           varchar(02)
declare @w_customer_zip                             varchar(10)

declare @w_customer_contact_link                    int
declare @w_customer_first_name                      varchar(50)
declare @w_customer_last_name                       varchar(50)
declare @w_customer_title                           varchar(20)
declare @w_customer_phone                           varchar(20)
declare @w_customer_fax                             varchar(20)
declare @w_customer_email                           nvarchar(256)
declare @w_customer_birthday                        char(05)

declare @w_billing_address_link                     int
declare @w_billing_address                          varchar(50)
declare @w_billing_suite                            varchar(10)
declare @w_billing_city                             varchar(28)
declare @w_billing_state                            varchar(02)
declare @w_billing_zip                              varchar(10)

declare @w_billing_contact_link                     int
declare @w_billing_first_name                       varchar(50)
declare @w_billing_last_name                        varchar(50)
declare @w_billing_title                            varchar(20)
declare @w_billing_phone                            varchar(20)
declare @w_billing_fax                              varchar(20)
declare @w_billing_email                            nvarchar(256)
declare @w_billing_birthday                         varchar(05)

declare @w_owner_name_link                          int
declare @w_owner_name                               varchar(100)

declare @w_service_address_link                     int
declare @w_service_address                          varchar(50)
declare @w_service_suite                            varchar(10)
declare @w_service_city                             varchar(28)
declare @w_service_state                            varchar(02)
declare @w_service_zip                              varchar(10)

declare @w_business_type                            varchar(35)
declare @w_business_activity                        varchar(35)
declare @w_additional_id_nbr_type                   varchar(10)
declare @w_additional_id_nbr                        varchar(30)
declare @w_contract_eff_start_date                  datetime

declare @w_enrollment_type							int
declare @w_term_months                              int
declare @w_date_end                                 datetime
declare @w_date_deal                                datetime
declare @w_date_created                             datetime
declare @w_sales_rep                                varchar(100)
declare @w_username                                 nchar(100)
declare @w_sales_channel_role                       nvarchar(50)
declare @w_origin                                   varchar(50)
declare @w_date_submit                              datetime
declare @w_chgstamp                                 smallint

declare @w_contract_rate_type							varchar(50)


declare @w_requested_flow_start_date                datetime
declare @w_deal_type                                char(20)

declare @w_customer_code                            char(05)
declare @w_customer_group                           char(100)

declare @w_ssnClear                                 nvarchar(100) -- IT002
declare @w_ssnEncrypted                             nvarchar(512) -- IT002


declare @w_sales_mgr								varchar(100)	-- IT021
declare @w_evergreen_option_id						int				-- IT021
declare @w_evergreen_commission_end					datetime		-- IT021
declare @w_evergreen_commission_rate				float			-- IT021
declare @w_residual_option_id						int				-- IT021 
declare @w_residual_commission_end					datetime		-- IT021
declare @w_initial_pymt_option_id					int				-- IT021 

declare @w_header_enrollment_1						varchar(8)
declare @w_header_enrollment_2						varchar(8)

declare @w_contract_type							varchar(20)

declare	@ProductBrandID								int,
		@PriceID									int,
		@PriceTier									int,
		@TaxExempt									int

if @p_account_number                                = 'CONTRACT'
begin
   select @w_header_enrollment_1 = header_enrollment_1,
      	  @w_header_enrollment_2 = header_enrollment_2
      	  from deal_config
      	  
   select @w_status                                 = status,
          @w_retail_mkt_id                          = retail_mkt_id,
          @w_utility_id                             = c.utility_id,
		  @w_account_type							= isnull(account_type,p.account_type_id),
          @w_product_id                             = c.product_id,
          @w_rate_id                                = rate_id,
          @w_rate                                   = rate,
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
		  @w_enrollment_type						= enrollment_type,
          @w_term_months                            = c.term_months,
          @w_date_end                               = date_end,
          @w_date_deal                              = date_deal,
          @w_date_created                           = c.date_created,
          @w_date_submit                            = date_submit,
          @w_sales_channel_role                     = ltrim(rtrim(sales_channel_role)),
          @w_username                               = c.username,
          @w_sales_rep                              = sales_rep,
          @w_origin                                 = origin,
          @w_chgstamp                               = c.chgstamp,
		  @w_contract_rate_type                     = contract_rate_type,
          @w_requested_flow_start_date              = isnull(requested_flow_start_date, '19000101'),
          @w_deal_type                              = isnull(deal_type, ''),
          @w_customer_code                          = isnull(customer_code, ''),
          @w_customer_group                         = isnull(customer_group, ''),
          @w_ssnEncrypted							= isnull(SSNEncrypted,''),
          @w_ssnClear								= isnull(SSNClear,'')
			, @w_sales_mgr							= sales_manager
			, @w_evergreen_option_id				= evergreen_option_id
			, @w_evergreen_commission_rate			= evergreen_commission_rate
			, @w_evergreen_commission_end			= evergreen_commission_end
			, @w_residual_option_id					= residual_option_id
			, @w_residual_commission_end			= residual_commission_end
			, @w_initial_pymt_option_id				= initial_pymt_option_id
			, @w_contract_type						= contract_type	
			,@PriceID		= c.PriceID
			,@PriceTier		= c.PriceTier
			, @TaxExempt= c.TaxStatus
   from deal_contract c with (NOLOCK INDEX = deal_contract_idx)
   left join lp_common..common_product p 
   on c.product_id                                  = p.product_id
   where contract_nbr                               = @p_contract_nbr

end
else
begin
   select @w_status                                 = b.status,
          @w_account_id                             = a.account_id,
          @w_retail_mkt_id                          = a.retail_mkt_id,
          @w_utility_id                             = a.utility_id,
		  @w_account_type							= isnull(a.account_type,p.account_type_id),
          @w_product_id                             = a.product_id,
          @w_rate_id                                = a.rate_id,
          @w_rate                                   = a.rate,
          @w_account_name_link                      = a.account_name_link,
          @w_customer_name_link                     = a.customer_name_link,
          @w_customer_address_link                  = a.customer_address_link,
          @w_customer_contact_link                  = a.customer_contact_link,
          @w_billing_address_link                   = a.billing_address_link,
          @w_billing_contact_link                   = a.billing_contact_link,
          @w_owner_name_link                        = a.owner_name_link,
          @w_service_address_link                   = a.service_address_link,
          @w_business_type                          = a.business_type,
          @w_business_activity                      = a.business_activity,
          @w_additional_id_nbr_type                 = a.additional_id_nbr_type,
          @w_additional_id_nbr                      = a.additional_id_nbr,
          @w_contract_eff_start_date                = a.contract_eff_start_date,
		  @w_enrollment_type						= a.enrollment_type,
          @w_term_months                            = a.term_months,
          @w_date_end                               = a.date_end,
          @w_date_deal                              = a.date_deal,
          @w_date_created                           = a.date_created,
          @w_date_submit                            = a.date_submit,
          @w_sales_channel_role                     = ltrim(rtrim(a.sales_channel_role)),
          @w_username                               = a.username,
          @w_sales_rep                              = a.sales_rep,
          @w_origin                                 = a.origin,
          @w_chgstamp                               = a.chgstamp,
		  @w_contract_rate_type						= b.contract_rate_type,
          @w_requested_flow_start_date              = isnull(a.requested_flow_start_date, '19000101'),
          @w_deal_type                              = isnull(a.deal_type, ''),
          @w_customer_group                         = isnull(a.customer_group, ''),
          @w_ssnEncrypted							= isnull(a.SSNEncrypted,''),
          @w_ssnClear								= isnull(a.SSNClear,'')
			, @w_sales_mgr							=	b.sales_manager
			, @w_evergreen_option_id				= b.evergreen_option_id
			, @w_evergreen_commission_rate			= b.evergreen_commission_rate
			, @w_evergreen_commission_end			= b.evergreen_commission_end
			, @w_residual_option_id					= b.residual_option_id
			, @w_residual_commission_end			= b.residual_commission_end
			, @w_initial_pymt_option_id				= b.initial_pymt_option_id
			, @PriceID		= a.PriceID
			, @TaxExempt    = a.TaxStatus
   from deal_contract_account a with (NOLOCK)
   join deal_contract b with (NOLOCK) 
   on a.contract_nbr                                = b.contract_nbr
   left join lp_common..common_product p 
   on a.product_id                                  = p.product_id
   where a.contract_nbr                             = @p_contract_nbr
   and   a.account_number                           = @p_account_number

end

-- begin IT106
if @PriceID is not null
	begin
		select	@ProductBrandID = ProductBrandID
		from	Libertypower..Price (nolock)
		where	ID = @PriceID
	end



select @w_contract_nbr                              = ''
select @w_account_number                            = ''
select @w_account_name                              = ''
select @w_customer_name                             = ''
select @w_customer_address                          = ''
select @w_customer_suite                            = ''
select @w_customer_city                             = ''
select @w_customer_state                            = 'NN'
select @w_customer_zip                              = ''
select @w_customer_first_name                       = ''
select @w_customer_last_name                        = ''
select @w_customer_title                            = ''
select @w_customer_phone                            = ''
select @w_customer_fax                              = ''
select @w_customer_email                            = ''
select @w_customer_birthday                         = 'NONE'
select @w_billing_first_name                        = ''
select @w_billing_last_name                         = ''
select @w_billing_title                             = ''
select @w_billing_phone                             = ''
select @w_billing_fax                               = ''
select @w_billing_email                             = ''
select @w_billing_birthday                          = 'NONE'
select @w_billing_address                           = ''
select @w_billing_suite                             = ''
select @w_billing_city                              = ''
select @w_billing_state                             = 'NN'
select @w_billing_zip                               = ''
select @w_owner_name                                = ''
select @w_service_address                           = ''
select @w_service_suite                             = ''
select @w_service_city                              = ''
select @w_service_state                             = 'NN'
select @w_service_zip                               = ''

declare @w_user_id                                  int

select @w_user_id                                   = UserID
from lp_portal..Users with (NOLOCK INDEX = IX_Users)
where Username                                      = @p_username

if  lp_common.dbo.ufn_is_liberty_employee(@p_username) = 0
and not exists(select b.RoleName 
               from lp_portal..UserRoles a with (NOLOCK INDEX = IX_UserRoles),
               lp_portal..Roles b with (NOLOCK INDEX = IX_RoleName)
               where a.UserID                       = @w_user_id
               and   a.RoleID                       = b.RoleID
               and   b.RoleName                     = ltrim(rtrim(@w_sales_channel_role)))
and ltrim(rtrim(@w_sales_channel_role))            <> 'NONE'
begin 
   select @w_status                                 = ''
   select @w_account_id                             = ''
   select @w_retail_mkt_id                          = ''
   select @w_utility_id                             = ''
   select @w_product_id                             = ''
   select @w_rate_id                                = 0
   select @w_rate                                   = 0
   select @w_customer_name_link                     = 0
   select @w_customer_address_link                  = 0
   select @w_customer_contact_link                  = 0
   select @w_billing_address_link                   = 0
   select @w_billing_contact_link                   = 0
   select @w_owner_name_link                        = 0
   select @w_service_address_link                   = 0
   select @w_business_type                          = ''
   select @w_business_activity                      = ''
   select @w_additional_id_nbr_type                 = ''
   select @w_additional_id_nbr                      = ''
   select @w_contract_eff_start_date                = '19000101'
   select @w_term_months                            = 0
   select @w_date_end                               = '19000101'
   select @w_date_deal                              = '19000101'
   select @w_date_created                           = '19000101'
   select @w_date_submit                            = '19000101'
   select @w_sales_channel_role                     = ''
   select @w_username                               = ''
   select @w_sales_rep                              = ''
   select @w_origin                                 = ''
   select @w_chgstamp                               = 0
   select @w_contract_rate_type						= ''
   select @w_requested_flow_start_date              =  '19000101'
   select @w_deal_type                              = ''
   select @w_customer_code                          = ''
   select @w_ssnEncrypted							= ''
   select @w_ssnClear								= ''
   select @w_sales_mgr							= null
	select @w_evergreen_option_id				= null
	select @w_evergreen_commission_end			= null
	select @w_evergreen_commission_rate			= null
	select @w_residual_option_id				= null
	select @w_residual_commission_end			= null
	select @w_initial_pymt_option_id			= null

   goto goto_select
end

select @w_contract_nbr                              = @p_contract_nbr
select @w_account_number                            = @p_account_number

if @w_account_name_link <> 0
begin
   select @w_account_name                           = full_name
   from deal_name with (NOLOCK INDEX = deal_name_idx)
   where contract_nbr                               = @p_contract_nbr
   and   name_link                                  = @w_account_name_link
end

if @w_customer_name_link <> 0
begin

   select @w_customer_name                          = full_name
   from deal_name with (NOLOCK INDEX = deal_name_idx)
   where contract_nbr                               = @p_contract_nbr
   and   name_link                                  = @w_customer_name_link
end

if @w_customer_address_link <> 0
begin

   select @w_customer_address                       = address,
          @w_customer_suite                         = suite,
          @w_customer_city                          = city,
          @w_customer_state                         = state,
          @w_customer_zip                           = zip
   from deal_address with (NOLOCK INDEX = deal_address_idx)
   where contract_nbr                               = @p_contract_nbr
   and   address_link                               = @w_customer_address_link
end

if @w_customer_contact_link <> 0
begin
   select @w_customer_first_name                    = first_name,
          @w_customer_last_name                     = last_name,
          @w_customer_title                         = title,
          @w_customer_phone                         = phone,
          @w_customer_fax                           = fax,
          @w_customer_email                         = email,
          @w_customer_birthday                      = birthday
   from deal_contact with (NOLOCK INDEX = deal_contact_idx)
   where contract_nbr                               = @p_contract_nbr
   and   contact_link                               = @w_customer_contact_link
end

if @w_billing_contact_link <> 0
begin

   select @w_billing_first_name                     = first_name,
          @w_billing_last_name                      = last_name,
          @w_billing_title                          = title,
          @w_billing_phone                          = phone,
          @w_billing_fax                            = fax,
          @w_billing_email                          = email,
          @w_billing_birthday                       = birthday
   from deal_contact with (NOLOCK INDEX = deal_contact_idx)
   where contract_nbr                               = @p_contract_nbr
   and   contact_link                               = @w_billing_contact_link
end

if @w_billing_address_link <> 0
begin
   select @w_billing_address                        = address,
          @w_billing_suite                          = suite,
          @w_billing_city                           = city,
          @w_billing_state                          = state,
          @w_billing_zip                            = zip
   from deal_address with (NOLOCK INDEX = deal_address_idx)
   where contract_nbr                               = @p_contract_nbr
   and   address_link                               = @w_billing_address_link
end

if @w_owner_name_link <> 0
begin
   select @w_owner_name = full_name
   from deal_name with (NOLOCK INDEX = deal_name_idx)
   where contract_nbr = @p_contract_nbr and name_link = @w_owner_name_link
end

if @w_service_address_link <> 0
begin

   select @w_service_address                        = address,
          @w_service_suite                          = suite,
          @w_service_city                           = city,
          @w_service_state                          = state,
          @w_service_zip                            = zip
   from deal_address with (NOLOCK INDEX = deal_address_idx)
   where contract_nbr = @p_contract_nbr and address_link = @w_service_address_link
end

goto_select:

select contract_nbr                                 = isnull(@w_contract_nbr, ''),
       account_number                               = isnull(@w_account_number, ''),
       account_type                                 = @w_account_type,
       status                                       = isnull(@w_status, ''),
       account_id                                   = isnull(@w_account_id, ''),
       retail_mkt_id                                = isnull(rtrim(ltrim(@w_retail_mkt_id)), ''),
       utility_id                                   = isnull(rtrim(ltrim(@w_utility_id)), ''),
       product_id                                   = isnull(rtrim(ltrim(@w_product_id)), ''),
       rate_id                                      = isnull(@w_rate_id, 0),
       rate                                         = isnull(@w_rate, ''),
       customer_name_link                           = isnull(@w_customer_name_link, 0),
       customer_name                                = isnull(@w_customer_name, ''),
       customer_address_link                        = isnull(@w_customer_address_link, 0),
       customer_address                             = isnull(@w_customer_address, ''),
       customer_suite                               = isnull(@w_customer_suite, ''),
       customer_city                                = isnull(@w_customer_city, ''),
       customer_state                               = isnull(@w_customer_state, ''),
       customer_zip                                 = isnull(@w_customer_zip, ''),
       customer_contact_link                        = isnull(@w_customer_contact_link, 0),
       customer_first_name                          = isnull(@w_customer_first_name, ''),
       customer_last_name                           = isnull(@w_customer_last_name, ''),
       customer_title                               = isnull(@w_customer_title, ''),
       customer_phone                               = isnull(@w_customer_phone, ''),
       customer_fax                                 = isnull(@w_customer_fax, ''),
       customer_email                               = isnull(@w_customer_email, ''),
       customer_birthday                            = isnull(ltrim(rtrim(@w_customer_birthday)), ''),
       billing_address_link                         = isnull(@w_billing_address_link, 0),
       billing_address                              = isnull(@w_billing_address, ''),
       billing_suite                                = isnull(@w_billing_suite, ''),
       billing_city                                 = isnull(@w_billing_city, ''),
       billing_state                                = isnull(@w_billing_state, ''),
       billing_zip                                  = isnull(@w_billing_zip, ''),
       billing_contact_link                         = isnull(@w_billing_contact_link, 0),
       billing_first_name                           = isnull(@w_billing_first_name, ''),
       billing_last_name                            = isnull(@w_billing_last_name, ''),
       billing_title                                = isnull(@w_billing_title, ''),
       billing_phone                                = isnull(@w_billing_phone, ''),
       billing_fax                                  = isnull(@w_billing_fax, ''),
       billing_email                                = isnull(@w_billing_email, ''),
       billing_birthday                             = isnull(ltrim(rtrim(@w_billing_birthday)), ''),
       owner_name_link                              = isnull(@w_owner_name_link, ''),
       owner_name                                   = isnull(@w_owner_name, ''),
       service_address_link                         = isnull(@w_service_address_link, 0),
       service_address                              = isnull(@w_service_address, ''),
       service_suite                                = isnull(@w_service_suite, ''),
       service_city                                 = isnull(@w_service_city, ''),
       service_state                                = isnull(@w_service_state, ''),
       service_zip                                  = isnull(@w_service_zip, ''),
       business_type                                = isnull(@w_business_type, ''),
       business_activity                            = isnull(@w_business_activity, ''),
       additional_id_nbr_type                       = isnull(@w_additional_id_nbr_type, ''),
       additional_id_nbr                            = isnull(@w_additional_id_nbr, ''),
       contract_eff_start_date                      = isnull(@w_contract_eff_start_date, ''),
       enrollment_type   						  	= isnull(@w_enrollment_type, 1),
       term_months                                  = isnull(@w_term_months, 0),
       date_end                                     = isnull(@w_date_end, ''),
       date_deal                                    = isnull(@w_date_deal, ''),
       date_created                                 = isnull(@w_date_created, ''),
       date_submit                                  = isnull(@w_date_submit, ''),
       sales_channel_role                           = isnull(ltrim(rtrim(@w_sales_channel_role)), ''),
       username                                     = isnull(@w_username, ''),
       sales_rep                                    = isnull(@w_sales_rep, ''),
       origin                                       = isnull(@w_origin, ''),
       comment                                      = isnull((select comment from deal_contract_comment where contract_nbr = @p_contract_nbr), ''),
       chgstamp                                     = isnull(@w_chgstamp, ''),
       contract_rate_type                           = isnull(@w_contract_rate_type, ''),
       requested_flow_start_date                    = isnull(@w_requested_flow_start_date, '19000101'),
       deal_type                                    = isnull(@w_deal_type, ''),
       customer_code                                = isnull(@w_customer_code, ''),
       customer_group                               = isnull(@w_customer_group, '') ,
       SSNEncrypted									= isnull(@w_ssnEncrypted, ''),
       SSNClear										= isnull(@w_ssnClear, ''),
       evergreen_option_id							= @w_evergreen_option_id,					
       evergreen_commission_end						= @w_evergreen_commission_end,
       residual_option_id							= @w_residual_option_id,	
       residual_commission_end						= @w_residual_commission_end,
       initial_pymt_option_id						= @w_initial_pymt_option_id,			
       sales_mgr									= @w_sales_mgr, 
	   evergreen_commission_rate					= @w_evergreen_commission_rate,
	   header_enrollment_1							= @w_header_enrollment_1,
	   header_enrollment_2							= @w_header_enrollment_2,
	   contract_type								= @w_contract_type,
	   ProductBrandID								= @ProductBrandID,
	   PriceID										= @PriceID,
	   PriceTier									= @PriceTier,
	   TaxExempt									= @TaxExempt
	   
--- END of procedure [dbo].[usp_contract_sel] -----------------------------------------------------------------

