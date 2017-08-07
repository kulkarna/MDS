USE LP_MTM

GO

-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 02/10/2014
-- Description:	Insert execution status on MtMRiskControlExecution table
-- =============================================
CREATE PROCEDURE usp_InsertRiskControlExecStatus
	@guid varchar(50),
	@state smallint,
	@type smallint,
	@errorDescription varchar(500) = null
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO MtMRiskControlExecution ([Guid], [State], [Type], RecordDate, ErrorDescription) VALUES (@guid, @state, @type, GETDATE(), @errorDescription)
    
    SET NOCOUNT OFF;    
END
GO
