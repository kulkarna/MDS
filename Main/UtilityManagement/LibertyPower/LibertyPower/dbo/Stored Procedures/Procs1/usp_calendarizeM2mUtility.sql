
/*******************************************************************************
 * usp_calendarizeM2mUtility
 * Calendirizes multiple meter accounts for mark to market; ameren reset takes
 *		about 45 mins to complete..
 *
 * History
 *		10/27/2011 - changed the name of the temp table + of the cursor..
 *		11/08/2011 (fcj) - added logic for single month meter reads..
 *		04/04/2012 - per Luca, adding indexes on temp tables..
 *		05/30/2012 - per Ignacio's request, allow user uploaded records..
 *******************************************************************************
 * 10/19/2011 - Eduardo Patino
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_calendarizeM2mUtility]
	@deal			VARCHAR (70),
	@utilityCode	VARCHAR (50)
AS

BEGIN

	SET NOCOUNT ON;

	INSERT INTO	lp_historical_info..zMtM_Tracking (loop, row_count, account_number) VALUES ('calendarizeM2mUtility (start) - ' + @utilityCode, @@ROWCOUNT, @deal)
	print '' print '* ' + lp_historical_info.dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + ' calendarizeM2mUtility (start)..'

--	select * from sys.procedures where name = 'usp_calendarizeM2mUtility'
--	SET NOCOUNT ON;	DECLARE	@deal VARCHAR (70), @utilityCode	VARCHAR (50)	set @deal = 'MTM MISO (11-2011) 7052'	set @utilityCode = 'AMEREN'
	DECLARE	@billed				SMALLINT,
			@historical			SMALLINT,
			@user				SMALLINT,
			@utilityEstimate	SMALLINT,
			@usr				VARCHAR (30)

	SELECT	@billed = value FROM libertypower..usagetype WHERE description = 'billed'
	SELECT	@historical = value FROM libertypower..usagetype WHERE description = 'historical'
	SELECT	@utilityEstimate = value FROM libertypower..usagetype WHERE description = 'utilityEstimate'
	SELECT	@user = value from libertypower..usagetype where description = 'File'
	SELECT	@usr = 'calendarizeMultipleMeters'

	-- - - - - - - - - - - - - - - - - - - - - - - - 
	print '' print '* ' + lp_historical_info.dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + ' initial list..'
	-- - - - - - - - - - - - - - - - - - - - - - - - 
	-- select * from #mms where accountnumber in ('0116601114', '1429517033', '1975301277', '2835222090', '4132612123', '7344251029', '8166200116', '8830448020') order by 2, 4 desc
	CREATE	TABLE #mms (UtilityCode VARCHAR (50), accountNumber VARCHAR (50), meterNumber VARCHAR (50), FromDate DATETIME, ToDate DATETIME, TotalKwh INT, Days SMALLINT, avgKwh FLOAT)
	INSERT	INTO #mms
	SELECT	DISTINCT abi.UtilityCode, upper(rtrim(abi.accountnumber)) accountNumber, abi.meterNumber, FromDate, ToDate, abi.TotalKwh, datediff(d, FromDate, ToDate) Days, abi.TotalKwh avgKwh
	FROM	lp_historical_info..ProspectAccounts ACT WITH (NOLOCK)
		INNER JOIN UsageConsolidated ABI WITH (NOLOCK) ON ACT.AccountNumber = ABI.AccountNumber and act.Utility = abi.UtilityCode
		INNER JOIN utility (NOLOCK) UT ON abi.UtilityCode = ut.UtilityCode
	WHERE	[deal id] = @deal	--and abi.accountnumber in ('0199652332', '0233064000', '0291136039', '0315365136', '0368071005', '0490845299', '0547126571', '0563000560', '0669625132', '9726009618', '9753665939')
		AND	abi.UtilityCode = @utilityCode
		AND	abi.Active		= 1
		AND	multiplemeters	= 1
		AND	usagetype in (@billed, @historical, @utilityEstimate, @user)
		AND	abi.TotalKwh >= 0
	ORDER BY 1, 2, 4 desc

	CREATE CLUSTERED INDEX #mms_idx on #mms (accountNumber, FromDate, ToDate) WITH fillfactor = 100

	INSERT INTO	lp_historical_info..zMtM_Tracking (loop, row_count, account_number) VALUES ('calendarizeM2mUtility - get rid of overlapping dates (no double dipping)..', @@ROWCOUNT, @deal)

	UPDATE	#mms SET avgKwh = 0
	UPDATE	#mms SET avgKwh = CONVERT( FLOAT, TotalKwh) / CONVERT( FLOAT, days)

	-- - - - - - - - - - - - - - - - - - - - - - - - 
	print '' print '* ' + lp_historical_info.dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + ' get rid of overlapping dates (no double dipping)..'
	-- - - - - - - - - - - - - - - - - - - - - - - - 
	DECLARE	@@act_nbr	VARCHAR (50),
			@@prv_acct	VARCHAR (50),
			@@fromdate	DATETIME,
			@@begin		DATETIME,
			@@loop		CHAR(1),
			@@todate	DATETIME,
			@@prv_from	DATETIME,
			@@eom		DATETIME,
			@@kwh		FLOAT,
			@@val		FLOAT

	DECLARE LpCursor CURSOR FOR
		SELECT	DISTINCT accountNumber, FromDate, ToDate, sum(avgKwh) FROM #mms	-- where accountnumber in ('0116601114', '1429517033', '1975301277', '2835222090', '4132612123', '7344251029', '8166200116', '8830448020')
		GROUP BY accountNumber, FromDate, ToDate ORDER BY 1, 2 DESC

	OPEN LpCursor
	FETCH NEXT FROM LpCursor INTO @@act_nbr, @@fromdate, @@todate, @@val

	WHILE (@@FETCH_STATUS <> -1)
	  BEGIN
		IF @@act_nbr = @@prv_acct and @@todate = @@prv_from
		  BEGIN
--			print @@act_nbr + ', ' + convert(varchar(20), @@fromdate) + ', ' + convert(varchar(20), @@todate) + ', ' + convert(varchar(20), @@val)
			UPDATE	#mms
			SET		ToDate = dateadd(d, -1, @@todate)
			WHERE	accountNumber = @@act_nbr AND FromDate = @@fromdate AND ToDate = @@todate
		  END
		SET @@prv_acct = @@act_nbr
		SET @@prv_from = @@fromdate

		FETCH NEXT FROM LpCursor INTO @@act_nbr, @@fromdate, @@todate, @@val
	  END

	CLOSE LpCursor
	DEALLOCATE LpCursor

	-- - - - - - - - - - - - - - - - - - - - - - - - 
	print '' print '* ' + lp_historical_info.dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + ' daily aggregated list..'
	-- - - - - - - - - - - - - - - - - - - - - - - - 
	-- select * from #dailyValues where accountnumber in ('0116601114', '1429517033', '1975301277', '2835222090', '4132612123', '7344251029', '8166200116', '8830448020') and loop = 'T' order by 1, 2 desc
	CREATE	TABLE #dailyValues (accountNumber VARCHAR (50), FromDate DATETIME, TotalKwh FLOAT, [Loop] CHAR(1))

	DECLARE LpCursor CURSOR FOR
		SELECT	DISTINCT accountNumber, FromDate, ToDate, sum(avgKwh) FROM #mms	-- where accountnumber = '0984706002'
		GROUP BY accountNumber, FromDate, ToDate ORDER BY 1, 2 DESC

	OPEN LpCursor
	FETCH NEXT FROM LpCursor INTO @@act_nbr, @@fromdate, @@todate, @@val

	WHILE (@@FETCH_STATUS <> -1)
	  BEGIN
--		print @@act_nbr + ', ' + convert(varchar(20), @@fromdate) + ', ' + convert(varchar(20), @@todate) + ', ' + convert(varchar(20), @@val)
		WHILE (@@fromdate <= @@todate)
		  BEGIN
--			print @@act_nbr + ', ' + convert(varchar(20), @@fromdate) + ', ' + convert(varchar(20), @@val)
			INSERT	INTO #dailyValues VALUES (@@act_nbr, @@fromdate, @@val, '')
			SET		@@fromdate = dateadd(d, 1, @@fromdate)
		  END

		FETCH NEXT FROM LpCursor INTO @@act_nbr, @@fromdate, @@todate, @@val
	  END

	CLOSE LpCursor
	DEALLOCATE LpCursor

	CREATE CLUSTERED INDEX #dailyV_idx on #dailyValues (accountNumber, FromDate) WITH fillfactor = 100

	-- - - - - - - - - - - - - - - - - - - - - - - - 
	print '' print '* ' + lp_historical_info.dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + ' create (master) calendarized list..'
	-- - - - - - - - - - - - - - - - - - - - - - - - 
	-- select *, datediff(d, FromDate, ToDate) Days from #calendarizedValues where accountnumber in ('0233064000', '0984706002', '1466157771', '2333205293') and master = 'T' order by 1, 2 desc
	CREATE	TABLE #calendarizedValues (accountNumber VARCHAR (50), FromDate DATETIME, ToDate DATETIME, TotalKwh INT, [Master] CHAR(1))

	SET @@prv_acct = '01/01/2001'
	SET @@kwh = 0

	DECLARE LpCursor CURSOR FOR
		SELECT	DISTINCT accountNumber, FromDate, sum(TotalKwh) FROM #dailyValues	-- where accountnumber = '8450275695'
		GROUP BY accountNumber, FromDate ORDER BY 1, 2 DESC

	OPEN LpCursor
	FETCH NEXT FROM LpCursor INTO @@act_nbr, @@fromdate, @@val

	SET	@@todate = @@fromdate

	WHILE (@@FETCH_STATUS <> -1)
	  BEGIN
		IF @@prv_acct = '01/01/2001'
		  BEGIN
--			print @@act_nbr + '-1, to: ' + convert(varchar(20), @@fromdate)
			SET @@prv_from = DATEADD(d, 1, @@fromdate)
			SET	@@prv_acct = @@act_nbr
		  END

--		print @@act_nbr + ', from: ' + convert(varchar(20), @@fromdate) + ', prev from: ' + convert(varchar(20), @@prv_from) + ', prev from-1: ' + convert(varchar(20), DATEADD(d, -1, @@prv_from))
		IF @@fromdate <> DATEADD(d, -1, @@prv_from)
		  BEGIN
--			print @@prv_acct + '-2-, ' + convert(varchar(20), @@prv_from) + ', ' + convert(varchar(20), @@todate) + ', ' + convert(varchar(20), @@kwh)
			INSERT	INTO #calendarizedValues VALUES (@@prv_acct, @@prv_from, @@todate, @@kwh, 'T')
			SET	@@prv_acct = '01/01/2001'
			SET	@@todate = @@fromdate
			SET @@kwh = 0
		  END

		SET	@@kwh = @@kwh + @@val
		SET	@@prv_from = @@fromdate

		FETCH NEXT FROM LpCursor INTO @@act_nbr, @@fromdate, @@val
	  END

	-- last round..
	INSERT	INTO #calendarizedValues VALUES (@@prv_acct, @@prv_from, @@todate, @@kwh, 'T')

	CREATE CLUSTERED INDEX #calValues on #calendarizedValues (accountNumber, FromDate, ToDate) WITH fillfactor = 100

	CLOSE LpCursor
	DEALLOCATE LpCursor

	-- - - - - - - - - - - - - - - - - - - - - - - - 
	print '' print '* ' + lp_historical_info.dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + ' create calendarized list..'
	-- - - - - - - - - - - - - - - - - - - - - - - - 

	UPDATE	#dailyValues SET [Loop] = 'T'
--	SELECT	t1.accountNumber, t1.FromDate, t2.FromDate, t2.ToDate, datediff(d, t2.FromDate, t2.ToDate) Days
	FROM	#dailyValues t1 inner join #calendarizedValues t2 on t1.accountNumber = t2.accountNumber and (t1.FromDate = t2.FromDate or t1.FromDate = t2.ToDate)
--	where	t1.accountNumber in ('0233064000', '0984706002', '1466157771', '2333205293') order by 1, 3 desc

	DECLARE	@edge SMALLINT SET @edge = 1
	SET	@@begin = '01/01/2001'
	SET @@kwh = 0

	DECLARE LpCursor CURSOR FOR
		SELECT	DISTINCT t1.accountNumber, t1.FromDate, sum(t1.TotalKwh), [Loop] FROM #dailyValues t1	--where accountnumber in ('0116601114', '0116008373', '0175003221', '2835222090')
		GROUP BY t1.accountNumber, t1.FromDate, [Loop] ORDER BY 1, 2

	OPEN LpCursor
	FETCH NEXT FROM LpCursor INTO @@act_nbr, @@fromdate, @@val, @@loop

	WHILE (@@FETCH_STATUS <> -1)
	  BEGIN
		SET	@@kwh = @@kwh + @@val
		SET	@@eom = DATEADD(d,-1,DATEADD(mm, DATEDIFF(m, 0, @@fromdate)+1, 0))

		IF @@prv_acct <> @@act_nbr AND @edge = 2
		  BEGIN
--			print @@prv_acct + '-single-, ' + convert(varchar(20), @@begin) + ', ' + convert(varchar(20), @@prv_from) + ', ' + convert(varchar(20), @@kwh)
			INSERT	INTO #calendarizedValues VALUES (@@prv_acct, @@begin, @@prv_from, @@kwh, ' ')
			SET @@begin = @@fromdate
			SET @edge = 2
			SET @@kwh = 0
		  END

		IF @@begin = '01/01/2001'
		  BEGIN
			SET @@begin = @@fromdate
			SET @edge = @edge + 1
		  END

		-- last day of the month..
		IF @@fromdate = @@eom AND @@loop <> 'T'	-- no double dipping (last part)
		  BEGIN
--			print @@act_nbr + '-eom-, ' + convert(varchar(20), @@begin) + ', ' + convert(varchar(20), @@fromdate) + ', ' + convert(varchar(20), @@kwh) + ', edge= ' + convert(varchar(20), @edge)
			INSERT	INTO #calendarizedValues VALUES (@@act_nbr, @@begin, @@fromdate, @@kwh, ' ')
			SET	@@begin = '01/01/2001'
			SET @@kwh = 0
		  END

--		print @@act_nbr + '-fromdate-, ' + convert(varchar(20), @@fromdate) + ', loop ' + convert(varchar(20), @@loop) + ', eom ' + convert(varchar(20), @@eom) + ', edge ' + convert(varchar(20), @edge)
		IF @@loop = 'T' AND @edge > 2
		  BEGIN
--			print @@act_nbr + '-last-, ' + convert(varchar(20), @@begin) + ', ' + convert(varchar(20), @@fromdate) + ', ' + convert(varchar(20), @@kwh)
			INSERT	INTO #calendarizedValues VALUES (@@act_nbr, @@begin, @@fromdate, @@kwh, ' ')
			SET	@@begin = '01/01/2001'
			SET @edge = 1
			SET @@kwh = 0
		  END

		  SET	@@prv_acct = @@act_nbr
		  SET	@@prv_from = @@fromdate

		FETCH NEXT FROM LpCursor INTO @@act_nbr, @@fromdate, @@val, @@loop
	  END

	CLOSE LpCursor
	DEALLOCATE LpCursor

	-- - - - - - - - - - - - - - - - - - - - - - - - 
	print '' print '* ' + lp_historical_info.dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + ' copied from ro_pricing_request..'
	-- - - - - - - - - - - - - - - - - - - - - - - - 
	DECLARE	@w_return	INT
--			@w_sql		VARCHAR (4000)

	-- select top 10 * from lp_historical_info..RO_PA_USAGE_HISTORY
	DELETE	lp_historical_info..RO_PA_USAGE_HISTORY
	WHERE	pa_ext_id IN (SELECT distinct accountNumber FROM #calendarizedValues)

--	DELETE	lp_historical_info..RO_PA_USAGE_HISTORY
--	WHERE	pa_ext_id IN (SELECT distinct t1.pa_ext_id FROM lp_historical_info..RO_PA_PROSPECT (nolock) t1 where quote_number = @deal)

--	SELECT	@w_sql = 'DELETE FROM openquery(ro_prod, ''select * from PA_USAGE_HISTORY WHERE upper(pa_ext_id) in (select distinct upper(pa_ext_id) from pa_prospect where quote_number = ''''' + @deal + ''''')'')'
--	EXEC   (@w_sql)

	SELECT	@w_return = COUNT(DISTINCT accountNumber)
	FROM	#calendarizedValues

	-- - - - - - - - - - - - - - - - - - - - - - - - 
	print '' print '* ' + lp_historical_info.dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + ' loop through usage..'
	-- - - - - - - - - - - - - - - - - - - - - - - - 
	INSERT INTO	lp_historical_info..zMtM_Tracking (loop, row_count, account_number) VALUES ('calendarizeM2mUtility - begin loop insert into RO_PA_USAGE_HISTORY', @w_return, @deal)
	SET STATISTICS PROFILE OFF

		DECLARE LpCursor CURSOR FOR
			SELECT	accountNumber, FromDate, ToDate, TotalKwh		--, datediff(d, FromDate, ToDate) Days
			FROM	#calendarizedValues
			WHERE	[Master] <> 'T'	-- and accountnumber in ('0116601114', '0116008373')
			ORDER BY 1, 2 DESC

		OPEN LpCursor
		FETCH NEXT FROM LpCursor INTO @@act_nbr, @@fromdate, @@todate, @@val

		WHILE (@@FETCH_STATUS <> -1)
		  BEGIN
			insert into lp_historical_info..RO_PA_USAGE_HISTORY (pa_ext_id, usage_begin_date, usage_end_date, usage_val, created_by) values (@@act_nbr, @@fromdate, @@todate, @@val, @usr)

			FETCH NEXT FROM LpCursor INTO @@act_nbr, @@fromdate, @@todate, @@val
		  END

		CLOSE LpCursor
		DEALLOCATE LpCursor

	DROP TABLE	#mms
	DROP TABLE	#dailyValues
	DROP TABLE	#calendarizedValues

	INSERT INTO	lp_historical_info..zMtM_Tracking (loop, row_count, account_number) VALUES ('calendarizeM2mUtility - Done..', @w_return, @deal)

	SET NOCOUNT OFF;

END

-- Copyright 2011 Liberty Power

