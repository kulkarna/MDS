USE [lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_dealscreening_autoprocessing]    Script Date: 10/02/2012 10:35:00 ******/
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
-- Modified 04/27/2012 Isabelle Tamanini
-- Ticket : 1-4112671
-- Update the status of accounts that were rejected in transfer of 
-- ownership and are in this status for more than 10 days to 11000-30
-- =======================================
-- Modified 05/31/2012 Isabelle Tamanini
-- Call proc that autoapproves the POR contracts in credit check step
-- IT043
-- exec [usp_dealscreening_autoprocessing] 0,'2012-0211451'
-- =======================================


ALTER PROCEDURE [dbo].[usp_dealscreening_autoprocessing] 
	(@RecordAgeInMinutes	INT = 10
	,@ContractNumberFilter	VARCHAR(12) = '')
AS

set transaction isolation level read uncommitted

DECLARE @contract_nbr VARCHAR(12), @check_type VARCHAR(30), @check_request_id VARCHAR(25), @approval_status VARCHAR(15), @call_request_id CHAR(15)

DECLARE @contract_type	VARCHAR(25) -- ADD TICKET 18353
DECLARE @Message		VARCHAR(max) 
DECLARE @p_utility		varchar(50)
DECLARE @p_utility_id	int
DECLARE @p_market_id	int
DECLARE @p_account_type varchar(35) -- SR1-3213252

