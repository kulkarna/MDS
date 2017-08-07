-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/6/2013
-- Description:	Get Property Rule
-- =============================================
CREATE PROCEDURE [dbo].[usp_PropertyRuleByEntitySelect]
	 @externalEntityId int = null
	, @propertyId int = null 
	, @IncludeInactive bit = 0 
AS
BEGIN
	SET NOCOUNT ON;

    SELECT pr.*
	FROM LibertyPower..PropertyRule pr (NOLOCK) 
		JOIN LibertyPower..ExternalEntityPropertyRule eepr (NOLOCK) 
			ON pr.ID = eepr.PropertyRuleID
	WHERE eepr.ExternalEntityID = ISNULL ( @externalEntityId, eepr.ExternalEntityID)
		AND eepr.PropertyID = ISNULL ( @propertyId , eepr.PropertyID ) 
		
		AND (pr.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated	
		AND (eepr.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated	
END
