USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_sel_list]    Script Date: 05/10/2012 14:33:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
-- Modify		: Jose Munoz
-- Date			: 03/01/2012
-- Ticket		: 1-9689023 
-- Description	: Show Account in renewal using the new structure
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
-- Isabelle Tamanini
-- Modified: 5/10/2012
-- Changed where clause: Adding rate_descp field back to the select clause
-- SR1-15169065
-- =============================================
    
--577411834600001 CONED              
/*


exec lp_account..[usp_account_sel_list_JFORERO] @p_username=N'LIBERTYPOWER\atafur'
,@p_view=N'BY CONTRACT EFF START DATE'
,@p_rec_sel=N'50',@p_contract_nbr_filter=N'2743937',@p_account_id_filter=N'NONE',@p_account_number_filter=N'NONE',
@p_full_name_filter=N'',@p_status_filter=N'NONE',@p_sub_status_filter=N'NONE',@p_utility_id_filter=N'ALL',
@p_entity_id_filter=N'ALL',@p_retail_mkt_id_filter=N'ALL',@p_account_type_filter=N'NONE',@p_sales_channel_role_filter=N'NONE',
@p_ready_to_send_status_only=N'0',@p_enrollment_type=NULL



*/
    

ALTER procedure [dbo].[usp_account_sel_list]    
(@p_username                                        NCHAR(100) ,    
 @p_view                                            VARCHAR(35) = 'ALL',    
 @p_rec_sel                                         INT = 50,    
 @p_account_id_filter                               CHAR(12) = NULL,    
 @p_account_number_filter                           VARCHAR(30) = NULL,    
 @p_legacy_account_filter                           VARCHAR(30) = 'ALL', -- INF83    
 @p_contract_nbr_filter                             CHAR(12) = NULL,    
 @p_full_name_filter                                VARCHAR(30)= 'ALL',    
 @p_status_filter                                   VARCHAR(15)= 'ALL',    
 @p_sub_status_filter                               VARCHAR(15)= 'ALL',    
 @p_utility_id_filter                               VARCHAR(15)= 'ALL',                                          
 @p_entity_id_filter                                VARCHAR(15) = NULL,    
 @p_retail_mkt_id_filter                            VARCHAR(04)= 'ALL',    
 @p_account_type_filter                             VARCHAR(35)= 'ALL',    
 @p_customer_id_filter								VARCHAR(35) = NULL,    
 @p_sales_channel_role_filter                       VARCHAR(50)= 'ALL',    
 @p_ready_to_send_status_only                       SMALLINT = 0,    
 @p_usage_request_status							VARCHAR(20) = '',    
 @p_enrollment_type									VARCHAR(20) = null,    
 @p_reenroll_and_resendstatus_flag					BIT = 0,    
 @p_include_scrapable_utilities						VARCHAR(3) = 'YES',    
 @p_billing_account_filter							VARCHAR(50) = 'ALL',
 @p_exclude_inactive								BIT = 0    
)    
AS    
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
    
-- You can remove the block below once usage_request.aspx is properly passing in this parameter.
IF @p_usage_request_status = 'PENDING'
	SET @p_exclude_inactive = 1
    
--Enrollment Submission Standard queue was getting Move-in also. 'null, 0, 1' parameter moved to '1'
IF @p_enrollment_type IN ('NONE','','ALL')    
 SET @p_enrollment_type = NULL    
IF @p_enrollment_type IN ('0','null, 0, 1')    
 SET @p_enrollment_type = '1'    
IF @p_enrollment_type IN ('3,4')    
 SET @p_enrollment_type = '3'    

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
   
  
CREATE TABLE #Account(  
 [AccountID] [int] NOT NULL,  
 [AccountIdLegacy] [char](12) NULL,  
 [AccountNumber] [varchar](30) NULL,  
 [CustomerIdLegacy] [varchar](10) NULL,  
 [DateCreated] [datetime] NOT NULL,  
 [origin] [varchar](50) NULL,  
 [PorOption] [bit] NULL,  
 [ServiceRateClass] [varchar](50) NULL,  
 [CurrentContractID] [int] NULL,  
 [CurrentRenewalContractID] [int] NULL,  
 [AccountTypeID] [int] NULL,  
 [RetailMktID] [int] NULL,  
 [EntityID] [char](15) NULL,  
 [UtilityID] [int] NULL,  
 [CustomerID] [int] NULL,  
 [BillingTypeID] [int] NULL,  
 [TaxStatusID] [int] NULL  
) ON [PRIMARY]  
  
