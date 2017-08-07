-- =============================================
-- Create date: 1/11/2010
-- Description:	Select roles that are like @p_role_type
--	Ported from lp_deal_capture.[dbo].[usp_roles_type_sel] 
-- =============================================
CREATE procEDURE [dbo].[usp_RoleGetByRoleNameLike]

@p_partialRoleName	varchar(255)

AS

SELECT	
	RoleID,    
	RoleName,    
	DateCreated,  
	DateModified,  
	CreatedBy,  
	ModifiedBy,
	Description  
FROM	libertypower..[Role]
WHERE	RoleName LIKE '%' + @p_partialRoleName + '%'
AND		RoleName <> 'ABC flexible pricing' AND RoleName <> 'NON-ABC standard pricing channel'
