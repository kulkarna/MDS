USE [integration]

GO
  
-- Modified 12/06/2007  
-- Gail Mangaroo  
-- added source parameter to usp_comm_trans_detail_ins call  
-- =========================================================  
-- Modified 11/18/2010  
-- Gail Mangaroo  
-- removed commission call  
-- =========================================================  
-- Modified 11/27/2013
-- Agata Studzinska 
-- Added to condition case when @Date_Flow_Start and @Date_DeEnrollment is NULL, since we gets rid of 1900 dates;
-- Replaced account and tblAccounts view by legacy tables
-- IT124
--==========================================================

ALTER PROCEDURE [dbo].[usp_edi_deenrollment_request] (@AccountID int, @p_reasoncode varchar(100), @p_request_date datetime, @EDI_814_transaction_result_id int = null)  
AS  
BEGIN   

SET NOCOUNT ON;

 DECLARE @Date_Flow_Start datetime  
 DECLARE @Date_DeEnrollment datetime  
 DECLARE @NewStatus varchar(15)  
 DECLARE @NewSubStatus varchar(15)  
 DECLARE @Phone varchar(20)  
 DECLARE @UpdateStatusResults varchar(100), @ChargeBackResults varchar(100), @RetentionResults varchar(100)  
 DECLARE @Reason_Text varchar(50)  
 DECLARE @ChargeBack_Flag tinyint, @Retention_Flag tinyint, @Requires_Fix_Flag tinyint, @Enrollment_Submission_Requeue tinyint  
 DECLARE @Legacy_Account_ID char(12)  
 DECLARE @AccountNumber varchar(30)  
  
 --SELECT @Phone    = ContactPhone  
 -- ,@Date_Flow_Start  = FlowStartDate  
 -- ,@Date_DeEnrollment  = De_EnrollmentDate  
 -- ,@Legacy_Account_ID  = account_id  
 -- ,@AccountNumber   = accountnumber  
 --FROM lp_account.dbo.tblAccounts   
 --WHERE accountnumber in (select account_number from lp_account..account where AccountID = @AccountID) 
 
 SELECT DISTINCT 
		 @Phone = C.Phone
		,@Date_Flow_Start = ASERVICE.StartDate
		,@Date_DeEnrollment = ASERVICE.EndDate
		,@Legacy_Account_ID = A.AccountIdLegacy
		,@AccountNumber = A.AccountNumber
 FROM Libertypower..Account A WITH (NOLOCK)
 LEFT JOIN Libertypower..AccountLatestService ASERVICE WITH (NOLOCK) ON ASERVICE.AccountID = A.AccountID
 JOIN LibertyPower.dbo.CustomerContact CC WITH (NOLOCK) ON CC.CustomerID = A.CustomerID
 JOIN Libertypower..Contact C WITH (NOLOCK) ON C.ContactID = CC.ContactID
 WHERE A.AccountID = @AccountID
 
 -- With the reason code, we can look up how the account needs to be managed.  
 SELECT @Reason_Text = reason_text, @ChargeBack_Flag = chargeback, @Retention_Flag = retention, @Requires_Fix_Flag = requires_fix, @Enrollment_Submission_Requeue = enrollment_submission_requeue  
 FROM dbo.reason_code_vw WITH (NOLOCK)  
 WHERE reason_code = @p_reasoncode  
  
 -- Determine new status.  
 IF (((@Date_Flow_Start  = '19000101') OR (@Date_Flow_Start IS NULL)) 
	  AND ((@Date_DeEnrollment = '19000101') OR (@Date_DeEnrollment IS NULL))) --IT124 Agata Studzinska 11/27/2013
  SELECT @NewStatus = '999998', @NewSubStatus = '10'  
 ELSE    
  IF (@Date_Flow_Start >= @p_request_date)  
   IF lp_account.dbo.ufn_has_been_enrolled(@AccountID) = 1  
    SELECT @NewStatus = '911000', @NewSubStatus = '10'  
   ELSE  
    SELECT @NewStatus = '999998', @NewSubStatus = '10'  
  --ELSE IF (@p_request_date < getDate())  
  -- SELECT @NewStatus = '911000', @NewSubStatus = '10'  
  ELSE  
   SELECT @NewStatus = '11000',  @NewSubStatus = '50'  
  
 DECLARE @w_msg_id char(8)  
 DECLARE @w_msg_desc varchar(255)  
 DECLARE @return_value int  
 DECLARE @w_error char(1)  
 DECLARE @w_descp varchar(250)  
 DECLARE @w_descp_add varchar(100)  
 DECLARE @w_trans_id bigint  
 DECLARE @w_trans_id_output bigint  
 DECLARE @w_trans_date_id char(8)  
 DECLARE @w_getdate datetime  
 SET @w_getdate = getdate()  
  
 -- This logic was added on 2007-06-12  
 -- If a drop is received within 30 days of a renewal, then the deenrollment is essentially ignored.  The account will be automatically queued for reenrollment.  
 DECLARE @days_since_last_renewal int  
  
 --SELECT @days_since_last_renewal = datediff(day,isnull(max(date_resolved),'1900-01-01'),getdate())  
 --FROM lp_contract_renewal.dbo.renewal_header r  
 --JOIN lp_account.dbo.account a on r.contract_nbr = a.contract_nbr  
 --WHERE a.AccountID = @AccountID  
 --AND call_status = 'S'  
 
 SELECT @days_since_last_renewal = datediff(day,isnull(max(date_resolved),'1900-01-01'),getdate())  
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
  IF @return_value = 1 SET @UpdateStatusResults = isnull(convert(varchar(10),@return_value),'') + ':' + isnull(@w_error,'') + ':' + isnull(@w_msg_id,'') + ':' + isnull(@w_descp,'') + ':' + isnull(@w_descp_add,'')  
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
   --UPDATE lp_account.dbo.account								-- commented this update out, since below we have query to update the most recent record -- IT124 Agata Studzinska 11/27/2013
   --SET date_deenrollment = isnull(@p_request_date,date_deenrollment)  
   --WHERE AccountID = @AccountID      
 
  -- Ticket 5312.  We record a history of account service periods. 2010-06-24  
  -- We want to make sure we are updating the most recent record of the account.  
  --UPDATE AccountService  
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
    (@Legacy_Account_ID,getdate()   ,@p_reasoncode,'SET NUMBER','SYSTEM',0)  
  END  
  
  --select 1,@Account_ID,@p_account_number,@NewStatus,@NewSubStatus  
  -- Update Status.  
  EXECUTE @return_value = lp_account.dbo.usp_account_status_process   
     'SYSTEM','SET NUMBER',@Legacy_Account_ID,@AccountNumber,@NewStatus,@NewSubStatus, @p_request_date  
    ,' ',' ',' ',' ',' ',@w_error OUTPUT,@w_msg_id OUTPUT,@w_descp OUTPUT,@w_descp_add OUTPUT,'N'  
  IF @return_value = 1 SET @UpdateStatusResults = isnull(convert(varchar(10),@return_value),'') + ':' + isnull(@w_error,'') + ':' + isnull(@w_msg_id,'') + ':' + isnull(@w_descp,'') + ':' + isnull(@w_descp_add,'')  
  
  -- Insert into Retention.  
  IF  @Retention_Flag = 1  
  BEGIN  
   EXEC @return_value = lp_enrollment.dbo.usp_retention_header_ins 'SYSTEM', @Phone, @Legacy_Account_ID, ' ', 0, 0, 'L', @p_reasoncode, 'NONE', '19000101','BATCH',' ',' ',' ','N'  
   IF @return_value = 1 SET @RetentionResults = isnull(convert(varchar(10),@return_value),'') + ':' + isnull(@w_error,'') + ':' + isnull(@w_msg_id,'') + ':' + isnull(@w_descp,'') + ':' + isnull(@w_descp_add,'')  
  END  
  
 END  
  
 ---- Track results of the EDI processing  
 UPDATE EDI_814_transaction_result  
 SET update_status_results = @UpdateStatusResults, charge_back_results = @ChargeBackResults, retention_results = @RetentionResults  
 WHERE EDI_814_transaction_result_id = @EDI_814_transaction_result_id  
 
SET NOCOUNT OFF;

END  

GO