DECLARE @filtered BIT


DECLARE @UtilityID INT

SELECT @UtilityID = ID
FROM LibertyPower.dbo.Utility
WHERE UtilityCode = @p_utility_id_filter AND InactiveInd = 0
    
-- selection by Account  
IF @p_account_number_filter IS NOT NULL
	OR @UtilityID IS NOT NULL   
BEGIN  
	SET @filtered = 1  

	INSERT INTO #Account    
	SELECT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	, A.origin, A.PorOption, A.ServiceRateClass, A.CurrentContractID, A.CurrentRenewalContractID, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	, A.CustomerID, A.BillingTypeID, A.TaxStatusID    
	FROM LibertyPower..Account A (NOLOCK)    
	WHERE 1=1    
	AND (A.CurrentContractID IS NOT NULL OR A.CurrentRenewalContractID IS NOT NULL )     
	AND (@p_account_id_filter IS NULL OR A.AccountIdLegacy = @p_account_id_filter)    
	-- INF83, per Douglas, do specific search for legacy account #'s - 06/03/2009    
	AND (@p_account_number_filter      IS NULL OR A.AccountNumber  = @p_account_number_filter)    
	AND (@p_legacy_account_filter      IN ('NONE','','ALL') OR A.AccountNumber in (select new_account_number from lp_account..account_number_history where old_account_number = '' + @p_legacy_account_filter + '') )    
	AND (@p_entity_id_filter           IS NULL OR A.EntityID   = @p_entity_id_filter)    
	AND (@p_customer_id_filter		   IS NULL OR A.CustomerIdLegacy = @p_customer_id_filter)    
	AND (@UtilityID IS NULL OR A.UtilityID = @UtilityID)    

	CREATE CLUSTERED INDEX idx1 ON #Account  (Accountid)  

	INSERT INTO #Contract  
	SELECT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	, C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	FROM LibertyPower.dbo.Contract   C     
	join LibertyPower.dbo.AccountContract AC ON C.ContractID = AC.[ContractID]  
	join #Account A  ON A.AccountID  = AC.AccountID  
	WHERE (@p_contract_nbr_filter IS NULL OR Number = @p_contract_nbr_filter)  

	CREATE CLUSTERED INDEX idx1 ON #Contract (Contractid)  
END  
--select count(*) from #Account
--select count(*) from #Contract
  
IF @p_contract_nbr_filter IS NOT NULL AND ISNULL(@filtered, 0) = 0
BEGIN  
	SET @filtered = 1  

	INSERT INTO #Contract  
	SELECT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	, C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	FROM LibertyPower..Contract C (NOLOCK)    
	WHERE (C.Number = @p_contract_nbr_filter)    
	and (@p_contract_nbr_filter IS NULL OR Number = @p_contract_nbr_filter)     
	 
	CREATE CLUSTERED INDEX idx1 on #Contract (Contractid)  

	INSERT INTO #Account    
	SELECT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	, A.origin, A.PorOption, A.ServiceRateClass, A.CurrentContractID, A.CurrentRenewalContractID, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	, A.CustomerID, A.BillingTypeID, A.TaxStatusID    
	FROM LibertyPower.dbo.Account   A     
	join LibertyPower.dbo.AccountContract AC ON A.AccountID  = AC.AccountID  
	join #Contract       C  on C.ContractID = AC.ContractID  
	WHERE 1=1    
	and (@p_account_id_filter IS NULL OR A.AccountIdLegacy = @p_account_id_filter)    
	AND (A.CurrentContractID IS NOT NULL OR A.CurrentRenewalContractID IS NOT NULL )     
	AND (@p_account_id_filter IS NULL OR A.AccountIdLegacy = @p_account_id_filter)    
	-- INF83, per Douglas, do specific search for legacy account #'s - 06/03/2009    
	AND (@p_account_number_filter      IS NULL OR A.AccountNumber  = @p_account_number_filter)    
	AND (@p_legacy_account_filter      IN ('NONE','','ALL') OR A.AccountNumber in (select new_account_number from lp_account..account_number_history where old_account_number = '' + @p_legacy_account_filter + '') )    
	AND (@p_entity_id_filter           IS NULL OR A.EntityID   = @p_entity_id_filter)    
	AND (@p_customer_id_filter     IS NULL OR A.CustomerIdLegacy = @p_customer_id_filter)    

	/* TICKET 1-9689023 BEGIN*/
	--SR1-10751951 - Distinct added to avoid duplicated records
	INSERT INTO #Contract					
	SELECT DISTINCT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	, C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    					
	FROM LibertyPower..Contract C (NOLOCK)
	JOIN #Account A ON A.CurrentContractId = C.ContractID
	AND NOT EXISTS (SELECT 1 FROM #Contract CC
					WHERE CC.ContractID = C.Contractid)					
	/* TICKET 1-9689023 END*/

	CREATE CLUSTERED INDEX idx1 on #Account  (Accountid)  
