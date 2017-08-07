USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyInternalRefUpdate]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyInternalRefUpdate]
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
	 
 	SET NOCOUNT OFF;		

END
GO