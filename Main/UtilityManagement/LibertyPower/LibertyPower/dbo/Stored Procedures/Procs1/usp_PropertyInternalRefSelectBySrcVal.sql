-- =============================================    
-- Author:  Gail Mangaroo    
-- Create date: 4/5/2013    
-- Description: Get the Target Value for the specified Externanl Entity    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_PropertyInternalRefSelectBySrcVal]
(
@propertyId int ,
@srcEntityId int ,
@srcValue varchar(100) 
)
AS 
BEGIN 

	Select pir.* 
	FROM LibertyPower..PropertyInternalRef pir 
		JOIN LibertyPower..PropertyValue srcPV on srcPV.InternalRefID = pir.ID 
		JOIN LibertyPower..ExtEntityValue srcEV on srcEV.PropertyValueID = srcPV.ID  
		JOIN LibertyPower..ExternalEntity srcEE on srcEE.ID = srcEV.ExtEntityID  

	WHERE pir.propertyId =  @PropertyId
		AND srcEE.ID = @srcEntityId
		AND srcPV.Value = @srcValue

END 