END  
  
  
IF @p_full_name_filter NOT IN ('NONE','','ALL') AND ISNULL(@filtered, 0) = 0
BEGIN  
	SET @filtered = 1  

	INSERT INTO #Account    
	SELECT DISTINCT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	, A.origin, A.PorOption, A.ServiceRateClass, A.CurrentContractID, A.CurrentRenewalContractID, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	, A.CustomerID, A.BillingTypeID, A.TaxStatusID    
	FROM LibertyPower.dbo.Account  A     
	JOIN LibertyPower.dbo.Customer  CUST ON A.CustomerID = CUST.CustomerID     
	join lp_account.dbo.account_name h  ON h.AccountNameID = CUST.NameID  
	WHERE 1=1    
	and (h.full_name like '' + @p_full_name_filter+ '%')   
	AND (A.CurrentContractID IS NOT NULL OR A.CurrentRenewalContractID IS NOT NULL )     
	AND (@p_account_id_filter IS NULL OR A.AccountIdLegacy = @p_account_id_filter)    
	-- INF83, per Douglas, do specific search for legacy account #'s - 06/03/2009    
	AND (@p_account_number_filter      IS NULL OR A.AccountNumber  = @p_account_number_filter)    
	AND (@p_legacy_account_filter      IN ('NONE','','ALL') OR A.AccountNumber in (select new_account_number from lp_account..account_number_history where old_account_number = '' + @p_legacy_account_filter + '') )    
	AND (@p_entity_id_filter           IS NULL OR A.EntityID   = @p_entity_id_filter)    
	AND (@p_customer_id_filter     IS NULL OR A.CustomerIdLegacy = @p_customer_id_filter)    

	CREATE CLUSTERED INDEX idx1 on #Account  (Accountid)  

	Insert INTO #Contract  
	SELECT DISTINCT  C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	, C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	FROM LibertyPower.dbo.Contract   C     
	join LibertyPower.dbo.AccountContract AC ON C.ContractID = AC.[ContractID]  
	join #Account       A  on A.AccountID  = AC.AccountID  
	WHERE 1=1  
	AND (@p_contract_nbr_filter IS NULL OR Number = @p_contract_nbr_filter)    
	CREATE CLUSTERED INDEX idx1 on #Contract (Contractid)  
END  

/*
exec lp_account..usp_account_sel_list @p_billing_account_filter=N'NONE',@p_username=N'LIBERTYPOWER\e3hernandez',@p_view=N'ALL',@p_rec_sel=N'50'
,@p_contract_nbr_filter=N'NONE',@p_account_id_filter=N'NONE',@p_account_number_filter=N'NONE',@p_full_name_filter=N'',@p_status_filter=N'ALL',@p_sub_status_filter=N'ALL'
,@p_utility_id_filter=N'ALL',@p_entity_id_filter=N'ALL',@p_retail_mkt_id_filter=N'ALL',@p_account_type_filter=N'ALL',@p_sales_channel_role_filter=N'NONE'
*/  

-- default filters  
IF @p_billing_account_filter='NONE'   
	and @p_view='ALL'   
	and @p_contract_nbr_filter IS NULL
	and @p_account_id_filter IS NULL
	and @p_account_number_filter IS NULL  
	and @p_full_name_filter=''  
	and @p_status_filter='ALL'  
	and @p_sub_status_filter='ALL'  
	and @p_utility_id_filter='ALL'  
	and @p_entity_id_filter IS NULL
	and @p_retail_mkt_id_filter='ALL'  
	and @p_account_type_filter='ALL'  
	and @p_sales_channel_role_filter='NONE' 
	AND ISNULL(@filtered, 0) = 0
