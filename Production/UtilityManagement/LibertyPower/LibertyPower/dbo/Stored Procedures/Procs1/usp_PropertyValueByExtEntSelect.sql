-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 4/29/2013
-- Description:	Get Property Values mapped to the External Entity
-- =============================================
-- exec LibertyPower..[usp_PropertyValueByExtEntSelect] 8 , 1
-- ============================================
CREATE PROCEDURE [dbo].[usp_PropertyValueByExtEntSelect]
	@externalEntityId int
	, @propertyId int = null
	, @propertyTypeId int = null 
	, @IncludeInactive bit = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT  pv.*     
	FROM LibertyPower..ExternalEntityValue eev (NOLOCK)
		JOIN LibertyPower..PropertyValue pv (NOLOCK)
			ON pv.ID = eev.PropertyValueID
	WHERE 1 =1 
		AND eev.ExternalEntityID = @externalEntityId
		AND pv.PropertyId = ISNULL ( @propertyId, pv.PropertyId) 
		AND ISNULL(pv.PropertyTypeId, 0) = ISNULL(@propertytypeId , ISNULL(pv.PropertyTypeId, 0) ) 

		AND (eev.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (pv.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
END
