
-- =============================================    
-- Author:  Gail Mangaroo    
-- Create date: 4/5/2013    
-- Description: Get the Target Value for the specified Externanl Entity    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_PropertyValueUnMappedSelect]
( @propertyId int = null, 
	@propertyTypeID int = null
	, @IncludeInactive bit = 0 
)

AS 
BEGIN 

	Select distinct pv.* 
	FROM LibertyPower..PropertyValue pv (NOLOCK) 
	WHERE ISNULL (pv.InternalRefID, 0 ) = 0  
		AND pv.PropertyId = ISNULL ( @propertyId , pv.PropertyId ) 
		AND ISNULL(pv.PropertyTypeId, 0) = ISNULL(@propertytypeId , ISNULL(pv.PropertyTypeId, 0) ) 
		AND (pv.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
END 
