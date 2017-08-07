USE [lp_MtM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 11/05/2013
-- Description:	Procedure to return all row from table MtMRiskControlReasons
-- =============================================
CREATE PROCEDURE usp_CPEFailureReasonsList
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		*
	FROM
		MtMRiskControlReasons WITH (nolock)

	SET NOCOUNT OFF;
END
GO
