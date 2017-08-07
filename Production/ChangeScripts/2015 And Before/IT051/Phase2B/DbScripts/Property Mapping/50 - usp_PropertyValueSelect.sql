USE LibertyPower 
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyValueSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyValueSelect]
GO

-- =============================================    
-- Author:  Gail Mangaroo    
-- Create date: 4/5/2013    
-- Description: Get the Target Value for the specified Externanl Entity    
-- =============================================    
-- exec LibertyPower..[usp_PropertyValueSelect] 546
-- ==============================================
CREATE PROCEDURE [dbo].[usp_PropertyValueSelect]
(
@Id int = null 
)
AS 
BEGIN 
	SET NOCOUNT ON;		
	
	Select pv.* 
	FROM LibertyPower..PropertyValue pv  (NOLOCK) 
	WHERE pv.ID = ISNULL(@Id, pv.ID) 
	
	SET NOCOUNT OFF;			
END 
GO 