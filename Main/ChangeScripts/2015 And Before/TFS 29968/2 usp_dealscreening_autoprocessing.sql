USE [lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_dealscreening_autoprocessing]    Script Date: 03/28/2014 12:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =======================================
-- Modified 02/22/2012 Jose Munoz -  SWCS
-- Ticket : 1-7176611	Residential Contracts to Automate Through Queues
-- IL	: ComEd, Ameren
-- PA	: MetEd, PECO, Penelec, PennPR, PPL
-- NY	: ConEd, RGE, NYSEG
-- =======================================
-- Modified 03/06/2012 Isabelle Tamanini
-- Ticket : 1-8758521
-- Documents step should be autoapproved for tablet-generated contracts
-- =======================================
-- Modified 05/31/2012 Isabelle Tamanini
-- Call proc that autoapproves the POR contracts in credit check step
-- IT043
-- exec [usp_dealscreening_autoprocessing] 0,'2012-0211451'
-- =======================================
-- Modified 11/15/2012 Isabelle Tamanini
-- Added code to make sure the task is still on the expected status when trying to approve it
-- 1-35611118
-- =======================================
-- Modified 01/18/2013 Isabelle Tamanini
-- Added code to autoapprove TPVs from EGSI
-- 1-54006156
-- =======================================
-- Modified: Isabelle Tamanini 3/15/2013
-- Adding code to autoapprove Tablet review step for 
-- contracts having origin other than GENIE
-- SR1-78040921
-- =======================================
-- Modified: Isabelle Tamanini 7/30/2013
-- Changing code to autoapprove Tablet review step for contracts
-- that were not submitted by the tablet (Createdby = 1913)
-- SR1-173341054
-- =======================================
-- Modified: Isabelle Tamanini 3/28/2014
-- Added code to call new proc to check tablet documents and changed the
-- @p_TabletContract to use the Client application key to identify the
-- contract's correct origin
-- PBI 29968
-- =======================================

ALTER PROCEDURE [dbo].[usp_dealscreening_autoprocessing] 
	(@RecordAgeInMinutes	INT = 10
	,@ContractNumberFilter	VARCHAR(12) = '')
