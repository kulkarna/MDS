
--exec usp_utility_sel_listbyusername 'admin', '37'

 /*
Modified 3/5/09
To allow all utilities to be selected for Liberty Power employees
for drop-down controls on web pages
*/
CREATE procedure [dbo].[usp_utility_sel_listbyusername]
(@p_username                                        nchar(100),
 @p_retail_mkt_id                                   char(02),
 @p_union_select                                    varchar(15) = ' ')
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
						return_value                        = 'NONE'
				 union
				 select distinct 
						seq                                 = 2,
						option_id                           = d.utility_descp,
						return_value                        = ltrim(rtrim(c.utility_id))
				 from lp_security..security_role_utility c with (NOLOCK INDEX = security_role_utility_idx),
					  lp_common..common_utility d with (NOLOCK INDEX = common_utility_idx)
				 where c.utility_id                         = d.utility_id
				 and   d.retail_mkt_id                      = @p_retail_mkt_id
				 and   d.inactive_ind                       = '0') a
		   order by a.seq, a.option_id
		end
	else
		begin
		   select a.option_id, 
				  a.return_value
		   from (select seq                                 = 1,
						option_id                           = 'None',
						return_value                        = 'NONE'
				 union
				 select distinct 
						seq                                 = 2,
						option_id                           = d.utility_descp,
						return_value                        = ltrim(rtrim(c.utility_id))
				 from lp_portal..UserRoles a with (NOLOCK INDEX = IX_UserRoles_1),
					  lp_portal..Roles b with (NOLOCK INDEX = IX_RoleName),
					  lp_security..security_role_utility c with (NOLOCK INDEX = security_role_utility_idx),
					  lp_common..common_utility d with (NOLOCK INDEX = common_utility_idx)
				 where (a.UserID                            = @w_user_id 
				 and    a.RoleID                            = b.RoleID
				 and    b.RoleName                          = c.role_name)
				 and   c.utility_id                         = d.utility_id
				 and   d.retail_mkt_id                      = @p_retail_mkt_id
				 and   d.inactive_ind                       = '0') a
		   order by a.seq, a.option_id
		end
end
else
begin
	if lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1
		begin
			select distinct 
				  option_id                                 = d.utility_descp,
				  return_value                              = ltrim(rtrim(c.utility_id))
			from lp_security..security_role_utility c with (NOLOCK INDEX = security_role_utility_idx),
				lp_common..common_utility d with (NOLOCK INDEX = common_utility_idx)
			where c.utility_id                               = d.utility_id
			and   d.retail_mkt_id                            = @p_retail_mkt_id
			and   d.inactive_ind                             = '0'
			order by option_id
		end
	else
		begin
			select distinct 
				  option_id                                 = d.utility_descp,
				  return_value                              = ltrim(rtrim(c.utility_id))
			from lp_portal..UserRoles a with (NOLOCK INDEX = IX_UserRoles_1),
				lp_portal..Roles b with (NOLOCK INDEX = IX_RoleName),
				lp_security..security_role_utility c with (NOLOCK INDEX = security_role_utility_idx),
				lp_common..common_utility d with (NOLOCK INDEX = common_utility_idx)
			where (a.UserID                                  = @w_user_id 
			and    a.RoleID                                  = b.RoleID
			and    b.RoleName                                = c.role_name)
			and   c.utility_id                               = d.utility_id
			and   d.retail_mkt_id                            = @p_retail_mkt_id
			and   d.inactive_ind                             = '0'
			order by option_id
		end
end
