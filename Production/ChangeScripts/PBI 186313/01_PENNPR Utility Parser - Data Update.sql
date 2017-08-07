	USE Workspace
	GO

	IF OBJECT_ID('tempdb..#AllAccounts') IS NOT NULL
	DROP TABLE #AllAccounts
		
	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY AccountNumber) AS RowNumber, 
				MAX(ID) AS MaxID, 
				AccountNumber 
	INTO #AllAccounts FROM EdiAccount(nolock) WHERE UtilityCode = 'PENNPR'
	GROUP BY AccountNumber

	SELECT * FROM #AllAccounts(nolock) INNER JOIN EdiUsageDetail(nolock) 
	ON #AllAccounts.MaxID = EdiUsageDetail.EdiAccountID

	--Backing up data
	IF OBJECT_ID('Workspace..TFS_189693_Backup') IS NOT NULL
	DROP TABLE Workspace..TFS_189693_Backup

	SELECT * INTO Workspace..TFS_189693_Backup FROM #AllAccounts(nolock) INNER JOIN EdiUsageDetail(nolock) 
	ON #AllAccounts.MaxID = EdiUsageDetail.EdiAccountID
	--------------

	Delete a FROM EdiUsageDetail a
       INNER JOIN #AllAccounts b 
       ON b.MaxID = a.EdiAccountID
       where a.BeginDate > '2015-01-01'

	



