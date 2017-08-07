use lp_account
GO          
-- =========================================================================        
-- Sofia Melo        
-- Modified: 1/5/2011         
-- Added a condition to select renewal data:          
-- if renewal contract_eff_start_date is < getdate()        
-- =========================================================================        
-- Isabelle Tamanini        
-- Modified: 5/10/2011         
-- Added service_rate_class to select clause        
-- MD056        
-- =========================================================================        
-- Isabelle Tamanini        
-- Modified: 6/29/2011         
-- Changed join with account_additional_info to a left join        
-- SD23993        
-- =========================================================================        
-- Isabelle Tamanini        
-- Modified: 3/1/2012    
-- Added case when to account type to return residential instead of res.    
-- On the legacy proc, this was pointing to table account, account_type field,    
-- and there's no record with account type as RES in this table, only RESIDENTIAL    
-- SR1-10130746        
-- =============================================    
-- Modify  : Jose Munoz    
-- Date   : 03/01/2012    
-- Ticket  : 1-9689023     
-- Description : Show Account in renewal using the new structure    
-- =============================================    
-- Isabelle Tamanini        
-- Modified: 3/12/2012    
-- Added distinct to the second insert for the #Contract table when filtering    
-- by contract number to avoid duplicated records.    
-- SR1-10751951     
-- =============================================    
-- Rafael Vasconcelos      
-- Modified: 3/23/2012    
-- Added @p_exclude_inactive parameter    
-- 1-9467063    
-- =============================================    
-- Isabelle Tamanini    
-- Modified: 4/4/2012    
-- Changed where clause: SendAfterDate should be <= to current date and function     
-- [Libertypower].[dbo].ufn_GetLegacyAccountStatus(AST.[Status], AST.SubStatus)     
-- and [Libertypower].[dbo].ufn_GetLegacyAccountSubStatus(AST.[Status], AST.SubStatus)     
-- were used to retrieve the correct status for add on accounts    
-- SR1-12457198    
-- =============================================    
-- Jaime Forero  
-- Modified: 6/19/2012  
-- MD084 moved the legacy address, name, and contact tablet to liberty power  
-- had to change reference to the JOIN "h"(account_name) so that it uses the new tables  
-- SD23993  
-- =========================================================================  
-- Eric Hernandez    
-- Modified: 7/16/2012    
-- SD21525    
-- Removed Texas from the output when requesting list of reenrollments.    
-- =============================================    
-- Lev Rosenblum  
-- Modified: 9/19/2012  
-- PBI1040  
-- change in inner join of final statement from LibertyPower..AccountContractRate to LibertyPower..vw_AccountContractRateForEnrollment to accomodate maltiterm productType  
-- =============================================  
-- Lev Rosenblum  
-- Modified: 10/04/2012  
-- PBI0999  
-- The aggrigative field values have been added for multi-term product type  
-- =============================================  
-- Isabelle Tamanini    
-- Modified: 12/31/2012    
-- Changed proc so that Price is null, ProductBrand will still return based on common_product table   
-- 1-46439861   
-- =============================================    
-- 1/31/2012 - Rick Deigsler  
-- Modified to pull most recent annual usage  
-- SR 1-58076132 - Was not returning record if account usage date did not match contract date  
-- =============================================    
-- 11/11/2013 - José Muñoz - SWCS  
-- TFS: 25871 : Add SET ARITHABORT ON     
-- Improve response time and reduce IO/CPU of one of the most called procedures   
-- which will result in overall experience improvement.  
-- =============================================    
-- 1/28/2014 - Diogo Lima
-- TFS 30486: Fixing issue for Multi-Tems accounts that have different terms with the same RateStart
-- =============================================
        
--577411834600001 CONED                  
/*    
    
    
exec lp_account..[usp_account_sel_list] @p_username=N'LIBERTYPOWER\atafur'    
,@p_view=N'BY CONTRACT EFF START DATE'    
,@p_rec_sel=N'50',@p_contract_nbr_filter=N'2743937',@p_account_id_filter=N'NONE',@p_account_number_filter=N'NONE',    
@p_full_name_filter=N'',@p_status_filter=N'NONE',@p_sub_status_filter=N'NONE',@p_utility_id_filter=N'ALL',    
@p_entity_id_filter=N'ALL',@p_retail_mkt_id_filter=N'ALL',@p_account_type_filter=N'NONE',@p_sales_channel_role_filter=N'NONE',    
@p_ready_to_send_status_only=N'0',@p_enrollment_type=NULL    
    
*/    
        
