USE Lp_UtilityManagement
GO

BEGIN TRY 
	BEGIN TRAN
	
	CREATE TABLE #TABLELOOP (ROW INT IDENTITY(1,1) PRIMARY KEY
						,[YEAR]			INT
						,[MONTH]		INT
						,UTILITYCODE	VARCHAR(15)
						,CYCLEREAD		VARCHAR(15)	
						,DATEREAD		DATETIME)

	INSERT INTO #TABLELOOP SELECT 2017, 5, 'AMEREN', '8', '20170509'
	INSERT INTO #TABLELOOP SELECT 2017, 5, 'AMEREN', '9', '20170510'
	INSERT INTO #TABLELOOP SELECT 2017, 9, 'ALLEGMD', '14', '20170915'
	INSERT INTO #TABLELOOP SELECT 2017, 9, 'SHARYLAND', '5', '20170908'
	INSERT INTO #TABLELOOP SELECT 2017, 12, 'SHARYLAND', '9', '20171212'
	INSERT INTO #TABLELOOP SELECT 2017, 6, 'NSTAR-BOS', '8', '20170612'
	INSERT INTO #TABLELOOP SELECT 2017, 6, 'NSTAR-BOS', '9', '20170613'
	INSERT INTO #TABLELOOP SELECT 2017, 6, 'NSTAR-BOS', '10', '20170614'
	INSERT INTO #TABLELOOP SELECT 2017, 6, 'NSTAR-BOS', '11', '20170615'
	INSERT INTO #TABLELOOP SELECT 2017, 6, 'NSTAR-BOS', '12', '20170616'
	INSERT INTO #TABLELOOP SELECT 2017, 6, 'NSTAR-BOS', '13', '20170617'
	INSERT INTO #TABLELOOP SELECT 2017, 6, 'NSTAR-BOS', '14', '20170618'
	INSERT INTO #TABLELOOP SELECT 2017, 6, 'NSTAR-BOS', '15', '20170619'
	INSERT INTO #TABLELOOP SELECT 2017, 6, 'NSTAR-BOS', '16', '20170620'
	INSERT INTO #TABLELOOP SELECT 2017, 6, 'NSTAR-BOS', '17', '20170621'
	INSERT INTO #TABLELOOP SELECT 2017, 7, 'NSTAR-BOS', '1', '20170630'
	INSERT INTO #TABLELOOP SELECT 2017, 11, 'SCE', '56', '20171107'
	INSERT INTO #TABLELOOP SELECT 2017, 1, 'WMECO', '10', '20170116'
	INSERT INTO #TABLELOOP SELECT 2017, 1, 'WMECO', '11', '20170117'
	INSERT INTO #TABLELOOP SELECT 2017, 1, 'WMECO', '12', '20170118'
	INSERT INTO #TABLELOOP SELECT 2017, 1, 'WMECO', '13', '20170119'
	INSERT INTO #TABLELOOP SELECT 2017, 1, 'WMECO', '14', '20170120'

	DECLARE @Loop		INT
		,@Total			INT
		,@UtiltyID		[uniqueidentifier]
		,@YearID		[uniqueidentifier]
		,@MonthID		[uniqueidentifier]
		,@UtiltyCode	VARCHAR(15)
		,@YearIDINT		INT
		,@MonthIDINT	INT
		,@CycleRead		VARCHAR(15)	
		,@DateRead		DATETIME
		,@DateProcess	DATETIME
		
	SELECT @Total			= (SELECT MAX(ROW) FROM #TABLELOOP)
		,@Loop				= 1
		,@DateProcess		= GETDATE()
		
	WHILE @Loop <= @Total 
	BEGIN
		PRINT STR(@Loop)
		
		SELECT @UtiltyCode		= UTILITYCODE
			,@YearIDINT			= [YEAR]
			,@MonthIDINT		= [MONTH]
			,@CycleRead			= CYCLEREAD
			,@DateRead			= DATEREAD
		FROM #TABLELOOP WITH (NOLOCK)
		WHERE [ROW]				= @Loop
		
		SET @UtiltyID		= (SELECT UT.ID FROM UtilityCompany UT WITH (NOLOCK) WHERE UT.UtilityCode = @UtiltyCode)
		SET @YearID			= (SELECT YE.ID FROM [Year] YE WITH (NOLOCK) WHERE YE.[YEAR]= @YearIDINT)
		SET @MonthID		= (SELECT MO.ID FROM [MONTH] MO WITH (NOLOCK) WHERE MO.[MONTH] = @MonthIDINT)

		DELETE Lp_UtilityManagement..meterreadcalendar
		WHERE UtilityId		= @UtiltyID
		AND YearId			= @YearID
		AND MonthId			= @MonthID 
		
		INSERT INTO Lp_UtilityManagement..meterreadcalendar
			([UtilityId],[YearId],[MonthId],[ReadCycleId],[ReadDate],[Inactive],[CreatedDate],[CreatedBy],[LastModifiedDate],[LastModifiedBy])
		SELECT @UtiltyID, @YearID, @MonthID, @CycleRead, @DateRead , 0, @DateProcess, 'Libertypower\jmunoz', @DateProcess, 'Libertypower\jmunoz'
		
		SET @Loop = @Loop  + 1
		
	END

	COMMIT TRAN
	PRINT 'COMMIT'
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
	PRINT 'ROLLBACK'
END CATCH	
