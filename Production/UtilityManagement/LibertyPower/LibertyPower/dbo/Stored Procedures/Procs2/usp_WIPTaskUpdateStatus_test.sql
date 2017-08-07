
-- =============================================
-- Created: Isabelle Tamanini 07/23/2012
-- Updates the status of a WIP task for a contract
-- =============================================
/*
begin tran
exec usp_WIPTaskUpdateStatus @p_username=N'LIBERTYPOWER\itamanini',@p_check_request_id=N'Enrollment',
@p_contract_nbr=N'test3',@p_check_type=N'tpv',@p_approval_status=N'APPROVED',@p_comment=N'test'

rollback
select * from wiptask
*/ 
CREATE PROCEDURE [dbo].[usp_WIPTaskUpdateStatus_test]
(@p_username         nchar(100)=null,
 @p_contract_nbr     char(12),
 @p_check_type       char(30),
 @p_approval_status	 char(15),
 @p_comment          varchar(max),
 @p_check_request_id char(15),
 @p_reason_code		 char(10) = 'NONE',
 @p_error            char(01) = ' ' output,
 @p_msg_id           char(08) = ' ' output,
 @p_descp            varchar(250) = ' ' output)
AS
BEGIN
	
	DECLARE @w_error     char(01)
	DECLARE @w_msg_id    char(08)
	DECLARE @w_descp     varchar(250)
	DECLARE @w_descp_add varchar(100)
	DECLARE @w_return    int
	DECLARE @w_application varchar(20)
	DECLARE @p_ContractID INT
	
	IF @p_approval_status = 'APPROVAL'
	BEGIN
	   SELECT @p_approval_status = 'APPROVED'
	END

	IF @p_approval_status = 'REJECT'
	BEGIN
	   SELECT @p_approval_status = 'REJECTED'
	END
	 
	SELECT @w_error = 'I', @w_msg_id = '00000001', @w_descp = ' ', @w_descp_add = ' ', @w_return = 0, @w_application = 'COMMON'

	-- This is a security check to see if the user has access to the Sales Channel.  If the username is "Usage Trigger" or "SYSTEM", then we bypass the security check.
	--DECLARE @w_role_name VARCHAR(50)
	--SELECT @w_order = [order], @w_role_name = role_name
	--FROM lp_common..common_utility_check_type WITH (NOLOCK) -- INDEX = common_utility_check_type_idx)
	--WHERE utility_id = @w_utility_id and contract_type = @w_contract_type and check_type = @p_check_type

	select 'point 1'
	IF @p_username NOT IN ('SYSTEM','Usage Trigger','USAGE ACQUIRE SCRAPER') 
	--AND NOT EXISTS (SELECT sales_channel_role FROM lp_common..ufn_check_role(@p_username, @w_role_name))
	AND lp_common.dbo.ufn_is_liberty_employee(@p_username) = 0
	BEGIN
		select 'point 20'
	   SELECT @w_error = 'E', @w_msg_id = '00000013', @w_application = 'SECURITY', @w_return = 1
	END

	-- Here we enforce that the comment cannot be blank.
	IF @p_comment is null or @p_comment = ' '
	BEGIN
	   SELECT @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00001011', @w_return = 1
	END

	IF @w_error = 'E'
	   GOTO GOTO_select

	select 'point 30'

	-- Check if there is more than 1 account in contract.
	-- If so, then set to INCOMPLETE.
	IF @p_check_type = 'USAGE ACQUIRE' AND @p_approval_status = 'REJECTED' AND @p_username IN ('Usage Trigger','USAGE ACQUIRE SCRAPER')
	BEGIN
		IF (SELECT COUNT(A.AccountNumber) 
			FROM LibertyPower..Account    A (NOLOCK) 
			JOIN LibertyPower..[Contract] C (NOLOCK) ON A.CurrentContractID = C.ContractID 
													AND C.ContractID = @p_ContractID) > 1
			BEGIN
				SET	@p_approval_status = 'INCOMPLETE'
			END
	END

