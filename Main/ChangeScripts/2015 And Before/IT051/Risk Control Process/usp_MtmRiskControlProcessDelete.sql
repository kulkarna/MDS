USE [lp_MtM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 10/31/2013
-- Description:	Delete all info from MtmRiskControlProcess
-- =============================================
CREATE PROCEDURE usp_MtmRiskControlProcessDelete 
AS
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM MtmRiskControlProcess

	SET NOCOUNT OFF;
END
GO
