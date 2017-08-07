USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyValueMappingRemove]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyValueMappingRemove]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	  
	SET NOCOUNT OFF;		
     
END
GO