--new code
-------------------------------------
	
	select 'point 40'
	SELECT @p_ContractID = ContractID
	  FROM LibertyPower..[Contract] (NOLOCK)
	 WHERE Number = @p_contract_nbr 
	
	DECLARE @p_TaskStatusID INT
	SELECT @p_TaskStatusID = TaskStatusID
	  FROM LibertyPower..TaskStatus (NOLOCK)
	 WHERE StatusName = @p_approval_status

	DECLARE @p_WIPTaskID INT
	DECLARE @p_WorkflowTaskID INT
	DECLARE @p_WorkflowTaskHeaderID INT
	DECLARE @p_WIPTaskStatus CHAR(15)
	DECLARE @p_WorkflowTaskTypeID INT
	DECLARE @p_WorkflowID INT
	
	SELECT @p_WorkflowTaskID = WIPT.WorkflowTaskID,
		   @p_WIPTaskID = WIPT.WIPTaskID,
		   @p_WIPTaskStatus = TS.StatusName,
		   @p_WorkflowTaskHeaderID = WTH.WIPTaskHeaderId,
		   @p_WorkflowTaskTypeID = TT.TaskTypeID,
		   @p_WorkflowID = WTH.WorkflowID
	  FROM LibertyPower..WIPTask       WIPT (NOLOCK)
	  JOIN LibertyPower..WIPTaskHeader WTH  (NOLOCK) ON WTH.WIPTaskHeaderId = WIPT.WIPTaskHeaderId
	  JOIN LibertyPower..WorkflowTask  WT   (NOLOCK) ON WT.WorkflowTaskID = WIPT.WorkflowTaskID
	  JOIN LibertyPower..TaskType      TT   (NOLOCK) ON TT.TaskTypeID = WT.TaskTypeID
	  JOIN LibertyPower..TaskStatus    TS   (NOLOCK) ON TS.TaskStatusID = WIPT.TaskStatusID
	 WHERE WTH.ContractId = @p_ContractID
	   AND TT.TaskName = @p_check_type
	ORDER BY WIPT.DateCreated -- If there are multiple, we want the last one.
	
	select 'point 50'
	select @p_WIPTaskStatus, @p_approval_status
	-- Does not allow to reject an approved task
	IF (@p_WIPTaskStatus = 'APPROVED' AND @p_approval_status = 'REJECTED')
	BEGIN
		select 'point 51'
		SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_return = 1, @w_descp_add = '(check_account)'
		GOTO GOTO_select
	END
	
	--DECLARE @p_UserId INT
	--SELECT @p_UserId = UserId
	--  FROM LibertyPower..[User]
	-- WHERE Username = rtrim(ltrim(@p_username))
		
	--Update WIPTask record
	UPDATE LibertyPower..WIPTask
	   SET TaskStatusID = @p_TaskStatusID
	     , TaskComment = @p_comment
		 , DateUpdated = getdate()
		 , UpdatedBy = @p_username
	 WHERE WIPTaskID = @p_WIPTaskID
	
	--Record comments
	INSERT INTO lp_account..account_comments
	SELECT A.AccountIdLegacy AS account_id,
		   GETDATE(), 
		   @p_check_type, 
		   @p_comment, 
		   @p_username,
		   0
	FROM LibertyPower..Account A (NOLOCK) 
	WHERE CurrentContractID = @p_ContractID
	   OR CurrentRenewalContractId = @p_ContractID
	
	INSERT INTO lp_account..account_renewal_comments
	SELECT A.AccountIdLegacy AS account_id,
		   GETDATE(), 
		   @p_check_type, 
		   @p_comment, 
		   @p_username,
		   0
	FROM LibertyPower..Account A (NOLOCK) 
	WHERE CurrentRenewalContractId = @p_ContractID
	
	INSERT INTO lp_account..account_status_history 
	SELECT A.AccountIDLegacy, AST.[Status], AST.SubStatus, getdate(), @p_username, 
	@p_check_type, '','','','','','','','',getdate()
	FROM LibertyPower..Account A (NOLOCK) 
	JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID 
												  AND (A.CurrentContractID = AC.ContractID
												    OR A.CurrentRenewalContractId = AC.ContractId)
	JOIN LibertyPower..[Contract] C (NOLOCK)  ON AC.ContractID = C.ContractID
	JOIN LibertyPower..AccountStatus AST  (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	WHERE C.ContractID = @p_ContractID
	 
	select 'point 60'

	IF (@p_WIPTaskStatus = 'REJECTED' AND @p_approval_status = 'APPROVED')
	BEGIN
		-- insert reason code for each account in contract
		INSERT INTO	lp_account..account_reason_code_hist
				(account_id, date_created, reason_code, process_id, username, chgstamp)
		SELECT A.AccountIdLegacy AS account_id,
			   GETDATE(), 
			   CASE WHEN @p_reason_code = 'NONE' THEN '1032' ELSE @p_reason_code END, 
			   'CHECK ACCOUNT', 
			   @p_username,
			   0
		FROM LibertyPower..Account A (NOLOCK) 
		WHERE CurrentContractID = @p_ContractID
		
		-- If not exists task rejected for the contract
		IF NOT EXISTS (SELECT 1 FROM LibertyPower..WIPTask
						WHERE WIPTaskHeaderId = @p_WorkflowTaskHeaderID
						  AND TaskStatusId = 4)
		BEGIN
			UPDATE AcctS
			SET [Status] = '01000',
				SubStatus = '10'
			FROM LibertyPower..[Contract]       C  (NOLOCK)
			JOIN LibertyPower..AccountContract  AC (NOLOCK) ON AC.ContractId = C.ContractId
			JOIN LibertyPower..AccountStatus AcctS (NOLOCK) ON AcctS.AccountContractId = AC.AccountContractId
			WHERE C.ContractId = @p_ContractID
			  AND Accts.Status <> '05000'
			  AND Accts.Status+Accts.SubStatus not in ('0700010', '0700020')
		END
		
		IF NOT EXISTS (SELECT 1 FROM LibertyPower..WIPTask
						WHERE WIPTaskHeaderId = @p_WorkflowTaskHeaderID
						  AND TaskStatusId in (2, 6)) --Pending or On Hold
		BEGIN
			EXEC LibertyPower..usp_WorkflowStartMigration043_RejectApproval @pContractNumber=@p_contract_nbr
		END
	END

	--Update subsequent tasks to pending
	--gets list of task that depend on the task updated
	SELECT WPL.[WorkflowTaskID]
		  ,WPL.[WorkflowTaskIDRequired]
		  ,WPL.[ConditionTaskStatusID]
	INTO #DependentTasks
	FROM [LibertyPower].[dbo].[WorkflowPathLogic] WPL (NOLOCK)
	WHERE (WPL.IsDeleted is null OR WPL.IsDeleted = 0)
	  AND WPL.WorkflowTaskIDRequired = @p_WorkflowTaskID
	  AND WPL.ConditionTaskStatusID = @p_TaskStatusID


	--Check if dependent tasks don't have any other logic to keep them on hold
	DECLARE @p_DpWorkflowTaskID INT
	DECLARE cursorTasks CURSOR FOR

	SELECT DISTINCT WorkflowTaskID
	FROM #DependentTasks

	OPEN cursorTasks 

	FETCH NEXT FROM cursorTasks INTO @p_DpWorkflowTaskID
		
	WHILE (@@FETCH_STATUS <> -1) 
	BEGIN 
		--Select other tasks that the dependent task might depend on
		SELECT WPL.[WorkflowTaskID]
			  ,WPL.[WorkflowTaskIDRequired]
			  ,WPL.[ConditionTaskStatusID]
		INTO #OtherDependentTasks
		FROM [LibertyPower].[dbo].[WorkflowPathLogic] WPL (NOLOCK)
		WHERE (WPL.IsDeleted is null OR WPL.IsDeleted = 0)
		  AND WPL.WorkflowTaskID = @p_DpWorkflowTaskID
		  AND NOT (WPL.WorkflowTaskIDRequired = @p_WorkflowTaskID
					AND WPL.ConditionTaskStatusID = @p_TaskStatusID)
						   
		IF(@@rowcount > 0)
		BEGIN
			--Check if other conditions to have dependent task set to pending are already satisfied
			IF NOT EXISTS(SELECT 1
						  FROM LibertyPower..WIPTask       WIPT (NOLOCK)
						  JOIN LibertyPower..WIPTaskHeader WTH  (NOLOCK) ON WTH.WIPTaskHeaderId = WIPT.WIPTaskHeaderId
						  JOIN #OtherDependentTasks        TEMP (NOLOCK) ON TEMP.WorkflowTaskIDRequired = WIPT.WorkflowTaskID
						 WHERE WTH.ContractID = @p_ContractID
						   AND TEMP.ConditionTaskStatusID <> WIPT.TaskStatusID)
			BEGIN
				--Updates status of dependent task to pending
				UPDATE LibertyPower..WIPTask
				   SET TaskStatusID = 2 --Pending
				  FROM LibertyPower..WIPTask       WIPT (NOLOCK)
				  JOIN LibertyPower..WIPTaskHeader WTH  (NOLOCK) ON WTH.WIPTaskHeaderId = WIPT.WIPTaskHeaderId
				  JOIN LibertyPower..WorkflowTask  WT   (NOLOCK) ON WT.WorkflowTaskID = WIPT.WorkflowTaskID
				 WHERE WTH.ContractId = @p_ContractID
				   AND WT.WorkflowTaskID = @p_DpWorkflowTaskID
			END
		END
		ELSE
		BEGIN
		  --Updates status of dependent task to pending
		  UPDATE LibertyPower..WIPTask
			 SET TaskStatusID = 2 --Pending
			FROM LibertyPower..WIPTask       WIPT (NOLOCK)
			JOIN LibertyPower..WIPTaskHeader WTH  (NOLOCK) ON WTH.WIPTaskHeaderId = WIPT.WIPTaskHeaderId
			JOIN LibertyPower..WorkflowTask  WT   (NOLOCK) ON WT.WorkflowTaskID = WIPT.WorkflowTaskID
		   WHERE WTH.ContractId = @p_ContractID
			 AND WT.WorkflowTaskID = @p_DpWorkflowTaskID
		END
		
		DROP TABLE #OtherDependentTasks
		
		FETCH NEXT FROM cursorTasks INTO @p_DpWorkflowTaskID
			
	END

	CLOSE cursorTasks 
	DEALLOCATE cursorTasks
	
	DROP TABLE #DependentTasks
-------------------------------------------
--end new code

	-- If approving a rate code approval step,
	-- set billing type to dual for those accounts without rate code, rate ready for accounts with rate code
	IF @p_check_type = 'RATE CODE APPROVAL' AND @p_approval_status = 'APPROVED'
		EXEC lp_account..usp_account_billing_type_upd @p_contract_nbr, @p_check_request_id
	
	DECLARE @p_WorkflowEventtriggerId INT
	DECLARE @p_RequiredTaskStatusId INT
	
	SELECT @p_WorkflowEventtriggerId = WorkflowEventtriggerId,
		   @p_RequiredTaskStatusId = RequiredTaskStatusId
    FROM WorkflowEventTrigger WTE (NOLOCK)
    JOIN AccountEventType AET (NOLOCK) on AET.AccountEventTypeId = WTE.AccountEventTypeId
    WHERE WTE.WorkflowId = @p_WorkflowID
      AND WTE.RequiredTaskId = @p_WorkflowTaskTypeID
      AND AET.Name = 'CommissionRequirementSatisfied'
      
	-- request commission transction
	IF (@p_WorkflowEventtriggerId IS NOT NULL)
	BEGIN
		DECLARE @pDealType VARCHAR(10)
		SELECT @pDealType = DT.DealType
		FROM LibertyPower..Contract C (NOLOCK)
		JOIN LibertyPower..ContractDealType DT (NOLOCK) ON DT.ContractDealTypeId = C.ContractDealTypeId
		WHERE C.ContractId = @p_ContractID
		
		IF (@p_RequiredTaskStatusId = (SELECT TaskStatusId
									   FROM TaskStatus
									   WHERE StatusName = 'APPROVED'))
		BEGIN
			IF (@pDealType = 'NEW')
			BEGIN
				EXECUTE lp_commissions..usp_transaction_request_enrollment_process 'NONE', @p_contract_nbr, 'COMM', null, 'ENROLLMENT CHECK STEP',  @p_username
			END
			ELSE
			BEGIN
				EXECUTE lp_commissions..usp_transaction_request_enrollment_process 'NONE', @p_contract_nbr, 'RENEWCOMM', null, 'RENEWAL CHECK STEP',  @p_username
			END
		END
		ELSE IF (@p_RequiredTaskStatusId = (SELECT TaskStatusId
									        FROM TaskStatus
									        WHERE StatusName = 'REJECTED'))
		BEGIN
			IF (@pDealType = 'NEW')
			BEGIN
				EXECUTE lp_commissions..usp_transaction_request_enrollment_process 'NONE', @p_contract_nbr, null, null, 'ENROLLMENT REJECTION CHECK STEP',  @p_username
			END
			ELSE
			BEGIN
				EXECUTE lp_commissions..usp_transaction_request_enrollment_process 'NONE', @p_contract_nbr, null, null, 'ENROLLMENT REJECTION CHECK STEP',  @p_username
			END
		END
	END
	
	--IF @w_commission_on_approval = 1 AND @p_approval_status = 'APPROVED'
	--	EXECUTE lp_commissions..usp_transaction_request_enrollment_process 'NONE', @p_contract_nbr, 'COMM', null, 'ENROLLMENT CHECK STEP',  @p_username
	--ELSE IF @p_approval_status = 'REJECTED'
	--	EXECUTE lp_commissions..usp_transaction_request_enrollment_process 'NONE', @p_contract_nbr, null, null, 'ENROLLMENT REJECTION CHECK STEP',  @p_username
	
	IF(@p_approval_status = 'REJECTED')
	BEGIN
		--Set status to 999999-10 (07000-80 if contract is a renewal)
		UPDATE AcctS
		SET [Status] = case when DT.DealType = 'NEW' then '999999'
					   else '07000' end,
		    SubStatus = case when DT.DealType = 'NEW' then '10'
					    else '80' end
		FROM LibertyPower..[Contract]       C  (NOLOCK)
		JOIN LibertyPower..AccountContract  AC (NOLOCK) ON AC.ContractId = C.ContractId
		JOIN LibertyPower..AccountStatus AcctS (NOLOCK) ON AcctS.AccountContractId = AC.AccountContractId
		JOIN LibertyPower..ContractDealType DT (NOLOCK) ON DT.ContractDealTypeId = C.ContractDealTypeId
		WHERE C.ContractId = @p_ContractID
		  AND Accts.Status not in ('05000', '07000')
		
		--IF contract is rejected in check account, set accounts status back to what they were before
		IF(@p_check_type = 'CHECK ACCOUNT')
		BEGIN
			UPDATE AccS
			SET [Status] = ZA.[Status],
				SubStatus = ZA.SubStatus
			FROM LibertyPower..Account A (NOLOCK)
			JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.AccountId = AC.AccountId
														  AND AC.ContractId <> A.CurrentContractId
			JOIN LibertyPower..zAuditAccountStatus ZA (NOLOCK) ON AC.AccountContractId = ZA.AccountContractId
			JOIN LibertyPower..AccountContract ACNew (NOLOCK) ON A.AccountId = ACNew.AccountId
															 AND ACNew.ContractId = A.CurrentContractId
			JOIN LibertyPower..AccountStatus AccS (NOLOCK) ON AccS.AccountContractId = ACNew.AccountContractId
			WHERE A.CurrentContractId = @p_ContractID
			  AND ZA.zAuditAccountStatusId = (SELECT max(zAuditAccountStatusId)
											  FROM LibertyPower..zAuditAccountStatus ZA1 (NOLOCK)
											  WHERE ZA1.AccountContractId = AC.AccountContractId)
		END
	END
	ELSE IF(@p_approval_status = 'APPROVED')
	BEGIN
		DECLARE @p_SubmitEnrollmentFlag INT
		EXEC @p_SubmitEnrollmentFlag = LibertyPower..ufn_GetTaskLogic @p_WorkflowTaskID, 'Submitenrollment'
		
		
		IF --Not exists tasks for the contract that are not approved
	       NOT EXISTS (SELECT 1 FROM LibertyPower..WIPTask
					   WHERE WIPTaskHeaderId = @p_WorkflowTaskHeaderID
					     AND TaskStatusId <> 3)
		   OR @p_SubmitEnrollmentFlag = 1 
		BEGIN	
			UPDATE A
			SET CurrentContractId = CurrentRenewalContractId,
			    CurrentRenewalContractId = NULL
			FROM LibertyPower..[Contract]       C  (NOLOCK)
			JOIN LibertyPower..AccountContract  AC (NOLOCK) ON AC.ContractId = C.ContractId
			JOIN LibertyPower..Account			A  (NOLOCK) ON A.AccountId = AC.AccountId
														   AND A.CurrentRenewalContractId = AC.ContractId
			JOIN LibertyPower..AccountStatus AcctS (NOLOCK) ON AcctS.AccountContractId = AC.AccountContractId
			JOIN LibertyPower..AccountContract  ACOld (NOLOCK) ON ACOld.AccountId = A.AccountId
															  AND ACOld.ContractId = A.CurrentContractId
			JOIN LibertyPower..AccountStatus AcctSOld (NOLOCK) ON AcctSOld.AccountContractId = ACOld.AccountContractId
			WHERE C.ContractId = @p_ContractID
			  AND AcctSOld.Status in ('999999', '999998', '911000')
					
			UPDATE AcctS
			SET [Status] = '07000',
				SubStatus = '10'
			FROM LibertyPower..[Contract]       C  (NOLOCK)
			JOIN LibertyPower..AccountContract  AC (NOLOCK) ON AC.ContractId = C.ContractId
			JOIN LibertyPower..Account			A  (NOLOCK) ON A.AccountId = AC.AccountId
														   AND A.CurrentRenewalContractId = AC.ContractId
			JOIN LibertyPower..AccountStatus AcctS (NOLOCK) ON AcctS.AccountContractId = AC.AccountContractId
			WHERE C.ContractId = @p_ContractID
			  AND Accts.Status = '01000'
		
			UPDATE AcctS
			SET [Status] = '05000',
				SubStatus = '10'
			FROM LibertyPower..[Contract]       C  (NOLOCK)
			JOIN LibertyPower..AccountContract  AC (NOLOCK) ON AC.ContractId = C.ContractId
			JOIN LibertyPower..Account			A  (NOLOCK) ON A.AccountId = AC.AccountId
														   AND A.CurrentContractId = AC.ContractId
			JOIN LibertyPower..AccountStatus AcctS (NOLOCK) ON AcctS.AccountContractId = AC.AccountContractId
			WHERE C.ContractId = @p_ContractID
			  AND Accts.Status in ('01000', '07000')
		END
	END
	
	GOTO_select:
	 
	IF @w_error <> 'N'
	BEGIN
	   EXEC lp_common..usp_messages_sel @w_msg_id, @w_descp output, @w_application
	   SELECT @w_descp = ltrim(rtrim(@w_descp )) + ' ' + @w_descp_add
	END
	 
	--IF @p_result_ind = 'Y'
	--BEGIN
	   SELECT flag_error = @w_error, code_error = @w_msg_id, message_error = @w_descp
	   GOTO GOTO_return
	--END
	 
	SELECT @p_error = @w_error, @p_msg_id = @w_msg_id, @p_descp = @w_descp
	 
	GOTO_return:
	return @w_return

END

----------------------------------------------------------------------------------------------------------


