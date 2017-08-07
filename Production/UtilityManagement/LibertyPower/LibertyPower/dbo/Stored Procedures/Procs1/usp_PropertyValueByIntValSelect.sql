
-- =============================================    
-- Author:  Gail Mangaroo    
-- Create date: 4/5/2013    
-- Description: Get the Target Value for the specified Externanl Entity    
-- =============================================    
-- exec LibertyPower..[usp_PropertyValueByIntValSelect] 1
-- =============================================
CREATE PROCEDURE [dbo].[usp_PropertyValueByIntValSelect]
(
@propertyId int ,
@internalValue varchar(100) , 
@extEntityId int = null 
, @IncludeInactive bit = 0 
)
AS 
BEGIN 

	Select pv.* 
	FROM LibertyPower..PropertyInternalRef pir  (NOLOCK) 
		JOIN LibertyPower..PropertyValue pv  (NOLOCK) 
			ON pv.InternalRefID = pir.ID 
		JOIN LibertyPower..ExternalEntityValue ev  (NOLOCK) 
			ON ev.PropertyValueID = pv.ID  
	WHERE pir.propertyId =  @propertyId
		AND pir.Value = @internalValue
		AND ev.ExternalEntityID = ISNULL(@extEntityId , ExternalEntityID) 
		
		AND (pir.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (pv.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (ev.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
END 
