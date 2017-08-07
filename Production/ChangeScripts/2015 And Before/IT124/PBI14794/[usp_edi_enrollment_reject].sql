USE [integration]

GO  
  
  
-- Modified 12/06/2007  
-- Gail Mangaroo  
-- added source parameter to usp_comm_trans_detail_ins call  
-- =========================================================  
-- Modified 11/16/2010  
-- Isabelle Tamanini  
-- Commented the condition to add a comment in account_comments table (SD18749)  
-- =========================================================  
-- Modified 11/18/2010  
-- Gail Mangaroo   
-- Removed the commission transaction call   
-- =========================================================  
-- Modified 05/09/2011  
-- Isabelle Tamanini  
-- Added logic to handle COMED accounts enrollment rejections   
-- due to invalid billing type  
-- MD056  
-- =========================================================  
-- Modified 10/26/2011  
-- By  : José Muñoz  
-- Ticket : 1-2173857  
-- NFI (not first in) & NLI (not last in) enrollments  
-- If we are unable to enroll the account after trying 5 times,   
-- we have been requesting IT to update the status to enrollment cancelled done.  
-- =============================================  
-- Author:  Jaime Forero  
-- Create date: 1/29/2012  
-- Description: Refactored for IT79 and use of new schema  
-- =========================================================  
-- Modified 03/19/2012  
-- By  : José Muñoz  
-- Ticket : 1-9615907  (Incorrect Statuses)  
--   : Please fix this bug - the account's status should revert back   
--     to De-Enrolled Done if the re-enrollment process fails.  
-- =========================================================  
-- Modified 03/18/2013  
-- By  : José Muñoz  
-- Ticket : 1-77838383 CLP- B30 Enrollment Rejection  
-- =============================================  
-- =========================================================  
-- Modified 08/23/2013  
-- By  : Sal Tenorio  
-- Ticket : 1-148149850 (PBI 13846)  
--    Handle case when Account is deenrolled but it already existed in the past  
-- =============================================  
-- Modified 11/27/2013
-- Agata Studzinska 
-- Commented the update of date_flow_start and date_deenrollment to '19000101',
-- replaced account and tblAccounts views by legacy tables,
-- IT124
--==============================================
  
  
ALTER PROCEDURE [dbo].[usp_edi_enrollment_reject] (@AccountID INT, @p_reasoncode varchar(10), @EDI_814_transaction_result_id int = null)  
AS  
BEGIN  

 SET NOCOUNT ON   
 
 --PRINT 'Processing Enrollment Reject'  
 DECLARE @Date_Flow_Start    datetime  
   ,@Date_Deenrollment    datetime  
   ,@NewStatus      varchar(15)  
   ,@NewSubStatus     varchar(15)  
   ,@Phone       varchar(20)  
   ,@Reason_Text     varchar(50)  
   ,@ChargeBack_Flag    tinyint  
   ,@Retention_Flag    tinyint  
   ,@Requires_Fix_Flag    tinyint  
   ,@Enrollment_Submission_Requeue tinyint  
   ,@Legacy_Account_ID    char(12)  
   ,@AccountNumber     varchar(30)  
   ,@UpdateStatusResults   varchar(100)  
   ,@ChargeBackResults    varchar(100)  
   ,@RetentionResults    varchar(100)  
   ,@EnrollmentCancelByNFIFlag  BIT  -- ADDED TICKET 1-2173857  
   ,@EDI_814_transaction_id  INT  -- ADDED TICKET 1-2173857  
   ,@UtilityId      INT  -- ADDED TICKET 1-2173857  
   --,@AccountStatus     VARCHAR(6) -- ADDED TICKET 1-9615907  we don't use the @AccountStatus and @AccountSubStatus any more
   --,@AccountSubStatus    VARCHAR(2) -- ADDED TICKET 1-9615907  
   ,@EnrollmentCancelByB30Flag  BIT  -- ADDED TICKET 1-77838383   
   ,@TEMPCOUNT      INT  
     
 DECLARE @CountNFITable     TABLE (ReasonCode    VARCHAR(100)  
            ,EDI_814_transaction_id  int) -- ADDED TICKET 1-2173857  
      
 /* Ticket 1-77838383 Begin 001 */              
 DECLARE @CountB30Table     TABLE (ReasonCode    VARCHAR(100)  
            ,EDI_814_transaction_id  int) -- ADDED TICKET 1-77838383  
 /* Ticket 1-77838383 End 001 */              
   
 -- First pull the information needed based on the account number.  
 --SELECT @Phone     = ContactPhone  
 -- ,@Date_Flow_Start   = FlowStartDate  
 -- ,@Date_Deenrollment   = De_enrollmentDate  
 -- ,@Legacy_Account_ID   = account_id  
 -- ,@AccountNumber    = accountnumber  
 -- ,@AccountStatus    = [status]  -- ADDED TICKET 1-9615907  
 -- ,@AccountSubStatus   = [sub_status] -- ADDED TICKET 1-9615907  
 --FROM lp_account.dbo.tblAccounts with (nolock)  
 ---- IT79 replaced this line with line below => WHERE accountnumber = (SELECT account_number FROM lp_account..account WITH (NOLOCK) WHERE AccountID = @AccountID)  
 --WHERE accountnumber = (SELECT AccountNumber FROM LibertyPower..Account WITH (NOLOCK) WHERE AccountID = @AccountID) 
 
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
   
 /*Ticket 1-2173857 Begin 001*/  
 SET @EnrollmentCancelByNFIFlag = 0  
  
 SELECT @EDI_814_transaction_id = EDI_814_transaction_id  
 FROM EDI_814_transaction_result WITH (NOLOCK)  
 WHERE EDI_814_transaction_result_id = @EDI_814_transaction_result_id  
  
 SELECT @UtilityId = utility_id  
 FROM integration..EDI_814_transaction WITH (NOLOCK INDEX = IX_account_number)   
 WHERE EDI_814_transaction_id = @EDI_814_transaction_id  
  
 IF @p_reasoncode = '595'  -- 595 IS NFI   
 BEGIN  
  DELETE @CountNFITable  
  INSERT INTO @CountNFITable  
  SELECT TOP 5 reasoncode, EDI_814_transaction_id  
  FROM integration..EDI_814_transaction WITH (NOLOCK INDEX = IX_account_number)   
  WHERE account_number = @AccountNumber  
  AND utility_id = @UtilityId  
  AND direction = 1  
  ORDER BY EDI_814_transaction_id DESC  
  
  IF (SELECT count(1) FROM @CountNFITable WHERE ReasonCode = 'NFI') >= 5    
   SET @EnrollmentCancelByNFIFlag  = 1  
  
 END  
 /*Ticket 1-2173857 End 001*/  
  
   
 /* Ticket 1-77838383 Begin 002 */      
 SET @EnrollmentCancelByB30Flag = 0  
  
 IF @UtilityId = 15  -- 15 IS CL&P Utility  
 AND @p_reasoncode IN('B30','595')   
 BEGIN  
  DELETE @CountB30Table  
  INSERT INTO @CountB30Table  
  SELECT TOP 5 reasoncode, EDI_814_transaction_id  
  FROM integration..EDI_814_transaction WITH (NOLOCK INDEX = IX_account_number)   
  WHERE account_number = @AccountNumber  
  AND utility_id   = @UtilityId  
  AND direction   = 1  
  ORDER BY EDI_814_transaction_id DESC  
  
  IF (SELECT count(1) FROM @CountB30Table WHERE ReasonCode = 'B30') >= 5    
   SET @EnrollmentCancelByB30Flag  = 1    
 END  
 /* Ticket 1-77838383 End 002 */  
  
 -- IF @Requires_Fix_Flag = 1 -- COMMENTED TICKET 1-2173857  
 IF @Requires_Fix_Flag = 1 AND @EnrollmentCancelByNFIFlag = 0 -- ADDED TICKET 1-2173857  
 AND @EnrollmentCancelByB30Flag = 0 -- ADDED TICKET 1-77838383  
  -- Based on the reject reason code, this account may need to go a "pending fix" status.  
  SELECT @NewStatus = '05000', @NewSubStatus = '25'  
 --ELSE IF @Enrollment_Submission_Requeue = 1 -- COMMENTED TICKET 1-2173857  
 ELSE IF @Enrollment_Submission_Requeue = 1 AND @EnrollmentCancelByNFIFlag = 0 -- ADDED TICKET 1-2173857  
 AND @EnrollmentCancelByB30Flag = 0 -- ADDED TICKET 1-77838383  
 BEGIN  
  -- Based on the reject reason code, this account may need to go a "reenrollment" status.  
  
  -- If the account was enrolled previously, we consider it a re-enrollment.  
  IF lp_account.dbo.ufn_has_been_enrolled(@AccountID) = 1  
   SELECT @NewStatus = '13000', @NewSubStatus = '60'  
  ELSE  
   SELECT @NewStatus = '05000', @NewSubStatus = '27'  
 END  
 ELSE  
 BEGIN  
  -- If flow date is in the past and deenrollment date is in the future, then this is a reinstatement effort.  
  -- Since the reinstatement failed, this account is either deenrolled or pending deenrollment.  
  -- IF @Date_Flow_Start < getdate() and @Date_Flow_Start > '1900-01-01 00:00:00.000' and @Date_Deenrollment > getdate() -- COMMENTED TICKET 1-2173857  
  IF @Date_Flow_Start < getdate() and @Date_Flow_Start > '1900-01-01 00:00:00.000' and @Date_Deenrollment > getdate() AND @EnrollmentCancelByNFIFlag = 0 -- ADDED TICKET 1-2173857  
  AND @EnrollmentCancelByB30Flag = 0 -- ADDED TICKET 1-77838383  
  BEGIN  
   IF @Date_Deenrollment < getdate()   
    SELECT @NewStatus = '911000', @NewSubStatus = '10'  
   ELSE  
    SELECT @NewStatus = '11000', @NewSubStatus = '50'  
  END  
  ELSE  
   SELECT @NewStatus = '999998', @NewSubStatus = '10'  
 END  
   
 declare @p_utility_id varchar(15)  
 -- IT79 replaced this line with line below => set @p_utility_id = (select top 1 utility_id from lp_account..account with (nolock) where accountid = @AccountID)   
 SET @p_utility_id = (SELECT U.UtilityCode   
       FROM LibertyPower..Utility U with (nolock)   
       JOIN LibertyPower..Account A with (nolock) ON U.ID = A.UtilityID AND A.AccountID = @AccountID);  
   
 IF (@p_reasoncode = '085' and ltrim(rtrim(@p_utility_id)) = 'COMED')  
 BEGIN  
  declare @p_contract_nbr varchar(12)  
  -- IT79 replaced this line with line below => set @p_contract_nbr = (select top 1 contract_nbr from lp_account..account where accountid = @AccountID)  
  set @p_contract_nbr = ( SELECT C.Number   
        FROM LibertyPower..Account A (NOLOCK)   
        JOIN LibertyPower..[Contract] C (NOLOCK)  ON A.CurrentContractID = C.ContractID  
        WHERE AccountID = @AccountID   
          );  
    
    
  IF not exists (select check_type from lp_enrollment..check_account  
        where contract_nbr = @p_contract_nbr  
          and check_type = 'POST-USAGE CREDIT CHECK')  
  
   exec lp_enrollment..usp_check_account_create_step 'SYSTEM',   
               @p_contract_nbr,   
               'POST-USAGE CREDIT CHECK'  
                 
  ELSE  
  BEGIN  
   update lp_enrollment..check_account  
   set approval_status = 'PENDING'  
      where contract_nbr = @p_contract_nbr  
        and check_type = 'POST-USAGE CREDIT CHECK'  
  END  
 END  
  
  
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
  
    IF (@NewStatus          = '999998' AND @NewSubStatus        = '10')  
    --AND (@AccountStatus   = '13000' AND @AccountSubStatus           = '80')  
    AND EXISTS (select * from libertypower..AccountService (NOLOCK) where account_id = @Legacy_Account_ID and EndDate is not null)  
    BEGIN  
        SELECT @NewStatus       = '911000'  
              ,@NewSubStatus    = '10'  
    END  
   
 -- Update Status.  
 EXECUTE @return_value = lp_account.dbo.usp_account_status_process   
          'SYSTEM','SET NUMBER',@Legacy_Account_ID,@AccountNumber,@NewStatus,@NewSubStatus, @w_getdate  
   ,' ',' ',' ',' ',' ',@w_error OUTPUT,@w_msg_id OUTPUT,@w_descp OUTPUT,@w_descp_add OUTPUT,'N'  
 SET @UpdateStatusResults = isnull(convert(varchar(10),@return_value),'') + ':' + isnull(@w_error,'') + ':' + isnull(@w_msg_id,'') + ':' + isnull(@w_descp,'') + ':' + isnull(@w_descp_add,'')  
  
 ---- Reason Change  
 IF  @ChargeBack_Flag = 1 OR @Retention_Flag = 1    
 BEGIN  
  INSERT lp_account.dbo.account_reason_code_hist  
   (account_id, date_created, reason_code  , process_id  , username, chgstamp)  
  VALUES  
   (@Legacy_Account_ID, getdate()  , @p_reasoncode, 'SET NUMBER', 'SYSTEM', 0       )  
 END  
  
 -- If block commented: ticket 18749  
 ---- Insert a comment which explains the fix which needs to be performed.  
 --IF @Requires_Fix_Flag = 1  
 --BEGIN  
  INSERT lp_account.dbo.account_comments  
   (account_id ,date_comment,process_id            ,comment                                     ,username,chgstamp)  
  VALUES  
   (@Legacy_Account_ID,getdate()   ,'ENROLLMENT REJECTION',@Reason_Text,'SYSTEM',0)  
 --END  
  
 ---- Trigger Retention     
 IF  @Retention_Flag = 1  
 BEGIN  
  --SELECT @w_phone = ContactPhone FROM lp_account.dbo.tblAccounts WHERE Account_ID = @Account_ID  
  EXEC @return_value = lp_enrollment.dbo.usp_retention_header_ins 'SYSTEM', @Phone, @Legacy_Account_ID, ' ', 0, 0, 'L', @p_reasoncode, 'NONE', '19000101','BATCH',' ',' ',' ','N'  
  SET @RetentionResults = isnull(convert(varchar(10),@return_value),'') + ':' + isnull(@w_error,'') + ':' + isnull(@w_msg_id,'') + ':' + isnull(@w_descp,'') + ':' + isnull(@w_descp_add,'')  
 END  
  
 -- Account flow start should match the deenrollment date on an enrollment cancellation.  
 IF @NewStatus = '999998'  
 BEGIN  
  --UPDATE lp_account.dbo.account   --IT124 Agata Studzinska 11/27/2013
  --SET date_flow_start = '1900-01-01', date_deenrollment = '1900-01-01'  
  --WHERE account_id = @Legacy_Account_ID  
  
  -- We want to make sure we are updating the most recent record of the account.  
  -- Or inserting a record if one does not exist.  
  DECLARE @AccountServiceID INT  
  DECLARE @StartDate DATETIME  
  DECLARE @LastEndDate DATETIME  
    
  SELECT top 1 @AccountServiceID = AccountServiceID, @LastEndDate = EndDate  
  FROM Libertypower..AccountService WITH (NOLOCK)  
  WHERE account_id = @Legacy_Account_ID   
  ORDER BY StartDate desc,EndDate desc,AccountServiceID desc  
    
  IF @LastEndDate IS NULL  
  BEGIN  
   UPDATE Libertypower..AccountService  
   SET EndDate = @Date_Flow_Start  
   WHERE AccountServiceID = @AccountServiceID  
  END  
 END  
      
 ---- Track results of the EDI processing  
 UPDATE EDI_814_transaction_result  
 SET update_status_results = @UpdateStatusResults, charge_back_results = @ChargeBackResults, retention_results = @RetentionResults  
 WHERE EDI_814_transaction_result_id = @EDI_814_transaction_result_id  
  
 SET NOCOUNT OFF  
 
END  

GO