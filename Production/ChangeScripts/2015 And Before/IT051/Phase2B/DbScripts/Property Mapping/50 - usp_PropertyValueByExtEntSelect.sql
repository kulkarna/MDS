USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyValueByExtEntSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyValueByExtEntSelect]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 4/29/2013
-- Description:	Get Property Values mapped to the External Entity
-- =============================================
-- exec LibertyPower..[usp_PropertyValueByExtEntSelect] 8 , 1
-- ============================================
CREATE PROCEDURE [dbo].[usp_PropertyValueByExtEntSelect]
	@externalEntityId int
	, @propertyId int = null
	, @propertyTypeId int = null 
	, @IncludeInactive bit = 0 
	, @sourceExtEntityId int = null 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT  pv.*     
	FROM LibertyPower..ExternalEntityValue eev (NOLOCK)
		JOIN LibertyPower..PropertyValue pv (NOLOCK)
			ON pv.ID = eev.PropertyValueID
		LEFT JOIN ( 
					SELECT pv.* 
					 FROM LibertyPower..ExternalEntityValue eev (NOLOCK)
						JOIN LibertyPower..PropertyValue pv (NOLOCK)
							ON pv.ID = eev.PropertyValueID
					WHERE eev.ExternalEntityID = @sourceExtEntityId
						AND (eev.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
						AND (pv.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
						
				) eev2 ON eev2.InternalRefID = pv.InternalRefID
	WHERE 1 =1 
		AND eev.ExternalEntityID = @externalEntityId
		AND pv.PropertyId = ISNULL ( @propertyId, pv.PropertyId) 
		AND ISNULL(pv.PropertyTypeId, 0) = ISNULL(@propertytypeId , ISNULL(pv.PropertyTypeId, 0) ) 
		
		AND (eev2.InternalRefID IS NOT NULL OR ISNULL(@sourceExtEntityId, 0) = 0 )

		AND (eev.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (pv.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		
	SET NOCOUNT OFF;				
END
GO