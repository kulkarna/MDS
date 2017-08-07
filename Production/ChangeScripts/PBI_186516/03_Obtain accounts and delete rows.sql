USE Libertypower

BEGIN TRY
	BEGIN TRANSACTION

--Step 2
IF OBJECT_ID('tempdb..#AllActiveAccounts') IS NOT NULL
    DROP TABLE #AllActiveAccounts

IF OBJECT_ID('tempdb..#AllAccounts') IS NOT NULL
	DROP TABLE #AllAccounts
	
SELECT DISTINCT AccountNumber,FromDate, UtilityCode,  COUNT(FromDate) AS CountFromDate INTO #AllActiveAccounts
FROM Libertypower..UsageConsolidated(nolock) UC
WHERE UC.UtilityCode IN ('BANGOR','CL&P','CMP', 'MECO', 'NANT', 'NECO', 'NSTAR-BOS', 'NSTAR-CAMB', 'NSTAR-COMM', 'UI', 'UNITIL', 'WMECO') AND Active = 1
GROUP BY AccountNumber, FromDate, UtilityCode
HAVING COUNT(FromDate) > 1

SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY AccountNumber DESC) AS RowNumber, AccountNumber, UtilityCode INTO #AllAccounts FROM #AllActiveAccounts
GROUP BY AccountNumber, UtilityCode

--Step 3
DELETE uc FROM 
Libertypower..UsageConsolidated uc INNER JOIN #AllAccounts ac ON uc.AccountNumber = ac.AccountNumber AND uc.UtilityCode = ac.UtilityCode
WHERE uc.FromDate >= DATEADD(day, -730, GETDATE())

	
COMMIT
PRINT 'COMMIT TRAN'
END TRY
BEGIN CATCH
	SELECT  
		ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage;  
	ROLLBACK TRAN
	PRINT 'ROLLBACK TRAN'
END CATCH