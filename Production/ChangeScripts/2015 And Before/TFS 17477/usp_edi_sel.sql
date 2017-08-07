
USE integration 
GO

/*
-- ================================================
-- March 03 of 2009
-- Module: EDI Tool
-- Description:	Depending on the first parameter, executes 4 different queries on the EDI tables
-- =============================================
-- May 19 of 2010 - Jose Munoz
-- Add the AccountId column to select
-- Add condiction "AND ac.utility_id	= u.utility" to join of the tables.
-- =============================================
-- March 15 2013 - Guy Gelin
-- Added the 'set transaction isolation level read uncommited' to improve
-- response time
-- =============================================
-- Modify:  08/26/2013
-- TFS: 17477
-- Update the query to improve the performance and avoid the timeout problem.
-- =============================================

exec usp_edi_sel
	@numOption=4
	,@Account_Number=N'PE000011945847914311'
	,@Contract_Number=NULL
	,@transaction_date='2013-01-01 00:00:00'
	,@processed_date=NULL
	,@Direction=2
	,@toDisplay=0
	,@market=NULL
	,@utility=N'PSEG'
	,@transaction_type=NULL
	,@action_code=NULL
	,@request_or_response=NULL
	,@reject_or_accept=NULL
	,@reasoncode=NULL
	,@reasontext=NULL

*/

ALTER PROCEDURE [dbo].[usp_edi_sel] (
	@numOption					int = null,
	@Account_Number				varchar(30) = null,
	@Contract_Number			varchar(30) = null, 
	@transaction_date			DateTime = null,
	@processed_date				DateTime =null,
	@direction					int = null,
	@toDisplay					int = null,
	@market						nvarchar(5) = null, 
	@utility					nvarchar(30) = null,
	@transaction_type			nvarchar(30) = null, 
	@action_code				nvarchar(30) = null,
	@request_or_response		nvarchar(5) = null, 
	@reject_or_accept			nvarchar(5) = null,
	@reasoncode					nvarchar(50) = null, 
	@reasontext					nvarchar(50) = null,
	@is_processed				int = null
	)
