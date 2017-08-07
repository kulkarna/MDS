USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyInternalRefInsert]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyInternalRefInsert]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	SET NOCOUNT OFF;		    
END
GO