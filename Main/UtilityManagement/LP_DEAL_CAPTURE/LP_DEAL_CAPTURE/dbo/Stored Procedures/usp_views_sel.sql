


CREATE      PROCEDURE [dbo].[usp_views_sel]
(@p_username                                        nchar(100),
 @p_process_id                                      varchar(30))
as

if @p_process_id                                    = 'DEAL CONTRACT TYPE'
begin
   declare @w_user_id                               int
   declare @w_role_name                             nvarchar(50)

   select @w_user_id                                = UserID
   from lp_portal..Users with (NOLOCK INDEX = IX_Users)
   where Username                                   = @p_username

	select
          option_id                                 = 'Select Type',
          return_value                              = ''
	union
   select distinct 
          option_id                                 = a.contract_type,
          return_value                              = upper(a.contract_type)
   from lp_security..security_role_contract_type  a with (NOLOCK INDEX = security_role_contract_type_idx),
        lp_portal..UserRoles b with (NOLOCK INDEX = IX_UserRoles),
        lp_portal..Roles c with (NOLOCK INDEX = IX_RoleName)
   where a.role_name                                = c.RoleName 
   and   b.UserID                                   = @w_user_id
   and   b.RoleID                                   = c.RoleID
order by return_value asc
               
end


exec lp_common..usp_views_sel @p_username,
                              @p_process_id

