-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 4/29/2013
-- Description:	Get Internal References 
-- =============================================
-- exec LibertyPower..usp_PropertyInternalRefByPropSelect 1 , null, 0 
-- ==============================================
CREATE PROCEDURE usp_PropertyInternalRefByPropSelect
(@propertyId int  = null 
 , @propertyTypeId int = null  
 , @IncludeInactive bit = 0 
) 
AS 
BEGIN 
	SELECT pir.* 
	FROM LibertyPower..PropertyInternalRef pir (NOLOCK) 
	WHERE pir.PropertyId = ISNULL(@propertyId , pir.PropertyId ) 
		AND ISNULL(pir.PropertyTypeId, 0) = ISNULL(@propertytypeId , ISNULL(pir.PropertyTypeId, 0) ) 
		-- AND Inactive = 0 
	    AND (pir.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated

END 
