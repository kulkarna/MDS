USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ExternalEntityMapViewByIRSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_ExternalEntityMapViewByIRSelect]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/8/2013
-- Description:	Get External Entity map View
-- =============================================
-- exec LibertyPower..[usp_ExternalEntityMapViewByIRSelect] 3040 , 1, null 
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityMapViewByIRSelect]
	@internalRefId int = null 
	, @intRefPropertyId int = null 
	, @intRefPropertyTypeId int = null 
	, @IncludeInactive bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT  *     
	FROM LibertyPower..vw_ExternalEntityMapping (NOLOCK)
	WHERE 1 =1 
		AND InternalRefID = ISNULL(@internalRefId, InternalRefID ) 
		AND InternalRefPropertyID = ISNULL ( @intRefPropertyId, InternalRefPropertyID ) 
		AND ISNULL(InternalRefPropertyTypeID, 0) = ISNULL ( @intRefPropertyTypeId, ISNULL(InternalRefPropertyTypeID,0) ) 
		
		AND (ExternalEntityInactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (ExtEntityValueInactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (PropertyValueInactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (InternalrefInactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
	
	SET NOCOUNT OFF;			
END
GO