use lp_LoadReconciliation
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 01/24/2014
-- Description:	List all reconciliation header
-- =============================================
CREATE PROCEDURE usp_RECONEDI_ListReconciliationHeader
	@p_headerId AS BIGINT = NULL
AS
BEGIN
	SET NOCOUNT ON;

    SELECT * FROM RECONEDI_Header A (NOLOCK)
    WHERE REHID = ISNULL(@p_headerId, REHID)
	
	SET NOCOUNT OFF;
END
GO
