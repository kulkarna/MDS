-- =============================================  
-- Author:  fmedeiros  
-- Create date: 3/23/2013  
-- Description: Insert a new Property Internal Reference  
-- =============================================  
-- exec 
-- =============================================
CREATE PROCEDURE [dbo].[usp_PropertyInternalRefUpdate] 
 @id int  
 ,@value varchar(100)  
 ,@propertyId int  
 ,@propertyTypeId int = null  
 ,@inactive bit  
 ,@modifiedBy int  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 UPDATE LibertyPower..PropertyInternalRef  
  SET Value = @value
	, PropertyId = @propertyId
	, PropertyTypeId = @propertyTypeId
	, Inactive = @inactive
	, Modified = GETDATE()
	, ModifiedBy = @modifiedBy
 WHERE id = @id 

END
