USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyInternalRefByPropSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyInternalRefByPropSelect]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

	SET NOCOUNT ON;		
	
	SELECT pir.* 
	FROM LibertyPower..PropertyInternalRef pir (NOLOCK) 
	WHERE pir.PropertyId = ISNULL(@propertyId , pir.PropertyId ) 
		AND ISNULL(pir.PropertyTypeId, 0) = ISNULL(@propertytypeId , ISNULL(pir.PropertyTypeId, 0) ) 
		-- AND Inactive = 0 
	    AND (pir.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated

	SET NOCOUNT OFF;		
END 