-- =============================================  
-- Author:  Jaime Forero  
-- Create date: 11/22/2011  
-- Description: Grabs all the accounts that changed during the day and saves the information in the old zaudit table  
--  
-- EXEC LibertyPower.dbo.[usp_CopyChangesTozAuditAccountLegacyTable] '2011-11-27'   ,  1  
-- SELECT * FROM lp_account..[zAudit_account_DEV]  
-- SELECT * FROM lp_account..[zAudit_account_renewal_DEV]  
-- DELETE  lp_account..[zAudit_account_DEV]  
-- DELETE  lp_account..[zAudit_account_renewal_DEV]  
--   
-- =============================================  
CREATE PROCEDURE [dbo].[usp_CopyChangesTozAuditAccountLegacyTable]  
 @BaseDate DATETIME = NULL,  
 @DebugOnly BIT = 0  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
-- declare @BaseDate DATETIME 
-- SET @BaseDate = '2012-01-31';  

 IF @BaseDate IS NULL  
  SET @BaseDate = GETDATE();  
   
 IF OBJECT_ID('tempdb..#TempAccountIds2') IS NOT NULL  
 BEGIN  
  DROP TABLE #TempAccountIds2    
  -- PRINT 'Temp Table Exists';  
 END  
   
  CREATE TABLE #TempAccountIds2  
 (  
 AccountID INT,  
 AccountIdLegacy CHAR(12),  
 AuditTableName VARCHAR(32),  
 AuditChangeType CHAR(3),  
 AuditChangeDate DATETIME,  
 AuditChangeBy   VARCHAR(30),  
 AuditChangeLocation VARCHAR(30),  
 ColumnsUpdated VARCHAR(MAX) NULL,  
 ColumnsChanged   VARCHAR(MAX) NULL  
 )  