CREATE PROCEDURE [dbo].[usp_account_sel_list_SubmissionQueue]        
(@p_username                                        NCHAR(100) ,        
 @p_view                                            VARCHAR(35) = 'ALL',        
 @p_rec_sel                                         INT = 50,        
 @p_account_id_filter                               CHAR(12) = 'ALL',        
 @p_account_number_filter                           VARCHAR(30) = 'ALL',        
 @p_legacy_account_filter                           VARCHAR(30) = 'ALL', -- INF83        
 @p_contract_nbr_filter                             CHAR(12)= 'ALL',        
 @p_full_name_filter                                VARCHAR(30)= 'ALL',        
 @p_status_filter                                   VARCHAR(15)= 'ALL',        
 @p_sub_status_filter                               VARCHAR(15)= 'ALL',        
 @p_utility_id_filter                               VARCHAR(15)= 'ALL',                                              
 @p_entity_id_filter                                VARCHAR(15)= 'ALL',        
 @p_retail_mkt_id_filter                            VARCHAR(04)= 'ALL',        
 @p_account_type_filter                             VARCHAR(35)= 'ALL',        
 @p_customer_id_filter        VARCHAR(35)= 'ALL',        
 @p_sales_channel_role_filter                       VARCHAR(50)= 'ALL',        
 @p_ready_to_send_status_only                       SMALLINT = 0,        
 @p_usage_request_status       VARCHAR(20) = '',        
 @p_enrollment_type         VARCHAR(20) = null,        
 @p_reenroll_and_resendstatus_flag     BIT = 0,        
 @p_include_scrapable_utilities      VARCHAR(3) = 'YES',        
 @p_billing_account_filter       VARCHAR(50) = 'ALL',    
 @p_exclude_inactive        BIT = 0        
)        
AS     
BEGIN  
 SET ARITHABORT ON     
 SET NOCOUNT ON  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
        
  /* Debugging code        
         
 DECLARE @p_username       nchar(100)        
 DECLARE @p_view                             VARCHAR(35)         
 DECLARE @p_rec_sel                          int        
 DECLARE @p_account_id_filter                char(12)         
 DECLARE @p_account_number_filter            VARCHAR(30)         
 DECLARE @p_legacy_account_filter            VARCHAR(30)  -- INF83        
 DECLARE @p_contract_nbr_filter              char(12)        
 DECLARE @p_full_name_filter                 VARCHAR(30)        
 DECLARE @p_status_filter                    VARCHAR(15)        
 DECLARE @p_sub_status_filter                VARCHAR(15)        
 DECLARE @p_utility_id_filter                VARCHAR(15)                                              
 DECLARE @p_entity_id_filter                 VARCHAR(15)        
 DECLARE @p_retail_mkt_id_filter             VARCHAR(04)        
 DECLARE @p_account_type_filter              VARCHAR(35)        
 DECLARE @p_customer_id_filter    VARCHAR(35)        
 DECLARE @p_sales_channel_role_filter        VARCHAR(50)        
 DECLARE @p_ready_to_send_status_only        SMALLINT         
 DECLARE @p_usage_request_status    VARCHAR(20)        
 DECLARE @p_enrollment_type     VARCHAR(20)        
 DECLARE @p_reenroll_and_resendstatus_flag BIT        
 DECLARE @p_include_scrapable_utilities  VARCHAR(3)        
 DECLARE @p_billing_account_filter   VARCHAR(50)         
         
 SET @p_username       = 'libertypower\e3hernandez'        
 SET @p_view                             = 'ALL'        
 SET @p_rec_sel                          = 0        
 SET @p_account_id_filter                = 'ALL'        
 SET @p_account_number_filter            = 'ALL'        
 SET @p_legacy_account_filter            = 'ALL' -- INF83        
 SET @p_contract_nbr_filter              = 'ALL'        
 SET @p_full_name_filter                 = 'ALL'        
 SET @p_status_filter                    = 'ALL'        
 SET @p_sub_status_filter                = 'ALL'        
 SET @p_utility_id_filter                = 'CONED'                   
 SET @p_entity_id_filter                 = 'ALL'        
 SET @p_retail_mkt_id_filter             = 'ALL'        
 SET @p_account_type_filter              = 'ALL'        
 SET @p_customer_id_filter    = 'ALL'        
 SET @p_sales_channel_role_filter        = 'ALL'        
 SET @p_ready_to_send_status_only        = 0        
 SET @p_usage_request_status    = ''        
 SET @p_enrollment_type     = null        
 SET @p_reenroll_and_resendstatus_flag = 0        
 SET @p_include_scrapable_utilities  = 'YES'        
 SET @p_billing_account_filter   = 'ALL'        
 */    
 DECLARE @Debug INT    
 SET @Debug = 0    
     
         
 -- You can remove the block below once usage_request.aspx is properly passing in this parameter.    
 IF @p_usage_request_status = 'PENDING'    
  SET @p_exclude_inactive = 1    
         
 --Enrollment Submission Standard queue was getting Move-in also. 'null, 0, 1' parameter moved to '1'    
 DECLARE @w_enrollment_type INT    
 IF @p_enrollment_type IN ('NONE','','ALL')        
  SET @w_enrollment_type = NULL        
 IF @p_enrollment_type IN ('0','null, 0, 1')        
  SET @w_enrollment_type = 1    
 IF @p_enrollment_type IN ('3,4')        
  SET @w_enrollment_type = 3    
 IF @p_enrollment_type IN ('5')        
  SET @w_enrollment_type = 5    
      
 IF @p_account_number_filter IN ('NONE','','ALL')    
  SET @p_account_number_filter = NULL    
 IF @p_contract_nbr_filter IN ('NONE','','ALL')    
  SET @p_contract_nbr_filter = NULL    
 IF @p_account_id_filter IN ('NONE','','ALL')    
  SET @p_account_id_filter = NULL    
 IF @p_entity_id_filter IN ('NONE','','ALL')    
  SET @p_entity_id_filter = NULL    
 IF @p_customer_id_filter IN ('NONE','','ALL')    
  SET @p_customer_id_filter = NULL    
 IF @p_full_name_filter IN ('NONE','','ALL')    
  SET @p_full_name_filter = NULL    
 IF @p_status_filter IN ('NONE','','ALL')    
  SET @p_status_filter = NULL    
 IF @p_sub_status_filter IN ('NONE','','ALL')    
  SET @p_sub_status_filter = NULL    
 IF @p_sub_status_filter IN ('NONE','','ALL')    
  SET @p_sub_status_filter = NULL    
 IF @p_utility_id_filter IN ('NONE','','ALL')    
  SET @p_utility_id_filter = NULL    
 IF @p_retail_mkt_id_filter IN ('NONE','','ALL')    
  SET @p_retail_mkt_id_filter = NULL    
 IF @p_usage_request_status IN ('NONE','','ALL')    
  SET @p_usage_request_status = NULL    
 IF @p_billing_account_filter IN ('NONE','','ALL')    
  SET @p_billing_account_filter = NULL    
     
 SET @p_sales_channel_role_filter = REPLACE(@p_sales_channel_role_filter,'SALES CHANNEL/','')    
 IF @p_sales_channel_role_filter IN ('NONE','','ALL')    
  SET @p_sales_channel_role_filter = NULL    
      
     
 CREATE TABLE #Contract(      
  [Number] [varchar](50) NOT NULL,      
  [SalesRep] [varchar](64) NULL,      
  [Contractid] [int] NOT NULL,      
  [SignedDate] [datetime] NOT NULL,      
  [SubmitDate] [datetime] NOT NULL,      
  [ContractTypeID] [int] NOT NULL,      
  [ContractTemplateID] [int] NOT NULL,      
  [StartDate] [datetime] NOT NULL,      
  [SalesChannelID] [int] NOT NULL,      
  [CreatedBy] [int] NOT NULL,      
  [SalesManagerID] [int] NULL,      
  [ContractDealTypeID] [int] NOT NULL      
 )       
        
 --CREATE TABLE #Customer(      
 -- [CustomerID] [int] NOT NULL    
 --)    
     
 CREATE TABLE #Account(      
  [AccountID] [int] NOT NULL,      
  [AccountIdLegacy] [char](12) NULL,      
  [AccountNumber] [varchar](30) NULL,      
  [CustomerIdLegacy] [varchar](10) NULL,      
  [DateCreated] [datetime] NOT NULL,      
  [origin] [varchar](50) NULL,      
  [PorOption] [bit] NULL,      
  [ServiceRateClass] [varchar](50) NULL,      
  [ContractID] [int] NULL,      
  --[CurrentContractID] [int] NULL,      
  --[CurrentRenewalContractID] [int] NULL,      
  [AccountTypeID] [int] NULL,      
  [RetailMktID] [int] NULL,      
  [EntityID] [char](15) NULL,      
  [UtilityID] [int] NULL,      
  [CustomerID] [int] NULL,      
  [BillingTypeID] [int] NULL,      
  [TaxStatusID] [int] NULL      
 ) ON [PRIMARY]      
       
     
 SELECT U.ID    
 INTO #UtilityIDs    
 FROM LibertyPower.dbo.Utility U  WITH (NOLOCK)  
 JOIN LibertyPower.dbo.Market M WITH (NOLOCK) ON U.MarketID = M.ID    
 WHERE 1=1    
 AND (@p_utility_id_filter IS NULL OR UtilityCode = @p_utility_id_filter)    
 AND (@p_retail_mkt_id_filter IS NULL OR M.MarketCode   = @p_retail_mkt_id_filter)        
 --AND U.InactiveInd = 0  -- Removed Active filter because some accounts are still linked to inactive records.    
 --AND M.InactiveInd = 0  -- Removed Active filter because some accounts are still linked to inactive records.    
 AND (@p_include_scrapable_utilities <> 'NO' OR U.UtilityCode NOT IN ('PEPCO-DC','AMEREN','COMED','BGE','PEPCO-MD','CONED','NIMO','NYSEG','RGE','AEPCE','AEPNO','CTPEN','SHARYLAND','TXNMP','TXU','TXU-SESCO'))    
 AND (@p_reenroll_and_resendstatus_flag <> 1 OR M.ID <> 1) -- We do not send Texas accounts through Reenrollment. SD21525    
     
     
 IF @Debug = 1    
  select 'utility', count(*) from #UtilityIDs    
     
 DECLARE @AccountTypeID INT    
 SELECT @AccountTypeID = ID    
 FROM LibertyPower..AccountType  WITH (NOLOCK)  
 WHERE AccountType = @p_account_type_filter    
     
 DECLARE @converted_legacy_account_number VARCHAR(30)    
 IF @p_legacy_account_filter NOT IN ('NONE','','ALL')    
 BEGIN    
  SELECT @converted_legacy_account_number = new_account_number    
  FROM lp_account..account_number_history (NOLOCK)    
  WHERE old_account_number = @p_legacy_account_filter    
 END    
     
 DECLARE @SalesChannelID INT    
 SELECT  @SalesChannelID = ChannelID    
 FROM LibertyPower..SalesChannel (NOLOCK)  
 WHERE ChannelName = @p_sales_channel_role_filter    
     
     
     
     
 CREATE TABLE #AccountFilter( AccountID INT NOT NULL )    
 CREATE TABLE #AccountFilterTemp( AccountID INT NOT NULL )    
 DECLARE @FilterInUse INT    
 SET @FilterInUse = 0    
     
 IF (@p_full_name_filter IS NOT NULL)    
 BEGIN    
  SELECT A.AccountID    
  INTO #AccountID_name_filter    
  FROM LibertyPower.dbo.Customer CUST (NOLOCK)    
  JOIN LibertyPower.dbo.Name N (NOLOCK) ON N.NameID = CUST.NameID    
  JOIN LibertyPower.dbo.Account A (NOLOCK) ON A.CustomerID = CUST.CustomerID    
  WHERE N.name like '' + @p_full_name_filter+ '%'    
     
  -- Add to ongoing Account filter.    
  -- Start by transferring the current filter out to a temp table.    
  TRUNCATE TABLE #AccountFilterTemp    
  INSERT INTO #AccountFilterTemp SELECT AccountID FROM #AccountFilter    
  TRUNCATE TABLE #AccountFilter    
     
  INSERT INTO #AccountFilter    
  SELECT f1.AccountID    
  FROM #AccountID_name_filter f1    
  LEFT JOIN #AccountFilterTemp f2 ON f1.AccountID = f2.AccountID    
  WHERE @FilterInUse = 0 OR f2.AccountID IS NOT NULL    
     
  SET @FilterInUse = 1    
 END    
     
  
 /** LUCA Fix Step 2  
  
 SELECT AC.AccountID    
 INTO #AccountID_contract_number_filter    
 FROM LibertyPower.dbo.Contract C (NOLOCK)    
 JOIN LibertyPower.dbo.AccountContract AC (NOLOCK) ON C.ContractID = AC.ContractID    
 where 0=1   
  
 --- code below substitutes existing code  
 IF (@p_contract_nbr_filter IS NOT NULL)    
 BEGIN    
  INSERT into #AccountID_contract_number_filter  
  SELECT AC.AccountID    
  FROM LibertyPower.dbo.Contract C (NOLOCK)    
  
 */  
  
 IF (@p_contract_nbr_filter IS NOT NULL)    
 BEGIN    
  SELECT AC.AccountID    
  into #AccountID_contract_number_filter  
  FROM LibertyPower.dbo.Contract C (NOLOCK)    
  JOIN LibertyPower.dbo.AccountContract AC (NOLOCK) ON C.ContractID = AC.ContractID    
  WHERE Number = @p_contract_nbr_filter    
     
  -- Add to ongoing Account filter.    
  -- Start by transferring the current filter out to a temp table.    
  TRUNCATE TABLE #AccountFilterTemp    
  INSERT INTO #AccountFilterTemp SELECT AccountID FROM #AccountFilter    
  TRUNCATE TABLE #AccountFilter    
     
  INSERT INTO #AccountFilter    
  SELECT f1.AccountID    
  FROM #AccountID_contract_number_filter f1    
  LEFT JOIN #AccountFilterTemp f2 ON f1.AccountID = f2.AccountID    
  WHERE @FilterInUse = 0 OR f2.AccountID IS NOT NULL    
     
  SET @FilterInUse = 1    
 END    
     
     
     
 IF (@SalesChannelID IS NOT NULL)    
 BEGIN    
  -- Add to ongoing Account filter.    
  -- Start by transferring the current filter out to a temp table.    
  TRUNCATE TABLE #AccountFilterTemp    
  INSERT INTO #AccountFilterTemp SELECT AccountID FROM #AccountFilter    
  TRUNCATE TABLE #AccountFilter    
     
  INSERT INTO #AccountFilter    
  SELECT A.AccountID    
  FROM LibertyPower.dbo.Contract C (NOLOCK)    
  JOIN LibertyPower.dbo.Account A (NOLOCK) ON C.ContractID = A.CurrentContractID    
  LEFT JOIN #AccountFilterTemp f ON A.AccountID = f.AccountID    
  WHERE SalesChannelID = @SalesChannelID    
  AND (@FilterInUse = 0 OR A.AccountID IS NOT NULL)    
     
  SET @FilterInUse = 1    
 END    
     
 --select * from #AccountFilter    
 --where AccountID = 82589    
     
     
 IF @p_exclude_inactive = 1     
 OR @p_status_filter IS NOT NULL OR @p_sub_status_filter IS NOT NULL     
 OR @p_reenroll_and_resendstatus_flag = 1    
 OR @p_ready_to_send_status_only = 1    
 BEGIN    
  
  SELECT AC.AccountID, AC.ContractID    
  INTO #AccountID_status_filter    
  FROM LibertyPower..AccountStatus AST  WITH (NOLOCK, index=accountStatus_cover1)    -- LUCA FIX STEP 1  
  JOIN LibertyPower..AccountContract AC (NOLOCK) ON AC.AccountContractID = AST.AccountContractID    
  WHERE 1=1    
  AND (@p_exclude_inactive = 0 OR [Status] IN ('999999','999998','911000'))    
  AND (@p_status_filter IS NULL OR [Status] = @p_status_filter)    
  AND (@p_sub_status_filter IS NULL OR [SubStatus] = @p_sub_status_filter)    
  AND (@p_reenroll_and_resendstatus_flag = 0    
  OR (    
   (Status = '13000' AND SubStatus = '60')     
   OR    
   (Status IN ('05000','06000') AND SubStatus = '27')    
  )    
   )    
  AND (@p_reenroll_and_resendstatus_flag = 0    
  OR SendEnrollmentDate < getdate()    
   )    
  AND (@p_ready_to_send_status_only = 0     
  OR ([Status] IN ('05000','06000','07000') AND SubStatus = '10')    
   )    
  AND (@p_ready_to_send_status_only = 0    
  OR SendEnrollmentDate < getdate()    
   )    
  
    
  
 -- LUCA FIX STEP 1  
  If @@rowcount > 1000  
   begin  
    Create Clustered index idx1 on #AccountID_status_filter (AccountID, ContractID)  with (fillfactor = 100) -- LUCA FIX STEP 1  
   end  
       
     
  -- This is to ensure we're only looking at status for relevant contracts.  Not historical ones.    
  SELECT DISTINCT A.AccountID    
   , ContractID = CASE WHEN @p_view = 'BY PENDING RENEWALS' THEN A.CurrentRenewalContractID ELSE A.CurrentContractID END    
  INTO #Current    
  FROM LibertyPower..Account A (NOLOCK)     
  JOIN #AccountID_status_filter f1 ON A.AccountID = f1.AccountID    
    
 -- LUCA FIX STEP 1  
  If @@rowcount > 1000   
   begin  
    Create Clustered index idx1 on #Current (AccountID, ContractID)  with (fillfactor = 100) -- LUCA FIX STEP 1  
   end  
  
  
     
  -- Add to ongoing Account filter.    
  -- Start by transferring the current filter out to a temp table.    
  TRUNCATE TABLE #AccountFilterTemp    
  INSERT INTO #AccountFilterTemp SELECT AccountID FROM #AccountFilter    
  TRUNCATE TABLE #AccountFilter    
     
  
  INSERT INTO #AccountFilter    
  SELECT f1.AccountID    
  FROM #AccountID_status_filter f1    
  JOIN #Current C ON f1.AccountID = C.AccountID AND f1.ContractID = C.ContractID -- This is to ensure we're only looking at status for relevant contracts.  Not historical ones.    
  LEFT JOIN #AccountFilterTemp f2 ON f1.AccountID = f2.AccountID    
  WHERE @FilterInUse = 0 OR f2.AccountID IS NOT NULL    
     
  SET @FilterInUse = 1    
    
 END    
     
     
 IF @p_billing_account_filter IS NOT NULL    
 BEGIN    
  -- Add to ongoing Account filter.    
  -- Start by transferring the current filter out to a temp table.    
  TRUNCATE TABLE #AccountFilterTemp    
  INSERT INTO #AccountFilterTemp SELECT AccountID FROM #AccountFilter    
  TRUNCATE TABLE #AccountFilter    
     
  INSERT INTO #AccountFilter    
  SELECT A.AccountID    
  FROM lp_account..account_info AI (NOLOCK)    
  JOIN LibertyPower..Account A (NOLOCK) ON AI.account_id = A.AccountIDLegacy    
  LEFT JOIN #AccountFilterTemp f ON A.AccountID = f.AccountID    
  WHERE AI.BillingAccount = @p_billing_account_filter    
  AND (@FilterInUse = 0 OR f.AccountID IS NOT NULL)    
     
  SET @FilterInUse = 1    
 END    
     
     
     
 IF (@p_usage_request_status IS NOT NULL)    
 BEGIN    
  SELECT U.AccountID    
  INTO #AccountID_account_usage_filter    
  FROM LibertyPower..AccountUsage U (NOLOCK)    
  JOIN LibertyPower..UsageReqStatus S (NOLOCK) ON S.UsageReqStatusID = S.UsageReqStatusID    
  WHERE S.Status = @p_usage_request_status    
     
  -- Add to ongoing Account filter.    
  -- Start by transferring the current filter out to a temp table.    
  TRUNCATE TABLE #AccountFilterTemp    
  INSERT INTO #AccountFilterTemp SELECT AccountID FROM #AccountFilter    
  TRUNCATE TABLE #AccountFilter    
     
  INSERT INTO #AccountFilter    
  SELECT f1.AccountID    
  FROM #AccountID_account_usage_filter f1    
  LEFT JOIN #AccountFilterTemp f2 ON f1.AccountID = f2.AccountID    
  WHERE @FilterInUse = 0 OR f2.AccountID IS NOT NULL    
     
  SET @FilterInUse = 1    
 END    
     
     
 IF (@w_enrollment_type IS NOT NULL)    
 BEGIN    
  -- Add to ongoing Account filter.    
  -- Start by transferring the current filter out to a temp table.    
  TRUNCATE TABLE #AccountFilterTemp    
  INSERT INTO #AccountFilterTemp SELECT AccountID FROM #AccountFilter    
  TRUNCATE TABLE #AccountFilter    
     
  INSERT INTO #AccountFilter    
  SELECT D.AccountID    
  FROM LibertyPower..AccountDetail D (NOLOCK)    
  LEFT JOIN #AccountFilterTemp f ON D.AccountID = f.AccountID    
  WHERE (@FilterInUse = 0 OR f.AccountID IS NOT NULL)    
  AND (EnrollmentTypeID = @w_enrollment_type    
   OR (@w_enrollment_type = 1 AND EnrollmentTypeID IS NULL)  
   )  
     
  SET @FilterInUse = 1    
 END    
  
     
     
 IF (@p_account_number_filter IS NOT NULL)    
 BEGIN    
  -- Add to ongoing Account filter.    
  -- Start by transferring the current filter out to a temp table.    
  TRUNCATE TABLE #AccountFilterTemp    
  INSERT INTO #AccountFilterTemp SELECT AccountID FROM #AccountFilter    
  TRUNCATE TABLE #AccountFilter    
     
  INSERT INTO #AccountFilter    
  SELECT A.AccountID    
  FROM LibertyPower..Account A (NOLOCK)    
  LEFT JOIN #AccountFilterTemp f ON A.AccountID = f.AccountID    
  WHERE (@FilterInUse = 0 OR f.AccountID IS NOT NULL)    
  AND AccountNumber = @p_account_number_filter    
     
  SET @FilterInUse = 1    
 END    
     
     
 IF @p_reenroll_and_resendstatus_flag = 1    
 BEGIN    
  -- Add to ongoing Account filter.    
  -- Start by transferring the current filter out to a temp table.    
  TRUNCATE TABLE #AccountFilterTemp    
  INSERT INTO #AccountFilterTemp SELECT AccountID FROM #AccountFilter    
  TRUNCATE TABLE #AccountFilter    
     
  INSERT INTO #AccountFilter    
  SELECT f.AccountID    
  FROM LibertyPower..AccountLatestService ALS (NOLOCK)    
  LEFT JOIN #AccountFilterTemp f ON ALS.AccountID = f.AccountID    
  WHERE (EndDate IS NULL OR EndDate < getdate())    
  AND f.AccountID IS NOT NULL    
  AND (@FilterInUse = 0 OR f.AccountID IS NOT NULL)    
     
  SET @FilterInUse = 1    
 END    
     
 --select * from #AccountFilter    
 --where AccountID = 82589    
     
     
 /*    
 -- Compile a list of IDs using the filter if there is a filter in use.    
 SELECT A.AccountID, A.CustomerID, A.AccountIDLegacy    
  , ContractID = CASE WHEN @p_view = 'BY PENDING RENEWALS' THEN A.CurrentRenewalContractID ELSE A.CurrentContractID END    
 INTO #IDs    
 FROM LibertyPower.dbo.Account A(NOLOCK)    
 JOIN #UtilityIDs U ON A.UtilityID = U.ID    
 LEFT JOIN #AccountFilter F ON A.AccountID = F.AccountID    
 WHERE 1=1    
 AND (@FilterInUse = 0 OR F.AccountID IS NOT NULL)    
 AND (A.CurrentContractID IS NOT NULL OR A.CurrentRenewalContractID IS NOT NULL)         
 AND (@p_account_id_filter IS NULL OR A.AccountIdLegacy = @p_account_id_filter)        
 AND (@p_account_number_filter IS NULL OR A.AccountNumber  = @p_account_number_filter)        
 AND (@converted_legacy_account_number IS NULL OR A.AccountNumber  = @converted_legacy_account_number)        
 AND (@p_entity_id_filter IS NULL OR A.EntityID   = @p_entity_id_filter)        
 AND (@AccountTypeID IS NULL OR A.AccountTypeID = @AccountTypeID)    
 */    
 --select count(*) from #IDs    
     
     
 ---- Now we should have a small set of IDs to grab.  Create small table from those IDs.    
 --select COUNT(1) from #AccountFilter  
  
 create clustered index idx1 on #AccountFilter (AccountID) with (fillfactor = 100)  -- LUCA FIX STEP 1  
 create clustered index idx1 on #UtilityIDs (ID) with (fillfactor = 100)    -- LUCA FIX STEP 1  
  
  
 /**   LUCA FIX STEP 2  
  
 If (select count(1) from #AccountID_contract_number_filter) > 0  
  begin  
   INSERT INTO #Account        
   SELECT DISTINCT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy    
   , A.DateCreated    
   , A.origin, A.PorOption, A.ServiceRateClass    
   , ContractID = CASE WHEN @p_view = 'BY PENDING RENEWALS' THEN A.CurrentRenewalContractID ELSE A.CurrentContractID END    
   , A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID    
   , A.CustomerID, A.BillingTypeID, A.TaxStatusID        
   FROM LibertyPower..Account A (NOLOCK)        
   JOIN #UtilityIDs U ON A.UtilityID = U.ID    
   JOIN #AccountID_contract_number_filter cnf (nolock) on cnf.AccountID = A.AccountID  
   LEFT JOIN #AccountFilter F ON A.AccountID = F.AccountID    
   WHERE 1=1    
   AND (@FilterInUse = 0 OR F.AccountID IS NOT NULL)    
   AND (A.CurrentContractID IS NOT NULL OR A.CurrentRenewalContractID IS NOT NULL)         
   AND (@p_account_id_filter IS NULL OR A.AccountIdLegacy = @p_account_id_filter)        
   AND (@p_account_number_filter IS NULL OR A.AccountNumber  = @p_account_number_filter)        
   AND (@converted_legacy_account_number IS NULL OR A.AccountNumber  = @converted_legacy_account_number)        
   AND (@p_entity_id_filter IS NULL OR A.EntityID   = @p_entity_id_filter)        
   AND (@AccountTypeID IS NULL OR A.AccountTypeID = @AccountTypeID)    
  end  
  else  
  begin  
 */  
 /*  This has been substituted by code immedialtely following it  
  
   INSERT INTO #Account        
   SELECT DISTINCT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy    
   , A.DateCreated    
   , A.origin, A.PorOption, A.ServiceRateClass    
   , ContractID = CASE WHEN @p_view = 'BY PENDING RENEWALS' THEN A.CurrentRenewalContractID ELSE A.CurrentContractID END    
   , A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID    
   , A.CustomerID, A.BillingTypeID, A.TaxStatusID        
   FROM LibertyPower..Account A (NOLOCK)        
   JOIN #UtilityIDs U ON A.UtilityID = U.ID    
   LEFT JOIN #AccountFilter F ON A.AccountID = F.AccountID    
   WHERE 1=1    
   AND (@FilterInUse = 0 OR F.AccountID IS NOT NULL)    
   AND (A.CurrentContractID IS NOT NULL OR A.CurrentRenewalContractID IS NOT NULL)         
   AND (@p_account_id_filter IS NULL OR A.AccountIdLegacy = @p_account_id_filter)        
   AND (@p_account_number_filter IS NULL OR A.AccountNumber  = @p_account_number_filter)        
   AND (@converted_legacy_account_number IS NULL OR A.AccountNumber  = @converted_legacy_account_number)        
   AND (@p_entity_id_filter IS NULL OR A.EntityID   = @p_entity_id_filter)        
   AND (@AccountTypeID IS NULL OR A.AccountTypeID = @AccountTypeID)    
  --end -- LUCA FIX STEP 2  
 */  
  
 -- LUCA FIX STEP 1 B  
 /*  
 */  
  
  CREATE TABLE #Account_left_to_process (AccountID int PRIMARY KEY)  
  
  IF @FilterInUse = 0  
     INSERT INTO #Account_left_to_process  
     SELECT DISTINCT A.AccountID  
     FROM LibertyPower..Account A (NOLOCK)        
     ORDER BY AccountID  
     OPTION (KEEP PLAN)  
  
  IF @FilterInUse = 1  
     INSERT INTO #Account_left_to_process  
     SELECT DISTINCT A.AccountID  
     FROM LibertyPower..Account A (NOLOCK)        
     JOIN #AccountFilter F ON A.AccountID = F.AccountID    
     ORDER BY AccountID  
     OPTION (KEEP PLAN)  
  
  
  
  
  
 -- By joining these tables, we will limit the amount of rows we have to fetch for the final output.    
 SET ROWCOUNT @p_rec_sel    
  
  INSERT INTO #Account        
  SELECT DISTINCT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy    
  , A.DateCreated    
  , A.origin, A.PorOption, A.ServiceRateClass    
  , ContractID = CASE WHEN @p_view = 'BY PENDING RENEWALS' THEN A.CurrentRenewalContractID ELSE A.CurrentContractID END    
  , A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID    
  , A.CustomerID, A.BillingTypeID, A.TaxStatusID        
  FROM LibertyPower..Account A (NOLOCK)        
  JOIN #Account_left_to_process F ON A.AccountID = F.AccountID    
  JOIN #UtilityIDs U ON A.UtilityID = U.ID    
  WHERE 1=1    
  AND (A.CurrentContractID IS NOT NULL OR A.CurrentRenewalContractID IS NOT NULL)         
  AND (@p_account_id_filter IS NULL OR A.AccountIdLegacy = @p_account_id_filter)        
  --AND (@p_account_number_filter IS NULL OR A.AccountNumber  = @p_account_number_filter)        
  AND (@converted_legacy_account_number IS NULL OR A.AccountNumber  = @converted_legacy_account_number)        
  AND (@p_entity_id_filter IS NULL OR A.EntityID   = @p_entity_id_filter)        
  AND (@AccountTypeID IS NULL OR A.AccountTypeID = @AccountTypeID)    
  OPTION (KEEP PLAN)  
  
  
  
  
 --Select COUNT(1) from #Account  
     
 CREATE CLUSTERED INDEX idx1 on #Account  (Accountid)      
     
 INSERT INTO #Contract      
 SELECT DISTINCT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID    
 , C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID        
 FROM LibertyPower..Contract C (NOLOCK)    
 JOIN #Account ID ON C.ContractID = ID.ContractID    
     
 SELECT DISTINCT Cust.*    
 INTO #Customer    
 FROM LibertyPower..Customer Cust (NOLOCK)    
 JOIN #Account ID ON Cust.CustomerID = ID.CustomerID    
     
     
 CREATE CLUSTERED INDEX idx2 on #Contract (Contractid)     with (fillfactor=100)  -- LUCA FIX STEP 1  
 CREATE CLUSTERED INDEX idx3 on #Customer (Customerid)    with (fillfactor=100)  -- LUCA FIX STEP 1   
  
  
 /*    
 */    
 --select * from #Account    
 --select * from #UtilityIDs    
 --select 'Account count: ', count(*) from #Account    
 --select count(*) from #Contract    
 --select count(*) from #Customer    
      
     
     
         
     
 SELECT DISTINCT    
  account_id = A.AccountIdLegacy    
 ,account_number = A.AccountNumber    
 ,account_type = CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL'     
     ELSE AT.AccountType END    
 ,status = b.status_descp    
 ,sub_status = c.sub_status_descp    
 ,customer_id = A.CustomerIdLegacy    
 ,entity_id = d.entity_descp    
 ,contract_nbr = CONT.Number    
 ,contract_type =    
   CASE WHEN UPPER(CT.[Type]) = 'VOICE'  THEN UPPER(CT.[Type]) +  CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL'  ELSE '' END        
  WHEN CTT.ContractTemplateTypeID = 2 THEN 'CORPORATE'   +  CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL'  ELSE '' END         
  WHEN UPPER(CT.[Type]) = 'PAPER'  THEN UPPER(CT.[Type]) +  CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL'  ELSE '' END        
  WHEN UPPER(CT.[Type]) = 'EDI'   THEN 'POWER MOVE'        
  ELSE UPPER(CT.[Type]) END        
          
 ,retail_mkt_id = M.RetailMktDescp      
 ,utility_id = f.FullName    
 ,product_id = '' --g.product_descp    
 ,rate_id = ACR.RateID    
 ,rate = Round(ACR.Rate,5)    
 ,names = 'Names'    
 ,address = 'Address'    
 ,contact = 'Contacs'    
 ,business_type = '' --BT.[Type]    
 ,business_activity = '' --BA.Activity    
 ,additional_id_nbr_type =     
   CASE WHEN LTRIM(RTRIM(CUST.Duns)) <> '' THEN 'DUNSNBR'         
   WHEN LTRIM(RTRIM(CUST.EmployerId)) <> '' THEN 'EMPLID'         
   WHEN LTRIM(RTRIM(CUST.TaxId)) <> '' THEN 'TAX ID'         
   ELSE CASE WHEN CUST.SsnEncrypted IS NOT NULL AND CUST.SsnEncrypted != '' THEN 'SSN'         
    ELSE 'NONE' END END    
 ,additional_id_nbr =     
   CASE WHEN LTRIM(RTRIM(CUST.Duns)) <> '' THEN CUST.Duns        
   WHEN LTRIM(RTRIM(CUST.EmployerId)) <> '' THEN CUST.EmployerId         
   WHEN LTRIM(RTRIM(CUST.TaxId)) <> '' THEN CUST.TaxId         
   ELSE CASE WHEN CUST.SsnEncrypted IS NOT NULL  AND CUST.SsnEncrypted != '' THEN '***-**-****' ELSE 'NONE' END END    
 ,annual_usage = ISNULL(USAGE.AnnualUsage, (SELECT TOP 1 ISNULL(AnnualUsage, 0) FROM LibertyPower..AccountUsage WITH (NOLOCK) WHERE AccountID = A.AccountID ORDER BY EffectiveDate DESC))   
 ,annual_usage_mw = (ISNULL(USAGE.AnnualUsage, (SELECT TOP 1 ISNULL(AnnualUsage, 0) FROM LibertyPower..AccountUsage WITH (NOLOCK) WHERE AccountID = A.AccountID ORDER BY EffectiveDate DESC)))/1000    
 ,credit_score = CAST(0 AS INT)    
 ,credit_agency = CASE WHEN CA.Name IS NULL THEN 'NONE' ELSE UPPER(CA.Name) END    
 ,term_months = ACR.Term     
 ,username = USER1.UserName    
 ,sales_channel_role = 'SALES CHANNEL/' + SC.ChannelName    
 ,sales_rep = CONT.SalesRep    
 ,contract_eff_start_date = ACR.RateStart    
 ,date_end = ACR.RateEnd    
  
 ----------------------------------------------------------------------------------  
 --MD084 PBI0999  
 , ACR.CurrentTerm  
 , ACR.CurrentRateStart   
 , ACR.CurrentRateEnd  
 , isnull(PB.ProductBrandID, g.ProductBrandID) AS ProductBrandID  
 , PB.IsMultiTerm  
 , PB.Name as ProductBrandName  
 ----------------------------------------------------------------------------------  
  
 ,date_deal = CONT.SignedDate    
 ,date_created = A.DateCreated    
 ,date_submit = CONT.SubmitDate    
 ,date_flow_start = CASE WHEN AST.[Status] in ('999998','999999','01000','03000','04000','05000') AND AST.[SubStatus] not in ('30') THEN CAST('1900-01-01 00:00:00' AS DATETIME)        
    ELSE ISNULL(ASERVICE.StartDate, CAST('1900-01-01 00:00:00' AS DATETIME)) END    
 ,date_por_enrollment = AC.SendEnrollmentDate    
 ,date_deenrollment = CASE WHEN AST.[Status] in ('999998','999999','01000','03000','04000','05000') THEN CAST('1900-01-01 00:00:00' AS DATETIME)        
    WHEN AST.[Status] in ('13000') AND AST.[SubStatus] in ('70','80') THEN CAST('1900-01-01 00:00:00' AS DATETIME)        
    ELSE ISNULL(ASERVICE.EndDate, CAST('1900-01-01 00:00:00' AS DATETIME)) END    
 ,date_reenrollment = CAST('1900-01-01 00:00:00' AS DATETIME)    
 ,UPPER(TAX.[Status])  AS tax_status    
 ,CAST(0 AS INT) AS tax_rate    
 ,rate_descp = r.rate_descp    
 ,a.origin    
 --MD084 change  
 -- h.full_name,  
 ,h.Name as full_name  
 --MD084 change end  
 ,CASE WHEN A.PorOption = 1 THEN 'YES' ELSE 'NO' END AS por_option    
 ,billing_type = BILLTYPE.[Type]    
 ,chgstamp = CAST(0 AS INT)    
 ,ai.BillingAccount    
 ,duns_number = f.DunsNumber    
 ,CreditScoreEncrypted = '' --CUST.CreditScoreEncrypted    
 ,SSNEncrypted = '' --CUST.SsnEncrypted    
 ,utility_code = f.UtilityCode    
 ,evergreen_commission_end = '' --ACC.EvergreenCommissionEnd    
 ,residual_option_id = '' --ACC.ResidualOptionID    
 ,residual_commission_end = '' --ACC.ResidualCommissionEnd    
 ,initial_pymt_option_id = '' -- ACC.InitialPymtOptionID    
 ,sales_manager = ManagerUser.Firstname + ' ' + ManagerUser.Lastname    
 ,evergreen_commission_rate = '' --ACC.EvergreenCommissionRate    
 ,service_rate_class = A.ServiceRateClass    
 ,AC.AccountContractID 
 ,ACR.CountOfTerms
 ,ACR.CountOfDistinctTerms
 --into #temp -- drop table #temp        
  FROM #Account A (NOLOCK)         
  JOIN LibertyPower..AccountDetail DETAIL (NOLOCK) ON DETAIL.AccountID = A.AccountID        
  JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID AND A.ContractID = AC.ContractID    
  JOIN #Contract CONT (NOLOCK) ON AC.ContractID = CONT.ContractID         
  JOIN LibertyPower..[ContractType] CT (NOLOCK) ON CONT.ContractTypeID = CT.ContractTypeID         
  JOIN LibertyPower..ContractTemplateType CTT (NOLOCK) ON CONT.ContractTemplateID = CTT.ContractTemplateTypeID        
  JOIN LibertyPower..AccountStatus AST (NOLOCK) ON AC.AccountContractID = AST.AccountContractID         
  --JOIN LibertyPower..AccountContractCommission ACC (NOLOCK) ON AC.AccountContractID = ACC.AccountContractID        
          
 ------------ Modified by LAR 09192012 PBI1040: accomodate multiterm accounts for existing enrollment procedure ------------  
  --JOIN LibertyPower..AccountContractRate ACR (NOLOCK) ON AC.AccountContractID = ACR.AccountContractID AND IsContractedRate = 1  
  INNER JOIN LibertyPower..vw_AccountContractRateSubmissionQueue ACR  
  ON AC.AccountContractID = ACR.AccountContractID --AND IsContractedRate = 1  
    
  LEFT JOIN lp_common..common_product g (NOLOCK) ON  ACR.LegacyProductID = g.product_id   
  ---------------------------------------------------------  
  --MD084 PBI0999  
  LEFT OUTER JOIN LibertyPower..Price P with (NOLOCK) ON P.ID=ACR.PriceID  
  LEFT OUTER JOIN LibertyPower..ProductBrand PB with (NOLOCK) ON isnull(P.ProductBrandID, g.ProductBrandID)=PB.ProductBrandID  
 ---------------------------------------------------------------------------------------------------------------------------  
  JOIN LibertyPower..AccountType AT (NOLOCK) ON A.AccountTypeID = AT.ID        
          
  JOIN Libertypower..Market M (NOLOCK) ON A.RetailMktID = M.ID -- AND InactiveInd = 0        
          
  JOIN lp_account..enrollment_status b (NOLOCK) ON ([Libertypower].[dbo].ufn_GetLegacyAccountStatus(AST.[Status], AST.SubStatus) = b.[status] AND @p_view <> 'BY PENDING RENEWALS')    
      OR (AST.[Status] = b.[status] AND @p_view = 'BY PENDING RENEWALS')    
      
  JOIN lp_account..enrollment_sub_status c (NOLOCK) ON ([Libertypower].[dbo].ufn_GetLegacyAccountStatus(AST.[Status], AST.SubStatus) = c.[status]     
      AND [Libertypower].[dbo].ufn_GetLegacyAccountSubStatus(AST.[Status], AST.SubStatus)  = c.sub_status         
      AND @p_view <> 'BY PENDING RENEWALS')    
       OR (AST.[Status] = c.[status] AND AST.SubStatus = c.sub_status AND @p_view = 'BY PENDING RENEWALS')    
  JOIN lp_common..common_entity d   (NOLOCK) ON A.EntityID = d.entity_id         
  JOIN LibertyPower..Utility f   (NOLOCK) ON A.UtilityID = f.ID        
          
  LEFT JOIN LibertyPower.dbo.AccountUsage USAGE (NOLOCK) ON A.AccountID = USAGE.AccountID AND CONT.StartDate = USAGE.EffectiveDate        
  LEFT JOIN LibertyPower.dbo.UsageReqStatus URS (NOLOCK) ON USAGE.UsageReqStatusID = URS.UsageReqStatusID        
                 
  JOIN #Customer CUST (NOLOCK) ON A.CustomerID = CUST.CustomerID         
          
  -- MD084 CHANGE  
  -- JOIN lp_account..account_name h (NOLOCK) ON h.AccountNameID = CUST.NameID  
  -- Had to add additional check since the new view has repeated Id's  
  JOIN LibertyPower..Name h (NOLOCK) ON CUST.NameID = h.NameID --h.account_id = A.AccountIdLegacy AND h.AccountNameID = CUST.NameID  
  -- MD084 CHANGE END  
          
  LEFT JOIN LibertyPower.dbo.BillingType BILLTYPE (NOLOCK) ON A.BillingTypeID = BILLTYPE.BillingTypeID        
  LEFT JOIN LibertyPower.dbo.SalesChannel SC  (NOLOCK) ON CONT.SalesChannelID = SC.ChannelID        
  LEFT JOIN LibertyPower.dbo.[User] USER1   (NOLOCK) ON CONT.CreatedBy = USER1.UserID        
  LEFT JOIN LibertyPower.dbo.[User] ManagerUser (NOLOCK) ON CONT.SalesManagerID = ManagerUser.UserID        
  LEFT JOIN LibertyPower.dbo.CreditAgency CA  (NOLOCK) ON CUST.CreditAgencyID = CA.CreditAgencyID         
  --LEFT JOIN Libertypower..BusinessActivity BA  (NOLOCK) ON CUST.BusinessActivityID = BA.BusinessActivityID         
  --LEFT JOIN Libertypower..BusinessType BT   (NOLOCK) ON CUST.BusinessTypeID = BT.BusinessTypeID        
  LEFT JOIN LibertyPower.dbo.ContractDealType CDT (NOLOCK) ON CONT.ContractDealTypeID = CDT.ContractDealTypeID    
  LEFT JOIN lp_account..account_info ai   (NOLOCK) ON A.AccountIdLegacy = ai.account_id        
  LEFT JOIN LibertyPower.dbo.TaxStatus TAX  (NOLOCK) ON A.TaxStatusID = TAX.TaxStatusID        
  LEFT JOIN lp_common..common_product_rate r  (NOLOCK) ON r.product_id = ACR.LegacyProductID and r.rate_id = ACR.RateID         
  LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE (nolock) on A.AccountId = ASERVICE.accountid         
 --WHERE 1=1    
 --  AND (@p_ready_to_send_status_only = 0 OR   
 --    not exists (select 1 from lp_enrollment..check_account ca (NOLOCK)  
 --       where ca.contract_nbr = cont.number  
 --         and ca.approval_status <> 'APPROVED'))  
  /*    
 exec lp_account..usp_account_sel_list_ERIC @p_billing_account_filter=N'NONE',@p_username=N'LIBERTYPOWER\e3hernandez',@p_view=N'ALL',@p_rec_sel=N'0'    
 ,@p_contract_nbr_filter=N'NONE',@p_account_id_filter=N'NONE',@p_account_number_filter=N'NONE',@p_full_name_filter=N'',@p_status_filter=N'ALL',@p_sub_status_filter=N'ALL'    
 ,@p_utility_id_filter=N'coned',@p_entity_id_filter=N'ALL',@p_retail_mkt_id_filter=N'ALL',@p_account_type_filter=N'ALL',@p_sales_channel_role_filter=N'NONE'    
 , @p_ready_to_send_status_only = 1     
 */    
         
 --select case when @p_billing_account_filter IN ('NONE','','ALL') then 'yeeah' else 'whaaa' end        
 --select account_number, count(*)        
 --from #temp        
 --group by account_number        
 --having count(*) > 1        
 --order by 2 desc        
         
 --select *        
 --from lp_account..account        
 --where utility_id = 'coned'        
 --and account_number not in (select account_number from #temp)        
  
 SET NOCOUNT OFF  
END 