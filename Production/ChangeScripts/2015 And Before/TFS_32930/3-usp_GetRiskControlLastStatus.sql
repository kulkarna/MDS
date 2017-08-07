USE LP_MTM
GO

-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 02/10/2014
-- Description: Get the last status of a guid execution
-- =============================================
CREATE PROCEDURE usp_GetRiskControlLastStatus
	@guid varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT TOP 1 * FROM MtMRiskControlExecution (NOLOCK) WHERE [Guid] = @guid ORDER BY RecordDate DESC

	SET NOCOUNT OFF;    
END
GO