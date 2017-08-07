use Libertypower
go

-- =============================================  
-- Author:  Jaime Forero  
-- Create date: 06/28/2011  
-- Description: trigger replacing [tr_account_renewal_status_upd]  
-- OLD Comments:  
 -- Author:  Rick Deigsler  
 -- Create date: 3/22/2007  
  
 -- Modified: 6/12/2007  
 -- Add code to update renewal queue  
  
 -- Description: Change status and sub_status of renewal  
 --    if account lost  (11000 50)(911000 10)  
 --    or account saved (05000 30)(06000 30)(905000 10)(906000 10)   
 --    update renewal queue to a loss if exists  
 -- =============================================  
 -- Modified 5/12/2009 Gail Mangaroo  
 -- Added call to usp_comm_trans_detail_ins_auto  
 -- =============================================  
 -- Modified 9/29/2010 Jose Munoz  
 -- Ticket : 18316  
 --   - Renewal contracts being deleted by system post deal entry due to pending drop.  
 --  
 -- =============================================  
 -- Modified 12/1/2010 Gail Mangaroo   
 -- Replaced commission call with call to lp_Commissions..usp_transaction_request_enrollment_process.  
-- =============================================  
 -- Modified 9/16/2012 Rafael Vasques
 -- Adding the change of the trigger also to impact on the new tables.
 -- IT 121 Data Migration
-- =============================================  
alter TRIGGER [dbo].[AfterUpdateAccountRenewalStatus]  
   ON  [dbo].[AccountStatus]  
   AFTER UPDATE  