BEGIN  
	SET @filtered = 1  

	INSERT INTO #Account    
	SELECT top (@p_rec_sel) A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	, A.origin, A.PorOption, A.ServiceRateClass, A.CurrentContractID, A.CurrentRenewalContractID, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	, A.CustomerID, A.BillingTypeID, A.TaxStatusID    
	-- INTO #Account    
	FROM LibertyPower..Account A (NOLOCK)    
	WHERE 1=1    
	AND (A.CurrentContractID IS NOT NULL OR A.CurrentRenewalContractID IS NOT NULL )     
	AND (@p_account_id_filter IS NULL OR A.AccountIdLegacy = @p_account_id_filter)    
	-- INF83, per Douglas, do specific search for legacy account #'s - 06/03/2009    
	AND (@p_account_number_filter      IS NULL OR A.AccountNumber  = @p_account_number_filter)    
	AND (@p_legacy_account_filter      IN ('NONE','','ALL') OR A.AccountNumber in (select new_account_number from lp_account..account_number_history where old_account_number = '' + @p_legacy_account_filter + '') )    
	AND (@p_entity_id_filter           IS NULL OR A.EntityID   = @p_entity_id_filter)    
	AND (@p_customer_id_filter     IS NULL OR A.CustomerIdLegacy = @p_customer_id_filter)    
	 
	CREATE CLUSTERED INDEX idx1 on #Account  (Accountid)  

	INSERT INTO #Contract  
	SELECT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	, C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	FROM LibertyPower..Contract C (NOLOCK)    
	--join LibertyPower.dbo.AccountContract AC ON C.ContractID = AC.[ContractID]  
	--join #Account       A  on A.AccountID  = AC.AccountID  
	WHERE (@p_contract_nbr_filter IS NULL OR Number = @p_contract_nbr_filter)    

	CREATE CLUSTERED INDEX idx1 on #Contract (Contractid)  
END  
    
  
IF isnull(@filtered,0) = 0  
BEGIN  
	INSERT INTO #Account    
	SELECT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	, A.origin, A.PorOption, A.ServiceRateClass, A.CurrentContractID, A.CurrentRenewalContractID, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	, A.CustomerID, A.BillingTypeID, A.TaxStatusID    
	-- INTO #Account    
	FROM LibertyPower..Account A (NOLOCK)    
	WHERE 1=1    
	AND (A.CurrentContractID IS NOT NULL OR A.CurrentRenewalContractID IS NOT NULL )     
	AND (@p_account_id_filter IS NULL OR A.AccountIdLegacy = @p_account_id_filter)    
	-- INF83, per Douglas, do specific search for legacy account #'s - 06/03/2009    
	AND (@p_account_number_filter      IS NULL OR A.AccountNumber  = @p_account_number_filter)    
	AND (@p_legacy_account_filter      IN ('NONE','','ALL') OR A.AccountNumber in (select new_account_number from lp_account..account_number_history where old_account_number = '' + @p_legacy_account_filter + '') )    
	AND (@p_entity_id_filter           IS NULL OR A.EntityID   = @p_entity_id_filter)    
	AND (@p_customer_id_filter     IS NULL OR A.CustomerIdLegacy = @p_customer_id_filter)    
	 
	--CREATE CLUSTERED INDEX idx1 on #Account  (Accountid)  

	INSERT INTO #Contract  
	SELECT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	, C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	FROM LibertyPower..Contract C (NOLOCK)    
	--join LibertyPower.dbo.AccountContract AC ON C.ContractID = AC.[ContractID]  
	--join #Account       A  on A.AccountID  = AC.AccountID  
	WHERE (@p_contract_nbr_filter IS NULL OR Number = @p_contract_nbr_filter)    

	CREATE CLUSTERED INDEX idx1 on #Contract (Contractid)  
END  
  
