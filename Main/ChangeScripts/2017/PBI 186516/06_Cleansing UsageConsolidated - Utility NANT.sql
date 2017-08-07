use Workspace

DECLARE @TmpAccNumber varchar(50)
DECLARE @TmpFromDate DATETIME
DECLARE @TmpToDate DATETIME
DECLARE @SumOfQuantities decimal(15,5)
DECLARE @TempUsageID bigint
DECLARE @CountOfTimesCombination int
DECLARE @CountOfRowsDuplicated int
DECLARE @MaxNumber int
DECLARE @Counter int
DECLARE @TmpTotal int

DECLARE @CounterAccounts int
DECLARE @MaxNumberAccounts int
DECLARE @ActualAccount varchar(50)


IF OBJECT_ID('Workspace..UsageConsolidated_NANT') IS NOT NULL
		DROP TABLE Workspace..UsageConsolidated_NANT

SELECT * INTO Workspace..UsageConsolidated_NANT FROM Libertypower..UsageConsolidated uc
WHERE uc.UtilityCode = 'NANT'

SET @CounterAccounts = 1

IF OBJECT_ID('tempdb..#MYTEMPRESULT') IS NOT NULL
		DROP TABLE #MYTEMPRESULT

IF OBJECT_ID('tempdb..#AccountsOfUtility') IS NOT NULL
DROP TABLE #AccountsOfUtility

SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY UC.ID DESC) AS RowNumber, AccountNumber INTO #AccountsOfUtility 
FROM Libertypower..UsageConsolidated(nolock) UC WHERE UC.UtilityCode IN ('NANT')
ORDER BY RowNumber

SET @MaxNumberAccounts = (SELECT MAX(RowNumber) FROM #AccountsOfUtility)

WHILE(@CounterAccounts <= @MaxNumberAccounts)
BEGIN 

	IF OBJECT_ID('tempdb..#Combinations') IS NOT NULL
		DROP TABLE #Combinations

	IF OBJECT_ID('tempdb..#AllRows') IS NOT NULL
		DROP TABLE #AllRows

	SET @ActualAccount = (SELECT AccountNumber FROM #AccountsOfUtility WHERE RowNumber = @CounterAccounts)

	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY UC.ID DESC) AS RowNumber,  ID, AccountNumber, FromDate, ToDate INTO #Combinations FROM Libertypower..UsageConsolidated(nolock) UC
WHERE UC.UtilityCode IN('NANT') AND AccountNumber = @ActualAccount

SELECT RowNumber, uc.AccountNumber, cm.ID, cm.FromDate, cm.ToDate, uc.TotalKwh INTO #AllRows FROM #Combinations cm INNER JOIN Libertypower..UsageConsolidated uc 
ON uc.ID = cm.ID WHERE uc.UtilityCode = 'NANT' 
ORDER BY RowNumber

SET @MaxNumber = (SELECT MAX(RowNumber) FROM #Combinations)

SET @Counter = 1

WHILE(@Counter <= @MaxNumber)
BEGIN 
	SELECT @TmpAccNumber = AccountNumber, @TmpFromDate = FromDate, @TmpToDate = ToDate FROM #Combinations WHERE RowNumber = @Counter

	SET @CountOfTimesCombination = (SELECT COUNT(*) FROM #AllRows
	WHERE AccountNumber = @TmpAccNumber AND FromDate = @TmpFromDate AND ToDate = @TmpToDate)
	
	IF(@CountOfTimesCombination > 1)
	BEGIN
					
					SELECT * INTO #MYTEMPRESULT
					FROM #AllRows WHERE AccountNumber = @TmpAccNumber AND FromDate = @TmpFromDate AND ToDate = @TmpToDate

					SET @TempUsageID = (SELECT  TOP 1 ID FROM #MYTEMPRESULT)

					SET @TmpTotal = (SELECT SUM(TotalKwh) FROM #MYTEMPRESULT)

					UPDATE Libertypower..UsageConsolidated
					SET TotalKwh = @TmpTotal, 
					MeterNumber = '' 
					WHERE ID = @TempUsageID

					DELETE #MYTEMPRESULT WHERE ID = @TempUsageID 

					--DELETE uc
					--FROM Workspace..UsageConsolidated20170607 uc INNER JOIN ##MYTEMPRESULT ON uc.ID = ##MYTEMPRESULT.ID
					--WHERE uc.ID IN (SELECT ##MYTEMPRESULT.ID FROM ##MYTEMPRESULT)

					DELETE uc
					FROM Libertypower..UsageConsolidated uc INNER JOIN #MYTEMPRESULT ON uc.ID = #MYTEMPRESULT.ID
					WHERE uc.ID IN (SELECT #MYTEMPRESULT.ID FROM #MYTEMPRESULT)
	END

	IF OBJECT_ID('tempdb..#MYTEMPRESULT') IS NOT NULL
		DROP TABLE #MYTEMPRESULT

	
	SET @Counter = @Counter + 1

	PRINT 'Counter is in ' +  CAST(@Counter AS VARCHAR)
END

	
	PRINT 'Finished Account ' + @ActualAccount + ' with RowNumber ' + CAST(@CounterAccounts AS VARCHAR)
	SET @CounterAccounts = @CounterAccounts + 1	
END

