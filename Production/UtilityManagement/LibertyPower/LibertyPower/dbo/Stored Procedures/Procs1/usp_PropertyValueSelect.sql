
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

	Select pv.* 
	FROM LibertyPower..PropertyValue pv  (NOLOCK) 
	WHERE pv.ID = ISNULL(@Id, pv.ID) 
END 
