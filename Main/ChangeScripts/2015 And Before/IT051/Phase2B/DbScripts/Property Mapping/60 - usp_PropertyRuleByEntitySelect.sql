USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyRuleByEntitySelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyRuleByEntitySelect]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/6/2013
-- Description:	Get Property Rule
-- =============================================
-- exec LibertyPower..[usp_PropertyRuleByEntitySelect]
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
		AND pr.PropertyID = ISNULL ( @propertyId , pr.PropertyID ) 
		
		AND (pr.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated	
		AND (eepr.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated	
		
	SET NOCOUNT OFF;				
END
GO