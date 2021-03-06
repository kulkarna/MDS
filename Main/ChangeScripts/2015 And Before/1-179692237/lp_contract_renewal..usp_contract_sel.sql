USE [lp_contract_renewal]
GO
/****** Object:  StoredProcedure [dbo].[usp_contract_sel]    Script Date: 07/25/2013 13:37:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_contract_sel 'LAPTOPSALMEIRAO\Marcio Salmeirao', '2006-0000320', 'CONTRACT'
-- =============================================
-- Modify		: Jose Munoz
-- Date			: 02/18/2010
-- Description	: Add SSNClear, SSNEncrypted and CreditScoreEncrypted columns to insert.
-- Ticket		: IT002
-- =============================================
-- =============================================
-- Modified: George Worthington 4/30/2010
-- added Sales Channel Settings overrided fields
-- Project IT021
-- =============================================
-- Modified José Muñoz 06/10/2011
-- Added new table deal_account_address into the query
-- Added new table deal_account_contact into the query
-- Ticket 23125
-- =============================================
-- Modify : Thiago Nogueira
-- Date : 7/25/2013 
-- Ticket: 1-179692237
-- Changed PriceID to BIGINT
-- =============================================

ALTER procedure [dbo].[usp_contract_sel]
	(@p_username                                        nchar(100),
	@p_contract_nbr                                    char(12),
	@p_account_number                                  varchar(30) = ' ')
as

SET NOCOUNT ON

declare @w_contract_nbr                             varchar(12)
		,@w_account_number                           varchar(30)
		,@w_account_type                             int
		,@w_status                                   varchar(15)
		,@w_account_id                               varchar(12)
		,@w_retail_mkt_id                            varchar(15)
		,@w_utility_id                               varchar(15)
		,@w_product_id                               varchar(20)
		,@w_rate_id                                  int
		,@w_rate                                     float

		,@w_account_name_link                        int
		,@w_account_name                             varchar(100)
 
		,@w_customer_name_link                       int
		,@w_customer_name                            varchar(100)

		,@w_customer_address_link                    int
		,@w_customer_address                         varchar(50)
		,@w_customer_suite                           varchar(10)
		,@w_customer_city                            varchar(28)
		,@w_customer_state                           varchar(02)
		,@w_customer_zip                             varchar(10)

		,@w_customer_contact_link                    int
		,@w_customer_first_name                      varchar(50)
		,@w_customer_last_name                       varchar(50)
		,@w_customer_title                           varchar(20)
		,@w_customer_phone                           varchar(20)
		,@w_customer_fax                             varchar(20)
		,@w_customer_email                           nvarchar(256)
		,@w_customer_birthday                        char(05)

		,@w_billing_address_link                     int
		,@w_billing_address                          varchar(50)
		,@w_billing_suite                            varchar(10)
		,@w_billing_city                             varchar(28)
		,@w_billing_state                            varchar(02)
		,@w_billing_zip                              varchar(10)

		,@w_billing_contact_link                     int
		,@w_billing_first_name                       varchar(50)
		,@w_billing_last_name                        varchar(50)
		,@w_billing_title                            varchar(20)
		,@w_billing_phone                            varchar(20)
		,@w_billing_fax                              varchar(20)
		,@w_billing_email                            nvarchar(256)
		,@w_billing_birthday                         varchar(05)

		,@w_owner_name_link                          int
		,@w_owner_name                               varchar(100)

		,@w_service_address_link                     int
		,@w_service_address                          varchar(50)
		,@w_service_suite                            varchar(10)
		,@w_service_city                             varchar(28)
		,@w_service_state                            varchar(02)
		,@w_service_zip                              varchar(10)

		,@w_business_type                            varchar(35)
		,@w_business_activity                        varchar(35)
		,@w_additional_id_nbr_type                   varchar(10)
		,@w_additional_id_nbr                        varchar(30)
		,@w_contract_eff_start_date                  datetime
		,@w_term_months                              int
		,@w_date_end                                 datetime
		,@w_date_deal                                datetime
		,@w_date_created                             datetime
		,@w_sales_rep                                varchar(100)
		,@w_username                                 nchar(100)
		,@w_sales_channel_role                       nvarchar(50)
		,@w_origin                                   varchar(50)
		,@w_date_submit                              datetime
		,@w_chgstamp                                 smallint

		,@w_SSNClear									nvarchar	(100) -- IT002
		,@w_SSNEncrypted								nvarchar	(512) -- IT002
		,@w_CreditScoreEncrypted						nvarchar	(512) -- IT002

-- Added for IT021 
		,@w_sales_mgr								varchar(100)
		,@w_evergreen_option_id						int 
		,@w_evergreen_commission_end					datetime
		,@w_evergreen_commission_rate				float
		,@w_residual_option_id						int 
		,@w_residual_commission_end					datetime
		,@w_initial_pymt_option_id					int 


		,@w_renew									tinyint
		,@w_user_id                                  int
		
declare	@ProductBrandID								int,
		@PriceID									bigint,
		@PriceTier									int		

if @p_account_number                                = 'CONTRACT'
begin
   select @w_status                                 = status,
          @w_retail_mkt_id                          = retail_mkt_id,
          @w_utility_id                             = c.utility_id,
		  @w_account_type							= isnull(account_type,p.account_type_id),
          @w_product_id                             = c.product_id,
          @w_rate_id                                = ISNULL(rate_id,0),
          @w_rate                                   = ISNULL(rate,0),
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
          @w_term_months                            = c.term_months,
          @w_date_end                               = date_end,
          @w_date_deal                              = date_deal,
          @w_date_created                           = c.date_created,
          @w_date_submit                            = date_submit,
          @w_sales_channel_role                     = ltrim(rtrim(sales_channel_role)),
          @w_username                               = c.username,
          @w_sales_rep                              = sales_rep,
          @w_origin                                 = origin,
          @w_chgstamp                               = c.chgstamp
          ,@w_SSNClear								= c.SSNClear				-- IT002
		  ,@w_SSNEncrypted							= c.SSNEncrypted			-- IT002
		  ,@w_CreditScoreEncrypted					= c.CreditScoreEncrypted	-- IT002

			, @w_sales_mgr							= sales_manager						-- IT021
			, @w_evergreen_option_id				= evergreen_option_id				-- IT021
			, @w_evergreen_commission_rate			= evergreen_commission_rate			-- IT021
			, @w_evergreen_commission_end			= evergreen_commission_end			-- IT021
			, @w_residual_option_id					= residual_option_id				-- IT021
			, @w_residual_commission_end			= residual_commission_end			-- IT021
			, @w_initial_pymt_option_id				= initial_pymt_option_id    		-- IT021
			,@PriceID		= c.PriceID
			,@PriceTier		= c.PriceTier			
   from deal_contract c with (NOLOCK INDEX = deal_contract_idx)
   left join lp_common..common_product p on c.product_id = p.product_id
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
		  @w_renew									= a.renew
		  ,@w_SSNClear								= a.SSNClear				-- IT002
		  ,@w_SSNEncrypted							= a.SSNEncrypted			-- IT002
		  ,@w_CreditScoreEncrypted					= a.CreditScoreEncrypted	-- IT002
			, @w_sales_mgr							= b.sales_manager				-- IT021
			, @w_evergreen_option_id				= a.evergreen_option_id			-- IT021
			, @w_evergreen_commission_rate			= a.evergreen_commission_rate	-- IT021
			, @w_evergreen_commission_end			= a.evergreen_commission_end	-- IT021
			, @w_residual_option_id					= a.residual_option_id			-- IT021
			, @w_residual_commission_end			= a.residual_commission_end		-- IT021
			, @w_initial_pymt_option_id				= a.initial_pymt_option_id		-- IT021
			,@PriceID		= a.PriceID
			,@PriceTier		= a.PriceTier			
   from deal_contract_account a with (NOLOCK)
   join deal_contract b with (NOLOCK) on a.contract_nbr = b.contract_nbr
   left join lp_common..common_product p on a.product_id = p.product_id
   where a.contract_nbr                             = @p_contract_nbr
   and   a.account_number                           = @p_account_number
   and   a.renew									= 1
end

-- begin IT106
if @PriceID is not null
	begin
		select	@ProductBrandID = ProductBrandID
		from	Libertypower..Price (nolock)
		where	ID = @PriceID
	end

select @w_contract_nbr                              = ''
		,@w_account_number                            = ''
		,@w_account_name                              = ''
		,@w_customer_name                             = ''
		,@w_customer_address                          = ''
		,@w_customer_suite                            = ''
		,@w_customer_city                             = ''
		,@w_customer_state                            = 'NN'
		,@w_customer_zip                              = ''
		,@w_customer_first_name                       = ''
		,@w_customer_last_name                        = ''
		,@w_customer_title                            = ''
		,@w_customer_phone                            = ''
		,@w_customer_fax                              = ''
		,@w_customer_email                            = ''
		,@w_customer_birthday                         = 'NONE'
		,@w_billing_first_name                        = ''
		,@w_billing_last_name                         = ''
		,@w_billing_title                             = ''
		,@w_billing_phone                             = ''
		,@w_billing_fax                               = ''
		,@w_billing_email                             = ''
		,@w_billing_birthday                          = 'NONE'
		,@w_billing_address                           = ''
		,@w_billing_suite                             = ''
		,@w_billing_city                              = ''
		,@w_billing_state                             = 'NN'
		,@w_billing_zip                               = ''
		,@w_owner_name                                = ''
		,@w_service_address                           = ''
		,@w_service_suite                             = ''
		,@w_service_city                              = ''
		,@w_service_state                             = 'NN'
		,@w_service_zip                               = ''



select @w_user_id                                   = UserID
from lp_portal..Users with (NOLOCK)
where Username                                      = @p_username

select @w_contract_nbr                              = @p_contract_nbr
select @w_account_number                            = @p_account_number

if @w_account_name_link                            <> 0
begin
	if @p_account_number								= 'CONTRACT'
		select @w_account_name                           = full_name
		from deal_account_name with (NOLOCK)
		where account_id							in (select top 1 account_id
														from lp_contract_renewal..deal_contract_account with (nolock)
														where contract_nbr		= @p_contract_nbr
														and account_name_link	= @w_account_name_link)
		and   name_link                                 = @w_account_name_link
	else
		select @w_account_name                           = full_name
		from deal_account_name with (NOLOCK)
		where account_id								= @w_account_id
		and   name_link                                 = @w_account_name_link
end

if @w_customer_name_link                           <> 0
begin
	if @p_account_number                           = 'CONTRACT'
		select @w_customer_name                          = full_name
		from deal_account_name with (NOLOCK)
		where account_id							in (select top 1 account_id
														from lp_contract_renewal..deal_contract_account with (nolock)
														where contract_nbr		= @p_contract_nbr
														and customer_name_link	= @w_customer_name_link)
		and   name_link                                  = @w_customer_name_link	
	else
		select @w_customer_name                          = full_name
		from deal_account_name with (NOLOCK)
		where account_id								= @w_account_id
		and   name_link                                  = @w_customer_name_link	
end

if @w_customer_address_link                        <> 0
begin
	if @p_account_number                           = 'CONTRACT'
		select @w_customer_address                       = address,
			  @w_customer_suite                         = suite,
			  @w_customer_city                          = city,
			  @w_customer_state                         = state,
			  @w_customer_zip                           = zip
		from deal_account_address with (NOLOCK)
		where account_id							in (select top 1 account_id
														from lp_contract_renewal..deal_contract_account with (nolock)
														where contract_nbr			= @p_contract_nbr
														and customer_address_link	= @w_customer_address_link)
		and   address_link                               = @w_customer_address_link
	else
		select @w_customer_address                       = address,
			  @w_customer_suite                         = suite,
			  @w_customer_city                          = city,
			  @w_customer_state                         = state,
			  @w_customer_zip                           = zip
		from deal_account_address with (NOLOCK)
		where account_id								= @w_account_id
		and   address_link                               = @w_customer_address_link
end

if @w_customer_contact_link                        <> 0
begin
	if @p_account_number                           = 'CONTRACT'
		select @w_customer_first_name                    = first_name,
			  @w_customer_last_name                     = last_name,
			  @w_customer_title                         = title,
			  @w_customer_phone                         = phone,
			  @w_customer_fax                           = fax,
			  @w_customer_email                         = email,
			  @w_customer_birthday                      = birthday
		from deal_account_contact with (NOLOCK)
		where account_id							in (select top 1 account_id
														from lp_contract_renewal..deal_contract_account with (nolock)
														where contract_nbr			= @p_contract_nbr
														and customer_contact_link	= @w_customer_contact_link)
		and   contact_link                               = @w_customer_contact_link
	else
		select @w_customer_first_name                   = first_name,
			  @w_customer_last_name                     = last_name,
			  @w_customer_title                         = title,
			  @w_customer_phone                         = phone,
			  @w_customer_fax                           = fax,
			  @w_customer_email                         = email,
			  @w_customer_birthday                      = birthday
		from deal_account_contact with (NOLOCK)
		where account_id								= @w_account_id
		and   contact_link                              = @w_customer_contact_link	
end

if @w_billing_contact_link                         <> 0
begin
	if @p_account_number                           = 'CONTRACT'
		select @w_billing_first_name                     = first_name,
			  @w_billing_last_name                      = last_name,
			  @w_billing_title                          = title,
			  @w_billing_phone                          = phone,
			  @w_billing_fax                            = fax,
			  @w_billing_email                          = email,
			  @w_billing_birthday                       = birthday
		from deal_account_contact with (NOLOCK)
		where account_id							in (select top 1 account_id
														from lp_contract_renewal..deal_contract_account with (nolock)
														where contract_nbr			= @p_contract_nbr
														and billing_contact_link	= @w_billing_contact_link)
		and   contact_link                               = @w_billing_contact_link
	else
		select @w_billing_first_name                     = first_name,
			  @w_billing_last_name                      = last_name,
			  @w_billing_title                          = title,
			  @w_billing_phone                          = phone,
			  @w_billing_fax                            = fax,
			  @w_billing_email                          = email,
			  @w_billing_birthday                       = birthday
		from deal_account_contact with (NOLOCK)
		where account_id								= @w_account_id
		and   contact_link                               = @w_billing_contact_link

end

if @w_billing_address_link                         <> 0
begin
	if @p_account_number                           = 'CONTRACT'
		select @w_billing_address                        = address,
			  @w_billing_suite                          = suite,
			  @w_billing_city                           = city,
			  @w_billing_state                          = state,
			  @w_billing_zip                            = zip
		from deal_account_address with (NOLOCK)
		where account_id							in (select top 1 account_id
														from lp_contract_renewal..deal_contract_account with (nolock)
														where contract_nbr			= @p_contract_nbr
														and billing_address_link	= @w_billing_address_link)
		and   address_link                           = @w_billing_address_link
	else
		select @w_billing_address                        = address,
			  @w_billing_suite                          = suite,
			  @w_billing_city                           = city,
			  @w_billing_state                          = state,
			  @w_billing_zip                            = zip
		from deal_account_address with (NOLOCK)
		where account_id								= @w_account_id
		and   address_link                               = @w_billing_address_link	
end

if @w_owner_name_link                              <> 0
begin
	if @p_account_number                           = 'CONTRACT'
		select @w_owner_name                             = full_name
		from deal_account_name with (NOLOCK)
		where account_id							in (select top 1 account_id
														from lp_contract_renewal..deal_contract_account with (nolock)
														where contract_nbr			= @p_contract_nbr
														and owner_name_link			= @w_owner_name_link)
		and   name_link                                  = @w_owner_name_link
	else
		select @w_owner_name                             = full_name
		from deal_account_name with (NOLOCK)
		where account_id								= @w_account_id
		and   name_link                                  = @w_owner_name_link
			
end

if @w_service_address_link                         <> 0
begin
	if @p_account_number                           = 'CONTRACT'
		select @w_service_address                        = address,
			  @w_service_suite                          = suite,
			  @w_service_city                           = city,
			  @w_service_state                          = state,
			  @w_service_zip                            = zip
		from deal_account_address with (NOLOCK)
		where account_id							in (select top 1 account_id
														from lp_contract_renewal..deal_contract_account with (nolock)
														where contract_nbr			= @p_contract_nbr
														and service_address_link	= @w_service_address_link)
		and   address_link                               = @w_service_address_link
	else
		select @w_service_address                        = address,
			  @w_service_suite                          = suite,
			  @w_service_city                           = city,
			  @w_service_state                          = state,
			  @w_service_zip                            = zip
		from deal_account_address with (NOLOCK)
		where account_id								= @w_account_id
		and   address_link                               = @w_service_address_link
end

goto_select:

if @p_account_number                                = 'CONTRACT'
begin

   select contract_nbr                              = @w_contract_nbr,
          status                                    = @w_status,
          retail_mkt_id                             = rtrim(ltrim(@w_retail_mkt_id)),
          utility_id                                = rtrim(ltrim(@w_utility_id)),
		  account_type								= @w_account_type,
          product_id                                = rtrim(ltrim(@w_product_id)),
          rate_id                                   = @w_rate_id,
          rate                                      = @w_rate,
          customer_name_link                        = @w_customer_name_link,
          customer_name                             = @w_customer_name,
          customer_address_link                     = @w_customer_address_link,
          customer_address                          = @w_customer_address,
          customer_suite                            = @w_customer_suite,
          customer_city                             = @w_customer_city,
          customer_state                            = @w_customer_state,
          customer_zip                              = @w_customer_zip,
          customer_contact_link                     = @w_customer_contact_link,
          customer_first_name                       = @w_customer_first_name,
          customer_last_name                        = @w_customer_last_name,
          customer_title                            = @w_customer_title,
          customer_phone                            = @w_customer_phone,
          customer_fax                              = @w_customer_fax,
          customer_email                            = @w_customer_email,
          customer_birthday                         = ltrim(rtrim(@w_customer_birthday)),
          billing_address_link                      = @w_billing_address_link,
          billing_address                           = @w_billing_address,
          billing_suite                             = @w_billing_suite,
          billing_city                              = @w_billing_city,
          billing_state                             = @w_billing_state,
          billing_zip                               = @w_billing_zip,
          billing_contact_link                      = @w_billing_contact_link,
          billing_first_name                        = @w_billing_first_name,
          billing_last_name                         = @w_billing_last_name,
          billing_title                             = @w_billing_title,
          billing_phone                             = @w_billing_phone,
          billing_fax                               = @w_billing_fax,
          billing_email                             = @w_billing_email,
          billing_birthday                          = ltrim(rtrim(@w_billing_birthday)),
          owner_name_link                           = @w_owner_name_link,
          owner_name                                = @w_owner_name,
          service_address_link                      = @w_service_address_link,
          service_address                           = @w_service_address,
          service_suite                             = @w_service_suite,
          service_city                              = @w_service_city,
          service_state                             = @w_service_state,
          service_zip                               = @w_service_zip,
          business_type                             = @w_business_type,
          business_activity                         = @w_business_activity,
          additional_id_nbr_type                    = @w_additional_id_nbr_type,
          additional_id_nbr                         = @w_additional_id_nbr,
          contract_eff_start_date                   = @w_contract_eff_start_date,
          term_months                               = @w_term_months,
          date_end                                  = @w_date_end,
          date_deal                                 = @w_date_deal,
          date_created                              = @w_date_created,
          date_submit                               = @w_date_submit,
          sales_channel_role                        = ltrim(rtrim(@w_sales_channel_role)),
          username                                  = @w_username,
          sales_rep                                 = @w_sales_rep,
          origin                                    = @w_origin,
          chgstamp                                  = @w_chgstamp
          ,SSNClear									= @w_SSNClear				-- IT002
		  ,SSNEncrypted								= @w_SSNEncrypted			-- IT002
		  ,CreditScoreEncrypted						= @w_CreditScoreEncrypted	-- IT002

			,evergreen_option_id						= @w_evergreen_option_id,				-- IT021				
			evergreen_commission_end					= @w_evergreen_commission_end,			-- IT021
			residual_option_id							= @w_residual_option_id,				-- IT021
			residual_commission_end						= @w_residual_commission_end,			-- IT021
			initial_pymt_option_id						= @w_initial_pymt_option_id,			-- IT021
			sales_mgr									= @w_sales_mgr, 						-- IT021
			evergreen_commission_rate					= @w_evergreen_commission_rate,			-- IT021
		   ProductBrandID								= @ProductBrandID,
		   PriceID										= @PriceID,
		   PriceTier									= @PriceTier,
		   '' as comment			
end
else
begin
   select contract_nbr                              = @w_contract_nbr,
          account_number                            = @w_account_number,
          status                                    = @w_status,
          account_id                                = @w_account_id,
          retail_mkt_id                             = rtrim(ltrim(@w_retail_mkt_id)),
          utility_id                                = rtrim(ltrim(@w_utility_id)),
		  account_type								= @w_account_type,
          product_id                                = rtrim(ltrim(@w_product_id)),
          rate_id                                   = @w_rate_id,
          rate                                      = @w_rate,
          customer_name_link                        = @w_customer_name_link,
          customer_name                             = @w_customer_name,
          customer_address_link                     = @w_customer_address_link,
          customer_address                          = @w_customer_address,
          customer_suite                            = @w_customer_suite,
          customer_city                             = @w_customer_city,
          customer_state                            = @w_customer_state,
          customer_zip                              = @w_customer_zip,
          customer_contact_link                     = @w_customer_contact_link,
          customer_first_name                       = @w_customer_first_name,
          customer_last_name                        = @w_customer_last_name,
          customer_title                            = @w_customer_title,
          customer_phone                            = @w_customer_phone,
          customer_fax                              = @w_customer_fax,
          customer_email                            = @w_customer_email,
          customer_birthday                         = @w_customer_birthday,
          billing_address_link                      = @w_billing_address_link,
          billing_address                           = @w_billing_address,
          billing_suite                             = @w_billing_suite,
          billing_city                              = @w_billing_city,
          billing_state                             = @w_billing_state,
          billing_zip                               = @w_billing_zip,
          billing_contact_link                      = @w_billing_contact_link,
          billing_first_name                        = @w_billing_first_name,
          billing_last_name                         = @w_billing_last_name,
          billing_title                             = @w_billing_title,
          billing_phone                             = @w_billing_phone,
          billing_fax                               = @w_billing_fax,
          billing_email                             = @w_billing_email,
          billing_birthday                          = @w_billing_birthday,
          owner_name_link                           = @w_owner_name_link,
          owner_name                                = @w_owner_name,
          service_address_link                      = @w_service_address_link,
          service_address                           = @w_service_address,
          service_suite                             = @w_service_suite,
          service_city                              = @w_service_city,
          service_state                             = @w_service_state,
          service_zip                               = @w_service_zip,
          business_type                             = @w_business_type,
          business_activity                         = @w_business_activity,
          additional_id_nbr_type                    = @w_additional_id_nbr_type,
          additional_id_nbr                         = @w_additional_id_nbr,
          contract_eff_start_date                   = @w_contract_eff_start_date,
          term_months                               = @w_term_months,
          date_end                                  = @w_date_end,
          date_deal                                 = @w_date_deal,
          date_created                              = @w_date_created,
          date_submit                               = @w_date_submit,
          sales_channel_role                        = ltrim(rtrim(@w_sales_channel_role)),
          username                                  = @w_username,
          sales_rep                                 = @w_sales_rep,
          origin                                    = @w_origin,
          chgstamp                                  = @w_chgstamp,
		  renew										= @w_renew
		  ,SSNClear									= @w_SSNClear						-- IT002
		  ,SSNEncrypted								= @w_SSNEncrypted					-- IT002
		  ,CreditScoreEncrypted						= @w_CreditScoreEncrypted			-- IT002
			,evergreen_option_id							= @w_evergreen_option_id,	-- IT002
			evergreen_commission_end					= @w_evergreen_commission_end,	-- IT002
			residual_option_id							= @w_residual_option_id,		-- IT002
			residual_commission_end						= @w_residual_commission_end,	-- IT002
			initial_pymt_option_id						= @w_initial_pymt_option_id,	-- IT002
			sales_mgr									= @w_sales_mgr, 				-- IT002
			evergreen_commission_rate					= @w_evergreen_commission_rate,	-- IT002
		   ProductBrandID								= @ProductBrandID,
		   PriceID										= @PriceID,
		   PriceTier									= @PriceTier,
		   '' as comment			
end


SET NOCOUNT OFF