-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 4/26/2013
-- Description:	Get External References
-- =============================================
-- exec LibertyPower..[usp_ExternalEntityByPropValueSelect] 89719
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityByPropValueSelect]
	@propertyValueId int 
	, @IncludeInactive bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT  vee.*     
	FROM LibertyPower..vw_ExternalEntity vee (NOLOCK)
		JOIN LibertyPower..ExternalEntityValue eev ON eev.ExternalEntityID = vee.ID
		
	WHERE 1 =1 
		AND (eev.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (vee.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND eev.PropertyValueID = @propertyValueId
		
END
