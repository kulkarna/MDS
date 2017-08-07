USE LibertyPower 
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyValueByIntValSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyValueByIntValSelect]
GO

-- =============================================    
-- Author:  Gail Mangaroo    
-- Create date: 4/5/2013    
-- Description: Get the Target Value for the specified Externanl Entity    
-- =============================================    
-- exec LibertyPower..[usp_PropertyValueByIntValSelect] 1, 'J' , null , 1
-- =============================================
CREATE PROCEDURE [dbo].[usp_PropertyValueByIntValSelect]
(
@propertyId int ,
@internalValue varchar(100) , 
@extEntityId int = null 
, @IncludeInactive bit = 0 
)
AS 
BEGIN 
	
	SET NOCOUNT ON;		
	
	Select pv.* 
	FROM LibertyPower..PropertyInternalRef pir  (NOLOCK) 
		JOIN LibertyPower..PropertyValue pv  (NOLOCK) 
			ON pv.InternalRefID = pir.ID 
		JOIN LibertyPower..ExternalEntityValue ev  (NOLOCK) 
			ON ev.PropertyValueID = pv.ID  
	WHERE pir.propertyId =  @propertyId
		AND pir.Value = @internalValue
		AND ev.ExternalEntityID = ISNULL(@extEntityId , ExternalEntityID) 
		
		AND (pir.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (pv.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (ev.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		
	SET NOCOUNT OFF;				
END 
GO 