USE [lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_check_account_renewal_approval_reject]    Script Date: 08/17/2012 09:23:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/19/2007
-- Description:	Self-explanatory
-- =============================================

-- =======================================
-- Modified: DEV 8/21/2007 PROD 8/27/2007
-- Modified By: Gail Mangaroo
-- Changed to call lp_enrollment..[usp_comm_trans_detail_ins_express] instead of lp_account..account_commission_request_ins

-- =====================================================================================================
-- Modified 9/27/2007 GM changed comm type to RENEWCOMM on call to [usp_comm_trans_detail_ins_express]
-- Added audit trail to determine why accounts are not getting commissioned
-- 10/17/2007 -- removed audit trail
-- ====================================================

-- =======================================
-- Modified 11/07/2007 GM 
-- added commission audit trail.
-- =======================================

-- =======================================
-- Modified 4/14/2008
-- Modified By: Rick Deigsler
-- If a new account has been added to a renewal through contract amendment,
-- and the contract is rejected or is incomplete, then set the new account(s) to not enrolled.
-- =======================================

-- =======================================
-- Modified 8/15/08 Rick Deigsler
-- Added rate code functionality
-- =======================================

-- =======================================
-- Modified 9/19/08 Eric Hernandez
-- Made it possible to approve a rejected step which had no approval_status defined.
-- =======================================

-- =======================================
-- Modified 5/13/2009 Gail Mangaroo in Prod 7/1/2009
-- Added call to usp_comm_trans_detail_ins_auto so chargebacks can be created if necessary
-- =======================================
-- Modified 11/10/2010 Isabelle Tamanini
-- ticket 17324
-- Fixed status update to handle an "approved rejected contract" scenerio.
-- Also updates "add on" account correctly now.
-- =======================================

-- =======================================
-- Modified 10/28/2010 Gail Mangaroo 
-- Replaced commissions call with call to lp_commissions..usp_transaction_request_enrollment_process 
-- =======================================
-- Modified 02/11/2011 Isabelle Tamanini
-- Added a case when statement for joinning account_renewal table and #wait_status to handle
-- the insertion of approval comments for renewals that had the previous step rejected
-- SD21151
-- =======================================
-- Modified 02/23/2011 Isabelle Tamanini 
-- Fixed status update to handle an approved scenerio where the account is not active in
-- account table (911000, 999999, 999998).
-- =======================================
-- Modified 05/06/2011 Isabelle Tamanini
-- Only creates the next step if it is necessary
-- MD056
-- =======================================
-- Modified 05/23/2011 Isabelle Tamanini
-- Fixing select that gets the next account status and substatus to get only the most 
-- restrictive transition record - order: utility, market, default
-- SD23753 
-- =======================================
-- Modified 07/18/2011 Isabelle Tamanini
-- Approves only the most recent step when the contract has duplicated ones
-- SD24187 
-- =======================================
-- Modified 10/20/2011 Jose Munoz
-- Ticket : 1-3809331
-- Inactive accounts entered on renewal contracts to be processed as new deals
-- =======================================
-- Modified 05/24/2012 Jose Munoz - swcs
-- Ticket : 1-16372832 
-- Update the querys to avoid use the ISNULL sintax in the WHERE clause.
-- =======================================
-- Modified 6/28/2012 Isabelle Tamanini
-- Added logic to only change the status if approval status is not INCOMPLETE
-- SR1-18402625
-- =======================================
-- Modified 07/13/2012 Isabelle Tamanini
-- Status will go to 05000/10 on the account record if the account is inactive
-- and renewal gets approved to 07000/10
-- SR1-19853366
-- =======================================
-- Modified 07/14/2012 Eric Hernandez
-- Removed logic to handle parameter @p_account_id, this parameter is no longer used.
-- =======================================
-- Modified 07/30/2012 Isabelle Tamanini
-- Use new proc to approve / reject tasks
-- Task 1491
-- =======================================

