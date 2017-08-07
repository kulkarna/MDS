
-- =============================================    
-- Author:  Gail Mangaroo    
-- Create date: 4/5/2013    
-- Description: Get the Target Value for the specified Externanl Entity    
-- =============================================    
-- exec LibertyPower..[usp_PropertyValueByIntRefSelect] 2568
-- =============================================
CREATE PROCEDURE [dbo].[usp_PropertyValueByIntRefSelect]
(
@internalRefId int 
, @extEntityId int = null 
, @propertyId int = null 
, @propertyTypeId int = null 
, @IncludeInactive bit = 0 

)
AS 
BEGIN 

	Select DISTINCT pv.* 
	FROM LibertyPower..PropertyInternalRef pir (NOLOCK) 
		JOIN LibertyPower..PropertyValue pv (NOLOCK) 
			ON pv.InternalRefID = pir.ID 

		LEFT JOIN LibertyPower..ExternalEntityValue ev (NOLOCK) 
			ON ev.PropertyValueID = pv.ID 
			AND (ev.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated	 

	WHERE pir.ID =  @internalRefId
		AND ISNULL(ev.ExternalEntityID,0) = ISNULL(@extEntityId, ISNULL(ev.ExternalEntityID, 0)) 
		AND ISNULL(pv.PropertyId, 0) = ISNULL(@propertyId , ISNULL(pv.PropertyId, 0)) 
		AND ISNULL(pv.PropertyTypeId, 0) = ISNULL(@propertyTypeId , ISNULL(pv.PropertyTypeId, 0)) 
	
		AND (pir.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (pv.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		
END 
