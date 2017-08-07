USE Workspace
GO

SET NOCOUNT ON

IF OBJECT_ID('TEMPDB..#UtilityTable') IS NOT NULL
	DROP TABLE #UtilityTable

CREATE TABLE #UtilityTable (RowNumber		INT IDENTITY(1,1) PRIMARY KEY
							,UtilityCode	VARCHAR(15))

INSERT INTO #UtilityTable (UtilityCode) VALUES ('COMED'), ('AEPNO'),('ONCOR'),('ACE'),('ALLEGMD'),('BGE'),('CENHUD'),('DELDE')
											,('DELMD'),('DUQ'),('JCP&L'),('NYSEG'),('O&R'),('ORNJ'),('PEPCO-DC'),('PEPCO-MD')
											,('PGE'),('PPL'),('PSEG'),('RGE'),('SDGE'),('UGI'),('METED'),('PENELEC'),('PENNPR')
											,('WPP'),('OHP'),('CSP'),('CEI'),('TOLED'),('OHED')

DECLARE @UtlilityLoop		INT
	,@UtlilityEndLoop		INT
	,@UtilityCode			VARCHAR(15)
	,@Loop					INT
	,@EndLoop				INT

SELECT @UtlilityLoop		= 1 
	,@UtlilityEndLoop		=  MAX(A.RowNumber) FROM #UtilityTable A WITH (NOLOCK)

WHILE @UtlilityLoop <= @UtlilityEndLoop
BEGIN

	SELECT @UtilityCode	= UtilityCode
	FROM #UtilityTable A WITH (NOLOCK)
	WHERE A.RowNumber	= @UtlilityLoop
	
	PRINT @UtilityCode
	
	INSERT INTO WorkSpace..TFS_190200_UsageConsolidated_BK_20170620 (ID, UtilityCode,AccountNumber,UsageType,UsageSource,FromDate,ToDate
															,TotalKwh,DaysUsed,Created,CreatedBy,Modified,Active,ReasonCode,MeterNumber
															,OnPeakKWh,OffPeakKWh,IntermediateKwh,BillingDemandKW,MonthlyPeakDemandKW,MonthlyOffPeakDemandKw)
	SELECT UC.ID, UC.UtilityCode, UC.AccountNumber, UC.UsageType, UC.UsageSource, UC.FromDate, UC.ToDate
		,UC.TotalKwh, UC.DaysUsed, UC.Created, UC.CreatedBy, UC.Modified, UC.Active, UC.ReasonCode, UC.MeterNumber
		,UC.OnPeakKWh, UC.OffPeakKWh, UC.IntermediateKwh, UC.BillingDemandKW, UC.MonthlyPeakDemandKW, UC.MonthlyOffPeakDemandKw 
	FROM libertypower..UsageConsolidated UC WITH (NOLOCK)
	INNER JOIN workspace..TFS_190200_DuplicatedUsage AA WITH (NOLOCK)
	ON AA.UtilityCode			= UC.UtilityCode
	AND AA.AccountNumber		= UC.AccountNumber
	WHERE AA.UtilityCode		= @UtilityCode
	AND UC.ToDate				> '2015-05-01'
	AND EXISTS (SELECT NULL FROM libertypower..UsageConsolidated UCA WITH (NOLOCK)
				WHERE UCA.UtilityCode		= UC.UtilityCode
				AND UCA.AccountNumber		= UC.AccountNumber
				AND UCA.FromDate			= UC.FromDate
				AND UCA.MeterNumber			<> UC.MeterNumber
				AND UCA.ID					<> UC.ID)

	BEGIN TRY
		BEGIN TRAN
		DELETE libertypower..UsageConsolidated
		FROM libertypower..UsageConsolidated A
		INNER JOIN WorkSpace..TFS_190200_UsageConsolidated_BK_20170620 B WITH (NOLOCK)
		ON B.ID					= A.ID
		WHERE B.UtilityCode		= @UtilityCode

		IF OBJECT_ID('TEMPDB..#TempEdiUsageDetailRemove') IS NOT NULL
			DROP TABLE #TempEdiUsageDetailRemove

		SELECT CAST(ROW_NUMBER() OVER (ORDER BY ID) AS INT) AS RowNumber
			,A.* 
		INTO #TempEdiUsageDetailRemove
		FROM WorkSpace..TFS_190200_UsageConsolidated_BK_20170620 A WITH (NOLOCK) 
		WHERE A.UtilityCode			= @UtilityCode
		ORDER BY 1

		SELECT @Loop		= 1
			,@EndLoop		= MAX(RowNumber) FROM #TempEdiUsageDetailRemove WITH (NOLOCK)

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
			INNER JOIN #TempEdiUsageDetailRemove B WITH (NOLOCK)
			ON B.UtilityCode			= EA.UtilityCode
			AND B.AccountNumber			= EA.AccountNumber
			WHERE A.BeginDate			= B.FromDate
			AND A.EndDate				= B.ToDate
			AND B.RowNumber				= @Loop

			PRINT(STR(@Loop))
			SET @Loop	= @Loop	+ 1
		END 

		COMMIT TRAN
		PRINT ('COMMIT')
	END TRY
	BEGIN CATCH
		SELECT  ERROR_NUMBER()	AS ErrorNumber  
			,ERROR_SEVERITY()	AS ErrorSeverity  
			,ERROR_STATE()		AS ErrorState  
			,ERROR_PROCEDURE()	AS ErrorProcedure  
			,ERROR_LINE()		AS ErrorLine  
			,ERROR_MESSAGE()	AS ErrorMessage; 
		ROLLBACK TRAN
		PRINT ('ROLLBACK')
	END CATCH

	SET @UtlilityLoop = @UtlilityLoop + 1 
END

IF OBJECT_ID('WorkSpace..TFS_190200_AccountToReprocess') IS NOT NULL
	DROP TABLE TFS_190200_AccountToReprocess

SELECT DISTINCT A.UtilityCode
	,A.AccountNumber
	,AA.AccountID
	,CAST(0 AS BIT) AS ProcessFlag 
INTO WorkSpace..TFS_190200_AccountToReprocess
FROM WorkSpace..TFS_190200_UsageConsolidated_BK_20170620 A WITH (NOLOCK) 
LEFT JOIN Libertypower..Utility UT WITH (NOLOCK)
ON UT.UtilityCode		= A.UtilityCode
LEFT JOIN Libertypower..Account AA WITH (NOLOCK)
ON AA.UtilityID			= UT.ID
AND AA.AccountNumber	= A.AccountNumber
ORDER BY AccountNumber

IF OBJECT_ID('TEMPDB..#UtilityTable') IS NOT NULL
	DROP TABLE #UtilityTable

SET NOCOUNT OFF
