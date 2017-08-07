USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_MarginThresholdSelect]    Script Date: 08/02/2012 17:00:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MarginThresholdSelect]
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	SELECT *
	FROM LibertyPower.[dbo].[MarginThreshold] with (nolock)
	
END	
