USE LibertyPower 
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyInternalRefByValueSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyInternalRefByValueSelect]
GO
-- =============================================    
-- Author:  Gail Mangaroo    
-- Create date: 4/5/2013    
-- Description: Get the Property Inetrnal ref given the value    
-- =============================================  
-- exec   LibertyPower..[usp_PropertyInternalRefByValueSelect] 1, 'J' , 1 
-- =============================================
CREATE PROCEDURE [dbo].[usp_PropertyInternalRefByValueSelect]
(
@propertyId int ,
@propValue varchar(100) 
, @IncludeInactive bit = 0
)
AS 
BEGIN 

	SET NOCOUNT OFF;		
	
	Select pir.* 
	FROM LibertyPower..PropertyInternalRef pir (NOLOCK)
	WHERE pir.propertyId =  @propertyId
		AND pir.Value = @propValue
		AND (pir.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		
	SET NOCOUNT OFF;				
END 
GO 