AS   
BEGIN  
 SET NOCOUNT ON  
 DECLARE @w_contract_nbr  char(12),  
   @w_account_id  char(12),  
   @w_username   nchar(100),  
   @call_reason_code varchar(5),  
   @comment   varchar(MAX)  
   -- ADD Ticket 18316  
   ,@account_number VARCHAR(30)  
   ,@transaction_date DATETIME  
   ,@date_submit  DATETIME  
   ,@utility_id  CHAR(15)  
   -- ADD Ticket 18316  
     
 IF UPDATE([Status]) OR UPDATE([SubStatus])  
 BEGIN  
  -- lost ---------------------  
  DECLARE curLost CURSOR FOR  
  SELECT ar.contract_nbr, ar.account_id, ar.username ,ar.account_number, ar.date_submit, ar.utility_id  -- ADD Ticket 18316  
  FROM lp_account.dbo.account_renewal ar  
  WHERE ar.account_id   
  IN  ( SELECT A.AccountIdLegacy  
     FROM Inserted I  
     JOIN LibertyPower.dbo.AccountContract AC ON AC.AccountContractID = I.AccountContractID   
     JOIN LibertyPower.dbo.Account   A  ON A.AccountID    = AC.AccountID  
     WHERE ([Status] = '11000'  AND [SubStatus] = '50')  
     OR  ([Status] = '911000' AND [SubStatus] = '10')  
     OR  ([Status] = '999998' AND [SubStatus] = '10') -- ticket 21859 Added so that usage rejections can also cancel renewals.  
     )  
  AND NOT (status = '07000' AND sub_status = '90') -- Renewal cancelled  
  
  OPEN curLost   
  
  FETCH NEXT FROM curLost INTO @w_contract_nbr, @w_account_id, @w_username  
  ,@account_number, @date_submit, @utility_id -- ADD Ticket 18316  
  
  WHILE (@@FETCH_STATUS <> -1)   
  BEGIN   
   -- If status or sub_status values have actually changed on update  
     
   IF (SELECT TOP 1 [Status] FROM inserted I  
    JOIN LibertyPower.dbo.AccountContract AC ON AC.AccountContractID = I.AccountContractID   
    JOIN LibertyPower.dbo.Account   A  ON A.AccountID    = AC.AccountID   
       WHERE A.AccountIdLegacy = @w_account_id)   
       <>   
       (SELECT TOP 1 [Status] FROM Deleted D  
        JOIN LibertyPower.dbo.AccountContract AC ON AC.AccountContractID = D.AccountContractID   
     JOIN LibertyPower.dbo.Account   A  ON A.AccountID    = AC.AccountID  
        WHERE A.AccountIdLegacy = @w_account_id)  
   BEGIN  
    -- if drop is in retention and...  
    IF EXISTS ( SELECT TOP 1 call_reason_code  
     FROM   lp_enrollment..retention_header WITH (NOLOCK)  
     WHERE   account_id = @w_account_id   
     AND    call_status  = 'O' )  
     -- if it is in the renewal queue and is not closed, lose it  
     AND EXISTS (SELECT TOP 1 call_reason_code  
     FROM   lp_contract_renewal..renewal_header WITH (NOLOCK)  
     WHERE   contract_nbr = @w_contract_nbr   
     AND    (call_status = 'O' OR call_status = 'A'))  
    BEGIN  
     DECLARE @dt  datetime  
     SET  @dt  = GETDATE()  
  
     -- get the reason code and comment for the drop from retention  
     SELECT TOP 1 @call_reason_code = b.call_reason_code, @comment = b.comment  
     FROM   lp_enrollment..retention_header a WITH (NOLOCK) INNER JOIN lp_enrollment..retention_comment b WITH (NOLOCK) ON a.call_request_id = b.call_request_id  
     WHERE   a.account_id = @w_account_id   
     AND    a.call_status = 'O'   
     ORDER BY  a.date_created DESC  
  
     -- update renewal queue to a loss  
     EXEC lp_contract_renewal..usp_renewal_detail_upd @w_username, @w_contract_nbr, 'L', @call_reason_code, @w_username, 'NONE', @dt, '', @comment, '0', ''  
    END  
  
    /* ADD TICKET 18316 BEGIN */     
    SELECT TOP 1 @transaction_date = isnull(t.transaction_date, '19000101')  
    FROM integration.dbo.EDI_814_transaction t  
    --INNER JOIN integration.dbo.utility u  -- COMMENTS TICKET 19914  
    --ON t.utility_id = u.utility_id  
    INNER JOIN libertypower.dbo.utility u  -- ADD TICKET 19914  
    ON t.utility_id = u.[id]  
    INNER JOIN integration.dbo.EDI_814_transaction_result tr   
    ON t.EDI_814_transaction_id = tr.EDI_814_transaction_id   
    WHERE t.account_number   = @account_number  
    AND u.UtilityCode    = @utility_id  
    AND tr.lp_transaction_id IN (8, 6, 14) --  (8)Drop Request (6)Drop Acceptance (14)Usage Reject  
    ORDER BY t.transaction_date DESC  
      
    IF (@date_submit < @transaction_date)  
    BEGIN     
     INSERT INTO lp_account..account_status_history  
     SELECT  @w_account_id, '07000', '90', GETDATE(), @w_username,   
        'RENEWAL', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', GETDATE()   
       
     UPDATE lp_account..account_renewal  
     SET  status = '07000', sub_status = '90'  
     WHERE account_id = @w_account_id  
    --#Rafael Vasques IT121 Change Begin 
    update libertypower..AccountContract set AccountContractStatusID = 3, AccountContractStatusReasonID = 1 where AccountContractID in (
	select AC.AccountContractID from libertypower..account a WITH (NOLOCK)
	JOIN LibertyPower.dbo.AccountContract AC WITH (NOLOCK)   ON A.AccountID = AC.AccountID  AND A.CurrentRenewalContractID = AC.ContractID   
	join libertypower..Contract c with(nolock) on c.ContractID = a.CurrentRenewalContractID
	inner JOIN LibertyPower.dbo.AccountStatus ACS WITH (NOLOCK) ON  AC.AccountContractID = ACS.AccountContractID 	
	where  AccountIdLegacy = @w_account_id
	)
	--#Rafael Vasques IT121 Change END
    END  
    /* ADD TICKET 18316 END */     
      
    DECLARE @RC int  
     
    EXECUTE lp_commissions..usp_transaction_request_enrollment_process @w_account_id, @w_contract_nbr, null, null, 'RENEWAL CANCELLED',  @w_username  
  
   END  
   FETCH NEXT FROM curLost INTO @w_contract_nbr, @w_account_id, @w_username  
   ,@account_number, @date_submit, @utility_id -- ADD Ticket 18316  
  END  
  
  CLOSE curLost   
  DEALLOCATE curLost   
 END  
   
END  