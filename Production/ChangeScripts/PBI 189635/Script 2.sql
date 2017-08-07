
USE WORKSPACE
GO

IF OBJECT_ID('TEMPDB..#TEMP') IS NOT NULL
	DROP TABLE #TEMP


SELECT CAST(ROW_NUMBER() OVER (ORDER BY ID) AS INT) AS RowNumber
	,* 
INTO #TEMP
FROM WorkSpace..TFS_190200_UsageConsolidated_BK_20170620 with (nolock) order by 1


SET NOCOUNT ON

DECLARE @Loop		INT
	,@EndLoop		INT

SELECT @Loop		= 1
	,@EndLoop		= MAX(RowNumber) FROM #TEMP WITH (NOLOCK)

WHILE @Loop	<= @EndLoop
BEGIN

	DELETE lp_transactions..EdiUsageDetail
	OUTPUT DELETED.ID
			,DELETED.EdiAccountID
			,DELETED.PtdLoop
			,DELETED.BeginDate
			,DELETED.EndDate
			,DELETED.Quantity
			,DELETED.MeterNumber
			,DELETED.MeasurementSignificanceCode
			,DELETED.TransactionSetPurposeCode
			,DELETED.UnitOfMeasurement
			,DELETED.TimeStampInsert
			,DELETED.TimeStampUpdate
			,DELETED.EdiFileLogID
	INTO  WorkSpace..TFS_190200_EdiUsageDetail_BK_20170620
	FROM lp_transactions..EdiUsageDetail A WITH (NOLOCK)
	INNER JOIN lp_transactions..EdiAccount EA WITH (NOLOCK)
	ON A.EdiAccountID			= EA.ID
	INNER JOIN #TEMP B WITH (NOLOCK)
	ON B.UtilityCode			= EA.UtilityCode
	AND B.AccountNumber			= EA.AccountNumber
	WHERE A.BeginDate			= B.FromDate
	AND A.EndDate				= B.ToDate
	AND B.RowNumber				= @Loop

	PRINT(STR(@Loop))
	SET @Loop	= @Loop	+ 1
END 

SET NOCOUNT OFF
