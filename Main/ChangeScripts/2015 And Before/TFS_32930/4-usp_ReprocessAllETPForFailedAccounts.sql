USE LP_MTM
GO

-- =============================================
-- Author:		Felipe Medeiros	
-- Create date: 02/07/2014
-- Description:	Procedure to re-process all failed ETP status account on MtM
-- =============================================
CREATE PROCEDURE usp_ReprocessAllETPForFailedAccounts 
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	DISTINCT 
		QuoteNumber, 
		BatchNumber
	INTO #Batches
	FROM	
		MtMZainetAccountInfo i (nolock)
		INNER JOIN MtMAccount m (nolock)	ON (i.AccountID=m.AccountID	AND i.ContractID=m.ContractID)
	WHERE	
		ISNULL(i.BackToBack,0)=0
		AND i.ZainetEndDate >= DATEADD(D, 0, DATEDIFF(D, 0, GETDATE()))
		AND i.IsDaily = 1
		AND m.Status = 'Failed (ETP)'

	DECLARE	@QuoteNumber VARCHAR(50), @BatchNumber VARCHAR(50) 
	DECLARE CursorBatches CURSOR FAST_FORWARD
	
	FOR
	SELECT	
		QuoteNumber, 
		BatchNumber
	FROM
		#Batches

	OPEN CursorBatches
	FETCH NEXT FROM CursorBatches
	INTO @QuoteNumber, @BatchNumber

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC usp_MtMEnergyTransferPriceCreate @BatchNumber, @QuoteNumber, '1/1/1900'
		EXEC usp_MtMAccountETPStatusUpdate 'ETPd', 'Failed (ETP)', @BatchNumber, @QuoteNumber

		FETCH	NEXT FROM CursorBatches
		INTO	@QuoteNumber, @BatchNumber
	END
	CLOSE	CursorBatches
	DEALLOCATE CursorBatches

	DROP TABLE #Batches

	SET NOCOUNT OFF;
END
GO