ALTER PROCEDURE [dbo].[usp_check_account_renewal_approval_reject]
(@p_username         nchar(100),
 @p_contract_nbr     char(12),
 @p_account_id       char(12) = 'NONE',
 @p_account_number   varchar(30),
 @p_check_type       char(30),
 @p_check_request_id char(15),
 @p_approval_status	 char(15),
 @p_comment          varchar(max),
 @p_error            char(01) = ' ' output,
 @p_msg_id           char(08) = ' ' output,
 @p_descp            varchar(250) = ' ' output,
 @p_result_ind       char(01) = 'Y',
 @p_reason_code			char(10)		= 'NONE'
 )
AS
set nocount on;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @pIsIT043InUse BIT
SELECT @pIsIT043InUse = LibertyPower.dbo.ufn_GetApplicationFeatureSetting ('IT043','EnrollmentApp')

IF(@pIsIT043InUse = 1)
BEGIN
	
	EXEC [LibertyPower].[dbo].[usp_WIPTaskUpdateStatus] @p_username, @p_contract_nbr, @p_check_type, 
	@p_approval_status, @p_comment, @p_check_request_id 
		
END
ELSE
BEGIN

	DECLARE @w_error		char(01)
	DECLARE @w_msg_id		char(08)
	DECLARE @w_descp		varchar(250)
	DECLARE @w_descp_add	varchar(100)
	DECLARE @w_return		int
	DECLARE @w_annual_usage	int
	 
	SELECT @w_error = 'I', @w_msg_id = '00000001', @w_descp = ' ', @w_descp_add = ' ', @w_return = 0

	DECLARE @w_approval_status char(15)
	DECLARE @w_count_reg       int
	 
	DECLARE @w_application varchar(20)
	SELECT @w_application = 'COMMON'

	IF @p_approval_status = 'APROVED'
	   SELECT @p_approval_status = 'APPROVED'

	DECLARE @w_userfield_text_02 varchar(50)

	IF @p_account_id = 'NONE' 
	   SET @p_account_id = null
	   
	-- This proc should not run if this parameter is null
	IF @p_contract_nbr is null
		return

	IF @p_account_id is null and (@p_account_number is not null and @p_account_number <> ' ')
	   SELECT @p_account_id = rtrim(AccountIDLegacy) 
	   FROM LibertyPower..Account (NOLOCK) 
	   WHERE accountnumber = @p_account_number

	DECLARE @w_order int, @w_order_last int, @w_order_next int, @w_check_type char(30), @w_check_type_last char(30), @w_check_type_next char(30)
	DECLARE @w_utility_id char(15), @w_contract_type varchar(35), @w_por_option varchar(03), @w_account_type varchar(35)

	DECLARE @w_getdate datetime
	SELECT @w_getdate = getdate()

	DECLARE @w_contract_type_last varchar(35), @w_por_option_last varchar(03), @w_account_type_last varchar(35), @w_role_name varchar(50)

	DECLARE @w_account_id char(12)
	DECLARE @w_check_request_id char(25)
	DECLARE @w_status char(15)         , @w_sub_status char(15)
	DECLARE @w_wait_status char(15)    , @w_wait_sub_status char(15)
	DECLARE @w_approved_status char(15), @w_approved_sub_status char(15), 
			@w_approval_status_current char(15)
	DECLARE @w_rejected_status char(15), @w_rejected_sub_status char(15)
	DECLARE @w_status_code char(15)                                 
	DECLARE @w_commission_on_approval tinyint
	DECLARE @w_retail_mkt_id char(2)

	-- This retrieves the last status to determine if last step was rejected...
	-- to be used if last step was rejected and is now being approved
	SELECT	@w_approval_status_current = approval_status
	FROM	check_account (NOLOCK) 
	WHERE	contract_nbr = @p_contract_nbr AND check_type = @p_check_type AND check_request_id = @p_check_request_id

	-- Using the contract_nbr or account_number, we retrieve the utility, contract_type (VOICE/PAPER), account_type (MASS_MARKET/NATIONAL) and por_option.
	SELECT top 1 @w_utility_id = U.UtilityCode
		, @w_contract_type = LibertyPower.dbo.ufn_GetLegacyContractTypeByID(C.ContractTypeID, C.ContractTemplateID, C.ContractDealTypeID)
		, @w_account_type = CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE AT.AccountType END
		, @w_por_option = CASE WHEN A.PorOption = 0 THEN 'NO' ELSE 'YES' END
		, @w_retail_mkt_id = M.MarketCode
	FROM LibertyPower..Account A (NOLOCK)
	JOIN LibertyPower..AccountType AT (NOLOCK) ON A.AccountTypeID = AT.ID
	JOIN LibertyPower..Contract C (NOLOCK) ON A.CurrentRenewalContractID = C.ContractID
	JOIN LibertyPower..Utility U (NOLOCK) ON A.UtilityID = U.ID
	JOIN LibertyPower..Market M (NOLOCK) ON A.RetailMktID = M.ID
	WHERE C.Number = @p_contract_nbr



	-- This retrieves the current status for the check_type.  For example, if we're approving something, the current status would probably be "pending".
	SELECT @w_status_code = approval_status
	FROM check_account (NOLOCK)
	WHERE contract_nbr = @p_contract_nbr AND check_type = @w_check_type_next AND check_request_id = @p_check_request_id

	-- This section essentially is just to determine the previous and next check-steps.
	SELECT @w_order = [order], @w_role_name = role_name
	FROM lp_common..common_utility_check_type (NOLOCK)
	WHERE utility_id = @w_utility_id AND contract_type = @w_contract_type AND check_type = @p_check_type

	SELECT @w_order_last = isnull(max([order]), 0)
	FROM lp_common..common_utility_check_type (NOLOCK)
	WHERE utility_id = @w_utility_id AND contract_type = @w_contract_type AND [order] < @w_order

	SELECT @w_order_next = isnull(min([order]), 0)
	FROM lp_common..common_utility_check_type (NOLOCK)
	WHERE utility_id = @w_utility_id and contract_type = @w_contract_type AND [order] > @w_order

	SELECT @w_check_type_last = check_type
	FROM lp_common..common_utility_check_type (NOLOCK)
	WHERE utility_id = @w_utility_id and contract_type = @w_contract_type AND [order] = @w_order_last

	SELECT @w_check_type_next = check_type
	FROM lp_common..common_utility_check_type (NOLOCK)
	WHERE utility_id = @w_utility_id and contract_type = @w_contract_type AND [order] = @w_order_next

	--Logic moved to line above were the step is inserted (MD056)
	---- If you APPROVE a check step, the next step gets created.  If the next step already exists, we return an error.
	--IF EXISTS(SELECT contract_nbr FROM check_account with (nolock) WHERE contract_nbr = @p_contract_nbr and check_type = @w_check_type_next and check_request_id = @p_check_request_id)
	--   SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_descp_add = ' (Another Check Process EXISTS)', @w_return = 1

	-- Here we check if it is valid to APPROVE a check step.
	IF @p_approval_status = 'APPROVED' AND EXISTS(SELECT check_type FROM lp_common..common_check_type_status with (nolock) WHERE check_type = @p_check_type and status_code = @w_status_code and approval_online = 0)
	   SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_return = 1

	IF @p_approval_status = 'APPROVED' AND EXISTS(SELECT approval_status FROM check_account with (nolock) WHERE contract_nbr = @p_contract_nbr and check_type = @p_check_type and approval_status = 'REJECTED') 
	   AND @w_check_type not in ('TPV','DOCUMENT','USAGE ACQUIRE')

	   SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_return = 1


	-- Here we check if it is valid to REJECT a check step.
	IF @p_approval_status = 'REJECTED' AND EXISTS(SELECT check_type FROM lp_common..common_check_type_status with (nolock) WHERE check_type = @p_check_type and status_code = @w_status_code and reject_online = 0)
	   SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_return = 1

	IF @p_approval_status = 'REJECTED' AND EXISTS(SELECT approval_status FROM check_account with (nolock) WHERE contract_nbr = @p_contract_nbr and check_type = @p_check_type and approval_status = 'APPROVED')
	   SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_return = 1

	IF @w_error = 'E'
	   GOTO GOTO_select

	IF @p_approval_status = 'APPROVAL'
	BEGIN
	   SELECT @p_approval_status = 'APPROVED'
	   GOTO GOTO_continue
	END

	IF @p_approval_status = 'REJECT'
	BEGIN
	   SELECT @p_approval_status = 'REJECTED'
	   GOTO GOTO_continue
	END

	-- This is a security check to see if the user has access to the Sales Channel.  If the username is "Usage Trigger" or "SYSTEM", then we bypass the security check.
	IF @p_username not in ('SYSTEM','Usage Trigger') AND NOT EXISTS (SELECT sales_channel_role FROM lp_common..ufn_check_role(@p_username, @w_role_name))
	BEGIN
	   SELECT @w_error = 'E', @w_msg_id = '00000013', @w_application = 'SECURITY', @w_return = 1
	--   SELECT @w_error = 'E', @w_msg_id = '00000013', @w_application = 'SECURITY', @w_return = 1
	   GOTO GOTO_select
	END

	GOTO_continue:

	-- Here we enforce that the comment cannot be blank.
	IF @p_comment is null or @p_comment = ' '
	BEGIN
	   SELECT @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00001011', @w_return = 1
	   GOTO GOTO_select
	END

	-- We change the terminology here.  Notice we start referring to the current check step as the last check step.
	SELECT @w_account_type_last = @w_account_type, @w_por_option_last = @w_por_option, @w_check_type_last = @p_check_type, @w_order_last = @w_order

	IF (SELECT count([order]) FROM lp_common..common_utility_check_type with (nolock) WHERE utility_id = @w_utility_id and contract_type = @w_contract_type and [order] = @w_order) > 1
	BEGIN
		IF @w_por_option <> 'YES'
			SELECT @w_account_type_last = 'ALL', @w_por_option_last = 'NO'
	END
	ELSE
		SELECT @w_account_type_last = 'ALL', @w_por_option_last = 'ALL'

	-- Again, we change terminology.  We consider the next-step, the current-step now.
	SELECT @w_order = @w_order_next

	SELECT @w_wait_status = wait_status, @w_wait_sub_status = wait_sub_status,
		   @w_approved_status = approved_status, @w_approved_sub_status = approved_sub_status,
		   @w_rejected_status = rejected_status, @w_rejected_sub_status = rejected_sub_status,
		   @w_commission_on_approval = commission_on_approval
	FROM lp_common..common_utility_check_type WITH (NOLOCK)-- INDEX = common_utility_check_type_idx)
	WHERE utility_id = @w_utility_id and [order] = @w_order_last and contract_type = @w_contract_type and por_option = @w_por_option_last and check_type = @w_check_type_last


	-- check to make sure there is usage for all accounts
	IF @w_commission_on_approval = 1 AND @p_approval_status = 'APPROVED'
		BEGIN
			
			-- new accounts
			SELECT TOP 1 @w_annual_usage = isnull(AU.AnnualUsage,0) 
			FROM LibertyPower..Account A (NOLOCK)
			JOIN LibertyPower..Contract C (NOLOCK) ON A.CurrentContractID = C.ContractID
			JOIN LibertyPower..AccountUsage AU (NOLOCK) ON A.AccountID = AU.AccountID AND AU.EffectiveDate = C.StartDate
			WHERE C.Number = @p_contract_nbr

			IF @w_annual_usage = 0
			BEGIN
				SELECT	@w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000082', @w_return = 1
				GOTO	GOTO_select
			END

			-- renewal accounts
			SELECT	TOP 1 @w_annual_usage = AU.AnnualUsage
			FROM LibertyPower..Account A (NOLOCK)
			JOIN LibertyPower..Contract C (NOLOCK) ON A.CurrentRenewalContractID = C.ContractID
			JOIN LibertyPower..AccountUsage AU (NOLOCK) ON A.AccountID = AU.AccountID AND AU.EffectiveDate = C.StartDate
			WHERE C.Number = @p_contract_nbr

			IF @w_annual_usage IS NULL
			BEGIN
				SELECT	@w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000082', @w_return = 1
				GOTO	GOTO_select
			END

		END	

	-- The wait status should reflect the current status of the account.
	CREATE TABLE #wait_status (status varchar(15), sub_status varchar(15))    
	IF @w_wait_status = '*'
	BEGIN
	   INSERT INTO #wait_status
	   SELECT status, sub_status
	   FROM lp_common..common_check_type_status_code WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 WITH (NOLOCK INDEX = common_check_type_status_code_idx)
	   WHERE code = @w_wait_sub_status
	END
	ELSE IF @w_wait_status = 'ALL'
	BEGIN
	   INSERT INTO #wait_status
	   SELECT status, sub_status
	   FROM lp_account.dbo.enrollment_sub_status with (nolock)
	END
	ELSE
	BEGIN
	   INSERT INTO #wait_status
	   SELECT @w_wait_status, @w_wait_sub_status
	END


	IF @p_approval_status = 'REJECTED'
	   SELECT @w_status = @w_rejected_status, @w_sub_status = @w_rejected_sub_status
	ELSE
	   SELECT @w_status = @w_approved_status, @w_sub_status = @w_approved_sub_status

	BEGIN TRAN check_account

	SELECT @w_account_id = isnull(@p_account_id,' ')

	-- Recording comments.
	INSERT INTO lp_account..account_renewal_comments
	SELECT a.AccountIDLegacy, @w_getdate, @w_check_type_last, @p_comment, @p_username, 0
	FROM LibertyPower..Account A (NOLOCK) 
	JOIN LibertyPower..AccountContract AC (NOLOCK) ON AC.AccountID = A.AccountID AND A.CurrentRenewalContractID = AC.ContractID
	JOIN LibertyPower..AccountStatus S (NOLOCK) ON AC.AccountContractID = S.AccountContractID
	JOIN LibertyPower..Contract C (NOLOCK) ON C.ContractID = A.CurrentRenewalContractID
	JOIN #wait_status b ON S.status = CASE WHEN @w_approval_status_current = 'REJECTED' THEN '07000' ELSE b.status END
						AND S.substatus = CASE WHEN @w_approval_status_current = 'REJECTED' THEN '80' ELSE b.sub_status END
	WHERE C.Number = @p_contract_nbr

	INSERT INTO lp_account..account_comments
	SELECT a.AccountIDLegacy, @w_getdate, @w_check_type_last, @p_comment, @p_username, 0
	FROM LibertyPower..Account A (NOLOCK) 
	JOIN LibertyPower..AccountContract AC (NOLOCK) ON AC.AccountID = A.AccountID AND A.CurrentRenewalContractID = AC.ContractID
	JOIN LibertyPower..AccountStatus S (NOLOCK) ON AC.AccountContractID = S.AccountContractID
	JOIN LibertyPower..Contract C (NOLOCK) ON C.ContractID = A.CurrentRenewalContractID
	JOIN #wait_status b ON S.status = CASE WHEN @w_approval_status_current = 'REJECTED' THEN '07000' ELSE b.status END
						AND s.SubStatus = CASE WHEN @w_approval_status_current = 'REJECTED' THEN '80' ELSE b.sub_status END
	WHERE C.Number = @p_contract_nbr

	-- Recording status history for the status change that already occurred.
	-- Note that if approved status of a check account step is null, that is how we indicate that the status of the account should not change.
	IF @w_status is not null AND @w_sub_status is not null
	BEGIN 
		INSERT INTO lp_account..account_status_history
		SELECT a.AccountIDLegacy, @w_status, @w_sub_status, @w_getdate, @p_username, @w_check_type_last, ' ',' ',' ',' ',' ',' ',' ',' ',@w_getdate
		FROM LibertyPower..Account a (NOLOCK)
		JOIN LibertyPower..AccountContract AC (NOLOCK) ON AC.AccountID = A.AccountID AND A.CurrentRenewalContractID = AC.ContractID
		JOIN LibertyPower..AccountStatus S (NOLOCK) ON AC.AccountContractID = S.AccountContractID
		JOIN LibertyPower..Contract C (NOLOCK) ON C.ContractID = A.CurrentRenewalContractID
		JOIN #wait_status b ON S.status = b.status AND s.SubStatus = b.sub_status
		WHERE C.Number = @p_contract_nbr-- AND a.account_id = isnull(@p_account_id,a.account_id)
	END

	-- Check if there is more than 1 account in contract.
	-- If so, then set to INCOMPLETE.
	IF @w_check_type_last = 'USAGE ACQUIRE' AND @p_approval_status = 'REJECTED'
	BEGIN
		IF (SELECT COUNT(AccountNumber)
			FROM LibertyPower..Account A (NOLOCK)
			JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.CurrentRenewalContractID = AC.ContractID
			JOIN LibertyPower..Contract C (NOLOCK) ON A.CurrentRenewalContractID = C.ContractID
			WHERE C.Number = @p_contract_nbr) > 1
			BEGIN
				SET	@p_approval_status = 'INCOMPLETE'
			END
	END

	-- Get approval_status of current check account step before update.
	IF @w_check_type_last = 'RATE CODE APPROVAL'
	BEGIN
		SELECT	@w_approval_status = approval_status, @w_userfield_text_02 = userfield_text_02
		FROM	lp_enrollment..check_account (NOLOCK)
		WHERE	contract_nbr = @p_contract_nbr AND check_type = @w_check_type_last AND check_request_id = @p_check_request_id
	END

	-- This updates the check step which just got approved/rejected.
	UPDATE lp_enrollment..check_account 
	SET approval_status = @p_approval_status, approval_comments = @p_comment, approval_eff_date = @w_getdate, username = @p_username
	FROM lp_enrollment..check_account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 WITH (NOLOCK INDEX = check_account_idx)
	WHERE contract_nbr = @p_contract_nbr and account_id = isnull(@p_account_id,' ') and check_type = @w_check_type_last and check_request_id = @p_check_request_id
	  and date_created = (select max(date_created) from lp_enrollment..check_account with (NOLOCK)
						  where contract_nbr = @p_contract_nbr 
							and check_type = @w_check_type_last 
							and check_request_id = @p_check_request_id)

	-- If approving a rate code approval step,
	-- SET billing type to dual for those accounts without rate code, rate ready for accounts with rate code
	IF @w_check_type_last = 'RATE CODE APPROVAL' AND @p_approval_status = 'APPROVED' -- AND @w_approval_status = 'INCOMPLETE'
		EXEC lp_account..usp_account_billing_type_upd @p_contract_nbr, @p_check_request_id

	--SR1-18402625
	IF (@p_approval_status <> 'INCOMPLETE' OR @w_check_type_last <> 'TPV')
	BEGIN
		UPDATE AST
		SET AST.[Status]		= ISNULL(@w_status, AST.[Status]), 
			AST.[SubStatus]		= ISNULL(@w_sub_status, AST.[SubStatus])
		FROM LibertyPower..AccountStatus AST
		JOIN LibertyPower..AccountContract AC ON AST.AccountContractID = AC.AccountContractID
		JOIN LibertyPower..Account A ON AC.AccountID = A.AccountID 
		JOIN LibertyPower..[Contract] C ON C.ContractID = AC.ContractID AND C.IsFutureContract = 1
		LEFT JOIN #wait_status ws ON AST.[Status] = ws.status and AST.[SubStatus] = ws.sub_status
		WHERE C.Number			= @p_contract_nbr
		  -- Must match wait status, unless we are approving a rejected step
		  AND ((AST.[Status] = ws.[status] AND AST.[SubStatus] = ws.sub_status)
			   OR (@p_approval_status = 'APPROVED' AND @w_approval_status_current = 'REJECTED'))
	END
	  
		
	--Update the new accounts included in the renewal.
	--In the account table, there are certain status which differ from the renewal table which have to hardcode.

	--SR1-18402625
	IF (@p_approval_status <> 'INCOMPLETE' OR @w_check_type_last <> 'TPV')
	BEGIN
		UPDATE AST
		SET AST.[Status] = case when @w_status is null then AST.[Status]
								when @w_status = '07000' and @w_sub_status = '10' then '05000' 
								when @w_status = '07000' and @w_sub_status = '80' then '999999' 
								else @w_status end,
			AST.[SubStatus] = case when @w_sub_status is null then AST.SubStatus
								   when @w_status = '07000' and @w_sub_status = '10' then '10' 
								   when @w_status = '07000' and @w_sub_status = '80' then '10' 
								   else @w_sub_status end
		FROM LibertyPower..AccountStatus AST
		JOIN LibertyPower..AccountContract AC ON AST.AccountContractID = AC.AccountContractID
		JOIN LibertyPower..Account A ON AC.AccountID = A.AccountID 
		JOIN LibertyPower..[Contract] C ON C.ContractID = AC.ContractID AND C.IsFutureContract = 1
		LEFT JOIN #wait_status ws on AST.[Status] = ws.[status] AND AST.[SubStatus] = ws.sub_status
		WHERE C.Number				= @p_contract_nbr
		  -- Must match wait status, unless we are approving a rejected step
		  AND ((AST.[Status] = ws.[status] AND AST.[SubStatus] = ws.sub_status)
			   OR (@p_approval_status = 'APPROVED' AND @w_approval_status_current = 'REJECTED'))
		  AND AC.ContractID = C.ContractID
	END
	  



	--SR 1-19853366
	UPDATE AST
	SET AST.[Status] = '05000', 
		AST.[SubStatus] = '10'
	FROM LibertyPower..AccountStatus ASTR
	JOIN LibertyPower..AccountContract ACR ON ASTR.AccountContractID = ACR.AccountContractID
	JOIN LibertyPower..Account A ON ACR.AccountID = A.AccountID 
	JOIN LibertyPower..[Contract] CR ON CR.ContractID = A.CurrentRenewalContractID
	JOIN LibertyPower..[Contract] C ON C.ContractID = A.CurrentContractID
	JOIN LibertyPower..AccountContract AC ON C.ContractID = AC.ContractID
										 AND A.AccountID = AC.AccountID
	JOIN LibertyPower..AccountStatus AST ON AST.AccountContractID = AC.AccountContractID
	WHERE CR.Number = @p_contract_nbr
	  AND ASTR.[Status] = '07000' 
	  AND ASTR.[SubStatus] = '10'
	  AND AST.[Status] in ('999999','911000', '999998')	-- 1-3809331 STATUS ADDED TO RESULT IN CREATE UTILITY FILE PER TICKET		JM					



	-- Here is where we insert the next check step into the check_account table.
	IF @p_approval_status = 'APPROVED' and @w_order > 0
	BEGIN                                                           
	   SELECT @w_check_type = @w_check_type_next

	   SELECT top 1 @w_status_code = status_code
	   FROM lp_common..common_check_type_status WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 WITH (NOLOCK INDEX = common_check_type_status_idx)
	   WHERE check_type = @w_check_type
	   ORDER BY seq
	   
	   --MD056 the next step should only be created if there's any account with the current status specified in the next step, 
	   --or if the current status in the new step is null or 'ALL'
	   DECLARE @w_next_step_required bit
	   DECLARE @w_next_step_current_status varchar(50)                                                          
	   DECLARE @w_next_step_current_sub_status varchar(50)
	   
	   SELECT @w_next_step_current_status = t.CurrentAccountStatus,
			  @w_next_step_current_sub_status = t.CurrentAccountSubStatus
	   FROM libertypower.dbo.DealScreeningPathAssignment pa
	   JOIN libertypower.dbo.DealScreeningPath p on pa.DealScreeningPathID = p.DealScreeningPathID
	   JOIN libertypower.dbo.DealScreeningStep s on p.DealScreeningPathID = s.DealScreeningPathID 
	   JOIN libertypower.dbo.DealScreeningStepType st on s.StepTypeID = st.DealScreeningStepTypeID 
	   JOIN libertypower.dbo.DealScreeningTransition t on s.DealScreeningStepID = t.DealScreeningStepID 
	   WHERE 1=1
		 AND (pa.Utility = @w_utility_id OR pa.Utility IS NULL)
		 AND (pa.Market = @w_retail_mkt_id OR pa.Market IS NULL)
		 AND pa.ContractType = @w_contract_type
		 AND st.Description = @w_check_type
		 AND t.Disposition = 'APPROVED'
		ORDER BY pa.Utility, pa.Market desc
	   
	   IF (
			(@w_next_step_current_status is null and @w_next_step_current_sub_status is null)
			OR (@w_next_step_current_status = 'ALL' and @w_next_step_current_sub_status = 'ALL')
			OR EXISTS ( SELECT A.AccountNumber 
						FROM LibertyPower..Account A
						JOIN LibertyPower..AccountContract AC ON A.AccountID = AC.AccountID
						JOIN LibertyPower..AccountStatus S ON S.AccountContractID = AC.AccountContractID
						JOIN LibertyPower..Contract C ON C.ContractID = AC.ContractID
						WHERE C.Number = @p_contract_nbr
						AND S.[status] = @w_next_step_current_status AND S.substatus = @w_next_step_current_sub_status)
		  )
	   BEGIN
			SET @w_next_step_required = 1
	   END
	   ELSE
	   BEGIN
			SET @w_next_step_required = 0
	   END
	   
	   IF @w_next_step_required = 1
	   BEGIN
		   -- If you APPROVE a check step, the next step gets created.  If the next step already exists, we return an error.
			IF EXISTS(SELECT contract_nbr FROM check_account with (nolock) WHERE contract_nbr = @p_contract_nbr AND check_type = @w_check_type_next AND check_request_id = @p_check_request_id)
				SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_descp_add = ' (Another Check Process EXISTS)', @w_return = 1
			IF (@w_error <> 'E')
			BEGIN
				EXEC @w_return = lp_enrollment..usp_check_account_ins @p_username, @p_contract_nbr, @w_account_id, @w_check_type, 'RENEWAL', @w_status_code, @w_getdate, ' ', '19000101', 'ONLINE', ' ', ' ', '19000101', ' ', '19000101', '19000101', 0, @w_error output, @w_msg_id output,  ' ', 'N'   
			END
	   END

	   IF @w_return <> 0
	   BEGIN
		  ROLLBACK TRAN check_account
		  IF (@w_error <> 'E')
			SELECT @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000051', @w_return = 1, @w_descp_add = ' (Insert ' + ltrim(rtrim(@w_check_type)) + ')'
		  GOTO GOTO_select
	   END
	END


	COMMIT TRAN check_account

	IF @w_commission_on_approval = 1 AND @p_approval_status = 'APPROVED'
		EXECUTE lp_commissions..usp_transaction_request_enrollment_process @p_account_id, @p_contract_nbr, 'RENEWCOMM', null, 'RENEWAL CHECK STEP',  @p_username
	ELSE IF @p_approval_status = 'REJECTED'
		EXECUTE lp_commissions..usp_transaction_request_enrollment_process @p_account_id, @p_contract_nbr, null, null, 'ENROLLMENT REJECTION CHECK STEP',  @p_username

		
	GOTO_select:
	 
	IF @w_error <> 'N'
	BEGIN
	   EXEC lp_common..usp_messages_sel @w_msg_id, @w_descp output, @w_application
	   SELECT @w_descp = ltrim(rtrim(@w_descp )) + ' ' + @w_descp_add
	END
	 
	IF @p_result_ind = 'Y'
	BEGIN
	   SELECT flag_error = @w_error, code_error = @w_msg_id, message_error = @w_descp
	   GOTO GOTO_return
	END
	 
	SELECT @p_error = @w_error, @p_msg_id = @w_msg_id, @p_descp = @w_descp

	set nocount off; 
	GOTO_return:
	return @w_return
	
END