AS
BEGIN
	set transaction isolation level read uncommitted

	SET NOCOUNT ON

	DECLARE @contract_nbr VARCHAR(12), @check_type VARCHAR(30), @check_request_id VARCHAR(25), @approval_status VARCHAR(15), @call_request_id CHAR(15)

	DECLARE @contract_type	VARCHAR(25) -- ADD TICKET 18353
	DECLARE @Message		VARCHAR(max) 
	DECLARE @p_utility		varchar(50)
	DECLARE @p_utility_id	int
	DECLARE @p_market_id	int
	DECLARE @p_account_type varchar(35) -- SR1-3213252
	DECLARE @p_newApprovalStatus VARCHAR(15)
	DECLARE @p_ApprovalComments VARCHAR(MAX)
	DECLARE @p_TabletContract BIT

	-- Grabs everything created in the last X minutes.
	DECLARE usp_dealscreening_autoprocessing_cursor CURSOR FORWARD_ONLY READ_ONLY  FOR 
	SELECT contract_nbr, check_type, check_request_id, approval_status 
	FROM lp_enrollment..check_account
	WHERE 1=1
	AND (@RecordAgeInMinutes IS NULL OR datediff(mi,date_created,getdate()) <= @RecordAgeInMinutes)
	AND approval_status IN ('INCOMPLETE','PENDING','PENDINGSYS')
	--Begin SR1-8758521
	AND check_type not in ('USAGE ACQUIRE') --Excluded TPV SR1-54006156
	--AND check_type not in ('TPV','USAGE ACQUIRE')
	--AND (check_type NOT IN ('DOCUMENTS', 'TPV')-- These steps are manually processed.
	--End SR1-8758521
	--AND check_type NOT IN ('DOCUMENTS','PRICE VALIDATION','TPV') -- These steps are manually processed.
	--CREDIT CHECK step removed / SR1-3213252
	AND datediff(mi,date_created,getdate()) > 1 
	--AND contract_nbr = '3338015'
	union
	SELECT contract_nbr, check_type, check_request_id, approval_status 
	FROM lp_enrollment..check_account
	WHERE contract_nbr		= @ContractNumberFilter
	AND approval_status IN ('INCOMPLETE','PENDING','PENDINGSYS')
	--Begin SR1-8758521
	AND check_type not in ('USAGE ACQUIRE') --Excluded TPV SR1-54006156
	--AND check_type not in ('TPV','USAGE ACQUIRE')
	--AND (check_type NOT IN ('DOCUMENTS', 'TPV')-- These steps are manually processed.
	--End SR1-8758521
	--AND check_type NOT IN ('DOCUMENTS','PRICE VALIDATION','TPV') -- These steps are manually processed.
	--CREDIT CHECK step removed / SR1-3213252
	AND datediff(mi,date_created,getdate()) > 1



	OPEN usp_dealscreening_autoprocessing_cursor
	FETCH NEXT FROM usp_dealscreening_autoprocessing_cursor INTO @contract_nbr, @check_type, @check_request_id, @approval_status

	WHILE @@FETCH_STATUS = 0
	BEGIN
		begin try
		print @contract_nbr
		set @Message = ''
		
		set @p_utility = NULL
		set @p_market_id = NULL
		set @p_utility_id = NULL
		set @p_account_type = NULL
		set @p_newApprovalStatus = NULL
		set @p_ApprovalComments = NULL
		
		SELECT top 1 @p_utility = u.utilitycode,
			   @p_utility_id = u.ID,
			   @p_account_type = at.AccountType -- SR1-3213252
			  ,@p_market_id = u.MarketID
			  --@p_TabletContract = (CASE WHEN c.CreatedBy = 1913 THEN 1 ELSE 0 END) /* ADD SR1-173341054 */
		FROM LibertyPower..Account a (NOLOCK)
		JOIN LibertyPower..Contract c (NOLOCK) ON (a.CurrentContractID = c.ContractID and @check_request_id <> 'RENEWAL')
												OR (a.CurrentRenewalContractID = c.ContractID and @check_request_id = 'RENEWAL')
		JOIN LibertyPower..AccountType at (NOLOCK) ON a.AccountTypeID = at.ID
		JOIN LibertyPower..Utility u (NOLOCK) ON a.UtilityID = u.ID
		WHERE c.Number = @contract_nbr
		
		exec @p_TabletContract = LibertyPower..ufn_IsTabletContract @contract_nbr


	--TPV
		--IF @check_type				= 'TPV'
		--	and @approval_status	in ('PENDING')
		--BEGIN
		--	DECLARE @salesChannel VARCHAR(200)
		--	SELECT @salesChannel = ChannelName
		--	FROM LibertyPower..Account A (NOLOCK)
		--	JOIN LibertyPower..Contract c (NOLOCK) ON (a.CurrentContractID = c.ContractID and @check_request_id <> 'RENEWAL')
		--										OR (a.CurrentRenewalContractID = c.ContractID and @check_request_id = 'RENEWAL')
		--	LEFT JOIN LibertyPower.dbo.SalesChannel SC		WITH (NOLOCK)		ON C.SalesChannelID = SC.ChannelID
		--	WHERE c.Number = @contract_nbr
			
		--	IF (@salesChannel = 'EGSI')
		--	BEGIN
		--		SET @p_newApprovalStatus = 'APPROVED'
		--		SET @p_ApprovalComments = N'Per SR1-54006156, EGSI TPVs will be autoapproved.'
		--	END
		--END
		
		
	--PRICE VALIDATION
		IF @check_type				= 'PRICE VALIDATION'
			and @approval_status	in ('PENDINGSYS')
		BEGIN
			IF @p_utility			in ('METED', 'PENELEC', 'PENNPR', 'CONED', 'RGE', 'NYSEG'
										,'ACE','ALLEGMD','AMEREN','BGE','COMED','DELDE','DELMD'
										,'DUQ','JCP&L','ORNJ','PECO', 'CL&P'
										,'PEPCO-DC','PEPCO-MD','PPL','PSEG','ROCKLAND','UGI','WPP')
			and @p_account_type		= 'RES'
			BEGIN
				SET @p_newApprovalStatus = 'APPROVED'
				SET @p_ApprovalComments = N'Residential accounts in METED, PENELEC, PENNPR, CONED, RGE and NYSEG are automatically approved by the system in the PRICE VALIDATION step.'
			END
			ELSE
			BEGIN
				SET @p_newApprovalStatus = 'PENDING'
			END
		END

		-- Code above already handles Price Validation
		--IF @check_type				= 'PRICE VALIDATION'
		--	and @approval_status	= 'PENDINGSYS' 
		--BEGIN
		--	--EXEC usp_tier_validation @contract_nbr, @check_request_id
		--	print 'tier validation temporarily disabled'
		--END
		--ELSE
		--BEGIN
		
	--POST-USAGE CREDIT CHECK
			-- This is a check account step that can be automatically run and does not need user intervention.
			-- This code previously excluded COMED accounts for no apparent reason.  That code has been removed for now.
			IF @check_type = 'POST-USAGE CREDIT CHECK' and @approval_status='PENDING' --and @p_utility <> 'COMED'
				EXEC usp_post_usage_credit_check @contract_nbr

	--POST-USAGE MIN USAGE CHECK
			-- This is a check account step that can be automatically run and does not need user intervention.
			-- Checks for minimum usage for each account in contract
			IF @check_type = 'POST-USAGE MIN USAGE CHECK' and @approval_status='PENDING' 
				EXEC usp_post_usage_min_usage_check @contract_nbr

	--POST-USAGE MAX USAGE CHECK
			-- This is a check account step that can be automatically run and does not need user intervention.
			-- Checks for maximum usage allowed for TPVs.
			IF ltrim(rtrim(@check_type)) = 'POST-USAGE MAX USAGE CHECK' and @approval_status='PENDING' 
				EXEC usp_post_usage_tpv_max_usage_check @contract_nbr, @check_request_id

	--RATE CODE APPROVAL
			-- Gets rate code
			IF @check_type = 'RATE CODE APPROVAL' and @approval_status='PENDING' 
				EXEC usp_acquire_rate_code @contract_nbr

	--ACQUIRE SERVICE CLASS
			-- If service class is already on the contract, step is approved right away. MD056
			IF @check_type = 'ACQUIRE SERVICE CLASS' and @approval_status='PENDING'
			BEGIN
				exec usp_process_acquire_service_class @contract_nbr, @check_request_id, @p_utility_id
			END

	--LETTER
		IF @check_type = 'LETTER' and @approval_status='PENDING'
		BEGIN
			
			IF @check_request_id <> 'RENEWAL'
			BEGIN
				-- A contract that is due for a Welcome Letter is also sent to the Welcome Call queue.
				IF NOT EXISTS(select 1 from lp_enrollment..welcome_header where contract_nbr = @contract_nbr)
					EXEC usp_welcome_call_queue_ins @contract_nbr
			
				-- If the LETTER step is created so late that the contract has ended, do not print the letter.
				-- We also check if the contract is more than 6 months old.
				-- Related to 17430
				IF EXISTS (SELECT 1
						   FROM lp_account.dbo.account a (NOLOCK)
						   JOIN lp_common..common_product p (NOLOCK) on a.product_id = p.product_id
						   WHERE contract_nbr = @contract_nbr and ((p.isdefault = 1) OR datediff(mm,date_submit,getdate()) > 6))
				BEGIN
					EXEC [LibertyPower].[dbo].[usp_WIPTaskUpdateStatus] @p_username = N'System', @p_contract_nbr = @contract_nbr, 
						@p_check_type = N'LETTER', @p_approval_status = N'APPROVED', @p_comment = N'Letter was scheduled to create after contract has finished.  System is canceling the print task.', 
						@p_check_request_id = @check_request_id, @p_WaitingTaskStatus = @approval_status
			END

					INSERT INTO lp_enrollment.dbo.welcome_letter_queue (account_id,account_number,date_created)
					SELECT a.AccountIDLegacy, a.accountnumber, getdate()
					FROM LibertyPower..Account a (NOLOCK)--lp_account..account a (NOLOCK)
					JOIN LibertyPower..Contract c (NOLOCK) ON a.CurrentContractID = c.ContractID
					WHERE c.Number = @contract_nbr
					AND a.accountnumber NOT IN (select account_number from lp_enrollment..welcome_letter_queue)
				END
				ELSE IF @check_request_id = 'RENEWAL'
				BEGIN
					INSERT INTO lp_enrollment.dbo.renewal_letter_queue (account_id,account_number,date_created)
					SELECT a.AccountIDLegacy, a.accountnumber, getdate()
					FROM LibertyPower..Account a (NOLOCK)--lp_account..account a (NOLOCK)
					JOIN LibertyPower..Contract c (NOLOCK) ON a.CurrentContractID = c.ContractID
					WHERE c.Number = @contract_nbr
					AND a.accountnumber NOT IN (select account_number from lp_enrollment..renewal_letter_queue)
				END
			END
			
	--CHECK ACCOUNT
			-- If a sales channel submits a contract and the account is currently in the retention queue, then we remove it from the queue.
			IF @check_type = 'CHECK ACCOUNT' and @approval_status='PENDINGSYS'
			BEGIN
				IF LEN(RTRIM(LTRIM(@contract_nbr))) > 0
				BEGIN
					SELECT	@call_request_id = call_request_id 
					FROM	lp_enrollment.dbo.retention_header r (NOLOCK)
							JOIN lp_account.dbo.account a (NOLOCK) ON r.account_id = a.account_id 
					WHERE	r.call_status = 'O' and a.contract_nbr = @contract_nbr

					UPDATE lp_enrollment..retention_header
					SET call_status = 'S', call_reason_code = '1023'
					FROM lp_enrollment.dbo.retention_header r
					JOIN lp_account.dbo.account a ON r.account_id = a.account_id
					WHERE r.call_status = 'O' and a.contract_nbr = @contract_nbr
						
					IF @@ROWCOUNT > 0
					BEGIN
						INSERT INTO	lp_enrollment..retention_comment
									(call_request_id, date_comment, call_status, call_reason_code, 
									comment, nextcalldate, username, chgstamp)
						VALUES		(@call_request_id, GETDATE(), 'S', '1023', 
												'Contract Renewing', '', 'SYSTEM', 0 )
					END

					/* ADD TICKET 18353 BEGIN */					
					IF @check_request_id <> 'RENEWAL'
					BEGIN 
						SET @contract_type = (SELECT TOP 1 LTRIM(RTRIM(contract_type)) FROM lp_account..account WHERE contract_nbr = @contract_nbr)
						IF @contract_type = 'POWER MOVE'
						BEGIN
						EXEC [LibertyPower].[dbo].[usp_WIPTaskUpdateStatus] @p_username = N'System', @p_contract_nbr = @contract_nbr, 
						@p_check_type = N'CHECK ACCOUNT', @p_approval_status = N'APPROVED', @p_comment = N'Automatically Approved.', 
						@p_check_request_id = @check_request_id, @p_WaitingTaskStatus = @approval_status
						END
					END
					/* ADD TICKET 18353 END */

				END
				
				--begin IT043
				--If submitting a brand new account to LP, autoapprove check account
				DECLARE @pContractId INT
				SELECT @pContractId = ContractId
				FROM LibertyPower..[Contract] (NOLOCK)
				WHERE Number = @contract_nbr
				
				IF NOT EXISTS (SELECT 1 
								FROM LibertyPower..AccountContract AC (NOLOCK)
								JOIN LibertyPower..AccountStatus AccS (NOLOCK) ON AC.AccountContractId = Accs.AccountContractId
								WHERE AccountId in (SELECT AccountId
													FROM LibertyPower..Account A (NOLOCK)
													WHERE CurrentContractId = @pContractId)
								  AND AC.ContractId <> @pContractId
								  AND Accs.[Status]+Accs.SubStatus in ('99999910', '99999810', '91100010'))
				BEGIN
					SET @p_newApprovalStatus = 'APPROVED'
					SET @p_ApprovalComments = N'Autoapproved by system. Contract ' + @contract_nbr
				END
				ELSE
				BEGIN
					SET @p_newApprovalStatus = 'PENDING'
				END
				--end IT043
			END
			
			print  @p_utility
			print @p_utility_id
			print  @p_account_type
			print @check_request_id

	--CREDIT CHECK
			IF @check_type = 'CREDIT CHECK'  AND @approval_status in ('PENDINGSYS')   -- MODIFIED THE STATUS CHECK TO PROCESS THE NEW PENDING SYS STATUS AT 06.11.2012
				--AND EXISTS (select * from LibertyPower..WorkFlowStepLogic where WorkFlowStepID = 2 and Enabled = 1)
			BEGIN
			   EXEC lp_enrollment.dbo.usp_ApproveCreditCheckForPOR  @contract_nbr 
			END
			
	--DOCUMENTS
			--Begin SR1-8758521
			IF @check_type = 'DOCUMENTS' AND @approval_status = 'PENDINGSYS' 
			BEGIN				
				IF (@p_TabletContract = 1)
				BEGIN
					DECLARE @missingDocuments BIT
					DECLARE @missingDocumentsMessage VARCHAR(250)
					
					EXEC LibertyPower..usp_ValidateTabletSubmissionDocuments @contract_nbr, @missingDocuments out, @missingDocumentsMessage out
					
					IF(@missingDocuments = 0)
					BEGIN
						SET @p_newApprovalStatus = 'APPROVED'
						SET @p_ApprovalComments = N'Tablet-generated contract automatically approved by the system.'
					END
					ELSE
					BEGIN
					    --Logs into account_comment the message returned from the validation proc
						INSERT INTO lp_account..account_comments
						SELECT AccountIdLegacy, GETDATE(), 'TABLET DOCUMENT VALIDATION', @missingDocumentsMessage, 'SYSTEM', 0
						FROM LibertyPower..Account a  (NOLOCK)
						JOIN LibertyPower..Contract c (NOLOCK) ON (a.CurrentContractID = c.ContractID and @check_request_id <> 'RENEWAL')
															   OR (a.CurrentRenewalContractID = c.ContractID and @check_request_id = 'RENEWAL')
						WHERE c.Number = @contract_nbr
						  AND NOT EXISTS (SELECT 1
						                  FROM lp_account..account_comments ac (NOLOCK) 
						                  WHERE a.AccountIdLegacy = ac.account_id
						                    AND ac.comment = @missingDocumentsMessage)
					
					END
				END
				ELSE
				BEGIN
					SET @p_newApprovalStatus = 'PENDING'
				END
			END
			--End SR1-8758521
			
	--TABLET REVIEW
			--Begin SR1-78040921
			IF @check_type = 'TABLET REVIEW' AND @approval_status = 'PENDINGSYS' 
			BEGIN
						
				IF (@p_TabletContract = 0)
				BEGIN
					SET @p_newApprovalStatus = 'APPROVED'
					SET @p_ApprovalComments = N'Auto-approved by system, not a TABLET contract. Contract '+ @contract_nbr +'.'
				END
				ELSE
				BEGIN
					SET @p_newApprovalStatus = 'PENDING'
				END
			END
			--End SR1-78040921
			
	--FINAL UPDATES
			IF(@p_newApprovalStatus = 'APPROVED')
			BEGIN
				EXEC LibertyPower..usp_WIPTaskUpdateStatus 'SYSTEM', @contract_nbr, @check_type, @p_newApprovalStatus,
					@p_ApprovalComments, @check_request_id, @p_WaitingTaskStatus = @approval_status
			END
			ELSE IF(@p_newApprovalStatus = 'PENDING')
			BEGIN
				DECLARE @p_TaskStatusId INT
				SELECT @p_TaskStatusId = TaskStatusId
				FROM LibertyPower..TaskStatus
				WHERE StatusName = @p_newApprovalStatus
				
				UPDATE LibertyPower..WIPTask
				SET TaskStatusId = @p_TaskStatusId
				FROM LibertyPower..WIPTask       WIPT (NOLOCK)
				JOIN LibertyPower..WIPTaskHeader WTH  (NOLOCK) ON WTH.WIPTaskHeaderId = WIPT.WIPTaskHeaderId
				JOIN LibertyPower..WorkflowTask  WT   (NOLOCK) ON WT.WorkflowTaskID = WIPT.WorkflowTaskID
				JOIN LibertyPower..TaskType      TT   (NOLOCK) ON TT.TaskTypeID = WT.TaskTypeID
				JOIN LibertyPower..Contract      C    (NOLOCK) ON C.ContractId = WTH.ContractId
				WHERE C.Number = @contract_nbr
				  AND TT.TaskName = @check_type
			END
		--END 
		end try
		begin catch
			SELECT
				ERROR_NUMBER()		AS ErrorNumber
				,ERROR_SEVERITY()	AS ErrorSeverity
				,ERROR_STATE()		AS ErrorState
				,ERROR_PROCEDURE()	AS ErrorProcedure
				,ERROR_LINE()		AS ErrorLine
				,ERROR_MESSAGE()	AS ErrorMessage;
		end catch
				
		FETCH NEXT FROM usp_dealscreening_autoprocessing_cursor INTO @contract_nbr, @check_type, @check_request_id, @approval_status
	END

	CLOSE usp_dealscreening_autoprocessing_cursor
	DEALLOCATE usp_dealscreening_autoprocessing_cursor


	IF @@ERROR<>0 OR @@TRANCOUNT=0 
	BEGIN 
		IF @@TRANCOUNT > 0 
			ROLLBACK 
		SET NOEXEC ON 
	END

	SET NOCOUNT OFF
END
