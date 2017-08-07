-- =============================================    
-- Author:  Gail Mangaroo    
-- Create date: 4/5/2013    
-- Description: Get the Property Inetrnal ref given the value    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_PropertyInternalRefSelectByValue]
(
@propertyId int ,
@propValue varchar(100) 
)
AS 
BEGIN 

	Select pir.* 
	FROM LibertyPower..PropertyInternalRef pir 
	WHERE pir.propertyId =  @propertyId
		AND pir.Value = @propValue

END 
