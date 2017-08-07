-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 4/29/2013
-- Description:	Get External Entity
-- =============================================
-- exec LibertyPower..usp_ExternalEntityByEntitySelect null , 2  , 1 
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityByEntitySelect]
	@entityKey int = null 
	, @entityTypeId int = null 
	, @IncludeInactive bit = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT  *     
	FROM LibertyPower..vw_ExternalEntity (NOLOCK)
	WHERE 1 =1 
		AND (Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND EntityKey = ISNULL (entityKey, EntityKey ) 
		AND EntityTypeID = ISNULL (@entityTypeId, EntityTypeID ) 
		
END
