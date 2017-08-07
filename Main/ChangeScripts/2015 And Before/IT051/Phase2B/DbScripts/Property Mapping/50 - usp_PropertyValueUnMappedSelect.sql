USE LibertyPower 
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyValueUnMappedSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyValueUnMappedSelect]
GO

-- =============================================    
-- Author:  Gail Mangaroo    
-- Create date: 4/5/2013    
-- Description: Get the Target Value for the specified Externanl Entity    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_PropertyValueUnMappedSelect]
( @propertyId int = null, 
	@propertyTypeID int = null
	, @IncludeInactive bit = 0 
)

AS 
BEGIN 

	SET NOCOUNT ON;		
	
	Select distinct pv.* 
	FROM LibertyPower..PropertyValue pv (NOLOCK) 
	WHERE ISNULL (pv.InternalRefID, 0 ) = 0  
		AND pv.PropertyId = ISNULL ( @propertyId , pv.PropertyId ) 
		AND ISNULL(pv.PropertyTypeId, 0) = ISNULL(@propertytypeId , ISNULL(pv.PropertyTypeId, 0) ) 
		AND (pv.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated

	SET NOCOUNT OFF;				
END 
GO 