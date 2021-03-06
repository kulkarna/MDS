USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ExternalEntityByIntRefSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_ExternalEntityByIntRefSelect]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 10/10/2013
-- Description:	Get External Entities mapped to an InternalReference
-- =============================================
-- exec LibertyPower..[usp_ExternalEntityByIntRefSelect] 3040 , 1, null 
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityByIntRefSelect]
	@internalRefId int  
	, @intRefPropertyId int = null 
	, @intRefPropertyTypeId int = null 
	, @IncludeInactive bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT  e.*     
	FROM  LibertyPower..PropertyInternalRef pir (NOLOCK) 
		JOIN  LibertyPower..PropertyValue pv (NOLOCK) ON pv.InternalRefID = pir.ID
		JOIN  LibertyPower..ExternalEntityValue ev (NOLOCK) ON ev.PropertyValueID  = pv.id
		JOIN  LibertyPower..vw_ExternalEntity e (NOLOCK) ON e.id  = ev.ExternalEntityID
		
	WHERE 1 =1 
		AND pir.ID = ISNULL(@internalRefId, pir.ID  ) 
		AND pir.PropertyID = ISNULL ( @intRefPropertyId, pir.PropertyID ) 
		AND ISNULL(pir.PropertyTypeId, 0) = ISNULL ( @intRefPropertyTypeId, ISNULL(pir.PropertyTypeId,0) ) 
		
		AND (pir.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (pv.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (e.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (ev.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated

	SET NOCOUNT OFF;			
END
