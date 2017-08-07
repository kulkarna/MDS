USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ExternalEntityTypeByPropSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_ExternalEntityTypeByPropSelect]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/6/2013
-- Description:	Get external enity type
-- =============================================
-- exec LibertyPower..[usp_ExternalEntityTypeByPropSelect] 2
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityTypeByPropSelect]
(	@propertyId int
	, @IncludeInactive bit = 0 
)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT eet.*
	FROM LibertyPower..ExternalEntityType eet (NOLOCK) 
		JOIN LibertyPower..PropertyTypeEntityTypeMap ptet (NOLOCK) 
			ON eet.ID = ptet.ExternalEntityTypeID
	WHERE ptet.PropertyID = @propertyId
		AND (eet.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated

	SET NOCOUNT OFF;			
END
GO