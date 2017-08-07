
-- =============================================    
-- Author:  Gail Mangaroo    
-- Create date: 4/5/2013    
-- Description: Get the Target Value for the specified Externanl Entity    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_PropertyTargetValueSelectByIntVal]
(
@propertyId int ,
@propertyValue varchar(100) , 
@extEntityId int
)
AS 
BEGIN 

	Select pv.* 
	FROM LibertyPower..PropertyInternalRef pir 
		JOIN LibertyPower..PropertyValue pv on pv.InternalRefID = pir.ID 
		JOIN LibertyPower..ExtEntityValue ev on ev.PropertyValueID = pv.ID  
		JOIN LibertyPower..ExternalEntity ee on ee.ID = ev.ExtEntityID  
	WHERE pir.propertyId =  @propertyId
		AND pir.Value = @propertyValue
		AND ee.ID = @extEntityId

END 