Create index idx1 on #TempAccountIds2 (AccountID) with fillfactor = 80

 -- Account audit:  
   
 INSERT INTO #TempAccountIds2  
 SELECT AccountID, AccountIdLegacy , 'zAuditAccount', AuditChangeType, max(AuditChangeDate), max(AuditChangeBy), max(AuditChangeLocation), max(ColumnsUpdated), max(ColumnsChanged)
 FROM LibertyPower..zAuditAccount   
 WHERE CAST(FLOOR(CAST(AuditChangeDate  AS FLOAT)) AS DATETIME) =  CAST(FLOOR(CAST(@BaseDate AS FLOAT)) AS DATETIME) -- this is a very efficient date casting method, i know there awre other ways, but this performs well under lots of data :p  
 group by AccountID, AccountIdLegacy , AuditChangeType


 --Account Detail audit:  
   
 INSERT INTO #TempAccountIds2  
 SELECT DISTINCT AccountID, NULL ,'zAuditAccountDetail', AuditChangeType, max(AuditChangeDate), max(AuditChangeBy), max(AuditChangeLocation), max(ColumnsUpdated), max(ColumnsChanged)
 FROM LibertyPower..zAuditAccountDetail   
 WHERE CAST(FLOOR(CAST(AuditChangeDate  AS FLOAT)) AS DATETIME) =  CAST(FLOOR(CAST(@BaseDate AS FLOAT)) AS DATETIME) -- this is a very efficient date casting method, i know there awre other ways, but this performs well under lots of data :p  
 AND AccountID NOT IN (SELECT AccountID FROM #TempAccountIds2)  
 group by AccountID, AuditChangeType
   
   
   
 --Account Usage audit:  
   
 INSERT INTO #TempAccountIds2
 SELECT DISTINCT AccountID, NULL ,'zAuditAccountUsage', AuditChangeType, max(AuditChangeDate), max(AuditChangeBy), max(AuditChangeLocation), max(ColumnsUpdated), max(ColumnsChanged)
 FROM LibertyPower..zAuditAccountUsage  
 WHERE CAST(FLOOR(CAST(AuditChangeDate  AS FLOAT)) AS DATETIME) =  CAST(FLOOR(CAST(@BaseDate AS FLOAT)) AS DATETIME) -- this is a very efficient date casting method, i know there awre other ways, but this performs well under lots of data :p  
 AND AccountID NOT IN (SELECT AccountID FROM #TempAccountIds2)  
 group by AccountID, AuditChangeType
   
   
 -- Account Contract audit:  
   
 INSERT INTO #TempAccountIds2
 SELECT DISTINCT AccountID, NULL ,'zAuditAccountContract', AuditChangeType, max(AuditChangeDate), max(AuditChangeBy), max(AuditChangeLocation), max(ColumnsUpdated), max(ColumnsChanged)
 FROM LibertyPower..zAuditAccountContract  
 WHERE CAST(FLOOR(CAST(AuditChangeDate  AS FLOAT)) AS DATETIME) =  CAST(FLOOR(CAST(@BaseDate AS FLOAT)) AS DATETIME) -- this is a very efficient date casting method, i know there awre other ways, but this performs well under lots of data :p  
 AND AccountID NOT IN (SELECT AccountID FROM #TempAccountIds2)  
 group by AccountID, AuditChangeType
   
   
 -- Account Contract Rate audit:  
   
 INSERT INTO #TempAccountIds2
 SELECT DISTINCT AC.AccountID, NULL ,'zAuditAccountContractRate', AuditChangeType, max(AuditChangeDate), max(AuditChangeBy), max(AuditChangeLocation), max(ColumnsUpdated), max(ColumnsChanged)
 FROM LibertyPower..zAuditAccountContractRate ACR   
 JOIN LibertyPower..AccountContract AC ON ACR.AccountContractID = AC.AccountContractID  
 WHERE CAST(FLOOR(CAST(AuditChangeDate  AS FLOAT)) AS DATETIME) =  CAST(FLOOR(CAST(@BaseDate AS FLOAT)) AS DATETIME) -- this is a very efficient date casting method, i know there awre other ways, but this performs well under lots of data :p  
 AND AC.AccountID NOT IN (SELECT AccountID FROM #TempAccountIds2)  
 group by AccountID, AuditChangeType
   
 -- Account Contract Commission audit:  
   
 INSERT INTO #TempAccountIds2
 SELECT DISTINCT AC.AccountID, NULL ,'zAuditAccountContractCommission', AuditChangeType, max(AuditChangeDate), max(AuditChangeBy), max(AuditChangeLocation), max(ColumnsUpdated), max(ColumnsChanged)
 FROM LibertyPower..zAuditAccountContractCommission ACC  
 JOIN LibertyPower..AccountContract AC ON ACC.AccountContractID = AC.AccountContractID  
 WHERE CAST(FLOOR(CAST(AuditChangeDate  AS FLOAT)) AS DATETIME) =  CAST(FLOOR(CAST(@BaseDate AS FLOAT)) AS DATETIME) -- this is a very efficient date casting method, i know there awre other ways, but this performs well under lots of data :p  
 AND AC.AccountID NOT IN (SELECT AccountID FROM #TempAccountIds2)  
 group by AccountID, AuditChangeType
   
 -- Account Status audit:  
   
 INSERT INTO #TempAccountIds2  
 SELECT DISTINCT AC.AccountID, NULL ,'zAuditAccountStatus', AuditChangeType, max(AuditChangeDate), max(AuditChangeBy), max(AuditChangeLocation), max(ColumnsUpdated), max(ColumnsChanged)
 FROM LibertyPower..zAuditAccountStatus AST  
 JOIN LibertyPower..AccountContract AC ON AST.AccountContractID = AC.AccountContractID  
 WHERE CAST(FLOOR(CAST(AuditChangeDate  AS FLOAT)) AS DATETIME) =  CAST(FLOOR(CAST(@BaseDate AS FLOAT)) AS DATETIME) -- this is a very efficient date casting method, i know there awre other ways, but this performs well under lots of data :p  
 AND AC.AccountID NOT IN (SELECT AccountID FROM #TempAccountIds2)  
 group by AccountID, AuditChangeType

 -- Contract audit:  
   
 INSERT INTO #TempAccountIds2  
 SELECT DISTINCT AC.AccountID, NULL ,'zAuditContract', AuditChangeType, max(AuditChangeDate), max(AuditChangeBy), max(AuditChangeLocation), max(ColumnsUpdated), max(ColumnsChanged)
 FROM LibertyPower..zAuditContract C  
 JOIN LibertyPower..AccountContract AC ON C.ContractID = AC.ContractID  
 WHERE CAST(FLOOR(CAST(AuditChangeDate  AS FLOAT)) AS DATETIME) =  CAST(FLOOR(CAST(@BaseDate AS FLOAT)) AS DATETIME) -- this is a very efficient date casting method, i know there awre other ways, but this performs well under lots of data :p  
 AND AC.AccountID NOT IN (SELECT AccountID FROM #TempAccountIds2)  
 group by AccountID, AuditChangeType
   
 -- Customer audit:  
   
 INSERT INTO #TempAccountIds2  
 SELECT DISTINCT A.AccountID, NULL ,'zAuditCustomer', AuditChangeType, max(AuditChangeDate), max(AuditChangeBy), max(AuditChangeLocation), max(ColumnsUpdated), max(ColumnsChanged)
 FROM LibertyPower..zAuditCustomer C  
 JOIN LibertyPower..Account A ON C.CustomerID = A.CustomerID  
 WHERE CAST(FLOOR(CAST(AuditChangeDate  AS FLOAT)) AS DATETIME) =  CAST(FLOOR(CAST(@BaseDate AS FLOAT)) AS DATETIME) -- this is a very efficient date casting method, i know there awre other ways, but this performs well under lots of data :p  
 AND A.AccountID NOT IN (SELECT AccountID FROM #TempAccountIds2)  
 group by AccountID, AuditChangeType
   
 drop index #TempAccountIds2.idx1
 Create index idx1 on #TempAccountIds2 (AccountID) include (AccountIDLegacy) with fillfactor = 100
 
 -- UPDATE THE AccountIDLegacy that doesnt exist  
 UPDATE T  
 SET T.AccountIDLegacy = A.AccountIdLegacy  
 FROM #TempAccountIds2 T  
 JOIN LibertyPower..Account A ON T.AccountID = A.AccountID  
 WHERE T.AccountIDLegacy IS NULL;  
   
 drop index #TempAccountIds2.idx1
 Create clustered index idx1 on #TempAccountIds2 (AccountID,AuditChangeDate)  with fillfactor = 100
   
   
 IF @DebugOnly  =  1  
 BEGIN  
  PRINT 'Debug only mode, so just printing values here ... ' ;  
  SELECT * FROM #TempAccountIds2  
 END  
 ELSE  
 BEGIN  
  -- INSERT THE RECORDS FROM HERE:  
  PRINT 'Inserting Account changes: ' ; -- SELECT * FROM #TempAccountIds2  
  -- SELECT * FROM lp_account..[zAudit_account_DEV]  
  INSERT INTO lp_account..[zAudit_account]  
  (  
  [account_id],  
  [account_number],  
  [account_type],  
  [status],  
  [sub_status],  
  [customer_id],  
  [entity_id],  
  [contract_nbr],  
  [contract_type],  
  [retail_mkt_id],  
  [utility_id],  
  [product_id],  
  [rate_id],  
  [rate],  
  [account_name_link],  
  [customer_name_link],  
  [customer_address_link],  
  [customer_contact_link],  
  [billing_address_link],  
  [billing_contact_link],  
  [owner_name_link],  
  [service_address_link],  
  [business_type],  
  [business_activity],  
  [additional_id_nbr_type],  
  [additional_id_nbr],  
  [contract_eff_start_date],  
  [term_months],  
  [date_end],  
  [date_deal],  
  [date_created],  
  [date_submit],  
  [sales_channel_role],  
  [username],  
  [sales_rep],  
  [origin],  
  [annual_usage],  
  [date_flow_start],  
  [date_por_enrollment],  
  [date_deenrollment],  
  [date_reenrollment],  
  [tax_status],  
  [tax_rate],  
  [credit_score],  
  [credit_agency],  
  [por_option],  
  [billing_type],  
  [chgstamp],  
  [usage_req_status],  
  [Created],  
  [CreatedBy],  
  [Modified],  
  [ModifiedBy],  
  
  [audit_change_type]  
  /* 001: Begin Ticket 14147 */    
  ,[rate_code]  
  ,[zone]  
  ,[service_rate_class]  
  ,[stratum_variable]  
  ,[billing_group]  
  ,[icap]  
  ,[tcap]  
  ,[load_profile]  
  ,[loss_code]  
  ,[meter_type]  
  ,[requested_flow_start_date]  
  ,[deal_type]  
  ,[enrollment_type]  
  ,[customer_code]  
  ,[customer_group]  
  ,[AccountID]  
  ,[ColumnsUpdated]  
  ,[ColumnsChanged]  
  /* 001: End Ticket 14147 */    
  /* 002: IT002 End */  
  ,[SSNClear]  
  ,[SSNEncrypted]  
  ,[CreditScoreEncrypted]  
  /* 002: IT002 End */   
  /* 003: IT021 Begin*/  
  ,[evergreen_option_id]  
  ,[evergreen_commission_end]  
  ,[residual_option_id]  
  ,[residual_commission_end]  
  ,[initial_pymt_option_id]  
  ,[sales_manager]  
  ,[evergreen_commission_rate]  
  /* 003: IT021 End*/  
  ,[original_tax_designation]
  , audit_change_dt
  , audit_change_by
  , audit_change_location
  )  
    
    
  SELECT   
  a.[account_id],  
  a.[account_number],  
  a.[account_type],  
  a.[status],  
  a.[sub_status],  
  a.[customer_id],  
  a.[entity_id],  
  a.[contract_nbr],  
  a.[contract_type],  
  a.[retail_mkt_id],  
  a.[utility_id],  
  a.[product_id],  
  a.[rate_id],  
  a.[rate],  
  a.[account_name_link],  
  a.[customer_name_link],  
  a.[customer_address_link],  
  a.[customer_contact_link],  
  a.[billing_address_link],  
  a.[billing_contact_link],  
  [owner_name_link],  
  [service_address_link],  
  [business_type],  
  [business_activity],  
  [additional_id_nbr_type],  
  [additional_id_nbr],  
  [contract_eff_start_date],  
  [term_months],  
  [date_end],  
  [date_deal],  
  [date_created],  
  [date_submit],  
  [sales_channel_role],  
  [username],  
  [sales_rep],  
  [origin],  
  [annual_usage],  
  [date_flow_start],  
  [date_por_enrollment],  
  [date_deenrollment],  
  [date_reenrollment],  
  [tax_status],  
  [tax_rate],  
  a.[credit_score],  
  a.[credit_agency],  
  a.[por_option],  
  a.[billing_type],  
  a.[chgstamp],  
  a.[usage_req_status],  
  a.[Created],  
  a.[CreatedBy],  
  a.[Modified],  
  a.[ModifiedBy],  
  
  T.AuditChangeType--'INS'  
  /* 001: Begin Ticket 14147 */    
  ,a.[rate_code]  
  ,a.[zone]  
  ,a.[service_rate_class]  
  ,a.[stratum_variable]  
  ,a.[billing_group]  
  ,a.[icap]  
  ,a.[tcap]  
  ,a.[load_profile]  
  ,a.[loss_code]  
  ,[meter_type]  
  ,[requested_flow_start_date]  
  ,[deal_type]  
  ,[enrollment_type]  
  ,[customer_code]  
  ,[customer_group]  
  ,a.[AccountID]  
  ,T.[ColumnsUpdated]  
  ,T.[ColumnsChanged]  
  /* 001: End Ticket 14147 */    
  /* 002: IT002 End */  
  ,[SSNClear]  
  ,[SSNEncrypted]  
  ,[CreditScoreEncrypted]  
  /* 002: IT002 End */   
  /* 003: IT021 Begin*/  
  ,[evergreen_option_id]  
  ,[evergreen_commission_end]  
  ,[residual_option_id]  
  ,[residual_commission_end]  
  ,[initial_pymt_option_id]  
  ,[sales_manager]  
  ,[evergreen_commission_rate]  
  /* 003: IT021 End*/  
  ,[original_tax_designation] 
  ,T.AuditChangeDate
  ,T.AuditChangeBy
  ,T.AuditChangeLocation   
  FROM lp_account..account a  
  JOIN #TempAccountIds2 T on a.accountID = T.AccountID  
  ORDER BY T.AuditChangeDate ASC  
    
    
  PRINT 'Inserting Account Renewal changes: ' ;  
  INSERT INTO lp_account..[zAudit_account_renewal]  
  (  
  [account_id],  
  [account_number],  
  [account_type],  
  [status],  
  [sub_status],  
  [customer_id],  
  [entity_id],  
  [contract_nbr],  
  [contract_type],  
  [retail_mkt_id],  
  [utility_id],  
  [product_id],  
  [rate_id],  
  [rate],  
  [account_name_link],  
  [customer_name_link],  
  [customer_address_link],  
  [customer_contact_link],  
  [billing_address_link],  
  [billing_contact_link],  
  [owner_name_link],  
  [service_address_link],  
  [business_type],  
  [business_activity],  
  [additional_id_nbr_type],  
  [additional_id_nbr],  
  [contract_eff_start_date],  
  [term_months],  
  [date_end],  
  [date_deal],  
  [date_created],  
  [date_submit],  
  [sales_channel_role],  
  [username],  
  [sales_rep],  
  [origin],  
  [annual_usage],  
  [date_flow_start],  
  [date_por_enrollment],  
  [date_deenrollment],  
  [date_reenrollment],  
  [tax_status],  
  [tax_rate],  
  [credit_score],  
  [credit_agency],  
  [por_option],  
  [billing_type],  
  [chgstamp],  
  [audit_change_type],  
  [ColumnsUpdated], -- Ticket 14407   
  [ColumnsChanged] -- Ticket 14407  
  /* 003: IT021 Begin*/  
  ,[evergreen_option_id]  
  ,[evergreen_commission_end]  
  ,[residual_option_id]  
  ,[residual_commission_end]  
  ,[initial_pymt_option_id]  
  ,[sales_manager]  
  ,[evergreen_commission_rate]  
  /* 003: IT021 End*/  
  , audit_change_dt
  , audit_change_by
  , audit_change_location
  )  
  SELECT   
  [account_id],  
  [account_number],  
  [account_type],  
  [status],  
  [sub_status],  
  [customer_id],  
  [entity_id],  
  [contract_nbr],  
  [contract_type],  
  [retail_mkt_id],  
  [utility_id],  
  [product_id],  
  [rate_id],  
  [rate],  
  [account_name_link],  
  [customer_name_link],  
  [customer_address_link],  
  [customer_contact_link],  
  [billing_address_link],  
  [billing_contact_link],  
  [owner_name_link],  
  [service_address_link],  
  [business_type],  
  [business_activity],  
  [additional_id_nbr_type],  
  [additional_id_nbr],  
  [contract_eff_start_date],  
  [term_months],  
  [date_end],  
  [date_deal],  
  [date_created],  
  [date_submit],  
  [sales_channel_role],  
  [username],  
  [sales_rep],  
  [origin],  
  [annual_usage],  
  [date_flow_start],  
  [date_por_enrollment],  
  [date_deenrollment],  
  [date_reenrollment],  
  [tax_status],  
  [tax_rate],  
  [credit_score],  
  [credit_agency],  
  [por_option],  
  [billing_type],  
  [chgstamp],  
  T.AuditChangeType--'INS'  
  ,T.[ColumnsUpdated]  
  ,T.[ColumnsChanged]  
  /* 003: IT021 Begin*/  
  ,[evergreen_option_id]  
  ,[evergreen_commission_end]  
  ,[residual_option_id]  
  ,[residual_commission_end]  
  ,[initial_pymt_option_id]  
  ,[sales_manager]  
  ,[evergreen_commission_rate]  
  /* 003: IT021 End*/  
  ,T.AuditChangeDate
  ,T.AuditChangeBy
  ,T.AuditChangeLocation   
 FROM lp_account..account_renewal r  
  JOIN #TempAccountIds2 T on r.account_id = T.AccountIDLegacy  
  ORDER BY T.AuditChangeDate ASC  
  
  
  
  
  
    
    
    
    
    
    
    
    
    
    
    
    
    
 END  
   
   
   
   
   
   
   
   
   
END  