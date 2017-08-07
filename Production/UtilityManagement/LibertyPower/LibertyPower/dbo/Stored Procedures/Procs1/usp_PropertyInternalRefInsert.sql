-- =============================================  
-- Author:  fmedeiros  
-- Create date: 3/23/2013  
-- Description: Insert a new Property Internal Reference  
-- =============================================  
-- exec 
-- =============================================
CREATE PROCEDURE [dbo].[usp_PropertyInternalRefInsert]  
 @value varchar(100)  
 ,@propertyId int  
 ,@propertyTypeId int = null  
 ,@inactive bit  
 ,@createdBy int  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 INSERT INTO PropertyInternalRef  
 (Value, PropertyId, PropertyTypeId, Inactive, DateCreated, CreatedBy)  
 VALUES  
 (@value, @propertyId, @propertyTypeId, @inactive, GETDATE(), @createdBy)  
          
    SELECT SCOPE_IDENTITY();  
END
