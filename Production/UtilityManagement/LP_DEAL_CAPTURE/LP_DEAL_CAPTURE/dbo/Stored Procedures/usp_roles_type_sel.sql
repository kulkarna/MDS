-- =============================================
-- Author:		Rick Deigsler
-- Create date: 12/11/2007
-- Description:	Select roles that are like @p_role_type
-- =============================================
CREATE PROCEDURE [dbo].[usp_roles_type_sel]

@p_role_type	varchar(255)

AS

exec LibertyPower.dbo.usp_RoleGetByRoleNameLike @p_partialRoleName = @p_role_type

--SELECT	RoleName AS option_id, RoleID AS return_value
--FROM	libertypower..[Role]
--WHERE	RoleName LIKE '%' + @p_role_type + '%'
--AND		RoleName <> 'ABC flexible pricing' AND RoleName <> 'NON-ABC standard pricing channel'