-- Grabs everything created in the last X minutes.
DECLARE usp_dealscreening_autoprocessing_cursor CURSOR FORWARD_ONLY READ_ONLY  FOR 
SELECT contract_nbr, check_type, check_request_id, approval_status 
FROM lp_enrollment..check_account
WHERE 1=1
AND (@RecordAgeInMinutes IS NULL OR datediff(mi,date_created,getdate()) <= @RecordAgeInMinutes)
AND approval_status IN ('INCOMPLETE','PENDING','PENDINGSYS')
--Begin SR1-8758521
AND check_type <> 'TPV' 
--AND (check_type NOT IN ('DOCUMENTS', 'TPV')-- These steps are manually processed.
--End SR1-8758521
--AND check_type NOT IN ('DOCUMENTS','PRICE VALIDATION','TPV') -- These steps are manually processed.
--CREDIT CHECK step removed / SR1-3213252
AND datediff(mi,date_created,getdate()) > 1 
union
SELECT contract_nbr, check_type, check_request_id, approval_status 
FROM lp_enrollment..check_account
WHERE contract_nbr		= @ContractNumberFilter
AND approval_status IN ('INCOMPLETE','PENDING','PENDINGSYS')
--Begin SR1-8758521
AND check_type <> 'TPV' 
--AND (check_type NOT IN ('DOCUMENTS', 'TPV')-- These steps are manually processed.
--End SR1-8758521
--AND check_type NOT IN ('DOCUMENTS','PRICE VALIDATION','TPV') -- These steps are manually processed.
--CREDIT CHECK step removed / SR1-3213252
AND datediff(mi,date_created,getdate()) > 1
union
 --SR1-4112671
SELECT contract_nbr, check_type, check_request_id, approval_status 
FROM lp_enrollment..check_account ca
WHERE 1=1
AND check_request_id = 'ESIID TRANSFER' 
AND approval_status = 'REJECTED'
AND approval_eff_date <= dateadd(dd, -10, getdate())
AND exists (select 1 from lp_account..account a
			where [status] in ('999999', '999998')
			  and a.contract_nbr = ca.contract_nbr)

-- Finds accounts with true 0 usage.
CREATE TABLE #AccountNumberAnnualUsage0 (Account_number varchar(30))

INSERT INTO #AccountNumberAnnualUsage0
SELECT
      Account_number=rtrim(ltrim(replace(replace (comment,'already has an annual usage = 0',''),'Account','')))
FROM libertypower..AuditUsageUsedLog (nolock)   
WHERE comment like 'Account%already has an annual usage = 0%'  

CREATE INDEX aidx on #AccountNumberAnnualUsage0 (Account_number) with fillfactor = 100

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
	
	IF @check_request_id <> 'RENEWAL'
	BEGIN
		SELECT top 1 @p_utility = u.utilitycode,
			   @p_utility_id = u.ID,
			   @p_account_type = at.AccountType -- SR1-3213252
			  ,@p_market_id = u.MarketID
		FROM LibertyPower..Account a (NOLOCK)
		JOIN LibertyPower..Contract c (NOLOCK) ON a.CurrentContractID = c.ContractID
		JOIN LibertyPower..AccountType at (NOLOCK) ON a.AccountTypeID = at.ID
		JOIN LibertyPower..Utility u (NOLOCK) ON a.UtilityID = u.ID
		WHERE c.Number = @contract_nbr
	END
	ELSE
	BEGIN
		SELECT top 1 @p_utility = u.utilitycode,
			   @p_utility_id = u.ID,
			   @p_account_type = at.AccountType -- SR1-3213252
		FROM LibertyPower..Account a (NOLOCK)
		JOIN LibertyPower..Contract c (NOLOCK) ON a.CurrentRenewalContractID = c.ContractID
		JOIN libertypower..AccountType at (NOLOCK) ON a.AccountTypeID = at.ID
		JOIN LibertyPower..Utility u (NOLOCK) ON a.UtilityID = u.ID
		WHERE c.Number = @contract_nbr
	END

	IF @check_type				= 'PRICE VALIDATION'
		and @approval_status	in ('PENDING')
		and @p_utility			in ('METED', 'PENELEC', 'PENNPR', 'CONED', 'RGE', 'NYSEG'
									,'ACE','ALLEGMD','AMEREN','BGE','COMED','DELDE','DELMD'
									,'DUQ','JCP&L','ORNJ','PECO', 'CL&P'
									,'PEPCO-DC','PEPCO-MD','PPL','PSEG','ROCKLAND','UGI','WPP')
		and @p_account_type		= 'RES'
	BEGIN
		IF @check_request_id <> 'RENEWAL'
		BEGIN
			EXEC lp_enrollment.dbo.usp_check_account_approval_reject @p_username = N'System', @p_check_request_id = @check_request_id, @p_contract_nbr = @contract_nbr, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = @check_type, @p_approval_status = N'APPROVED', @p_comment = N'Residential accounts in METED, PENELEC, PENNPR, CONED, RGE and NYSEG are automatically approved by the system in the PRICE VALIDATION step.'
		END
		ELSE
		BEGIN
			EXEC lp_enrollment.dbo.usp_check_account_renewal_approval_reject @p_username = N'System', @p_check_request_id = @check_request_id, @p_contract_nbr = @contract_nbr, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = @check_type, @p_approval_status = N'APPROVED', @p_comment = N'Residential accounts in METED, PENELEC, PENNPR, CONED, RGE and NYSEG are automatically approved by the system in the PRICE VALIDATION step.'
		END
	END

	IF @check_type				= 'PRICE VALIDATION'
		and @approval_status	= 'PENDING' 
	BEGIN
		--EXEC usp_tier_validation @contract_nbr, @check_request_id
		print 'tier validation temporarily disabled'
	END
	ELSE
	BEGIN
	
		-- This is a check account step that can be automatically run and does not need user intervention.
		-- This code previously excluded COMED accounts for no apparent reason.  That code has been removed for now.
		IF @check_type = 'POST-USAGE CREDIT CHECK' and @approval_status='PENDING' --and @p_utility <> 'COMED'
			EXEC usp_post_usage_credit_check @contract_nbr

		-- This is a check account step that can be automatically run and does not need user intervention.
		-- Checks for minimum usage for each account in contract
		IF @check_type = 'POST-USAGE MIN USAGE CHECK' and @approval_status='PENDING' 
			EXEC usp_post_usage_min_usage_check @contract_nbr

		-- This is a check account step that can be automatically run and does not need user intervention.
		-- Checks for maximum usage allowed for TPVs.
		IF ltrim(rtrim(@check_type)) = 'POST-USAGE MAX USAGE CHECK' and @approval_status='PENDING' 
			EXEC usp_post_usage_tpv_max_usage_check @contract_nbr, @check_request_id
		-- Gets rate code
		IF @check_type = 'RATE CODE APPROVAL' and @approval_status='PENDING' 
			EXEC usp_acquire_rate_code @contract_nbr

		-- Updates usage for renewals automatically.
		IF @check_type = 'USAGE ACQUIRE' and @approval_status IN ('INCOMPLETE','PENDING') and @check_request_id='RENEWAL'
		BEGIN
			IF NOT EXISTS (SELECT * FROM lp_account.dbo.account_renewal with (nolock)
							WHERE contract_nbr = @contract_nbr and annual_usage is null)
			BEGIN
				EXEC lp_enrollment.dbo.usp_check_account_renewal_approval_reject @p_username = N'Usage Trigger', @p_check_request_id = @check_request_id, @p_contract_nbr = @contract_nbr, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = N'USAGE ACQUIRE', @p_approval_status = N'APPROVED', @p_comment = N'All Usage Acquired'
				SET @Message = 'RENEWAL Contract Processed in USAGE ACQUIRE:' + @contract_nbr
				PRINT @Message
			END
			--ELSE											-- These lines were comment by Diogo Lima
			--BEGIN											-- to resolve ticket 17807. A job was created 
				--EXEC usp_renewal_usage_upd @contract_nbr	-- to replace that functionality
			--END											--		
		END
		
		-- If usage is already on the contract, step is approved right away.
		IF @check_type = 'USAGE ACQUIRE' and @approval_status IN ('INCOMPLETE','PENDING') and @check_request_id <> 'RENEWAL'
		BEGIN
			IF NOT EXISTS (SELECT * FROM lp_account.dbo.account a with (nolock)
							WHERE contract_nbr = @contract_nbr and status not in ('999998','999999') and annual_usage=0
							and not exists
								( -- added to check if account has true 0 usage
								   select 1   
								   from #AccountNumberAnnualUsage0 (nolock)   
								   where Account_number =  a.account_number 
								)						
							)
			BEGIN
				EXEC lp_enrollment.dbo.usp_check_account_approval_reject @p_username = N'Usage Trigger', @p_check_request_id = @check_request_id, @p_contract_nbr = @contract_nbr, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = N'USAGE ACQUIRE', @p_approval_status = N'APPROVED', @p_comment = N'All Usage Acquired'
				SET @Message = 'Contract Processed in USAGE ACQUIRE:' + @contract_nbr
				PRINT @Message
			END
		END
		
		-- If service class is already on the contract, step is approved right away. MD056
		IF @check_type = 'ACQUIRE SERVICE CLASS' and @approval_status='PENDING'
		BEGIN
			exec usp_process_acquire_service_class @contract_nbr, @check_request_id, @p_utility_id
		END

		IF @check_type = 'LETTER' and @approval_status='PENDING' and @check_request_id <> 'RENEWAL'
		BEGIN
			-- A contract that is due for a Welcome Letter is also sent to the Welcome Call queue.
			IF NOT EXISTS(select * from lp_enrollment..welcome_header where contract_nbr = @contract_nbr)
				EXEC usp_welcome_call_queue_ins @contract_nbr
		
			-- If the LETTER step is created so late that the contract has ended, do not print the letter.
			-- We also check if the contract is more than 6 months old.
			-- Related to 17430
			IF EXISTS (SELECT *
					   FROM lp_account.dbo.account a (NOLOCK)
					   JOIN lp_common..common_product p (NOLOCK) on a.product_id = p.product_id
					   WHERE contract_nbr = @contract_nbr and ((p.isdefault = 1) OR datediff(mm,date_submit,getdate()) > 6))
			BEGIN
				EXEC lp_enrollment.dbo.usp_check_account_approval_reject @p_username = N'System', @p_check_request_id = @check_request_id, @p_contract_nbr = @contract_nbr, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = N'LETTER', @p_approval_status = N'APPROVED', @p_comment = N'Letter was scheduled to create after contract has finished.  System is canceling the print task.'
			END
		END

		IF @check_type = 'LETTER' and @approval_status='PENDING'
		BEGIN
			IF @check_request_id <> 'RENEWAL'
			BEGIN
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
		
		-- If a sales channel submits a contract and the account is currently in the retention queue, then we remove it from the queue.
		IF @check_type = 'CHECK ACCOUNT' and @approval_status='PENDING'
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
						EXEC lp_enrollment.dbo.usp_check_account_approval_reject @p_username = N'System', @p_check_request_id = @check_request_id, @p_contract_nbr = @contract_nbr, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = N'CHECK ACCOUNT', @p_approval_status = N'APPROVED', @p_comment = N'Automatic Approved.'
					END
				END
				/* ADD TICKET 18353 END */

			END
			

		END
		
		print  @p_utility
		print @p_utility_id
		print  @p_account_type
		print @check_request_id

		IF @check_type = 'CREDIT CHECK' 
			AND @approval_status in ('PENDINGSYS')   -- MODIFIED THE STATUS CHECK TO PROCESS THE NEW PENDING SYS STATUS AT 06.11.2012
		    --AND EXISTS (select * from LibertyPower..WorkFlowStepLogic where WorkFlowStepID = 2 and Enabled = 1)
		BEGIN
		   EXEC lp_enrollment.dbo.usp_ApproveCreditCheckForPOR  @contract_nbr 
		END
		
		--Begin SR1-8758521
		IF @check_type = 'DOCUMENTS' AND @approval_status = 'PENDING' 
		BEGIN
			DECLARE @w_Origin VARCHAR(50)   
			
			IF @check_request_id <> 'RENEWAL'
			BEGIN
				SELECT TOP 1 @w_Origin = A.Origin
				FROM LibertyPower..Account    A (NOLOCK)
				JOIN LibertyPower..[Contract] C (NOLOCK) ON A.CurrentContractId = C.ContractId
				WHERE C.Number = @contract_nbr
				
				IF (@w_Origin = 'GENIE')
				BEGIN
					EXEC lp_enrollment.dbo.usp_check_account_approval_reject @p_username = N'System', @p_check_request_id = @check_request_id, @p_contract_nbr = @contract_nbr, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = N'DOCUMENTS', @p_approval_status = N'APPROVED', @p_comment = N'Tablet-generated contracts are automatically approved by the system.'
				END
			END
			ELSE
			BEGIN
				SELECT TOP 1 @w_Origin = A.Origin
				FROM LibertyPower..Account    A (NOLOCK)
				JOIN LibertyPower..[Contract] C (NOLOCK) ON A.CurrentRenewalContractId = C.ContractId
				WHERE C.Number = @contract_nbr
				
				IF (@w_Origin = 'GENIE')
				BEGIN
					EXEC lp_enrollment.dbo.usp_check_account_renewal_approval_reject @p_username = N'System', @p_check_request_id = @check_request_id, @p_contract_nbr = @contract_nbr, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = N'DOCUMENTS', @p_approval_status = N'APPROVED', @p_comment = N'Tablet-generated contracts are automatically approved by the system.'
				END
			END
		END
		--End SR1-8758521
		
		--Begin SR1-4112671
		IF @check_request_id = 'ESIID TRANSFER'
		AND @approval_status = 'REJECTED'
		BEGIN
			DECLARE @comment         NVARCHAR(100)
			DECLARE @new_status		 VARCHAR(15)
			DECLARE @new_sub_status	 VARCHAR(15)
			DECLARE @process_id      VARCHAR(50)
			
			SET @comment    = 'ESIID Transfer contract declined in queue and not approved in 10 days'
			SET @process_id = 'ESIID TRANSFER REJECTED'
			SET @new_status = '11000'
			SET @new_sub_status = '30'			
			
			UPDATE Libertypower.dbo.AccountStatus
			SET  [Status]	 = @new_status
				,[SubStatus] = @new_sub_status
			FROM Libertypower.dbo.AccountStatus	ASS WITH (NOLOCK)
			INNER JOIN Libertypower.dbo.AccountContract	AC WITH (NOLOCK) ON AC.AccountContractID = ASS.AccountContractID
			INNER JOIN Libertypower.dbo.Account			 A WITH (NOLOCK) ON A.AccountID = AC.AccountID
																	    AND A.CurrentContractID = AC.ContractID
			INNER JOIN Libertypower.dbo.[Contract]       C WITH (NOLOCK) ON AC.ContractID = C.ContractID
			WHERE C.Number = @contract_nbr
			
			INSERT INTO lp_account.dbo.account_status_history
			SELECT AccountIdLegacy, @new_status, @new_sub_status, getdate(), 'System', @process_id, '', '', '', '', '', '', '', '', getdate()
			FROM Libertypower.dbo.Account	 A WITH (NOLOCK)
			JOIN Libertypower.dbo.[Contract] C WITH (NOLOCK) ON A.CurrentContractID = C.ContractID
			WHERE C.Number = @contract_nbr
			
			INSERT INTO lp_account.dbo.account_comments	(account_id, date_comment, process_id, comment, username, chgstamp)
			SELECT AccountIdLegacy, getdate(), @process_id, @comment, 'System', 0
			FROM Libertypower.dbo.Account	 A WITH (NOLOCK)
			JOIN Libertypower.dbo.[Contract] C WITH (NOLOCK) ON A.CurrentContractID = C.ContractID
			WHERE C.Number = @contract_nbr
		END
		--End SR1-4112671
		
		--begin IT043
		--If submitting a brand new account to LP, autoapprove check account
		IF @check_type = 'Check Account'
		BEGIN
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
				DECLARE @pCheckRequestId CHAR(15)
				SELECT @pCheckRequestId = case when CDT.DealType = 'New' then 'Enrollment'
										  else CDT.DealType
										  end
				FROM LibertyPower..[Contract] C
				JOIN LibertyPower..ContractDealType CDT (NOLOCK) ON C.ContractDealTypeID = CDT.ContractDealTypeID
				WHERE C.ContractId = @pContractId
				
				DECLARE @p_ApprovalComment VARCHAR(100)
				SET @p_ApprovalComment = 'Autoapproved by system. Contract ' + @contract_nbr
				
				EXEC LibertyPower..usp_WIPTaskUpdateStatus 'SYSTEM', @contract_nbr, 'CHECK ACCOUNT', 'APPROVED',
					@p_ApprovalComment, @check_request_id
			END
		END
		--end IT043
	
	END 
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
