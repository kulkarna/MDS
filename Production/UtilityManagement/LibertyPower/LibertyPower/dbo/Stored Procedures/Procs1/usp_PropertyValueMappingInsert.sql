-- =============================================    
-- Author:  fmedeiros    
-- Create date: 3/23/2013    
-- Description: Insert a new external entity    
-- =============================================    
-- exec 
-- =============================================
CREATE PROCEDURE [dbo].[usp_PropertyValueMappingInsert]    
 @extEntityId int    
 ,@propertyValueId int    
 ,@propInternalRef int    
 ,@createdBy int    
AS    
BEGIN    
SET NOCOUNT ON;    
   
 DECLARE @OldMappingCount int = 0;  
    
 --FIND THE SAME MAPPIGN INACTIVATED    
 SELECT    
  @OldMappingCount = COUNT(*)   
 FROM LibertyPower..ExternalEntityValue  (NOLOCK)
 WHERE  
	ExternalEntityID = @extEntityId  
	AND PropertyValueID = @propertyValueId  
	--AND Inactive = 'true'  
   
 IF @OldMappingCount = 0  
 BEGIN  
  --INSERTING THE NEW MAPPING    
  INSERT INTO LibertyPower..ExternalEntityValue   
  (ExternalEntityID, PropertyValueID, Inactive, DateCreated, CreatedBy)    
  VALUES    
  (@extEntityId, @PropertyValueId, 'false', GETDATE(), @createdBy)    
 END  
 ELSE  
 BEGIN  
  --RECOVERING A OLD MAPPING    
  UPDATE LibertyPower..ExternalEntityValue  
  SET Inactive = 'false'     
  WHERE  
   ExternalEntityID = @extEntityId  
   AND PropertyValueID = @propertyValueId  
   AND Inactive = 'true'  
 END  
    
END
