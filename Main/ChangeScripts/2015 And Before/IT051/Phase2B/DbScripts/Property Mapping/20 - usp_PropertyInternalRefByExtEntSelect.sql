USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyInternalRefByExtEntSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyInternalRefByExtEntSelect]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 4/26/2013
-- Description:	Get Internal References mapped to the given External entity
-- =============================================
-- exec LibertyPower..[usp_PropertyInternalRefByExtEntSelect] 23 , null ,null , 1
-- =============================================
CREATE PROCEDURE [dbo].[usp_PropertyInternalRefByExtEntSelect]
	@externalEntityId int 
	, @propertyId int = null 
	, @propertyTypeId int = null 
	, @IncludeInactive bit = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT  pir.*     
	FROM LibertyPower..ExternalEntityValue ev (NOLOCK)
		JOIN LibertyPower..PropertyValue pv (NOLOCK)
			ON pv.ID = ev.PropertyValueID 
			AND pv.Inactive = 0 
		JOIN LibertyPower..PropertyInternalRef pir (NOLOCK)
			ON pir.ID = pv.InternalRefID
			AND pir.Inactive = 0 
	WHERE 
		ev.Inactive  = 0
		AND ev.ExternalEntityID = @externalEntityId
		AND pir.PropertyId = ISNULL(@propertyId , pir.PropertyId) 	
		AND ISNULL(pir.PropertyTypeId, 0) = ISNULL(@propertytypeId , ISNULL(pir.PropertyTypeId, 0) ) 

		AND (ev.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (pv.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (pir.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		
	SET NOCOUNT OFF;		
			
END
GO