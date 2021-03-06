USE [lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_check_account_approval_reject]    Script Date: 04/27/2012 17:14:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC usp_check_account_approval_reject 'libertypower\dmarino', '0114671', ' ', 'NONE', 'PROFITABILITY', 'ENROLLMENT', 'APPROVAL', 'tabaco'

-- =======================================
-- Modified: DEV 8/23/2007 PROD 8/27/2007
-- Modified By: Gail Mangaroo
-- Changed to call lp_enrollment..[usp_comm_trans_detail_ins_express] instead of lp_account..account_commission_request_ins
-- =====================================================================================================

-- =======================================
-- Modified 11/07/2007 GM 
-- added commission audit trail.
-- =======================================

-- =======================================
-- Modified 11/20/2007 Rick Deigsler
-- Added ability to approve a previously rejected check account step
-- If rejected step was credit check, then a reason code is required.
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
-- Modified 5/13/2009 Gail Mangaroo Prod 7/1/2009
-- Added call to usp_comm_trans_detail_ins_auto so chargebacks can be created if necessary
-- =======================================

-- =======================================
-- Modified 10/14/2010 Hector Gomez
-- Added the NOLOCK to SELECT statements that access lp_account
-- because we have had deadlock error messages and based on the tracking_ins stored proc
-- it recorded #4 but not #6 so in between is where I added this NOLOCK
-- =======================================

-- =======================================
-- Modified 10/28/2010 Gail Mangaroo 
-- Replaced commissions call with call to lp_commissions..usp_transaction_request_enrollment_process 
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
-- Modified 10/29/2011 Eric Hernandez
-- If the step being approved is 'CHECK ACCOUNT', this is a returning account
-- which means it still has old flow values which need to be reset.
-- =======================================
-- Modified 2/02/2012 Jaime Forero
-- Refactored to use the new tables. IT079
-- =======================================
-- Modified 3/27/2012 Isabelle Tamanini
-- Added logic to only change the status if approval status is not INCOMPLETE
-- SR1-11788321
-- =======================================
-- Modified 05/06/2011 Isabelle Tamanini
-- Use @p_check_request_id instead of 'ENROLLMENT' hardcoded
-- SR1-4112671
-- =======================================

ALTER PROCEDURE [dbo].[usp_check_account_approval_reject]

@p_username         nchar(100),
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
@p_result_ind			char(01)		= 'Y',
@p_reason_code			char(10)		= 'NONE'

AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

/*
DECLARE @p_username         nchar(100)
DECLARE @p_contract_nbr     char(12)
DECLARE @p_account_id       char(12)
DECLARE @p_account_number   varchar(30)
DECLARE @p_check_type       char(15)
DECLARE @p_check_request_id char(15)
DECLARE @p_approval_status	 char(15)
DECLARE @p_comment          varchar(max)
DECLARE @p_error            char(01)
DECLARE @p_msg_id           char(08)
DECLARE @p_descp            varchar(250)
DECLARE @p_result_ind       char(01)

SET @p_username = 'libertypower\e3hernandez'
SET @p_contract_nbr = '2007-0001074'
SET @p_account_id  = 'NONE' 
SET @p_account_number = ' '
SET @p_check_type = 'USAGE ACQUIRE'
SET @p_check_request_id = 'ENROLLMENT'
SET @p_approval_status = 'APPROVED'
SET @p_comment = 'All Usage Acquired'
SET @p_error = ' '
SET @p_msg_id = ' '
SET @p_descp = ' '
SET @p_result_ind = 'Y'
*/


DECLARE @w_error     char(01)
DECLARE @w_msg_id    char(08)
DECLARE @w_descp     varchar(250)
DECLARE @w_descp_add varchar(100)
DECLARE @w_return    int
DECLARE @w_AccountID INT;
DECLARE @w_ContractID INT;
 
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

IF @p_account_id is null and (@p_account_number is not null and LTRIM(RTRIM(@p_account_number)) <> '')
BEGIN
	SELECT @p_account_id = AccountIDLegacy, @w_AccountID = AccountID FROM LibertyPower..Account (NOLOCK) WHERE AccountNumber = @p_account_number;
END

-- Backwards compatible, 
IF @p_account_id IS NOT NULL AND @w_AccountID IS NULL
BEGIN
	IF @p_contract_nbr IS NULL
		SELECT  @p_account_number = AccountNumber , 
				@w_AccountID = AccountID, 
				@w_ContractID = CurrentContractID ,
				@p_contract_nbr = C.Number
		FROM LibertyPower..Account    A (NOLOCK) 
		JOIN LibertyPower..[Contract] C (NOLOCK) ON A.CurrentContractID = C.ContractID 
		WHERE AccountIDLegacy = @p_account_id; 	
	ELSE
		SELECT @p_account_number = AccountNumber , @w_AccountID = AccountID 
		FROM LibertyPower..Account (NOLOCK) 
		WHERE AccountIDLegacy = @p_account_id; 
END 


IF @p_contract_nbr IS NOT NULL AND LTRIM(RTRIM(@p_contract_nbr)) <> ''
BEGIN
   SELECT @w_ContractID = ContractID FROM LibertyPower..[Contract] (NOLOCK) WHERE Number = @p_contract_nbr;
END

-- After this point we should have a contractid or an accountid


