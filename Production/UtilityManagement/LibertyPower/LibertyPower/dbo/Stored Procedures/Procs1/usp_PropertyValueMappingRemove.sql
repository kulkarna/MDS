-- =============================================      
-- Author:  fmedeiros      
-- Create date: 3/23/2013      
-- Description: Insert a new external entity      
-- =============================================    
-- exec 
-- =============================================  
CREATE PROCEDURE [dbo].[usp_PropertyValueMappingRemove]   
 @extEntityId int      
 ,@propertyValueId int      
AS      
BEGIN      
SET NOCOUNT ON;        
 
--INACTIVATING THE OLD MAPPING      
 UPDATE ExternalEntityValue SET Inactive = 'true'       
 FROM ExternalEntityValue  ee with (nolock)      
 -- JOIN PropertyValue pv with (nolock) 
	--ON ee.PropertyValueID = pv.ID and pv.Inactive = 'false' 
 WHERE      
  ee.ExternalEntityID = @extEntityId    
  and  ee.PropertyValueID = @propertyValueId    
  -- and ee.Inactive = 'false'   
       
END
