USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_edi_deenrollment_request]    Script Date: 11/16/2015 11:12:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
******************************************************************************

 * PROCEDURE:	[usp_edi_deenrollment_request]
 * PURPOSE:		
 * HISTORY:		 
 *******************************************************************************
 * 06/22/2015 - Santosh Rao
 * Change for TFS Bug 76179.
 
   *******************************************************************************
 * Modified		: 01/15/2016  - José Muñoz
 * TFS Number	: 92797
 *				  Turn off Retention for Selected accounts (per Low Capacity)
				  Modify the logic to implement the Low Capacity rule when the account is deenrolled
				  PHASE 1A REQUEST- LONG TERM SOLUTION--   
 *******************************************************************************
  */

ALTER PROCEDURE [dbo].[usp_edi_deenrollment_request] (@AccountID int, @p_reasoncode VARCHAR(100), @p_request_date DATETIME, @EDI_814_transaction_result_id int = null)      
AS      
BEGIN       
	SET NOCOUNT ON;    
	DECLARE @Date_Flow_Start			DATETIME      
			,@Date_DeEnrollment			DATETIME
			,@ProcessDate				DATETIME		-- ADDED TFS 58755       
			,@NewStatus					VARCHAR(15)      
			,@NewSubStatus				VARCHAR(15)      
			,@Phone						VARCHAR(20)      
			,@UpdateStatusResults		VARCHAR(100)
			,@ChargeBackResults			VARCHAR(100)
			,@RetentionResults			VARCHAR(100)      
			,@Reason_Text				VARCHAR(50)      
			,@ChargeBack_Flag			TINYINT, @Retention_Flag tinyint, @Requires_Fix_Flag tinyint, @Enrollment_Submission_Requeue tinyint      
			,@Legacy_Account_ID			CHAR(12)      
			,@AccountNumber				VARCHAR(30)      
			,@LccCapacityFactor			NUMERIC(18,9)	--ADDED TFS 92797
			,@CapacityThreshold			NUMERIC(18,9)	--ADDED TFS 92797
			,@days_since_last_renewal	INT      

	DECLARE @w_msg_id				CHAR(8)     
			,@w_msg_desc			VARCHAR(255)      
 			,@return_value			INT      
 			,@w_error				CHAR(1)      
 			,@w_descp				VARCHAR(250)      
			,@w_descp_add			VARCHAR(100)      
 			,@w_trans_id			BIGINT      
 			,@w_trans_id_output		BIGINT      
 			,@w_trans_date_id		CHAR(8)      
 			,@w_getdate				DATETIME      
 
   
	SELECT DISTINCT     
		@Phone				= C.Phone    
		,@Date_Flow_Start	= ASERVICE.StartDate    
		,@Date_DeEnrollment = ASERVICE.EndDate    
		,@Legacy_Account_ID = A.AccountIdLegacy    
		,@AccountNumber		= A.AccountNumber
		,@ProcessDate		= GETDATE()			-- ADDED TFS 58755     
	 FROM Libertypower..Account A WITH (NOLOCK)    
	 LEFT JOIN Libertypower..AccountLatestService ASERVICE WITH (NOLOCK) ON ASERVICE.AccountID = A.AccountID    
	 JOIN LibertyPower.dbo.Customer CUST  WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID     
	 JOIN Libertypower..Contact C WITH (NOLOCK) ON C.ContactID = CUST.ContactID   
	 WHERE A.AccountID = @AccountID    

	-- With the reason code, we can look up how the account needs to be managed.      
	SELECT @Reason_Text = reason_text, @ChargeBack_Flag = chargeback, @Retention_Flag = retention, @Requires_Fix_Flag = requires_fix, @Enrollment_Submission_Requeue = enrollment_submission_requeue      
	FROM Integration..reason_code_vw WITH (NOLOCK)      
	WHERE reason_code = @p_reasoncode      

	/* TFS 58755 BEGIN  COMMENTED
	-- Determine new status.      
	IF ((@Date_Flow_Start  = '19000101') OR (@Date_Flow_Start IS NULL) OR (@Date_Flow_Start >= @p_request_date))  --TFS 47892     
		SELECT @NewStatus = '999998', @NewSubStatus = '10'      
	ELSE          
		SELECT @NewStatus = '911000', @NewSubStatus = '10'

	TFS 58755 END COMMENTED*/ 

	/* TFS 58755 BEGIN NEW CODE 
	IF (@p_request_date > @ProcessDate ) AND (@Date_Flow_Start <= @p_request_date) AND (lp_account.dbo.ufn_has_been_enrolled(@AccountID) = 1)
		SELECT @NewStatus = '11000', @NewSubStatus = '50'
	ELSE IF (@p_request_date <= @Date_Flow_Start) or (@Date_Flow_Start = '19000101')  or (@Date_Flow_Start is NULL)
		SELECT @NewStatus = '999998', @NewSubStatus = '10'
	ELSE 
		SELECT @NewStatus = '911000', @NewSubStatus = '10'
	TFS 58755 END NEW CODE */    
	
	SET @w_getdate = GETDATE()      

	/* TFS 76179 BEGIN NEW CODE */
	IF (@p_request_date > @ProcessDate ) AND (@Date_Flow_Start <= @p_request_date) AND (lp_account.dbo.ufn_has_been_enrolled(@AccountID) = 1)
		SELECT @NewStatus = '11000', @NewSubStatus = '50'
	ELSE IF(@p_request_date > @ProcessDate ) AND (@Date_Flow_Start < @p_request_date and @Date_Flow_Start <> '19000101' and @Date_Flow_Start is not null ) AND (lp_account.dbo.ufn_has_been_enrolled(@AccountID) = 0)
		SELECT @NewStatus = '11000', @NewSubStatus = '50'
	Else IF( @p_request_date = @Date_Flow_Start) and (lp_account.dbo.ufn_has_been_enrolled(@AccountID) = 1)
		SELECT @NewStatus = '911000', @NewSubStatus = '10'
	ELSE IF (@p_request_date <= @Date_Flow_Start) or (@Date_Flow_Start = '19000101')  or (@Date_Flow_Start is NULL)
		SELECT @NewStatus = '999998', @NewSubStatus = '10'
	ELSE
		SELECT @NewStatus = '911000', @NewSubStatus = '10'
	/* TFS 76179 END NEW CODE */

	 -- This logic was added on 2007-06-12      
	 -- If a drop is received within 30 days of a renewal, then the deenrollment is essentially ignored.  The account will be automatically queued for reenrollment.      

	SELECT @days_since_last_renewal = DATEDIFF(DAY,ISNULL(MAX(date_resolved),'1900-01-01'),GETDATE())      
	FROM lp_contract_renewal.dbo.renewal_header R WITH (NOLOCK)     
	JOIN Libertypower..Contract C WITH (NOLOCK) ON C.Number = R.contract_nbr    
	JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON AC.AccountContractID = C.ContractID     
	JOIN Libertypower..Account A WITH (NOLOCK) ON A.AccountID = AC.AccountID    
	AND A.CurrentContractID = C.ContractID     
	WHERE A.AccountID = @AccountID      
	AND call_status = 'S'     

	PRINT 'Processing Deenrollment.  check point 10'      

	IF @days_since_last_renewal < 30      

	BEGIN      
		EXECUTE @return_value = lp_account.dbo.usp_account_status_process       
		'SYSTEM','SET NUMBER',@Legacy_Account_ID,@AccountNumber,'13000','60', @w_getdate      
		,' ',' ',' ',' ',' ',@w_error OUTPUT,@w_msg_id OUTPUT,@w_descp OUTPUT,@w_descp_add OUTPUT,'N'      

		IF @return_value = 1 SET @UpdateStatusResults = isnull(convert(VARCHAR(10),@return_value),'') + ':' + isnull(@w_error,'') + ':' + isnull(@w_msg_id,'') + ':' + isnull(@w_descp,'') + ':' + isnull(@w_descp_add,'')      
	END        
	ELSE      
	BEGIN      
		-- Update dates.    
		--IF (@Date_Flow_Start >= @p_request_date AND lp_account.dbo.ufn_has_been_enrolled(@AccountID) = 1)      
		--BEGIN      
		-- -- If the start date is in the future, that means this is an enrollment cancellation.  In that case we maintain the old deenrollment date.      
		-- -- We also want the old start date which means we need to roll it back.      
		-- UPDATE lp_account.dbo.account      
		-- SET date_flow_start = isnull(lp_account.dbo.ufn_last_enroll_date(@AccountNumber, @p_request_date),date_flow_start),      
		--     date_deenrollment = isnull(lp_account.dbo.ufn_last_deenroll_date(@AccountNumber),date_deenrollment)      
		-- WHERE AccountID = @AccountID      
		--END      
		--ELSE      
     

		IF (@NewStatus <> '999998')      
			UPDATE Libertypower..AccountService  -- Fix error: Msg 208, Level 16, State 1, Procedure usp_edi_deenrollment_accept, Line 31 Invalid object name 'AccountService' (Joser Munoz 06/28/2010)      
			SET EndDate = isnull(@p_request_date,EndDate)      
			WHERE AccountServiceID =       
			(select top 1 AccountServiceID from Libertypower..AccountService where account_id = @Legacy_Account_ID       
			order by StartDate desc,EndDate desc,AccountServiceID desc)     
     
		PRINT 'Processing Deenrollment.  check point 20'      

		-- Insert reason code into comments.      

		IF (@p_reasoncode is not null)      
		BEGIN      
			INSERT lp_account.dbo.account_reason_code_hist      
			(account_id ,date_created,reason_code  ,process_id  ,username,chgstamp)      
			VALUES      
			(@Legacy_Account_ID,GETDATE()   ,@p_reasoncode,'SET NUMBER','SYSTEM',0)      
		END      

		--select 1,@Account_ID,@p_account_number,@NewStatus,@NewSubStatus      
		-- Update Status.      
		EXECUTE @return_value = lp_account.dbo.usp_account_status_process       
		'SYSTEM','SET NUMBER',@Legacy_Account_ID,@AccountNumber,@NewStatus,@NewSubStatus, @p_request_date      
		,' ',' ',' ',' ',' ',@w_error OUTPUT,@w_msg_id OUTPUT,@w_descp OUTPUT,@w_descp_add OUTPUT,'N'      

		IF @return_value = 1 SET @UpdateStatusResults = isnull(convert(VARCHAR(10),@return_value),'') + ':' + isnull(@w_error,'') + ':' + isnull(@w_msg_id,'') + ':' + isnull(@w_descp,'') + ':' + isnull(@w_descp_add,'')      
		-- Insert into Retention.      

		IF  @Retention_Flag = 1      
		BEGIN      
			/* TFS 92497 BEGIN */
			SELECT @LccCapacityFactor	= LccCapacityFactor
			FROM Libertypower..AccountContract AC WITH (NOLOCK)
			INNER JOIN Libertypower..Account AA WITH (NOLOCK)
			ON AA.AccountID				= AC.AccountID
			AND AA.CurrentContractID	= AC.ContractID
			WHERE AA.AccountID			= @AccountID

			SELECT @CapacityThreshold = ISNULL(CTD.[CapacityThreshold], -1)
			FROM Libertypower.dbo.Utility UT WITH (NOLOCK)
			INNER JOIN Libertypower.dbo.Account AA WITH (NOLOCK)
			ON UT.ID						= AA.UtilityID
			INNER JOIN Libertypower.dbo.AccountTYPE AT WITH (NOLOCK)
			ON AT.ID						= AA.AccountTypeID
			INNER JOIN [ENTAPP_UTILITYMANAGEMENT].[Lp_UtilityManagement].[dbo].[UtilityCompany] UTD WITH (NOLOCK)
			ON UTD.UtilityCode				= UT.UtilityCode
			INNER JOIN [ENTAPP_UTILITYMANAGEMENT].[Lp_UtilityManagement].[dbo].[CapacityThresholdRule] CTD WITH (NOLOCK)
			ON CTD.[UtilityCompanyId]		= UTD.[Id]
			INNER JOIN [ENTAPP_UTILITYMANAGEMENT].[Lp_UtilityManagement].[dbo].[CustomerAccountType] ATD WITH (NOLOCK)
			ON ATD.[AccountType]			= AT.AccountType
			WHERE AA.AccountID				= @AccountID
			AND CTD.CustomerAccountTypeId	= ATD.ID
			AND CTD.IgnoreCapacityFactor	= 0

			IF (@LccCapacityFactor IS NULL) OR (@LccCapacityFactor >= @CapacityThreshold) 
			BEGIN
				--PRINT 'Here to insert the new logic for Low Capacity'		
				EXEC @return_value = lp_enrollment.dbo.usp_retention_header_ins 'SYSTEM', @Phone, @Legacy_Account_ID, ' ', 0, 0, 'L', @p_reasoncode, 'NONE', '19000101','BATCH',' ',' ',' ','N'      
				IF @return_value = 1 SET @RetentionResults = isnull(convert(VARCHAR(10),@return_value),'') + ':' + isnull(@w_error,'') + ':' + isnull(@w_msg_id,'') + ':' + isnull(@w_descp,'') + ':' + isnull(@w_descp_add,'')      
			END

			/* TFS 92497 END */

		END      
	END      

	---- Track results of the EDI processing      
	UPDATE Integration..EDI_814_transaction_result  
	SET update_status_results = @UpdateStatusResults, charge_back_results = @ChargeBackResults, retention_results = @RetentionResults      
	WHERE EDI_814_transaction_result_id = @EDI_814_transaction_result_id      
  
	SET NOCOUNT OFF;    
END
