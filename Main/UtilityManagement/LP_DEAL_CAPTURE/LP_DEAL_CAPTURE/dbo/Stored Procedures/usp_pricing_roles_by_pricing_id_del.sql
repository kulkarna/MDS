
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/24/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_pricing_roles_by_pricing_id_del]

@p_pricing_id	int

AS

DELETE FROM	pricing_role
WHERE		pricing_id = @p_pricing_id