DECLARE @w_order int, @w_order_last int, @w_order_next int, @w_check_type char(30), @w_check_type_last char(30), @w_check_type_next char(30)
DECLARE @NextStepNumber INT, @CurrentStepNumber INT, @CurrentCheckType VARCHAR(30), @NextCheckType VARCHAR(30)

DECLARE @w_utility_id char(15), @w_contract_type varchar(35), @w_por_option varchar(03), @w_account_type varchar(35)

DECLARE @w_getdate datetime
SELECT @w_getdate = getdate()

DECLARE @w_contract_type_last varchar(35), @w_por_option_last varchar(03), @w_account_type_last varchar(35), @w_role_name varchar(50)

DECLARE @w_account_id char(12),
		@w_check_request_id char(25),
		@w_status char(15),						@w_sub_status char(15),
		@w_wait_status char(15),				@w_wait_sub_status char(15),
		@w_approved_status char(15),			@w_approved_sub_status char(15),
		@w_rejected_status char(15),			@w_rejected_sub_status char(15),
		@w_status_code char(15),				@w_commission_on_approval tinyint,
		@w_approval_status_current	char(15),	@w_account_id_for_cursor char(12),
		@w_service_class_req varchar(5),		@w_is_service_class_ready varchar(5),
		@w_trancount int,						@w_retail_mkt_id char(2)

SET		@w_service_class_req		= 'FALSE'
SET		@w_is_service_class_ready	= 'TRUE'
SET		@w_trancount				 = @@TRANCOUNT

-- Using the contract_nbr or account_number, we retrieve the utility, contract_type (VOICE/PAPER), account_type (MASS_MARKET/NATIONAL) and por_option.

SELECT top 1 
@w_utility_id = U.UtilityCode, 
@w_contract_type = LibertyPower.dbo.ufn_GetLegacyContractType(CT.[Type], C.ContractTemplateID, CDT.DealType ),
@w_account_type = At.[AccountType] , 
@w_por_option = CASE WHEN A.PorOption = 1 THEN 'YES' ELSE 'NO' END, 
@w_retail_mkt_id = M.MarketCode
FROM LibertyPower..Account A (NOLOCK)
JOIN LibertyPower..AccountType AT (NOLOCK)	ON A.AccountTypeID = AT.ID
JOIN LibertyPower..[Contract] C (NOLOCK)	ON A.CurrentContractID = C.ContractID
JOIN LibertyPower..Utility U  (NOLOCK)		ON A.UtilityID = U.ID
JOIN LibertyPower..[ContractDealType] CDT (NOLOCK) ON C.ContractDealTypeID = CDT.ContractDealTypeID
JOIN LibertyPower.dbo.ContractType CT (NOLOCK)	ON C.ContractTypeID = CT.ContractTypeID
JOIN LibertyPower.dbo.Market M	 (NOLOCK)	ON A.RetailMktID = M.ID
WHERE	C.ContractID = ISNULL(@w_ContractID, C.ContractID) 
	AND A.AccountID  = ISNULL(@w_AccountID,  A.AccountID)

--SELECT top 1 @w_utility_id = utility_id, @w_contract_type = contract_type, @w_account_type = account_type, @w_por_option = por_option, @w_retail_mkt_id = retail_mkt_id
--FROM lp_account..account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 WITH (NOLOCK INDEX = account_idx2)
--WHERE contract_nbr = isnull(@p_contract_nbr,contract_nbr) and account_id = isnull(@p_account_id,account_id)


-- PRINT 'ENTER HERE *******************************************************';
 
PRINT 'SECTION 1 ***************************************';
-- **************************************************
-- *******  SECTION 1  ******************************
-- **************************************************
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 1, '@w_utility_id', @w_utility_id
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 1, '@w_contract_type', @w_contract_type
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 1, '@w_account_type', @w_account_type
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 1, '@w_por_option', @w_por_option

-- This section essentially is just to determine the previous and next check-steps.
SELECT @w_order = [order], @w_role_name = role_name
FROM lp_common..common_utility_check_type WITH (NOLOCK) -- INDEX = common_utility_check_type_idx)
WHERE utility_id = @w_utility_id and contract_type = @w_contract_type and check_type = @p_check_type

SELECT @w_order_last = isnull(max([order]), 0)
FROM lp_common..common_utility_check_type WITH (NOLOCK) -- INDEX = common_utility_check_type_idx)
WHERE utility_id = @w_utility_id and contract_type = @w_contract_type and [order] < @w_order

SELECT @w_order_next = isnull(min([order]), 0)
FROM lp_common..common_utility_check_type WITH (NOLOCK) -- INDEX = common_utility_check_type_idx)
WHERE utility_id = @w_utility_id and contract_type = @w_contract_type and [order] > @w_order

SELECT @w_check_type_last = check_type
FROM lp_common..common_utility_check_type WITH (NOLOCK) -- INDEX = common_utility_check_type_idx)
WHERE utility_id = @w_utility_id and contract_type = @w_contract_type and [order] = @w_order_last

SELECT @w_check_type_next = check_type
FROM lp_common..common_utility_check_type WITH (NOLOCK) -- INDEX = common_utility_check_type_idx)
WHERE utility_id = @w_utility_id and contract_type = @w_contract_type and [order] = @w_order_next

-- This retrieves the current status for the check_type.  For example, if we're approving something, the current status would probably be "pending".
SELECT @w_status_code = approval_status
FROM check_account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 WITH (NOLOCK INDEX = check_account_idx)
WHERE contract_nbr = @p_contract_nbr and check_type = @w_check_type_next and check_request_id = @p_check_request_id

