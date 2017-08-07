USE [Workspace]

DECLARE @TmpAccNumber varchar(50)
DECLARE @TmpFromDate DATETIME
DECLARE @TmpToDate DATETIME
DECLARE @CountOfTimesCombination int
DECLARE @MaxNumber int
DECLARE @Counter int
DECLARE @SetUsageId bigint
DECLARE @TotalKwhRow int
DECLARE @UsageType smallint
DECLARE @CountDuplicated tinyint
DECLARE @CurrentAccount varchar(50)
DECLARE @CurrentUtility varchar(50)
DECLARE @MeterNumber varchar(50)
DECLARE @MaxAllAccountsNumber int
DECLARE @AllAccountsCounter int

IF OBJECT_ID('tempdb..#Accounts') IS NOT NULL
	DROP TABLE #Accounts
IF OBJECT_ID('tempdb..#UsageAccounts') IS NOT NULL
	DROP TABLE #UsageAccounts
IF OBJECT_ID('tempdb..#Result') IS NOT NULL
	DROP TABLE #Result

SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY AccountNumber) AS RowNumber,
	AccountNumber
	INTO #Accounts
	FROM Workspace..TFS_189365_DuplicatedUsageAccounts (NOLOCK)
	WHERE UtilityCode = 'COMED'
		AND Active = 1
	GROUP BY AccountNumber

SET @MaxAllAccountsNumber = (SELECT MAX(RowNumber) FROM #Accounts(NOLOCK))
SET @AllAccountsCounter = 1

WHILE(@AllAccountsCounter <= @MaxAllAccountsNumber)
BEGIN
	SET @CurrentAccount = (SELECT AccountNumber FROM #Accounts(NOLOCK) WHERE RowNumber = @AllAccountsCounter)

	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY UC.ID DESC) AS RowNumber,
		ID,
		AccountNumber,
		FromDate,
		ToDate,
		MeterNumber,
		TotalKwh,
		UsageType,
		Active
		INTO #UsageAccounts FROM Libertypower..UsageConsolidated (NOLOCK) UC
		WHERE UC.UtilityCode IN('COMED')
			AND AccountNumber = @CurrentAccount
			AND Active = 1

	SET @MaxNumber = (SELECT MAX(RowNumber) FROM #UsageAccounts (NOLOCK))
	SET @Counter = 1

	WHILE(@Counter <= @MaxNumber)
	BEGIN 
		SELECT @TmpAccNumber = AccountNumber,
			@TmpFromDate = FromDate,
			@TmpToDate = ToDate,
			@MeterNumber = MeterNumber,
			@SetUsageId = ID,
			@TotalKwhRow = TotalKwh,
			@UsageType = UsageType
			FROM #UsageAccounts (NOLOCK)
			WHERE RowNumber = @Counter

			SET @CountOfTimesCombination = (SELECT COUNT(*) FROM #UsageAccounts (NOLOCK)
				WHERE AccountNumber = @TmpAccNumber
					AND FromDate = @TmpFromDate
					AND ToDate = @TmpToDate
					AND TotalKwh = @TotalKwhRow)

			IF(@CountOfTimesCombination > 1)
			BEGIN
				IF OBJECT_ID('tempdb..#Result') IS NOT NULL
					DROP TABLE #Result
				
				SELECT * INTO #Result
					FROM #UsageAccounts(NOLOCK)
					WHERE AccountNumber = @TmpAccNumber
					AND FromDate = @TmpFromDate
					AND ToDate = @TmpToDate
					AND TotalKwh = @TotalKwhRow
			
				SET @CountDuplicated = (SELECT COUNT(*) FROM #Result (NOLOCK))
		
				IF(@CountDuplicated > 1)
					BEGIN					
						DELETE UC
							FROM Libertypower..UsageConsolidated (NOLOCK) UC
								INNER JOIN #Result (NOLOCK) ON UC.ID = #Result.ID
							WHERE UC.ID IN (SELECT #Result.ID FROM #Result (NOLOCK))
								AND UC.MeterNumber IN (SELECT #Result.MeterNumber FROM #Result (NOLOCK))
								AND UC.MeterNumber <> ''
						
						DELETE FROM #Result WHERE MeterNumber <> ''	
						BREAK;
				END
		END

		SET @Counter = @Counter + 1
			
	END

	IF OBJECT_ID('tempdb..#UsageAccounts') IS NOT NULL
				DROP TABLE #UsageAccounts
	SET @AllAccountsCounter = @AllAccountsCounter + 1
END