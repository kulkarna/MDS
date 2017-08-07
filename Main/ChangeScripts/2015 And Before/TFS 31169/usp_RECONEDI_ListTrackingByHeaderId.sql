
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 01/24/2014
-- Description:	Lis all tracking by reconciliation header ID
-- =============================================
CREATE PROCEDURE usp_RECONEDI_ListTrackingByHeaderId
	@p_headerId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM RECONEDI_Tracking A (NOLOCK) WHERE A.REHID = @p_headerId
	
	SET NOCOUNT OFF;
END
GO
