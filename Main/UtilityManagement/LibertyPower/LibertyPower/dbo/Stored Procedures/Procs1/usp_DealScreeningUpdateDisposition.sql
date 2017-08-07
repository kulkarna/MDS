CREATE PROCEDURE [dbo].[usp_DealScreeningUpdateDisposition]
	(
	@p_ContractNumber VARCHAR(50),
	@p_StepNumber INT,
	@p_Disposition VARCHAR(50),
	@p_Comment VARCHAR(50) = null
	)
	
AS
	UPDATE dbo.DealScreening 
	SET Disposition = @p_Disposition, 
		Comments = @p_Comment, 
		DateDispositioned = GETDATE()
	WHERE ContractNumber = @p_ContractNumber AND StepNumber = @p_StepNumber

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DealScreeningUpdateDisposition';

