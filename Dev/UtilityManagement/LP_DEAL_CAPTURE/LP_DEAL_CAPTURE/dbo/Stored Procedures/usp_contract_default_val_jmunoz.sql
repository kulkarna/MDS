 /*
 *******************************************************************************
 * 04/26/2012 - Jose Munoz - SWCS
 * Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
			and use the new table in libertypower database
 *******************************************************************************
 exec usp_contract_default_val 'libertypower\dmarino', '20060501', 'MD', 'BGE', 'BGE-FIXED-24', 2, 'NONE', 'NONE', 'NONE', 'Sales Channel/I2C'
*/   
 

CREATE procedure [dbo].[usp_contract_default_val_jmunoz]
(@p_username                                        nchar(100),
 @p_getdate                                         datetime,
 @p_retail_mkt_id                                   varchar(15) output,
 @p_utility_id                                      varchar(15) output,
 @p_product_id                                      varchar(20) output,
 @p_rate_id                                         int output,
 @p_business_type                                   varchar(35) output,
 @p_business_activity                               varchar(35) output,
 @p_additional_id_nbr_type                          varchar(10) output,
 @p_sales_channel_role                              nvarchar(50) output)
as

declare @w_retail_mkt_id                            varchar(15)
	,@w_utility_id									varchar(15)
	,@w_product_id									varchar(20)
	,@w_rate_id										int
	,@w_business_type								varchar(35)
	,@w_business_activity							varchar(35)
	,@w_additional_id_nbr_type						varchar(10)
	,@w_sales_channel_role							nvarchar(50)
	,@w_user_id										int
	
select @w_retail_mkt_id                             = @p_retail_mkt_id
	,@w_utility_id									= @p_utility_id
	,@w_product_id									= @p_product_id
	,@w_rate_id										= @p_rate_id 
	,@w_business_type								= @p_business_type
	,@w_business_activity							= @p_business_activity
	,@w_additional_id_nbr_type						= @p_additional_id_nbr_type
	,@w_sales_channel_role							= @p_sales_channel_role

select @w_user_id                                   = UserID
from libertypower..[User] with (NOLOCK INDEX = User__Username_I)
where Username                                      = ltrim(rtrim(@p_username))

if not exists(select c.retail_mkt_id
				from libertypower..[UserRole] a with (NOLOCK)
				inner join libertypower..[Role] b with (NOLOCK)
				on b.RoleID						= a.RoleID
				inner join lp_security..security_role_retail_mkt c with (NOLOCK INDEX = security_role_retail_mkt_idx)
				on c.role_name					= b.RoleName 
				inner join lp_common..common_retail_market d with (NOLOCK)
				on d.retail_mkt_id				= c.retail_mkt_id  
				inner join lp_common..common_wholesale_market e with (NOLOCK)
				on e.wholesale_mkt_id			= d.wholesale_mkt_id
				where a.UserID						= @w_user_id 
				and   c.retail_mkt_id				= @p_retail_mkt_id
				and   d.inactive_ind				= '0'
				and   e.inactive_ind				= '0')
begin
   select @w_retail_mkt_id                          = 'NN'
end

if not exists(select c.utility_id
				from libertypower..[UserRole]					a with (NOLOCK)
				inner join libertypower..[Role]					b with (NOLOCK)
				on b.RoleID							= a.RoleID
				inner join lp_security..security_role_utility	c with (NOLOCK INDEX = security_role_utility_idx)
				on c.role_name						= b.RoleName
				inner join libertypower..utility				d with (NOLOCK INDEX = common_utility_idx)
				on d.UtilityCode					= c.utility_id 
				inner join libertypower..market					m with (NOLOCK)
				on m.ID								= d.MarketID
				where a.UserID                      = @w_user_id 
				and   c.utility_id                  = @p_utility_id
				and   m.MarketCode					= @w_retail_mkt_id
				and   m.inactiveInd					= '0'
				and   d.inactiveInd					= '0')
begin
   select @w_utility_id                             = 'NONE'
end

if not exists(select product_id
              from lp_common..common_product d with (NOLOCK INDEX = common_product_idx1)
              where utility_id                      = @w_utility_id
              and   product_id                      = @p_product_id
              and   inactive_ind                    = '0')
begin
   select @w_product_id                             = 'NONE'
end

if not exists(select rate_id 
              from lp_common..common_product_rate with (NOLOCK INDEX = common_product_rate_idx)
              where product_id                      = @w_product_id
              and   inactive_ind                    = '0'
              and   eff_date                       <= convert(char(08), @p_getdate, 112)
              and   due_date                       >= convert(char(08), @p_getdate, 112))
begin
   select @w_rate_id                                = 999999999
end

if not exists(select option_id
              from lp_common..common_views with (NOLOCK INDEX = common_views_idx)
              where process_id                      = 'BUSINESS TYPE'
              and   return_value                    = @p_business_type
              and   seq                             < 20000)
begin
   select @w_business_type                          = 'NONE'
end

if not exists(select option_id
              from lp_common..common_views with (NOLOCK INDEX = common_views_idx)
              where process_id                      = 'BUSINESS ACTIVITY'
              and   return_value                    = @p_business_activity
              and   seq                             < 20000)
begin
   select @w_business_activity                      = 'NONE'
end

if not exists(select option_id
              from lp_common..common_views with (NOLOCK INDEX = common_views_idx)
              where process_id                      = 'ID TYPE'
              and   return_value                    = @p_additional_id_nbr_type 
              and   seq                             < 20000)
begin
   select @w_additional_id_nbr_type                 = 'NONE'
		,@w_additional_id_nbr_type                 = 'NONE'
end

if not exists(	select a.RoleID
				from libertypower..[UserRole] a with (NOLOCK)
				inner join libertypower..[Role] b with (NOLOCK)
				on b.RoleID						= a.RoleID 
				inner join lp_common..common_config C with (NOLOCK)
				on b.RoleName                   like ltrim(rtrim(c.sales_channel_prefix)) + '%'
				where a.UserID					= @w_user_id 
				and   b.RoleName				= @p_sales_channel_role)
begin
   select @w_sales_channel_role                     = 'NONE'
end

select @p_retail_mkt_id							  = @w_retail_mkt_id
	,@p_utility_id                                = @w_utility_id
	,@p_product_id                                = @w_product_id
	,@p_rate_id                                   = @w_rate_id 
	,@p_business_type                             = @w_business_type
	,@p_business_activity                         = @w_business_activity
	,@p_additional_id_nbr_type                    = @w_additional_id_nbr_type
	,@p_sales_channel_role                        = @w_sales_channel_role
