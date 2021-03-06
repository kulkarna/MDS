
USE [Integration]
GO
/****** Object:  StoredProcedure [dbo].[usp_IgnoreBockedEDITransactions]    Script Date: 6/29/2015 3:14:38 PM ******/

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_IgnoreBockedEDITransactions')
   DROP PROCEDURE [dbo].[usp_IgnoreBockedEDITransactions] 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================================================
-- Author: Bhavana Bakshi
-- Create date: 06/29/2015
-- Description: PBI 78169: To Ignore transactions based on mapping rules provided by business
--				Please note that this is clean up script only and not been used by any process/job.
-- ===============================================================================================
CREATE PROCEDURE [dbo].[usp_IgnoreBockedEDITransactions] 
(       
        @blockedTransCount INT = 1, --number of blocked transcation for an account to be ignored
        @fromDate          DATETIME = NULL,-- transaction date for ignoring the transcations from. 
        @toDate            DATETIME = NULL, -- transaction date for ignoring the transcations to
        @skipReason        VARCHAR(100)-- reason to skip the transaction
)
AS
BEGIN

-- cleanup for testing
 --IF OBJECT_ID('tempdb..#tempediignore') IS NOT NULL
	--DROP TABLE #tempediignore

 --IF OBJECT_ID('tempdb..#tempediblocked') IS NOT NULL
	--DROP TABLE #tempediblocked


 --STEP 1: Get list of blocked transactions
       SELECT  DISTINCT
                t.accountid, 
			   t.account_number, 
			   t.edi_814_transaction_id,             
               t.transaction_date, 
               t.action_code,  
               lp.lp_transaction_id ,       
               c.[status],
			   c.substatus
	    INTO   #tempediblocked 
		FROM   integration.dbo.edi_814_transaction t (nolock) 
               LEFT JOIN integration.dbo.edi_814_transaction_result tr (nolock) 
                      ON t.edi_814_transaction_id = tr.edi_814_transaction_id 
               LEFT JOIN integration..lp_transaction lp (nolock)
                      ON tr.lp_transaction_id = lp.lp_transaction_id 
               LEFT JOIN libertypower..account a (nolock) 
                      ON t.account_number = a.accountnumber and 
					  t.utility_id = a.UtilityID
			   LEFT JOIN libertypower..accountcontract b (nolock) 
                     ON a.accountid = b.accountid 
                       AND a.currentcontractid = b.contractid -- current contract only 
               LEFT JOIN libertypower..accountstatus c (nolock) 
                     ON b.accountcontractid = c.accountcontractid 
               LEFT JOIN libertypower..utility u (nolock) 
                     ON u.id = t.utility_id 	
               LEFT JOIN libertypower..market m (nolock) 
                     ON m.id = t.market_id       
        WHERE   t.direction = 1 --Inbound only
				and action_code <> 'C'
				and tr.skip_reason is null--Not been ignored through UI
				and (tr.date_processed is null or tr.error_msg is not null)-- not processed or processed with error messaged
				
 ORDER  BY t.account_number, 
          t.transaction_date DESC, 
          t.edi_814_transaction_id DESC 


--STEP 2 Get the count of blocked transactions for each transaction's account 
SELECT DISTINCT  *,
       (SELECT Count(DISTINCT t.edi_814_transaction_id) 
        FROM   #tempediblocked t 
        WHERE  t.account_number = t1.account_number) blocked_Trans 
INTO   #tempediignore 
FROM   #tempediblocked t1 


--STEP 3: Ignore the blocked transaction as per the current business rules

INSERT INTO edi_814_transaction_result 
            (edi_814_transaction_id, 
             date_created, 
			 date_last_mod,
			-- lp_transaction_id,
             skip_reason) 
SELECT t.edi_814_transaction_id,        
       Getdate(), 
	   GETDATE(),
	--   t.lp_transaction_id,
       @skipReason
FROM   #tempediignore t 
       INNER JOIN integration..[LPIgnoreEDITransactionRule] i 
               ON t.[status] = i.[Status] 
                  AND t.substatus = i.[SubStatus] 
                  AND t.lp_transaction_id = i.LPTransactionID
WHERE  t.blocked_trans <= @blockedTransCount 
       AND ( i.[TransactionFromDate] = @fromDate 
              OR @fromDate IS NULL ) 
       AND ( i.[TransactionToDate] = @toDate 
              OR @todate IS NULL ) 

-- STEP 4: return records effected for verification/report
SELECT * 
FROM   Integration..edi_814_transaction_result  
where  skip_reason = @skipReason and        
       CONVERT(VARCHAR(10), date_Created, 101)  = CONVERT(VARCHAR(10), GETDATE(), 101) 



-- STEP 5: Final cleanup
 IF OBJECT_ID('tempdb..#tempediignore') IS NOT NULL
	DROP TABLE #tempediignore

 IF OBJECT_ID('tempdb..#tempediblocked') IS NOT NULL
	DROP TABLE #tempediblocked



END










