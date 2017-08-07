Use Integration

GO

-- =========================================================
-- Modified 10/26/2011
-- By		: José Muñoz
-- Ticket	: SD24065
--			Resend Rates to Ista Upon enrollment Acceptence
-- =============================================

ALTER PROCEDURE [dbo].[usp_edi_enrollment_accept] (@AccountID varchar(30), @p_request_date datetime, @EDI_814_transaction_result_id int = null)
AS
BEGIN
	--PRINT 'Processing transaction as Enrollment Accept, result ID = ' + convert(varchar(30),@EDI_814_transaction_result_id)

	DECLARE @Date_Flow_Start datetime
	DECLARE @NewStatus varchar(15)
	DECLARE @NewSubStatus varchar(15)
	DECLARE @Legacy_Account_ID varchar(12)
	DECLARE @AccountNumber varchar(30)
	
	
	SELECT @Date_Flow_Start = date_flow_start, @Legacy_Account_ID = account_id 
	FROM lp_account.dbo.account
	WHERE AccountID = @AccountID

	IF EXISTS (SELECT status FROM lp_account.dbo.account WHERE AccountID = @AccountID AND status = '13000' AND sub_status in ('60','70'))
		SELECT @NewStatus = '13000',@NewSubStatus = '80'
	ELSE  IF EXISTS (SELECT status FROM lp_account.dbo.account WHERE AccountID = @AccountID AND status = '11000' AND sub_status in ('30','40','50') and @p_request_date > date_deenrollment )
		SELECT @NewStatus = '13000',@NewSubStatus = '80'
--	ELSE IF (SELECT por_option FROM lp_account.dbo.account WHERE account_number = @p_account_number) = 'YES'
--		SELECT @NewStatus = '06000',@NewSubStatus = '30'
	ELSE 
		SELECT @NewStatus = '05000',@NewSubStatus = '30' 

	-- Update flow date
	IF @NewStatus = '05000'
	BEGIN
		UPDATE ACR
		SET RateStart = isnull(@p_request_date,RateStart)
		FROM LibertyPower..Account A
		JOIN LibertyPower..AccountContract AC ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
		JOIN LibertyPower..vw_AccountContractRate ACR ON AC.accountcontractid = ACR.AccountContractID
		WHERE A.AccountID = @AccountID --AND ACR.IsContractedRate = 1 //the view in this condition will always return the first subterm in case of a multi term
	END
	
	-- Ticket 5312.  We record a history of account service periods. 2010-06-24
	INSERT INTO LibertyPower..AccountService
	(account_id, StartDate, EndDate)
	SELECT @Legacy_Account_ID, @p_request_date, null

	-- Cancel Retention if there is one pending.
	UPDATE lp_enrollment.dbo.retention_header
	SET call_status = 'C'
	WHERE account_id = @Legacy_Account_ID and call_status in ('O','A')

	DECLARE @w_msg_id char(8)
	DECLARE @w_msg_desc	varchar(255)
	DECLARE @return_value int
	DECLARE @w_error char(1)
	DECLARE	@w_descp varchar(250)
	DECLARE @w_descp_add varchar(100)
	DECLARE	@w_trans_id bigint
	DECLARE	@w_trans_id_output bigint
	DECLARE @w_trans_date_id char(8)
	DECLARE @w_getdate datetime
	SET @w_getdate = getdate()

	-- Update Status.
	EXECUTE @return_value = lp_account.dbo.usp_account_status_process 
          'SYSTEM','SET NUMBER',@Legacy_Account_ID,@AccountNumber,@NewStatus,@NewSubStatus, @p_request_date
		 ,' ',' ',' ',' ',' ',@w_error OUTPUT,@w_msg_id OUTPUT,@w_descp OUTPUT,@w_descp_add OUTPUT,'N'

	---- Track results of the EDI processing
	UPDATE EDI_814_transaction_result
	SET update_status_results = convert(varchar(10),@return_value) + ':' + @w_error + ':' + @w_msg_id + ':' + @w_descp + ':' + @w_descp_add
	WHERE EDI_814_transaction_result_id = @EDI_814_transaction_result_id
	
	/* Ticket SD24065 BEGIN */
	INSERT INTO [Libertypower].[dbo].[EnrollmentAcceptedLog]
	SELECT @AccountID, 0, @w_getdate
	/* Ticket SD24065 END */
END