AS
BEGIN 
	DECLARE @Insert				VARCHAR(MAX)
			,@WhereFlag			BIT
			,@Select				VARCHAR(MAX)
			
	SET NOCOUNT ON;
	
	SET @WhereFlag	= 0
	
	-- exec usp_edi_sel 4, null, null, '2009-02-01', null, null, 1
	IF @numOption = 1
	BEGIN
		-- Queries all mapped EDI transaction from view, with no filters
		select * from integration..mapped_EDI_transactions_vw order by 1,2,3,4,5,6,7,8 DESC
	END

	IF @numOption = 2
	BEGIN
		-- Querys reason code view
		select * from integration..reason_code_vw order by 1
	END

	IF @numOption = 3
	BEGIN
		-- Queryes unmapped EDI transactions from view
		select top 100 * from integration..unmapped_EDI_transactions_vw order by [amount of transactions], utility, market_id, action_code
	END

	if @numOption = 4
	BEGIN
		-- Queries all mapped EDI transactions from view
		SET NOCOUNT ON
		
		CREATE TABLE #transaction (
						EDI_814_transaction_id			INTEGER
						,account_number					VARCHAR(30)
						,external_id					INTEGER
						,market_id						INTEGER
						,utility_id						INTEGER
						,transaction_type				VARCHAR(10)
						,action_code					VARCHAR(10)
						,service_type2					VARCHAR(100)
						,transaction_date				DATETIME
						,request_date					DATETIME
						,direction						TINYINT
						,request_or_response			VARCHAR(10)
						,reject_or_accept				VARCHAR(10)
						,reasoncode						VARCHAR(100)	
						,reasontext						VARCHAR(200)
						,transaction_number				VARCHAR(100)
						,reference_transaction_number	VARCHAR(100)
						,date_created					DATETIME
						,date_last_mod					DATETIME
						,AccountID						INTEGER)
		
		SET @Insert	= 'INSERT INTO #transaction'
					+ ' SELECT * FROM integration.dbo.EDI_814_transaction t WITH (NOLOCK)'
		
		IF (@direction IS NOT NULL AND @direction <> 2)
		BEGIN
			SET	@Insert		= @Insert + ' WHERE t.direction = ' + LTRIM(RTRIM(STR(@direction))) + ' AND t.action_code <> ''C'''
			SET @WhereFlag	= 1
		END
		
		IF (@Account_Number IS NOT NULL)
		BEGIN
			IF @WhereFlag	= 1
				SET @Insert		= @Insert + ' AND t.Account_Number = ''' + @Account_Number + ''''
			ELSE
			BEGIN
				SET @Insert		= @Insert + ' WHERE t.Account_Number = ''' + @Account_Number + ''' AND t.action_code <> ''C'''
				SET @WhereFlag	= 1
			END
		END
		
		IF (@transaction_type IS NOT NULL)
		BEGIN
			IF @WhereFlag	= 1
				SET @Insert		= @Insert + ' AND t.transaction_type = ''' + @transaction_type + ''''
			ELSE
			BEGIN
				SET @Insert		=  @Insert + ' WHERE  t.transaction_type = ''' + @transaction_type + ''' AND t.action_code <> ''C'''
				SET @WhereFlag	= 1
			END
		END

		IF (@action_code IS NOT NULL AND @WhereFlag	= 0)
		BEGIN
			SET @Insert		=  @Insert + ' WHERE  t.action_code = ''' + @action_code + ''''
			SET @WhereFlag	= 1
		END

		IF (@request_or_response IS NOT NULL)
		BEGIN
			IF @WhereFlag	= 1
				SET @Insert		= @Insert + ' AND t.request_or_response = ''' + @request_or_response + ''''
			ELSE
			BEGIN
				SET @Insert		=  @Insert + ' WHERE  t.action_code <> ''C'' AND t.request_or_response = ''' + @request_or_response + ''''
				SET @WhereFlag	= 1
			END			
		END

		IF (@reject_or_accept IS NOT NULL)
		BEGIN
			IF @WhereFlag	= 1
				SET @Insert		= @Insert + ' AND t.reject_or_accept = ''' + @reject_or_accept + ''''
			ELSE
			BEGIN
				SET @Insert		=  @Insert + ' WHERE  t.action_code <> ''C'' AND t.reject_or_accept = ''' + @reject_or_accept + ''''
				SET @WhereFlag	= 1
			END			
		END

		IF (@reasoncode IS NOT NULL)
		BEGIN
			IF @WhereFlag	= 1
				SET @Insert		= @Insert + ' AND t.reasoncode = ''' + @reasoncode + ''''
			ELSE
			BEGIN
				SET @Insert		=  @Insert + ' WHERE  t.action_code <> ''C'' AND t.reasoncode = ''' + @reasoncode + ''''
				SET @WhereFlag	= 1
			END			
		END
		
		IF (@reasontext IS NOT NULL)
		BEGIN
			IF @WhereFlag	= 1
				SET @Insert		= @Insert + ' AND CHARINDEX('''+ @reasontext + ''', t.reasontext) > 0'
			ELSE
			BEGIN
				SET @Insert		=  @Insert + ' WHERE  t.action_code <> ''C'' AND CHARINDEX('''+ @reasontext + ''', t.reasontext) > 0'
				SET @WhereFlag	= 1
			END			
		END
		
		IF (@transaction_date IS NOT NULL)
		BEGIN
			IF @WhereFlag	= 1
				SET @Insert		= @Insert + ' AND t.transaction_Date >= ''' + CONVERT(VARCHAR(8), @transaction_date, 112) + ''''
			ELSE
			BEGIN
				SET @Insert		=  @Insert + ' WHERE  t.action_code <> ''C'' AND t.transaction_Date >= ''' + CONVERT(VARCHAR(8), @transaction_date, 112) + ''''
				SET @WhereFlag	= 1
			END			
		END
		
		EXEC (@Insert)			

		CREATE INDEX NDX_transaction_direction ON #transaction (direction)
		CREATE INDEX NDX_transaction_utility ON #transaction (utility_id)
		CREATE INDEX NDX_transaction_market ON #transaction (market_id)
		
		SET @Select	= 'SELECT t.EDI_814_transaction_id as [Transaction Record ID]'
			+ ', t.date_created as EDI_Date_Created'
			+ ', t.Account_Number'
			+ ', m.market'
			+ ', t.action_code'
			+ ', t.request_or_response'
			+ ', t.reasoncode'
			+ ', t.reasontext'
			+ ', CC.Number as Contract_nbr'
			+ ', case when t.direction = 0 then ''OUTBOUND'' else ''INBOUND'' end as Direction'
			+ ', u.Utility'
			+ ', t.transaction_type + ''_'' + isnull(t.action_code,'''') as Transaction_Type'
			+ ', t.Transaction_Date, t.Request_Date'
			+ ', t.Request_Or_Response, t.Reject_Or_Accept'
			+ ', t.reasoncode as [Reason Code]'
			+ ', t.reasontext as [Reason Text]' 
			+ ', r.reason_text as [Liberty Reason Equivalent]'
			+ ', case when lt.description is null or lt.description = ''IGNORE'' then tr.skip_reason end as [Liberty Transaction Equivalent]'
			+ ', tr.date_processed'
			+ ', tr.Date_Created as Result_Date_Created'
			+ ', tr.error_msg as [Error Message]'
			+ ', tr.old_status as [Status Before]'
			+ ', tr.old_sub_status as [Sub Status Before]'
			+ ', tr.new_status as [Status After]'
			+ ', tr.new_sub_status as [Sub_Status After]'
			+ ', case when LEN(tr.error_msg) > 0 then case when CHARINDEX(''mapping'',tr.error_msg) > 0 then 3 else 4 end else 0 end as Category'
			+ ', AA.AccountId'
		+ ' FROM #transaction t WITH (NOLOCK)' 
		+ ' JOIN integration.dbo.utility u  WITH (NOLOCK)' 
		+ ' ON u.utility_id = t.utility_id'
		+ ' LEFT JOIN Libertypower..Account AA WITH (NOLOCK)' 
		+ ' ON AA.AccountNumber = t.account_number' 
		+ ' AND AA.UtilityID = t.utility_id'
		+ ' INNER JOIN Libertypower..[Contract] CC WITH (NOLOCK)' 
		+ ' ON CC.ContractID = AA.CurrentContractID' 
		+ ' LEFT JOIN integration.dbo.market m  WITH (NOLOCK)' 
		+ ' ON m.market_id = t.market_id'
		+ ' LEFT JOIN integration.dbo.EDI_814_transaction_result tr WITH (NOLOCK)' 
		+ ' ON tr.EDI_814_transaction_id = t.EDI_814_transaction_id'
		+ ' LEFT JOIN integration.dbo.reason_code_vw r WITH (NOLOCK)' 
		+ ' ON r.reason_code = tr.lp_reasoncode'
		+ ' LEFT JOIN integration.dbo.lp_transaction lt WITH (NOLOCK)'
		+ ' ON lt.lp_transaction_id = tr.lp_transaction_id'

		SET @WhereFlag	= 0
		
		IF (@Contract_Number IS NOT NULL)
		BEGIN 
			BEGIN
				SET @Select		=  @Select + ' WHERE  CC.Number = ''' + @Contract_Number + ''''
				SET @WhereFlag	= 1
			END			
		END 	 	
	 	
	 	IF (@processed_date IS NOT NULL)
		BEGIN
			IF @WhereFlag	= 1
				SET @Select		= @Select + ' AND tr.date_processed >= ''' + CONVERT(VARCHAR(8), @processed_date, 112) + ''''
			ELSE
			BEGIN
				SET @Select		=  @Select + ' WHERE t.action_code <> ''C'' AND t.transaction_Date >= ''' + CONVERT(VARCHAR(8), @processed_date, 112) + ''''
				SET @WhereFlag	= 1
			END			
		END
	 	
	 	IF (@market IS NOT NULL)
		BEGIN
			IF @WhereFlag	= 1
				SET @Select		= @Select + ' AND m.market = ''' + @market + ''''
			ELSE
			BEGIN
				SET @Select		=  @Select + ' WHERE  t.action_code <> ''C'' AND m.market = ''' + @market + ''''
				SET @WhereFlag	= 1
			END			
		END

	 	IF (@utility IS NOT NULL)
		BEGIN
			IF @WhereFlag	= 1
				SET @Select		= @Select + ' AND u.utility = ''' + @utility + ''''
			ELSE
			BEGIN
				SET @Select		=  @Select + ' WHERE  t.action_code <> ''C'' AND u.utility = ''' + @utility + ''''
				SET @WhereFlag	= 1
			END			
		END

		IF (@is_processed IS NOT NULL)
		BEGIN
			IF @WhereFlag	= 1
				SET @Select		= @Select + ' AND (('+ LTRIM(RTRIM(STR(@is_processed))) + ' = 1 AND tr.date_processed is not null OR tr.skip_reason is not null) OR ('+ LTRIM(RTRIM(STR(@is_processed))) + ' = 0 AND NOT (tr.date_processed is not null OR tr.skip_reason is not null)))'
			ELSE
			BEGIN
				SET @Select		=  @Select + ' WHERE  t.action_code <> ''C'' AND ((@is_processed = 1 AND tr.date_processed is not null OR tr.skip_reason is not null) OR ('+ LTRIM(RTRIM(STR(@is_processed))) + ' = 0 AND NOT (tr.date_processed is not null OR tr.skip_reason is not null)))'
				SET @WhereFlag	= 1
			END	
		END			
		
		IF (@toDisplay IS NOT NULL AND @toDisplay <> 0)
		BEGIN
			SET @Select		= @Select + ' AND (('+ LTRIM(RTRIM(STR(@toDisplay))) + ' = 2 AND (tr.date_processed is not null OR tr.skip_reason is not null)) OR ('+ LTRIM(RTRIM(STR(@toDisplay))) + ' = 3 AND (CHARINDEX(''mapping'',tr.error_msg) > 0)) OR ('+ LTRIM(RTRIM(STR(@toDisplay))) + ' = 4 AND (CHARINDEX(''status'',tr.error_msg) > 0)))'
		END
		
	 	SET @Select		=  @Select + ' ORDER BY t.Transaction_Date DESC, t.EDI_814_transaction_id desc, tr.EDI_814_transaction_result_id desc'
	 	
	 	EXEC (@Select)			
	END

	SET NOCOUNT OFF;
END