-- This retrieves the last status to determine if last step was rejected...
-- to be used if last step was rejected and is now being approved
SELECT	@w_approval_status_current = approval_status
FROM	check_account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 WITH (NOLOCK INDEX = check_account_idx)
WHERE	contract_nbr = @p_contract_nbr and check_type = @p_check_type and check_request_id = @p_check_request_id

PRINT 'SECTION 2 ***************************************';
-- **************************************************
-- *******  SECTION 2  ******************************
-- **************************************************
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 2, '@w_order', @w_order
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 2, '@w_order_last', @w_order_last
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 2, '@w_order_next', @w_order_next
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 2, '@w_check_type_last', @w_check_type_last
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 2, '@w_check_type_next', @w_check_type_next
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 2, '@w_status_code', @w_status_code
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 2, '@w_approval_status_current', @w_approval_status_current

--Logic moved to line above were the step is inserted (MD056)
---- If you APPROVE a check step, the next step gets created.  If the next step already exists, we return an error.
--IF EXISTS(SELECT contract_nbr FROM check_account (NOLOCK) WHERE contract_nbr = @p_contract_nbr and check_type = @w_check_type_next and check_request_id = @p_check_request_id)
--   SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_descp_add = ' (Another Check Process EXISTS)', @w_return = 1

-- Here we check if it is valid to APPROVE a check step.
IF @p_approval_status = 'APPROVED' AND EXISTS(SELECT check_type FROM lp_common..common_check_type_status (NOLOCK) WHERE check_type = @p_check_type and status_code = @w_status_code and approval_online = 0)
	SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_return = 1, @w_descp_add = '(The step can not approve online)'

IF @p_approval_status = 'APPROVED' AND EXISTS(SELECT approval_status FROM check_account (NOLOCK) WHERE contract_nbr = @p_contract_nbr and check_type = @p_check_type and approval_status = 'REJECTED')
	AND @w_check_type not in ('TPV','DOCUMENT','USAGE ACQUIRE')
	SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_return = 1, @w_descp_add = '(check_account)'

-- Here we check if it is valid to REJECT a check step.
IF @p_approval_status = 'REJECTED' AND EXISTS(SELECT check_type FROM lp_common..common_check_type_status (NOLOCK) WHERE check_type = @p_check_type and status_code = @w_status_code and reject_online = 0)
	SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_return = 1, @w_descp_add = '(The step can not reject online)'

IF @p_approval_status = 'REJECTED' AND EXISTS(SELECT approval_status FROM check_account (NOLOCK) WHERE contract_nbr = @p_contract_nbr and check_type = @p_check_type and approval_status = 'APPROVED')
	SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_return = 1, @w_descp_add = '(check_account)'


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
IF @p_username not in ('SYSTEM','Usage Trigger','USAGE ACQUIRE SCRAPER') AND NOT EXISTS (SELECT sales_channel_role FROM lp_common..ufn_check_role(@p_username, @w_role_name))
AND lp_common.dbo.ufn_is_liberty_employee(@p_username) = 0
BEGIN
   SELECT @w_error = 'E', @w_msg_id = '00000013', @w_application = 'SECURITY', @w_return = 1
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

IF (SELECT count([order]) FROM lp_common..common_utility_check_type (NOLOCK) WHERE utility_id = @w_utility_id and contract_type = @w_contract_type and [order] = @w_order) > 1
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

PRINT 'SECTION 3 ***************************************';
-- **************************************************
-- *******  SECTION 3  ******************************
-- **************************************************
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 3, '@w_wait_status', @w_wait_status
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 3, '@w_wait_sub_status', @w_wait_sub_status
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 3, '@w_approved_status', @w_approved_status
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 3, '@w_approved_sub_status', @w_approved_sub_status
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 3, '@w_rejected_status', @w_rejected_status
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 3, '@w_rejected_sub_status', @w_rejected_sub_status
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 3, '@w_commission_on_approval', @w_commission_on_approval


-- The wait status should reflect the current status of the account.
CREATE TABLE #wait_status (status varchar(15), sub_status varchar(15))    
IF @w_wait_status = '*'
BEGIN
   INSERT INTO #wait_status
   SELECT status, sub_status
   FROM lp_common..common_check_type_status_code WITH (NOLOCK)-- REMOVE USE INDEX. TICKET 18281 WITH (NOLOCK INDEX = common_check_type_status_code_idx)
   WHERE code = @w_wait_sub_status
END
ELSE IF @w_wait_status = 'ALL'
BEGIN
   INSERT INTO #wait_status
   SELECT status, sub_status
   FROM lp_account.dbo.enrollment_sub_status (NOLOCK)
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

PRINT 'SECTION 4***************************************';
-- **************************************************
-- *******  SECTION 4  ******************************
-- **************************************************
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 4, '@w_status', @w_status
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 4, '@w_sub_status', @w_sub_status


-- If being called from a trigger, there will already be an implicit transaction
-- so create a savepoint instead of beginning a transaction
--IF @w_trancount > 0
--	SAVE TRAN check_account_rollback
--ELSE
--	BEGIN TRAN check_account

BEGIN TRAN check_account

SELECT @w_account_id = isnull(@p_account_id,' ')