SET ROWCOUNT @p_rec_sel    
    
 SELECT    DISTINCT
 A.AccountIdLegacy AS account_id,    
 A.AccountNumber AS account_number,    
 CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' 
		   ELSE AT.AccountType END AS account_type, 
 status = b.status_descp,    
 sub_status = c.sub_status_descp,    
 A.CustomerIdLegacy AS customer_id,    
 entity_id = d.entity_descp,    
 contract_nbr = CONT.Number,      
       
 CASE WHEN UPPER(CT.[Type]) = 'VOICE'  THEN UPPER(CT.[Type]) +  CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL'  ELSE '' END    
   WHEN CTT.ContractTemplateTypeID = 2 THEN 'CORPORATE'   +  CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL'  ELSE '' END     
   WHEN UPPER(CT.[Type]) = 'PAPER'  THEN UPPER(CT.[Type]) +  CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL'  ELSE '' END    
   WHEN UPPER(CT.[Type]) = 'EDI'   THEN 'POWER MOVE'    
   ELSE UPPER(CT.[Type]) END AS contract_type,    
     
 retail_mkt_id = M.RetailMktDescp,     
 utility_id = f.FullName,    
 product_id = g.product_descp,     
 rate_id = ACR.RateID,     
 rate = ACR.Rate,     
 names = 'Names',    
 address = 'Address',    
 contact = 'Contacs',    
 BT.[Type] AS business_type,      
 BA.Activity AS business_activity,    
     
 CASE WHEN LTRIM(RTRIM(CUST.Duns)) <> '' THEN 'DUNSNBR'     
 WHEN LTRIM(RTRIM(CUST.EmployerId)) <> '' THEN 'EMPLID'     
 WHEN LTRIM(RTRIM(CUST.TaxId)) <> '' THEN 'TAX ID'     
 ELSE CASE WHEN CUST.SsnEncrypted IS NOT NULL AND CUST.SsnEncrypted != '' THEN 'SSN'     
        ELSE 'NONE' END END AS additional_id_nbr_type,    
     
 CASE WHEN LTRIM(RTRIM(CUST.Duns)) <> '' THEN CUST.Duns    
 WHEN LTRIM(RTRIM(CUST.EmployerId)) <> '' THEN CUST.EmployerId     
 WHEN LTRIM(RTRIM(CUST.TaxId)) <> '' THEN CUST.TaxId     
 ELSE CASE WHEN CUST.SsnEncrypted IS NOT NULL  AND CUST.SsnEncrypted != '' THEN '***-**-****' ELSE 'NONE' END END AS additional_id_nbr,    
     
 USAGE.AnnualUsage AS annual_usage,     
 annual_usage_mw = (USAGE.AnnualUsage)/1000,    
 CAST(0 AS INT) AS credit_score,      
 CASE WHEN CA.Name IS NULL THEN 'NONE' ELSE UPPER(CA.Name) END AS credit_agency,    
     
 term_months        = ACR.Term ,     
 USER1.UserName AS username,    
 'SALES CHANNEL/' + SC.ChannelName AS sales_channel_role,     
 CONT.SalesRep    AS sales_rep,    
 contract_eff_start_date     = ACR.RateStart,     
 date_end        = ACR.RateEnd,     
 CONT.SignedDate AS date_deal,    
 A.DateCreated AS date_created,      
 CONT.SubmitDate AS date_submit,    
 CASE WHEN AST.[Status] in ('999998','999999','01000','03000','04000','05000') AND AST.[SubStatus] not in ('30') THEN CAST('1900-01-01 00:00:00' AS DATETIME)    
   ELSE ISNULL(ASERVICE.StartDate, CAST('1900-01-01 00:00:00' AS DATETIME)) END AS date_flow_start,    
    
 AC.SendEnrollmentDate AS date_por_enrollment,      
 CASE WHEN AST.[Status] in ('999998','999999','01000','03000','04000','05000') THEN CAST('1900-01-01 00:00:00' AS DATETIME)    
   WHEN AST.[Status] in ('13000') AND AST.[SubStatus] in ('70','80') THEN CAST('1900-01-01 00:00:00' AS DATETIME)    
   ELSE ISNULL(ASERVICE.EndDate, CAST('1900-01-01 00:00:00' AS DATETIME)) END AS date_deenrollment,    
     
 CAST('1900-01-01 00:00:00' AS DATETIME) AS date_reenrollment,    
 UPPER(TAX.[Status])  AS tax_status,    
 CAST(0 AS INT)   AS tax_rate,     
     
 rate_descp = isnull(r.rate_descp, '') ,    
 a.origin,    
 h.full_name,    
 CASE WHEN A.PorOption = 1 THEN 'YES' ELSE 'NO' END AS por_option,    
 BILLTYPE.[Type]   AS billing_type,    
 CAST(0 AS INT)   AS chgstamp,    
 ai.BillingAccount,    
 f.DunsNumber duns_number,    
 CUST.CreditScoreEncrypted  AS CreditScoreEncrypted,    
 CUST.SsnEncrypted    AS SSNEncrypted,    
 utility_code = f.UtilityCode,    
     
 ACC.EvergreenCommissionEnd  AS evergreen_commission_end,    
 ACC.ResidualOptionID   AS residual_option_id,    
 ACC.ResidualCommissionEnd  AS residual_commission_end,    
 ACC.InitialPymtOptionID   AS initial_pymt_option_id,    
 ManagerUser.Firstname + ' ' + ManagerUser.Lastname AS sales_manager,      
 ACC.EvergreenCommissionRate  AS evergreen_commission_rate,    
 A.ServiceRateClass AS service_rate_class     
     
 --into #temp -- drop table #temp    
 FROM #Account A (NOLOCK)     
 JOIN LibertyPower..AccountDetail DETAIL (NOLOCK) ON DETAIL.AccountID = A.AccountID    
 JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID AND     
              (    
              (A.CurrentContractID = AC.ContractID AND @p_view <> 'BY PENDING RENEWALS')    
              OR    
              (A.CurrentRenewalContractID = AC.ContractID AND @p_view = 'BY PENDING RENEWALS')    
              )    
 JOIN #Contract CONT (NOLOCK) ON AC.ContractID = CONT.ContractID     
 JOIN LibertyPower..[ContractType] CT (NOLOCK) ON CONT.ContractTypeID = CT.ContractTypeID     
 JOIN LibertyPower..ContractTemplateType CTT (NOLOCK) ON CONT.ContractTemplateID = CTT.ContractTemplateTypeID    
 JOIN LibertyPower..AccountStatus AST (NOLOCK) ON AC.AccountContractID = AST.AccountContractID     
 JOIN LibertyPower..AccountContractCommission ACC (NOLOCK) ON AC.AccountContractID = ACC.AccountContractID    
     
 JOIN LibertyPower..AccountContractRate ACR (NOLOCK) ON AC.AccountContractID = ACR.AccountContractID AND IsContractedRate = 1    
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
     
 JOIN LibertyPower.dbo.AccountUsage USAGE (NOLOCK) ON A.AccountID = USAGE.AccountID AND  CONT.StartDate = USAGE.EffectiveDate    
 JOIN LibertyPower.dbo.UsageReqStatus URS (NOLOCK) ON USAGE.UsageReqStatusID = URS.UsageReqStatusID    
     
 JOIN lp_common..common_product g (NOLOCK) ON  ACR.LegacyProductID = g.product_id     
     
 JOIN LibertyPower..Customer CUST (NOLOCK) ON A.CustomerID = CUST.CustomerID     
     
 JOIN lp_account..account_name h (NOLOCK) ON h.AccountNameID = CUST.NameID     
     
 LEFT JOIN LibertyPower.dbo.BillingType BILLTYPE (NOLOCK) ON A.BillingTypeID = BILLTYPE.BillingTypeID    
 LEFT JOIN LibertyPower.dbo.SalesChannel SC  (NOLOCK) ON CONT.SalesChannelID = SC.ChannelID    
 LEFT JOIN LibertyPower.dbo.[User] USER1   (NOLOCK) ON CONT.CreatedBy = USER1.UserID    
 LEFT JOIN LibertyPower.dbo.[User] ManagerUser (NOLOCK) ON CONT.SalesManagerID = ManagerUser.UserID    
 LEFT JOIN LibertyPower.dbo.CreditAgency CA  (NOLOCK) ON CUST.CreditAgencyID = CA.CreditAgencyID     
 LEFT JOIN Libertypower..BusinessActivity BA  (NOLOCK) ON CUST.BusinessActivityID = BA.BusinessActivityID     
 LEFT JOIN Libertypower..BusinessType BT   (NOLOCK) ON CUST.BusinessTypeID = BT.BusinessTypeID    
 LEFT JOIN LibertyPower.dbo.ContractDealType CDT (NOLOCK) ON CONT.ContractDealTypeID = CDT.ContractDealTypeID    
 LEFT JOIN lp_account..account_additional_info aa (NOLOCK) ON A.AccountIdLegacy = aa.account_id    
 LEFT JOIN lp_account..account_info ai   (NOLOCK) ON A.AccountIdLegacy = ai.account_id    
 LEFT JOIN LibertyPower.dbo.TaxStatus TAX  (NOLOCK) ON A.TaxStatusID = TAX.TaxStatusID    
 LEFT JOIN lp_common..common_product_rate r  (NOLOCK) ON r.product_id = ACR.LegacyProductID and r.rate_id = ACR.RateID     
 LEFT JOIN libertypower.dbo.AccountLatestService ASERVICE (nolock) on A.AccountId = ASERVICE.accountid     
 --LEFT JOIN (    
 -- select account_id, StartDate, EndDate, ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY StartDate DESC, EndDate DESC) AS rownum    
 -- from Libertypower.dbo.AccountService (NOLOCK)     
 --) ASERVICE  ON A.AccountIdLegacy = ASERVICE.account_id and ASERVICE.rownum = 1    
    
     
   WHERE 1=1    
    AND (@p_include_scrapable_utilities <> 'NO' OR f.UtilityCode NOT IN ('PEPCO-DC','AMEREN','COMED','BGE','PEPCO-MD','CONED','NIMO','NYSEG','RGE','AEPCE','AEPNO','CTPEN','SHARYLAND','TXNMP','TXU','TXU-SESCO'))    
 AND (@p_status_filter              IN ('NONE','','ALL') OR AST.[Status]   = @p_status_filter)    
 AND (@p_sub_status_filter          IN ('NONE','','ALL') OR AST.[SubStatus]  = @p_sub_status_filter)    
 AND (@p_utility_id_filter          IN ('NONE','','ALL') OR f.UtilityCode  = @p_utility_id_filter)    
 AND (@p_retail_mkt_id_filter       IN ('NONE','','ALL') OR M.MarketCode   = @p_retail_mkt_id_filter)    
 AND (@p_account_type_filter        IN ('NONE','','ALL') OR AT.AccountType  = @p_account_type_filter)    
 AND (@p_sales_channel_role_filter  IN ('NONE','','ALL') OR 'SALES CHANNEL/' + SC.ChannelName = @p_sales_channel_role_filter)    
 AND (@p_full_name_filter           IN ('NONE','','ALL') OR h.full_name like '' + @p_full_name_filter+ '%')    
 AND (@p_usage_request_status       IN ('')              OR CASE WHEN UPPER(URS.[Status]) = 'NONE' THEN NULL ELSE UPPER(URS.[Status]) END = @p_usage_request_status)    
 AND (@p_enrollment_type IS NULL OR convert(varchar(10),DETAIL.EnrollmentTypeID) = @p_enrollment_type)    
    
 -- The line below was updated 2007-09-13.  The date_por_enrollment field is being used to store the date when the enrollment should be sent.    
 AND (@p_ready_to_send_status_only  <> 1 OR (CONVERT(VARCHAR(10), AC.SendEnrollmentDate, 111) <= CONVERT(VARCHAR(10), GETDATE(), 111) 
				  AND [Libertypower].[dbo].ufn_GetLegacyAccountStatus(AST.[Status], AST.SubStatus) IN ('05000','06000') AND [Libertypower].[dbo].ufn_GetLegacyAccountSubStatus(AST.[Status], AST.SubStatus)='10'))  
 AND (@p_billing_account_filter     IN ('NONE','','ALL') OR ai.BillingAccount = @p_billing_account_filter)    
 AND (@p_reenroll_and_resendstatus_flag <> 1 OR (    
              ((AST.Status = '13000' AND AST.SubStatus = '60') OR (AST.Status IN ('05000','06000') AND AST.SubStatus = '27'))    
              AND (ASERVICE.EndDate IS NULL OR ASERVICE.EndDate < getdate() )    
              AND AC.SendEnrollmentDate < getdate()    
             )     
  )
 AND (@p_exclude_inactive = 0 OR AST.[Status] NOT IN ('999999','999998','911000'))    
    
/*       
    
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
    
    
    
    
    
    
    
    
    
    
