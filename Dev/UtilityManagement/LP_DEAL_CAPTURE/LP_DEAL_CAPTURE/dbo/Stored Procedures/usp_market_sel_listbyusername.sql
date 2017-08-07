
--exec usp_market_sel_listbyusername 'admin'

/*
Modified 3/5/09
To allow all markets to be selected for Liberty Power employees
for drop-down controls on web pages
*/
CREATE procedure [dbo].[usp_market_sel_listbyusername]
(@p_username                                        nchar(100),
 @p_union_select                                    varchar(15) = ' ',
 @p_contract_type									varchar(15)	= 'PAPER')
as
 
declare @w_user_id                                  int

select @w_user_id                                   = UserID
from lp_portal..Users with (NOLOCK INDEX = IX_Users)
where Username                                      = @p_username 

if @p_union_select                                  = 'NONE'
begin
	if lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1
		begin
		   select a.option_id,
				  a.return_value
		   from (select seq                                 = 1,
						option_id                           = 'None',
						return_value                        = 'NN'
				 union
				 select distinct
						seq                                 = 2,
						option_id                           = d.retail_mkt_descp,
						return_value                        = ltrim(rtrim(d.retail_mkt_id))
				 from lp_common..common_retail_market d with (NOLOCK INDEX = common_retail_market_idx),
					  lp_common..common_wholesale_market e with (NOLOCK INDEX = common_wholesale_market_idx)
				 where d.retail_mkt_id in (	select retail_mkt_id 
											from lp_common..utility_permission
											where (paper_contract_only = 0 or paper_contract_only = case when (left(@p_contract_type, 5) = 'PAPER' or @p_contract_type = 'PRE-PRINTED') then 1 else 0 end))) a
		   order by a.seq, a.option_id
		end
	else
		begin
		   select a.option_id,
				  a.return_value
		   from (select seq                                 = 1,
						option_id                           = 'None',
						return_value                        = 'NN'
				 union
				 select distinct
						seq                                 = 2,
						option_id                           = d.retail_mkt_descp,
						return_value                        = ltrim(rtrim(c.retail_mkt_id))
				 from lp_portal..UserRoles a with (NOLOCK INDEX = IX_UserRoles_1),
					  lp_portal..Roles b with (NOLOCK INDEX = IX_RoleName),
					  lp_security..security_role_retail_mkt c with (NOLOCK INDEX = security_role_retail_mkt_idx),
					  lp_common..common_retail_market d with (NOLOCK INDEX = common_retail_market_idx),
					  lp_common..common_wholesale_market e with (NOLOCK INDEX = common_wholesale_market_idx)
				 where (a.UserID                            = @w_user_id 
				 and    a.RoleID                            = b.RoleID
				 and    b.RoleName                          = c.role_name) 
				 and   c.retail_mkt_id                      = d.retail_mkt_id
				 and   d.inactive_ind                       = '0'
				 and   d.wholesale_mkt_id                   = e.wholesale_mkt_id
				 and   e.inactive_ind                       = '0' 
				 and   d.retail_mkt_id in (	select retail_mkt_id 
											from lp_common..utility_permission
											where (paper_contract_only = 0 or paper_contract_only = case when (left(@p_contract_type, 5) = 'PAPER' or @p_contract_type = 'PRE-PRINTED') then 1 else 0 end))) a
		   order by a.seq, a.option_id
		end
end
else
begin
	if lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1
		begin
		   select distinct
				  option_id                                 = d.retail_mkt_descp,
				  return_value                              = ltrim(rtrim(d.retail_mkt_id))
		   from lp_common..common_retail_market d with (NOLOCK INDEX = common_retail_market_idx),
				lp_common..common_wholesale_market e with (NOLOCK INDEX = common_wholesale_market_idx)
		   where d.retail_mkt_id in (	select retail_mkt_id 
										from lp_common..utility_permission
										where (paper_contract_only = 0 or paper_contract_only = case when (left(@p_contract_type, 5) = 'PAPER' or @p_contract_type = 'PRE-PRINTED') then 1 else 0 end))
		   order by option_id
		end
	else
		begin
		   select distinct
				  option_id                                 = d.retail_mkt_descp,
				  return_value                              = ltrim(rtrim(c.retail_mkt_id))
		   from lp_portal..UserRoles a with (NOLOCK INDEX = IX_UserRoles_1),
				lp_portal..Roles b with (NOLOCK INDEX = IX_RoleName),
				lp_security..security_role_retail_mkt c with (NOLOCK INDEX = security_role_retail_mkt_idx),
				lp_common..common_retail_market d with (NOLOCK INDEX = common_retail_market_idx),
				lp_common..common_wholesale_market e with (NOLOCK INDEX = common_wholesale_market_idx)
		   where (a.UserID                                  = @w_user_id 
		   and    a.RoleID                                  = b.RoleID
		   and    b.RoleName                                = c.role_name) 
		   and   c.retail_mkt_id                            = d.retail_mkt_id
		   and   d.inactive_ind                             = '0'
		   and   d.wholesale_mkt_id                         = e.wholesale_mkt_id
		   and   e.inactive_ind                             = '0'
		   and   d.retail_mkt_id in (	select retail_mkt_id 
										from lp_common..utility_permission
										where (paper_contract_only = 0 or paper_contract_only = case when (left(@p_contract_type, 5) = 'PAPER' or @p_contract_type = 'PRE-PRINTED') then 1 else 0 end))
		   order by option_id
		end
end

