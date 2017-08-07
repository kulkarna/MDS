-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 4/29/2013
-- Description:	Get Internal References mapped to the given External entity
-- =============================================
-- exec LibertyPower..[usp_PropertyInternalRefByEntIdSelect] 
-- ==============================================
CREATE PROCEDURE [dbo].[usp_PropertyInternalRefByEntKeySelect]
	@entityKey int 
	, @entityTypeId int 
	, @propertyId int = null 
	, @propertyTypeId int = null 
	, @IncludeInactive bit = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT  pir.*     
	FROM LibertyPower..ExternalEntity ee (NOLOCK)
		JOIN LibertyPower..ExternalEntityValue ev  (NOLOCK)
			ON ee.ID = ev.ExternalEntityID
		JOIN LibertyPower..PropertyValue pv  (NOLOCK)
			ON pv.ID = ev.PropertyValueID 
			--AND pv.Inactive = 0 
		JOIN LibertyPower..PropertyInternalRef pir  (NOLOCK)
			ON pir.ID = pv.InternalRefID
			--AND pir.Inactive = 0 
	WHERE 1= 1 
		
		AND ee.EntityKey = @entityKey
		AND ee.EntityTypeID = @entityTypeID
		AND pir.PropertyId = ISNULL(@propertyId , pir.PropertyId) 	
		AND ISNULL(pir.PropertyTypeId, 0) = ISNULL(@propertytypeId , ISNULL(pir.PropertyTypeId, 0) ) 
		
		AND (ee.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (ev.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (pv.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (pir.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
END
