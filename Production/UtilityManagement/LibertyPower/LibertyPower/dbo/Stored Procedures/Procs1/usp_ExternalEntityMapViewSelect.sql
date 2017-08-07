-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/8/2013
-- Description:	Get External Entity map View
-- =============================================
-- exec LibertyPower..[usp_ExternalEntityMapViewSelect] 8 , null , null , null 
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityMapViewSelect]
	@externalEntityId int = null 
	, @PropertyValueId int = null 
	, @propertyId int = null 
	, @propertyTypeId int = null 
	, @IncludeInactive bit = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT  *     
	FROM LibertyPower..vw_ExternalEntityMapping (NOLOCK)
	WHERE 1 =1 
		AND ExtEntityID = ISNULL (@externalEntityId, ExtEntityID ) 
		AND ExtPropertyValueID = ISNULL ( @PropertyValueId, ExtPropertyValueID ) 
		AND ExtEntityPropertyID = ISNULL ( @propertyId, 	ExtEntityPropertyID) 
		AND ISNULL(ExtEntityPropertyTypeID,0) = ISNULL ( @propertyTypeId , ISNULL(ExtEntityPropertyTypeID ,0)) 	 	
		
		AND (ExternalEntityInactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (ExtEntityValueInactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (PropertyValueInactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (InternalrefInactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
END
