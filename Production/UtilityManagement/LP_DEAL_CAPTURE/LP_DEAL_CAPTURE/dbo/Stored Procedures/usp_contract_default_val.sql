



--exec usp_contract_default_val 'libertypower\dmarino', '20060501', 'MD', 'BGE', 'BGE-FIXED-24', 2, 'NONE', 'NONE', 'NONE', 'Sales Channel/I2C'

CREATE procedure [dbo].[usp_contract_default_val]
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
declare @w_utility_id                               varchar(15)
declare @w_product_id                               varchar(20)
declare @w_rate_id                                  int
declare @w_business_type                            varchar(35)
declare @w_business_activity                        varchar(35)
declare @w_additional_id_nbr_type                   varchar(10)
declare @w_sales_channel_role                       nvarchar(50)

select @w_retail_mkt_id                             = @p_retail_mkt_id
select @w_utility_id                                = @p_utility_id
select @w_product_id                                = @p_product_id
select @w_rate_id                                   = @p_rate_id 
select @w_business_type                             = @p_business_type
select @w_business_activity                         = @p_business_activity
select @w_additional_id_nbr_type                    = @p_additional_id_nbr_type

select @w_sales_channel_role                        = @p_sales_channel_role

declare @w_user_id                                  int

select @w_user_id                                   = UserID
from lp_portal..Users with (NOLOCK INDEX = IX_Users)
where Username                                      = ltrim(rtrim(@p_username))

if not exists(select c.retail_mkt_id
              from lp_portal..UserRoles a with (NOLOCK INDEX = IX_UserRoles_1),
                   lp_portal..Roles b with (NOLOCK INDEX = IX_RoleName),
                   lp_security..security_role_retail_mkt c with (NOLOCK INDEX = security_role_retail_mkt_idx),
                   lp_common..common_retail_market d with (NOLOCK INDEX = common_retail_market_idx),
                   lp_common..common_wholesale_market e with (NOLOCK INDEX = common_wholesale_market_idx)
              where (a.UserID                       = @w_user_id 
              and    a.RoleID                       = b.RoleID
              and    b.RoleName                     = c.role_name) 
              and   c.retail_mkt_id                 = @p_retail_mkt_id
              and   c.retail_mkt_id                 = d.retail_mkt_id
              and   d.inactive_ind                  = '0'
              and   d.wholesale_mkt_id              = e.wholesale_mkt_id
              and   e.inactive_ind                  = '0')
begin
   select @w_retail_mkt_id                          = 'NN'
end

if not exists(select c.utility_id
              from lp_portal..UserRoles a with (NOLOCK INDEX = IX_UserRoles_1),
                   lp_portal..Roles b with (NOLOCK INDEX = IX_RoleName),
                   lp_security..security_role_utility c with (NOLOCK INDEX = security_role_utility_idx),
                   lp_common..common_utility d with (NOLOCK INDEX = common_utility_idx)
              where (a.UserID                       = @w_user_id 
              and    a.RoleID                       = b.RoleID
              and    b.RoleName                     = c.role_name)
              and   c.utility_id                    = @p_utility_id
              and   c.utility_id                    = d.utility_id
              and   d.retail_mkt_id                 = @w_retail_mkt_id
              and   d.inactive_ind                  = '0')
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
   select @w_additional_id_nbr_type                 = 'NONE'
end

if not exists(select a.RoleID
              from lp_portal..UserRoles a with (NOLOCK INDEX = IX_UserRoles_1),
                   lp_portal..Roles b with (NOLOCK INDEX = IX_RoleName),
                   lp_common..common_config C with (NOLOCK)
              where a.UserID                        = @w_user_id 
              and   a.RoleID                        = b.RoleID
              and   b.RoleName                      = @p_sales_channel_role
              and   b.RoleName                   like ltrim(rtrim(c.sales_channel_prefix)) + '%')
begin
   select @w_sales_channel_role                     = 'NONE'
end

select @p_retail_mkt_id                             = @w_retail_mkt_id
select @p_utility_id                                = @w_utility_id
select @p_product_id                                = @w_product_id
select @p_rate_id                                   = @w_rate_id 
select @p_business_type                             = @w_business_type
select @p_business_activity                         = @w_business_activity
select @p_additional_id_nbr_type                    = @w_additional_id_nbr_type
select @p_sales_channel_role                        = @w_sales_channel_role





