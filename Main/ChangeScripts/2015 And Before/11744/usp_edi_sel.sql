USE [Integration]
GO
/****** Object:  StoredProcedure [dbo].[usp_edi_sel]    Script Date: 10/09/2013 14:55:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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

-- =============================================
-- Oct 7, 2013 - Sal Tenorio
-- Support to search transactions given a range (From-To)
-- =============================================

/*

exec usp_edi_sel_jmunoz 4, null, null, '2009-02-01', null, null, 2
1.613.723 02:13

exec usp_edi_sel 4, null, null, '2009-02-01', null, null, 2 
1.654.622 10:08

exec usp_edi_sel
	@numOption=4
	,@Account_Number=NULL
	,@Contract_Number=NULL
	,@from_transaction_date=N'20130805'
	,@to_transaction_date=N'20130805'
	,@processed_date=NULL
	,@Direction=null
	,@toDisplay=0
	,@market=Null
	,@utility=NULL
	,@transaction_type=null
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
	@from_transaction_date		DateTime = null,
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
	@is_processed				int = null,
	@to_transaction_date		DateTime = null
	)
AS
BEGIN 
	DECLARE @Insert				NVARCHAR(MAX)
			,@WhereFlag			BIT
			,@Select			NVARCHAR(MAX)
			,@ParmDefinition	NVARCHAR(MAX)
			,@Execute			VARCHAR(10)
			
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
		
		SET @Insert	= N'INSERT INTO #transaction'
					+ ' SELECT * FROM integration.dbo.EDI_814_transaction t WITH (NOLOCK)'
					+ ' WHERE (t.action_code <> ''C''		OR t.action_code IS NULL)'
					+ ' AND (@Account_Number is null		OR t.Account_Number = @Account_Number)'
					+ ' AND (@from_transaction_date is null	OR t.transaction_Date >= @from_transaction_date)'
					+ ' AND (@to_transaction_date is null	OR t.transaction_Date <= @to_transaction_date)'
					+ ' AND (@direction is null				OR @direction = 2 OR t.direction = @direction)'
					+ ' AND (@transaction_type is null		OR t.transaction_type = @transaction_type)'
					+ ' AND (@action_code is null			OR t.action_code = @action_code)'
					+ ' AND (@request_or_response is null	OR t.request_or_response = @request_or_response)'
					+ ' AND (@reject_or_accept is null		OR t.reject_or_accept = @reject_or_accept)'
					+ ' AND (@reasoncode is null			OR t.reasoncode = @reasoncode)'
					+ ' AND (@reasontext is null			OR t.reasontext like ''%'' + @reasontext + ''%'')'
		
		SET @ParmDefinition =N'@Account_Number varchar(30), @from_transaction_date DATETIME, @to_transaction_date DATETIME, @direction BIT, @transaction_type nvarchar(30), @action_code nvarchar(30), @request_or_response nvarchar(30), @reject_or_accept nvarchar(30), @reasoncode nvarchar(50), @reasontext nvarchar(50)'
		EXEC sp_executesql @Insert, @ParmDefinition, @Account_Number, @from_transaction_date, @to_transaction_date, @direction, @transaction_type, @action_code, @request_or_response, @reject_or_accept, @reasoncode, @reasontext  

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
		+ ' WHERE (@Contract_Number is null OR CC.Number = @Contract_Number)'
		+ ' AND (@processed_date is null OR tr.date_processed >= @processed_date)'
		+ ' AND (@is_processed is null' 
		+ ' OR (@is_processed = 1 AND     (tr.date_processed is not null OR tr.skip_reason is not null))'
		+ ' OR (@is_processed = 0 AND NOT (tr.date_processed is not null OR tr.skip_reason is not null))'
		+ ' )'
		+ ' AND (@toDisplay is null '
		+ ' OR @toDisplay = 0'
		+ ' OR (@toDisplay = 2 AND (tr.date_processed is not null OR tr.skip_reason is not null))'--(2)Processed EDI
		+ ' OR (@toDisplay = 3 AND CHARINDEX(''mapping'',tr.error_msg) > 0)'--(3)Unmapped EDI Issues
		+ ' OR (@toDisplay = 4 AND CHARINDEX(''status'',tr.error_msg) > 0)'--(4)Invalid status EDI Issues
		+ ' )'
		+ ' AND (@market is null or m.market = @market)'
		+ ' AND (@utility is null or u.utility = @utility)'
		+ ' ORDER BY t.Transaction_Date DESC, t.EDI_814_transaction_id desc, tr.EDI_814_transaction_result_id desc'

		SET @ParmDefinition =N'@Contract_Number varchar(30), @processed_date DATETIME, @is_processed INT, @toDisplay INT, @market nvarchar(5), @utility nvarchar(15)'
		EXEC sp_executesql @Select, @ParmDefinition, @Contract_Number, @processed_date, @is_processed, @toDisplay, @market, @utility 
	 	
	END
	SET NOCOUNT OFF;
END



