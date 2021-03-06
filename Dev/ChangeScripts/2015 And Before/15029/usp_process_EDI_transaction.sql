USE [integration]
GO
/****** Object:  StoredProcedure [dbo].[usp_process_EDI_transaction]    Script Date: 11/05/2013 08:35:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jaime Forero
-- Create date: 1/29/2012
-- Description:	Refactored for IT79 and use of new schema
-- =============================================

-- =============================================
-- Modified 6/27/2013 - Sal Tenorio
-- Added ISNULL() conversions to the @ERROR_MSG select
-- so it will not return a null string when the 
-- individual values are null
-- SR 1-138301995
-- =============================================

-- =============================================
-- Modified 7/08/2013 - Sal Tenorio
-- Replaced the numerical status codes for their descriptions
-- in the error message
-- TFS 11745
-- =============================================

-- =============================================
-- Modified 10/31/2013 - Sal Tenorio
-- Added check for recent status updates before
-- processing the current transaction. Allow override and
-- also make sure the time component is not considered
-- SR 1-249608026, TFS 22233
-- =============================================

-- =============================================
-- Modified 11/04/2013 - Sal Tenorio
-- Added check for wholesale market (ISO) to determine the
-- best fit transaction id
-- PBI 15029
-- =============================================

-- usp_process_EDI_transaction 1047445, @Show_Debugging=1
-- 05000 27
--	select * from integration.dbo.EDI_814_transaction_result where EDI_814_transaction_id = 5782573
--	delete integration.dbo.EDI_814_transaction_result where EDI_814_transaction_id = 5782573
--	exec integration..usp_process_EDI_transaction 5782573, 1, 1


ALTER PROCEDURE [dbo].[usp_process_EDI_transaction] (@EDI_814_transaction_id int, @Invalid_Status_Override int = 0, @Show_Debugging int = 0)
AS

BEGIN 
	SET NOCOUNT ON;


DECLARE @EDI_814_transaction_result_id int
DECLARE @Best_Fit_Liberty_Transaction_ID int
DECLARE @Best_Fit_Liberty_ReasonCode varchar(100)
DECLARE @NewChangeValue varchar(200)
DECLARE @Account_Number varchar(30)
DECLARE @AccountID int
DECLARE @Error_MSG varchar(100)
DECLARE @Current_Status varchar(15), @Current_Sub_Status varchar(15)
DECLARE @Status_Desc varchar(50), @Sub_Status_Desc varchar(50)
DECLARE @Request_Date datetime
DECLARE @Transaction_Date datetime
DECLARE @WholeSaleMarketId char(10)

SELECT @Request_Date		    = isnull(t.request_date,t.transaction_date)
  	  ,@Transaction_Date		= t.transaction_date
	  ,@AccountID				= t.AccountID
	  ,@WholeSaleMarketId       = u.WholeSaleMktID
FROM EDI_814_transaction t (nolock)
JOIN Libertypower..Utility u (nolock) on u.ID = t.utility_id
WHERE t.EDI_814_transaction_id = @EDI_814_transaction_id

SELECT @NewChangeValue = tc.new_value
FROM EDI_814_transaction_change tc (nolock)
WHERE tc.EDI_814_transaction_id = @EDI_814_transaction_id


-- =========================================================
-- IT79 New Schema refactored code:
SELECT	@Current_Status		= AST.[Status],
		@Current_Sub_Status	= AST.[SubStatus]
FROM LibertyPower..AccountStatus AST (NOLOCK)
JOIN LibertyPower..AccountContract (NOLOCK) AC	ON AST.AccountContractID = AC.AccountContractID
JOIN LibertyPower..Account (NOLOCK)			A	ON AC.AccountID			 = A.AccountID AND AC.ContractID = A.CurrentContractID
WHERE A.AccountID  = @AccountID;


SELECT @Status_Desc = S.status_descp
	  ,@Sub_Status_Desc = SS.sub_status_descp
FROM Lp_Account..enrollment_status S (NOLOCK)
JOIN Lp_Account..enrollment_sub_status SS (NOLOCK) on S.status = SS.status
WHERE S.status = @Current_Status AND SS.sub_status = @Current_Sub_Status

--SELECT @Current_Status		= status
--	,@Current_Sub_Status	= sub_status
--FROM lp_account..account (nolock)
--WHERE AccountID = @AccountID
-- =========================================================


-- Here we create the record which will keep track of the processing results.
INSERT INTO EDI_814_transaction_result (EDI_814_transaction_id) VALUES (@EDI_814_transaction_id)
SET @EDI_814_transaction_result_id = SCOPE_IDENTITY()

-- There may be several mappings which fit this EDI transaction.
-- We choose the one that is most specific
SELECT @Best_Fit_Liberty_Transaction_ID = null, @Best_Fit_Liberty_ReasonCode = null

SELECT @Best_Fit_Liberty_Transaction_ID = tm.lp_transaction_id, @Best_Fit_Liberty_ReasonCode = lp_reasoncode
FROM EDI_814_transaction t (nolock)
LEFT JOIN EDI_814_transaction_change (nolock) tc on t.EDI_814_transaction_id = tc.EDI_814_transaction_id
JOIN lp_transaction_mapping tm (nolock)
	ON 1=1
	AND (tm.wholesale_market_id = @WholeSaleMarketId OR tm.wholesale_market_id is NULL) -- Will be null when utility is *ALL*
	AND (tm.market_id in (t.market_id,0))
	AND (tm.utility_id in (t.utility_id,0)) -- The choice *ALL* gets stored as a zero for utility.
	AND (tm.external_transaction_type in (t.transaction_type,'*ALL*'))
	AND (tm.external_action_code in (t.action_code,'*ALL*'))
	AND (tm.external_service_type2 in (t.service_type2,'*ALL*'))
	AND (tm.external_request_or_response in (t.request_or_response,'*ALL*'))
	AND (tm.external_reject_or_accept in (t.reject_or_accept,'*ALL*'))
	AND (tm.external_reasoncode in (t.reasoncode,'*ALL*'))
	AND (tm.external_change_code in (tc.change_code,'*ALL*'))
	AND (tm.external_change_detail in (tc.change_detail,'*ALL*'))
--	AND (replace(tm.external_reasontext,' ','') in (replace(t.reasontext,' ',''),'*ALL*'))
	AND ((replace(tm.external_reasontext,' ','') in (replace(t.reasontext,' ',''),'*ALL*'))
		or (UPPER(LTRIM(RTRIM(tm.external_reasontext)))) = 'NOT FIRST IN' AND (RTRIM(LTRIM(t.reasontext))= ''))
WHERE t.EDI_814_transaction_id = @EDI_814_transaction_id
AND tm.lp_transaction_id <> 0
--	ORDER BY tm.utility_id, tm.external_transaction_type, tm.external_action_code, tm.external_request_or_response, tm.external_reasoncode, tm.external_reasontext
ORDER BY t.external_id, tm.external_transaction_type, tm.external_action_code, tm.external_request_or_response, tm.external_reasoncode, tm.external_reasontext

IF @Show_Debugging = 1
BEGIN
	PRINT 'Best Fit Liberty Interpretation'
	PRINT @Best_Fit_Liberty_Transaction_ID
	PRINT @Best_Fit_Liberty_ReasonCode
	SELECT 'Acquired Best Fit EDI', getdate()
END

-- We call the appropriate stored procedure for the Liberty transaction type.
IF @AccountID is null
BEGIN
	SET @Error_MSG = 'No matching Account Number found in Deal Capture.'
	IF @Show_Debugging = 1 PRINT @Error_MSG
END
ELSE IF @Best_Fit_Liberty_Transaction_ID is null
BEGIN
	--SET @Error_MSG = 'No mapping was found for this transaction.'
	SET @Error_MSG = (	SELECT 'No mapping was found for this transaction. '
						+ ' Market: '	+ ISNULL(MA.MarketCode, 'Null') + '.'
						+ ' Utility : '	+ ISNULL(U.UtilityCode, 'Null') + '.'
						+ ' (Reason Code: ' + ISNULL(T.ReasonCode, 'Null') + '.'
						+ '	Reason Text: ' + ISNULL(T.reasontext, 'Null') + '.)'
						FROM EDI_814_transaction		T WITH (NOLOCK)
						INNER JOIN libertypower..Market MA WITH (NOLOCK)
						ON MA.ID						= T.market_id
						INNER JOIN libertypower..Utility U WITH (NOLOCK)
						ON U.ID							= T.utility_id
						WHERE T.EDI_814_transaction_id	= @EDI_814_transaction_id)
	IF @Show_Debugging = 1 PRINT @Error_MSG
END
ELSE IF NOT EXISTS (SELECT * FROM lp_transaction_valid_status with (nolock)
					WHERE lp_transaction_id = @Best_Fit_Liberty_Transaction_ID and status = @Current_Status and sub_status = @Current_Sub_Status)
		AND @Best_Fit_Liberty_Transaction_ID not in (1,5,11,13,15)
		AND @Invalid_Status_Override = 0
		AND (@Current_Status is not null AND @Current_Sub_Status is not null)
BEGIN
	SELECT @Error_MSG = 'Current status: ' + @Status_Desc + ', ' + @Sub_Status_Desc + ', is invalid to receive ' + description 
	FROM lp_transaction with (nolock) WHERE lp_transaction_id = @Best_Fit_Liberty_Transaction_ID
	IF @Show_Debugging = 1 PRINT @Error_MSG
	IF @Show_Debugging = 1 AND @Error_MSG is null PRINT 'Status Error'
END
ELSE IF @Invalid_Status_Override = 0
	    AND @Best_Fit_Liberty_Transaction_ID not in (1,5,11,13,15) -- Intentionally skipped, these are not errors.
		AND EXISTS	(SELECT s.* 
					FROM libertypower..accountstatus (nolock) s
					JOIN libertypower..AccountContract (nolock) ac on ac.AccountContractID = s.AccountContractID
					JOIN libertypower..Account (nolock) a on a.AccountID = ac.AccountID and a.CurrentContractID = ac.ContractID 
					WHERE a.AccountID = @AccountID  AND CAST(s.Modified AS DATE) > CAST(@Transaction_Date AS DATE))
		
BEGIN
	SET @Error_MSG = 'Transaction Date is older than the last Modified Date for the Account'
	
	IF @Show_Debugging = 1 PRINT @Error_MSG
END
ELSE
BEGIN
	IF @Show_Debugging = 1 PRINT 'Now processing transaction'
	IF @Show_Debugging = 1 PRINT @AccountID
	IF @Best_Fit_Liberty_Transaction_ID = 3
		EXEC dbo.usp_edi_enrollment_reject		@AccountID = @AccountID, @p_reasoncode = @Best_Fit_Liberty_ReasonCode, @EDI_814_transaction_result_id = @EDI_814_transaction_result_id
	ELSE IF @Best_Fit_Liberty_Transaction_ID = 14
		EXEC dbo.usp_edi_usage_reject			@AccountID = @AccountID, @p_reasoncode = @Best_Fit_Liberty_ReasonCode, @EDI_814_transaction_result_id = @EDI_814_transaction_result_id
	ELSE IF @Best_Fit_Liberty_Transaction_ID = 16
		EXEC dbo.usp_edi_usage_reject_no_usage	@AccountID = @AccountID, @p_reasoncode = @Best_Fit_Liberty_ReasonCode, @EDI_814_transaction_result_id = @EDI_814_transaction_result_id
	ELSE IF @Best_Fit_Liberty_Transaction_ID = 4
		EXEC dbo.usp_edi_enrollment_accept		@AccountID = @AccountID, @p_request_date = @Request_Date, @EDI_814_transaction_result_id = @EDI_814_transaction_result_id
	ELSE IF @Best_Fit_Liberty_Transaction_ID = 12 -- 1-35576502
		EXEC [usp_edi_reinstatement]		@AccountID = @AccountID, @p_request_date = @Request_Date, @EDI_814_transaction_result_id = @EDI_814_transaction_result_id
	ELSE IF @Best_Fit_Liberty_Transaction_ID = 6 AND @Current_Status = '11000' AND @Current_Sub_Status IN ('30','40') -- This is to handle the scenerios where there is an outbound and inbound deenrollment request which criss cross.
		EXEC dbo.usp_edi_deenrollment_accept	@AccountID = @AccountID, @p_request_date = @Request_Date, @EDI_814_transaction_result_id = @EDI_814_transaction_result_id
	ELSE IF @Best_Fit_Liberty_Transaction_ID = 6
		EXEC dbo.usp_edi_deenrollment_request	@AccountID = @AccountID, @p_reasoncode = @Best_Fit_Liberty_ReasonCode, @p_request_date = @Request_Date, @EDI_814_transaction_result_id = @EDI_814_transaction_result_id
	ELSE IF @Best_Fit_Liberty_Transaction_ID = 7
		EXEC dbo.usp_edi_deenrollment_reject	@AccountID = @AccountID, @EDI_814_transaction_result_id = @EDI_814_transaction_result_id--, @p_reasoncode = @Best_Fit_Liberty_ReasonCode
	ELSE IF @Best_Fit_Liberty_Transaction_ID = 8
		EXEC dbo.usp_edi_deenrollment_accept	@AccountID = @AccountID, @p_request_date = @Request_Date, @EDI_814_transaction_result_id = @EDI_814_transaction_result_id
	ELSE IF @Best_Fit_Liberty_Transaction_ID = 15
		EXEC dbo.usp_edi_billtype_change_request	@AccountID = @AccountID, @EDI_814_transaction_id = @EDI_814_transaction_id, @EffectiveDate = @Request_Date, @NewBillTypeValue = @NewChangeValue
	ELSE IF @Best_Fit_Liberty_Transaction_ID = 13 
		PRINT 'Usage Accepts are not handled at this time.'
	ELSE IF @Best_Fit_Liberty_Transaction_ID <> 11 -- 11 is an intentionally ignored transaction.
		SET @Error_MSG = 'No logic to handle this transaction.'
END

IF @Show_Debugging = 1 SELECT 'Updating transaction_result', getdate(), @EDI_814_transaction_result_id, @Error_MSG


-- =========================================================
-- IT79 New Schema refactored code:
DECLARE @w_acc_status VARCHAR(15);
DECLARE @w_acc_sub_status VARCHAR(15);

SELECT	@w_acc_status		= AST.[Status],
		@w_acc_sub_status	= AST.[SubStatus]
FROM LibertyPower..AccountStatus AST (NOLOCK)
JOIN LibertyPower..AccountContract (NOLOCK) AC	ON AST.AccountContractID = AC.AccountContractID
JOIN LibertyPower..Account (NOLOCK)			A	ON AC.AccountID			 = A.AccountID AND AC.ContractID = A.CurrentContractID
WHERE A.AccountID  = @AccountID;
-- =========================================================

IF @Show_Debugging = 1 SELECT 'result id',@EDI_814_transaction_result_id, @Error_MSG, @Best_Fit_Liberty_Transaction_ID

IF @Best_Fit_Liberty_Transaction_ID <> 0 OR @Best_Fit_Liberty_Transaction_ID IS NULL
BEGIN
	-- We track part of the results of this EDI processing here.  Some other fields are updated in the stored procedures prior.
	UPDATE EDI_814_transaction_result
	SET date_processed = case when @Error_MSG is null then getdate() else null end, 
		skip_reason    = case 
							when @Best_Fit_Liberty_Transaction_ID = 11 then 'Transaction purposely ignored due to transaction mapping setup.'
							when @Best_Fit_Liberty_Transaction_ID in (1,5) then 'Invalid transaction for processing.  Outbound transaction.'
							--when @Best_Fit_Liberty_Transaction_ID in (13) then 'Historical Usage transactions are handled by another process.'
							else null end,
		error_msg = @Error_MSG,
		lp_transaction_id = @Best_Fit_Liberty_Transaction_ID, 
		lp_reasoncode  = @Best_Fit_Liberty_ReasonCode,
		old_status = @Current_Status,
		old_sub_status = @Current_Sub_Status,
		-- IT79 NEW CODE
		new_status     = @w_acc_status,
		new_sub_status = @w_acc_sub_status
		--new_status     = (select status from lp_account.dbo.account where AccountID = @AccountID),
		--new_sub_status = (select sub_status from lp_account.dbo.account where AccountID = @AccountID)
		-- IT79 CHANGE END 
		
	WHERE EDI_814_transaction_result_id = @EDI_814_transaction_result_id

	IF @Show_Debugging = 1 SELECT 'Final1', getdate()

	-- If the EDI can be processed then all EDI for prior dates should be closed off, this is so that EDI does not get processed out of order.
	IF @Error_MSG is null 
		EXEC usp_close_prior_EDI_for_account @AccountID=@AccountID,@Transaction_Date=@Transaction_Date
	ELSE
		PRINT 'Error for transaction is ' + isnull(@Error_MSG,'none.')
END
IF @Show_Debugging = 1 SELECT 'Final2', getdate()

--SET @Error_MSG = null

	SET NOCOUNT OFF;

END