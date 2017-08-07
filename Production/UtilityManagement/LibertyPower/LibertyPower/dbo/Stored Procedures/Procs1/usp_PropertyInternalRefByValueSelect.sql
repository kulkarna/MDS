-- =============================================    
-- Author:  Gail Mangaroo    
-- Create date: 4/5/2013    
-- Description: Get the Property Inetrnal ref given the value    
-- =============================================  
-- exec   LibertyPower..[usp_PropertyInternalRefByValueSelect] 1, 'J' , 1 
-- =============================================
CREATE PROCEDURE [dbo].[usp_PropertyInternalRefByValueSelect]
(
@propertyId int ,
@propValue varchar(100) 
, @IncludeInactive bit = 0
)
AS 
BEGIN 

	Select pir.* 
	FROM LibertyPower..PropertyInternalRef pir (NOLOCK)
	WHERE pir.propertyId =  @propertyId
		AND pir.Value = @propValue
		AND (pir.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
END 