-- ================================================================ REVIEW THIS !!!!!!!!!!!!!!!!!!
-- Recording comments.
INSERT INTO lp_account..account_comments
SELECT A.AccountIDLegacy AS account_id, @w_getdate, @w_check_type_last, @p_comment, @p_username, 0
FROM LibertyPOwer..Account A (NOLOCK) 
JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
JOIN LibertyPOwer..[Contract] C (NOLOCK)  ON AC.ContractID = C.ContractID
JOIN LibertyPower..AccountStatus AST  (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
JOIN #wait_status b ON AST.[Status] = CASE WHEN @w_approval_status_current = 'REJECTED' THEN '999999' ELSE b.[status] END  AND AST.[SubStatus] = b.sub_status
WHERE C.ContractID = @w_ContractID and A.AccountIDLegacy = isnull(@p_account_id,a.AccountIDLegacy)


-- Recording status history for the status change that already occurred.
-- Note that if approved status of a check account step is null, that is how we indicate that the status of the account should not change.
IF @w_status is not null AND @w_sub_status is not null
BEGIN 
	INSERT INTO lp_account..account_status_history 
	SELECT A.AccountIDLegacy, @w_status, @w_sub_status, @w_getdate, @p_username, @w_check_type_last, ' ',' ',' ',' ',' ',' ',' ',' ',@w_getdate
	FROM LibertyPOwer..Account A (NOLOCK) 
	JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	JOIN LibertyPOwer..[Contract] C (NOLOCK)  ON AC.ContractID = C.ContractID
	JOIN LibertyPower..AccountStatus AST  (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	JOIN #wait_status b ON AST.[Status] = b.status and AST.[SubStatus] = b.sub_status
	WHERE C.ContractID = @w_ContractID and A.AccountIDLegacy = isnull(@p_account_id,A.AccountIDLegacy)
END

-- Check if there is more than 1 account in contract.
-- If so, then set to INCOMPLETE.
IF @w_check_type_last = 'USAGE ACQUIRE' AND @p_approval_status = 'REJECTED' AND @p_username IN ('Usage Trigger','USAGE ACQUIRE SCRAPER')
	BEGIN
		IF (SELECT COUNT(A.AccountNumber) 
			FROM LibertyPower..Account A (NOLOCK) 
			JOIN LibertyPower..[Contract] C (NOLOCK) ON A.CurrentContractID = C.ContractID AND C.ContractID = @w_ContractID
			) > 1
			BEGIN
				SET	@p_approval_status = 'INCOMPLETE'
			END
	END

PRINT 'SECTION 6***************************************';
-- **************************************************
-- *******  SECTION 6  ******************************
-- **************************************************
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 6, '@w_check_type_last', @w_check_type_last
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 6, '@p_approval_status', @p_approval_status
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 6, '@p_approval_status', @p_approval_status

-- get approval_status of current check account step before update
IF (@w_check_type_last = 'USAGE ACQUIRE' AND @p_username not in ('Usage Trigger','USAGE ACQUIRE SCRAPER')) OR @w_check_type_last = 'RATE CODE APPROVAL'
	BEGIN
	   SELECT @w_approval_status = RTRIM(LTRIM(approval_status)), @w_userfield_text_02 = userfield_text_02
	   FROM lp_enrollment..check_account WITH (NOLOCK INDEX = check_account_idx)
	   WHERE contract_nbr = @p_contract_nbr and check_type = @w_check_type_last and check_request_id = @p_check_request_id
	END

PRINT 'SECTION 7***************************************';
-- **************************************************
-- *******  SECTION 7  ******************************
-- **************************************************
--EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 7, '@w_approval_status', @w_approval_status
--EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 7, '@w_userfield_text_02', @w_userfield_text_02

-- This updates the check step which just got approved/rejected.
UPDATE lp_enrollment..check_account 
SET approval_status = @p_approval_status, approval_comments = @p_comment, approval_eff_date = @w_getdate, username = @p_username
FROM lp_enrollment..check_account WITH (NOLOCK INDEX = check_account_idx)
--WHERE contract_nbr = @p_contract_nbr and account_id = isnull(@p_account_id,' ') and check_type = @w_check_type_last and check_request_id = @p_check_request_id
WHERE contract_nbr = @p_contract_nbr and check_type = @w_check_type_last and check_request_id = @p_check_request_id
  and date_created = (select max(date_created) from lp_enrollment..check_account with (NOLOCK)
					  where contract_nbr = @p_contract_nbr 
					    and check_type = @w_check_type_last 
					    and check_request_id = @p_check_request_id)

-- If approving a rate code approval step,
-- set billing type to dual for those accounts without rate code, rate ready for accounts with rate code
IF @w_check_type_last = 'RATE CODE APPROVAL' AND @p_approval_status = 'APPROVED' -- AND @w_approval_status = 'INCOMPLETE'
	EXEC lp_account..usp_account_billing_type_upd @p_contract_nbr, @p_check_request_id


-- Here we update the status on the account.  
-- The JOIN with the #wait_status table ensures that the account is currently in the expected status for this check step.
IF @w_check_type_last = 'USAGE ACQUIRE' AND @p_username not in ('Usage Trigger','USAGE ACQUIRE SCRAPER')
	BEGIN
	   IF @p_approval_status = 'APPROVED' and @w_approval_status not in ('REJECTED','INCOMPLETE','PENDING')
		   BEGIN
				IF @@TRANCOUNT > 0
					ROLLBACK TRAN check_account
			    EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 7, '@p_contract_nbr', @p_contract_nbr

				SELECT @w_application = 'ACCOUNT', @w_error = 'E', @w_msg_id = '00000014', @w_return = 1
				GOTO GOTO_select			
/*
			  UPDATE lp_account..account 
			  SET status = isnull(@w_approved_status,a.status), sub_status = isnull(@w_approved_sub_status,a.sub_status)
			  FROM lp_account..account a
			  JOIN lp_risk..risk_tariff_rejects_accepts b ON ltrim(rtrim(a.account_number)) = ltrim(rtrim(b.account_number))
			  JOIN #wait_status c ON a.status = c.status and a.sub_status = c.sub_status
			  WHERE a.contract_nbr = isnull(@p_contract_nbr,a.contract_nbr) and a.account_id = isnull(@p_account_id,a.account_id)
			  and b.request_id = @w_userfield_text_02 and b.status = 'ACCEPTED'

			  IF @@rowcount <> 0
				 SELECT @w_status = @w_rejected_status, @w_sub_status = @w_rejected_sub_status
*/
		   END
		ELSE IF @p_approval_status = 'COMPLETED'
			BEGIN
				SELECT @w_status = @w_approved_status, @w_sub_status = @w_approved_sub_status
			END
		ELSE IF @w_check_type_last = 'USAGE ACQUIRE' AND @p_approval_status = 'APPROVED'
			BEGIN
				SELECT @w_status = @w_wait_status, @w_sub_status = @w_wait_sub_status
			END
		ELSE IF @p_approval_status = 'REJECTED' OR @w_approval_status = 'INCOMPLETE'
			BEGIN 
				SELECT @w_status = @w_rejected_status, @w_sub_status = @w_rejected_sub_status
		--			  ELSE IF @p_approval_status = 'APPROVED' -- AND @w_approval_status <> 'INCOMPLETE'
		--				 SELECT @w_status = @w_approved_status, @w_sub_status = @w_approved_sub_status
			END

			--IF @@TRANCOUNT > 0
			--	COMMIT TRAN check_account

		PRINT 'SECTION 8 ***************************************';
        -- **************************************************
		-- *******  SECTION 8  ******************************
		-- **************************************************
		EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 8, '@w_status', @w_status
		EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 8, '@w_sub_status', @w_sub_status

		-- for incomplete, only set status to not enrolled only for single account
		IF @p_approval_status = 'INCOMPLETE'
			BEGIN
				-- Refactored
				--UPDATE	lp_account..account 
				--SET		status = isnull(@w_status,a.status), 
				--		sub_status = isnull(@w_sub_status,a.sub_status)
				--FROM	lp_account..account a 
				--JOIN #wait_status b ON a.status = b.status and a.sub_status = b.sub_status
				--WHERE	a.contract_nbr = isnull(@p_contract_nbr,contract_nbr) 
				--and		a.account_id = isnull(@p_account_id,account_id)
				--AND		a.account_number = @p_account_number
				
				UPDATE AST
				SET AST.[Status]	 = ISNULL(@w_status, AST.[Status] ), 
					AST.[SubStatus]  = ISNULL(@w_sub_status,AST.[SubStatus])
				FROM Libertypower.dbo.AccountStatus AST
				JOIN Libertypower.dbo.AccountContract AC ON AST.AccountContractID = AC.AccountContractID
				JOIN Libertypower.dbo.[Contract] C ON C.ContractID = AC.ContractID
				JOIN Libertypower.dbo.Account A ON A.AccountID = AC.AccountID
				JOIN #wait_status b ON AST.[Status] = b.[status] and AST.SubStatus = b.[sub_status]
				WHERE	C.Number			= ISNULL(@p_contract_nbr,C.Number) 
				AND		A.AccountIdLegacy	= ISNULL(@p_account_id, A.AccountIdLegacy)
				--AND		A.AccountNumber		= @p_account_number
				
				--END REFACTOR
			END
		ELSE IF @p_approval_status = 'APPROVED'
			BEGIN
				--REFACTORED
				--UPDATE lp_account..account 
				--SET status		= isnull(@w_approved_status,a.status), 
				--    sub_status	= isnull(@w_approved_sub_status,a.sub_status)
				--FROM lp_account..account a JOIN #wait_status b ON a.status = b.status and a.sub_status = b.sub_status
				--WHERE	a.contract_nbr = isnull(@p_contract_nbr,contract_nbr) 
				--and		a.account_id = isnull(@p_account_id,account_id)
				
				UPDATE AST
				SET AST.[Status]	 = ISNULL(@w_approved_status, AST.[Status] ), 
					AST.[SubStatus]  = ISNULL(@w_approved_sub_status,AST.[SubStatus])
				FROM Libertypower.dbo.AccountStatus AST
				JOIN Libertypower.dbo.AccountContract AC ON AST.AccountContractID = AC.AccountContractID
				JOIN Libertypower.dbo.[Contract] C ON C.ContractID = AC.ContractID
				JOIN Libertypower.dbo.Account A ON A.AccountID = AC.AccountID
				JOIN #wait_status b ON AST.[Status] = b.[status] and AST.SubStatus = b.[sub_status]
				WHERE	C.Number			= ISNULL(@p_contract_nbr,C.Number) 
				AND		A.AccountIdLegacy	= ISNULL(@p_account_id, A.AccountIdLegacy)
				-- END REFACTORED
			END
		ELSE
			BEGIN
				--REFACTORED
				--UPDATE lp_account..account 
				--SET status		= isnull(@w_status,a.status), 
				--	sub_status	= isnull(@w_sub_status,a.sub_status)
				--FROM lp_account..account a JOIN #wait_status b ON a.status = b.status and a.sub_status = b.sub_status
				--WHERE	a.contract_nbr = isnull(@p_contract_nbr,contract_nbr) 
				--and		a.account_id = isnull(@p_account_id,account_id)
				
				UPDATE AST
				SET AST.[Status]	 = ISNULL(@w_status, AST.[Status] ), 
					AST.[SubStatus]  = ISNULL(@w_sub_status,AST.[SubStatus])
				FROM Libertypower.dbo.AccountStatus AST
				JOIN Libertypower.dbo.AccountContract AC ON AST.AccountContractID = AC.AccountContractID
				JOIN Libertypower.dbo.[Contract] C ON C.ContractID = AC.ContractID
				JOIN Libertypower.dbo.Account A ON A.AccountID = AC.AccountID
				JOIN #wait_status b ON AST.[Status] = b.[status] and AST.SubStatus = b.[sub_status]
				WHERE	C.Number			= ISNULL(@p_contract_nbr,C.Number) 
				AND		A.AccountIdLegacy	= ISNULL(@p_account_id, A.AccountIdLegacy)
				-- END REFACTORED
			END
	END
ELSE
BEGIN
	   SELECT @w_approval_status = approval_status, @w_userfield_text_02 = userfield_text_02
	   FROM lp_enrollment..check_account WITH (NOLOCK INDEX = check_account_idx)
	   WHERE contract_nbr = @p_contract_nbr and check_type = @w_check_type_last and check_request_id = @p_check_request_id

		PRINT 'SECTION 9 ***************************************';
		-- **************************************************
		-- *******  SECTION 9  ******************************
		-- **************************************************
		EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 9, '@w_approval_status', @w_approval_status
		EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 9, '@w_userfield_text_02', @w_userfield_text_02

		-- This update is for the specific request to approve a rejected check account step
		-- set the status and sub-status to the approved status and sub-status of rejected step
	   IF  @p_approval_status = 'APPROVED' AND @w_approval_status_current = 'REJECTED'
			BEGIN
				-- If the approved status is null, then we rollback the status of the account.
				-- An approved status of null indicates that the status should not change, so we are making it as though the status never changed.
				IF @w_approved_status is null AND @w_approved_sub_status is null
				BEGIN
					-- Update each account in contract
					DECLARE cur CURSOR FOR
						SELECT A.AccountIdLegacy AS account_id
						FROM LibertyPOwer..Account A (NOLOCK) 
						WHERE CurrentContractID = @w_ContractID;
					OPEN cur
					FETCH NEXT FROM cur INTO @w_account_id_for_cursor
					WHILE (@@FETCH_STATUS <> -1) 
						BEGIN 
							-- Verify that the status has to be restored.
							IF EXISTS (SELECT account_id FROM lp_account.dbo.account (NOLOCK) WHERE status = @w_rejected_status AND sub_status = @w_rejected_sub_status)
								EXEC lp_account.dbo.usp_AccountSetToPreviousStatus @w_account_id_for_cursor

							FETCH NEXT FROM cur INTO @w_account_id_for_cursor
						END
					CLOSE cur 
					DEALLOCATE cur
				END
				ELSE
				BEGIN
				
				
					--UPDATE lp_account..account 
					--SET status = @w_approved_status, 
					--sub_status = @w_approved_sub_status
					--WHERE contract_nbr = isnull(@p_contract_nbr,contract_nbr) and account_id = isnull(@p_account_id,account_id)
					
					UPDATE AST
					SET AST.[Status] = @w_approved_status, 
						AST.SubStatus = @w_approved_sub_status
					FROM LibertyPower..AccountContract AC (NOLOCK) 
					JOIN LibertyPower..AccountStatus AST ON AC.AccountContractID = AST.AccountContractID 
					WHERE AC.ContractID = @w_ContractID;
					
				END
					
				PRINT 'SECTION 10 ***************************************';

				-- **************************************************
				-- *******  SECTION 10  *****************************
				-- **************************************************
				EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 10, '@w_approved_status', @w_approved_status
				EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 10, '@w_approved_sub_status', @w_approved_sub_status

				-- insert reason code for each account in contract
				DECLARE cur CURSOR FOR
					--SELECT	account_id 
					--FROM	lp_account..account (NOLOCK)
					--WHERE	contract_nbr = @p_contract_nbr
					
					SELECT A.AccountIdLegacy AS account_id
						FROM LibertyPOwer..Account A (NOLOCK) 
						WHERE CurrentContractID = @w_ContractID;
					
					
					
				OPEN cur
				FETCH NEXT FROM cur INTO @w_account_id_for_cursor
				WHILE (@@FETCH_STATUS <> -1) 
					BEGIN 
						INSERT INTO	lp_account..account_reason_code_hist
									(account_id, date_created, reason_code, process_id, username, chgstamp)
						VALUES		(@w_account_id_for_cursor, GETDATE(), CASE WHEN @p_reason_code = 'NONE' THEN '1032' ELSE @p_reason_code END, 'CHECK ACCOUNT', @p_username, 0)

						FETCH NEXT FROM cur INTO @w_account_id_for_cursor
					END
				CLOSE cur 
				DEALLOCATE cur
			END

			IF NOT( @p_contract_nbr IS NULL ) -- LINE ADDED BY HECTOR GOMEZ 11/12/2010
				BEGIN
					DECLARE @ContractID INT;
					SELECT @ContractID = C.ContractID FROM LibertyPower.dbo.[Contract] C WHERE C.Number = LTRIM(RTRIM(@p_contract_nbr));
					IF @ContractID IS NULL OR @ContractID = 0
						-- per Eric Contract number was required but it seems there might be some old code using acocunt numbers instead
						RAISERROR('ContractID IS NULL, cannot continue, check [usp_check_account_approval_reject] ',11,1)
					
					--SR1-11788321
					IF (@p_approval_status <> 'INCOMPLETE')
					BEGIN
						UPDATE LibertyPower.dbo.AccountStatus
						SET [Status] = ISNULL(@w_status, AST.[Status]), [SubStatus] = ISNULL(@w_sub_status, AST.[SubStatus])
						FROM LibertyPower.dbo.AccountStatus AST
						JOIN LibertyPower.dbo.AccountContract AC ON AST.AccountContractID = AC.AccountContractID AND AC.ContractID = @ContractID
						JOIN #wait_status B on AST.[Status] = B.status and AST.SubStatus = B.sub_status
					END
					
					--UPDATE lp_account..account 
					--SET status = isnull(@w_status,a.status), sub_status = isnull(@w_sub_status,a.sub_status)
					--FROM lp_account..account a 
					--JOIN #wait_status b on a.status = b.status and a.sub_status = b.sub_status
					--		--WHERE a.contract_nbr = isnull(@p_contract_nbr,a.contract_nbr) and a.account_id = isnull(@p_account_id,a.account_id) COMMENTED OUT BY HECTOR GOMEZ 11/12/2010 confirmed by ERIC
					--WHERE a.contract_nbr = @p_contract_nbr 	
				
				END

			PRINT 'SECTION 11***************************************';

		    -- **************************************************
		    -- *******  SECTION 11  *****************************
		    -- **************************************************
		    EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 11, '@w_status', @w_status
		    EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 11, '@w_sub_status', @w_sub_status

END



-- If this is a returning account, it still has old flow values which need to be reset.  -- 2011-10-29

-- Commented out, new schema changes take care of this condition
--IF @w_check_type_last = 'CHECK ACCOUNT' AND @p_approval_status = 'APPROVED'
--BEGIN
	-- PRINT 'SECTION 11.1 ***************************************';
	--UPDATE lp_account..account
	--SET date_flow_start = '1900-01-01', date_deenrollment = '1900-01-01'
	--WHERE contract_nbr = @p_contract_nbr 
	
--END

DECLARE @NextStepRequired BIT
DECLARE @NextStepCurrentStatus VARCHAR(50)                                                          
DECLARE @NextStepCurrentSubStatus VARCHAR(50)

SELECT @NextStepCurrentStatus = t.CurrentAccountStatus,
	   @NextStepCurrentSubStatus = t.CurrentAccountSubStatus
FROM libertypower.dbo.DealScreeningPathAssignment pa
JOIN libertypower.dbo.DealScreeningPath p on pa.DealScreeningPathID = p.DealScreeningPathID
JOIN libertypower.dbo.DealScreeningStep s on p.DealScreeningPathID = s.DealScreeningPathID 
JOIN libertypower.dbo.DealScreeningStepType st on s.StepTypeID = st.DealScreeningStepTypeID 
JOIN libertypower.dbo.DealScreeningTransition t on s.DealScreeningStepID = t.DealScreeningStepID 
WHERE 1=1
 AND (pa.Utility = @w_utility_id OR pa.Utility IS NULL)
 AND (pa.Market = @w_retail_mkt_id OR pa.Market IS NULL)
 AND pa.ContractType = @w_contract_type
 AND st.Description = @w_check_type_next
 AND t.Disposition = @p_approval_status
ORDER BY pa.Utility desc

SELECT TOP 1 @NextStepNumber = t.NextStepNumber
FROM libertypower.dbo.DealScreeningPathAssignment pa
JOIN libertypower.dbo.DealScreeningPath p on pa.DealScreeningPathID = p.DealScreeningPathID
JOIN libertypower.dbo.DealScreeningStep s on p.DealScreeningPathID = s.DealScreeningPathID 
JOIN libertypower.dbo.DealScreeningStepType st on s.StepTypeID = st.DealScreeningStepTypeID 
JOIN libertypower.dbo.DealScreeningTransition t on s.DealScreeningStepID = t.DealScreeningStepID 
WHERE 1=1
 AND (pa.Utility = @w_utility_id OR pa.Utility IS NULL)
 AND (pa.Market = @w_retail_mkt_id OR pa.Market IS NULL)
 AND pa.ContractType = @w_contract_type
 AND st.Description = @p_check_type
 AND t.Disposition = @p_approval_status
ORDER BY pa.Utility, pa.Market desc

EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 500, '@p_check_type', @p_check_type
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 500, '@@@p_approval_status', @p_approval_status
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 500, '@@NextStepNumber', @NextStepNumber


-- This was added for the Billing Tax Exemption step, which creates a new step upon being rejected.
IF @p_approval_status = 'REJECTED' AND @NextStepNumber IS NOT NULL
BEGIN
	EXEC @w_return = lp_enrollment..usp_check_account_ins @p_username, @p_contract_nbr, @w_account_id, 'CUSTOMERCARE TAX EXEMPTION', @p_check_request_id, 'PENDING', @w_getdate, ' ', '19000101', 'ONLINE', ' ', ' ', '19000101', ' ', '19000101', '19000101', 0, @w_error output, @w_msg_id output,  ' ', 'N'   
END

-- Here is where we insert the next check step into the check_account table.
IF @p_approval_status = 'APPROVED' and @w_order > 0 
BEGIN
   SELECT @w_check_type = @w_check_type_next

   SELECT top 1 @w_status_code = status_code
   FROM lp_common..common_check_type_status WITH (NOLOCK INDEX = common_check_type_status_idx)
   WHERE check_type = @w_check_type
   
   --MD056 the next step should only be created if there's any account with the current status specified in the next step, 
   --or if the current status in the new step is null or 'ALL'
   IF ((@NextStepCurrentStatus is null and @NextStepCurrentSubStatus is null)
	   OR (@NextStepCurrentStatus = 'ALL' and @NextStepCurrentSubStatus = 'ALL')
	   OR EXISTS (
				
				SELECT A.AccountNumber 
				FROM LibertyPower..Account A (NOLOCK) 
				-- JOIN LibertyPower..[Contract] C (NOLOCK) 
				JOIN LibertyPower..[AccountContract] AC (NOLOCK)  ON A.AccountID = AC.AccountID AND AC.ContractID = @w_ContractID
				JOIN LibertyPower..[AccountStatus]   AST (NOLOCK) ON AST.AccountContractID = AC.AccountContractID 
				LEFT JOIN lp_account..account_renewal ar on a.accountidlegacy = ar.account_id
				 where (     
								([Libertypower].[dbo].ufn_GetLegacyAccountStatus(AST.[Status], AST.SubStatus) = @NextStepCurrentStatus 
								and 
								[Libertypower].[dbo].ufn_GetLegacyAccountSubStatus(AST.[Status], AST.SubStatus)= @NextStepCurrentSubStatus)
								
								OR 
								(ar.[status] = @NextStepCurrentStatus 
								and 
								ar.sub_status = @NextStepCurrentSubStatus
								)
				)))
		
   BEGIN
		SET @NextStepRequired = 1
   END
   ELSE
   BEGIN
		SET @NextStepRequired = 0
   END
   
   IF @NextStepRequired = 1
   BEGIN
       -- If you APPROVE a check step, the next step gets created.  If the next step already exists, we return an error.
	   --IF EXISTS(SELECT contract_nbr FROM check_account (NOLOCK) WHERE contract_nbr = @p_contract_nbr and check_type = @w_check_type_next and check_request_id = @p_check_request_id)
		  -- SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_descp_add = ' (Another Check Process EXISTS)', @w_return = 1
	   
	   IF (@w_error <> 'E')
	   BEGIN
		   EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 5, '@w_status_code', @w_status_code

		   EXEC @w_return = lp_enrollment..usp_check_account_ins @p_username, @p_contract_nbr, @w_account_id, @w_check_type, @p_check_request_id, @w_status_code, @w_getdate, ' ', '19000101', 'ONLINE', ' ', ' ', '19000101', ' ', '19000101', '19000101', 0, @w_error output, @w_msg_id output,  ' ', 'N'   

			PRINT 'SECTION 5***************************************';

		   -- **************************************************
		   -- *******  SECTION 5  ******************************
		   -- **************************************************
		   EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 5, '@w_status_code', @w_status_code
		   EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 5, '@w_check_type', @w_check_type
	   END
   END
   
   IF @w_return <> 0
   BEGIN
--		IF @w_trancount > 0
--			ROLLBACK TRAN check_account_rollback
--		ELSE
			ROLLBACK TRAN check_account
      EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 5, '@w_return', @w_return
      EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 5, '@w_msg_id', @w_msg_id
      EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 5, '@w_status_code', @w_status_code
      EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 5, '@p_contract_nbr', @p_contract_nbr
	  
	  IF (@w_error <> 'E')
		  SELECT @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000051', @w_return = 1, @w_descp_add = ' (Insert ' + ltrim(rtrim(@w_check_type)) + ')'
		  
	  GOTO GOTO_select
   END
END

IF @@TRANCOUNT > 0
	COMMIT TRAN check_account


--IF @w_trancount > 0
--	COMMIT TRAN check_account_rollback
--ELSE
--	COMMIT TRAN check_account

-- request commission transction
IF @w_commission_on_approval = 1 AND @p_approval_status = 'APPROVED'
	EXECUTE lp_commissions..usp_transaction_request_enrollment_process @p_account_id, @p_contract_nbr, 'COMM', null, 'ENROLLMENT CHECK STEP',  @p_username
ELSE IF @p_approval_status = 'REJECTED'
	EXECUTE lp_commissions..usp_transaction_request_enrollment_process @p_account_id, @p_contract_nbr, null, null, 'ENROLLMENT REJECTION CHECK STEP',  @p_username



PRINT 'SECTION 90***************************************';

GOTO_select:
-- **************************************************
-- *******  SECTION 90  *****************************
-- **************************************************
EXEC usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @p_account_id, @p_account_number, @p_check_type, @p_check_request_id, @p_approval_status, @p_comment, 90, '@@TRANCOUNT', @@TRANCOUNT
 
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
 
GOTO_return:
return @w_return




