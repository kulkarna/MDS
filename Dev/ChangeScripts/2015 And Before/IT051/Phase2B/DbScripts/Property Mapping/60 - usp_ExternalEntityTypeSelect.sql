USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ExternalEntityTypeSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_ExternalEntityTypeSelect]
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
-- exec LibertyPower..[usp_ExternalEntityTypeSelect] 3
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityTypeSelect]
	@Id int = null
AS
BEGIN
	SET NOCOUNT ON;

    SELECT *
	FROM LibertyPower..ExternalEntityType  (NOLOCK)
	WHERE ID = ISNULL(@Id, ID)
			
	SET NOCOUNT OFF;
END
GO