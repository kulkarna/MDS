

-- =============================================    
-- Author:  Gail Mangaroo    
-- Create date: 4/5/2013    
-- Description: Get the Target Value for the specified Externanl Entity    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_PropertyTargetValueSelectBySrcVal]
(
@propertyId int ,
@srcEntityId int ,
@srcValue varchar(100) , 
@trgtEntityId int 
)
AS 
BEGIN 

	Select tgtPV.* 
	FROM LibertyPower..PropertyInternalRef pir 
		JOIN LibertyPower..PropertyValue srcPV on srcPV.InternalRefID = pir.ID 
		JOIN LibertyPower..ExtEntityValue srcEV on srcEV.PropertyValueID = srcPV.ID  
		JOIN LibertyPower..ExternalEntity srcEE on srcEE.ID = srcEV.ExtEntityID  
		
		JOIN LibertyPower..PropertyValue tgtPV on tgtPV.InternalRefID = pir.ID 
		JOIN LibertyPower..ExtEntityValue tgtEV on tgtEV.PropertyValueID = tgtPV.ID  
				
	WHERE pir.propertyId =  @PropertyId
		AND srcEE.ID = @srcEntityId
		AND srcPV.Value = @srcValue
		AND tgtEV.ExtEntityID =  @trgtEntityId 

END 
