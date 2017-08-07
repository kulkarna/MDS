USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_usage_request_sel_list]    Script Date: 11/02/2012 10:36:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
-- =========================================================================    
-- Isabelle Tamanini
-- Created: 5/25/2012
-- usp_account_sel_list refactored for usage_request page only
-- SR1-16151160
-- =========================================================================   
-- =========================================================================    
-- Cathy Ghazal
-- Modified: 11/2/2012
-- use vw_AccountContractRate instead of AccountContractRate
-- MD084
-- =========================================================================   
            
/*

exec lp_account..[usp_account_usage_request_sel_list] @p_username=N'LIBERTYPOWER\itamanini',@p_contract_nbr_filter=N'NONE',
@p_account_number_filter=N'NONE',@p_utility_id_filter=N'CL&P',@p_entity_id_filter=N'LPH            ',
@p_retail_mkt_id_filter=N'CT',@p_usage_request_status=N'pending',@p_exclude_inactive=N'1'

exec lp_account..usp_account_sel_list @p_username=N'LIBERTYPOWER\itamanini',@p_rec_sel=N'0',
@p_contract_nbr_filter=N'NONE',@p_account_id_filter=N'NONE',@p_account_number_filter=N'NONE',
@p_full_name_filter=N'',@p_status_filter=N'NONE',@p_sub_status_filter=N'NONE',@p_utility_id_filter=N'CL&P',
@p_entity_id_filter=N'LPH            ',@p_retail_mkt_id_filter=N'CT',@p_account_type_filter=N'NONE',
@p_sales_channel_role_filter=N'NONE',@p_ready_to_send_status_only=N'0',@p_usage_request_status=N'pending',
@p_exclude_inactive=N'1'


*/
    

ALTER PROCEDURE [dbo].[usp_account_usage_request_sel_list]    
(@p_username                                        nchar(100) ,
 @p_rec_sel                                         INT = 0,    
 @p_account_number_filter                           VARCHAR(30) = 'ALL',    
 @p_contract_nbr_filter                             char(12)= 'ALL',    
 @p_utility_id_filter                               VARCHAR(15)= 'ALL',                                          
 @p_entity_id_filter                                VARCHAR(15)= 'ALL',    
 @p_retail_mkt_id_filter                            VARCHAR(04)= 'ALL',    
 @p_usage_request_status							VARCHAR(20) = '',
 @p_exclude_inactive								BIT = 0  
)    
AS    
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  


IF @p_account_number_filter IN ('NONE','','ALL')
	SET @p_account_number_filter = NULL
IF @p_contract_nbr_filter IN ('NONE','','ALL')
	SET @p_contract_nbr_filter = NULL
IF @p_entity_id_filter IN ('NONE','','ALL')
	SET @p_entity_id_filter = NULL
	
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
IF (@p_account_number_filter IS NOT NULL
	OR @UtilityID IS NOT NULL )
	AND ISNULL(@filtered, 0) = 0  
BEGIN  
	SET @filtered = 1  

	INSERT INTO #Account    
	SELECT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	, A.origin, A.PorOption, A.ServiceRateClass, A.CurrentContractID, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	, A.CustomerID, A.BillingTypeID, A.TaxStatusID    
	FROM LibertyPower..Account A (NOLOCK)    
	WHERE 1=1    
	AND (A.CurrentContractID IS NOT NULL)      
	AND (@p_account_number_filter      IS NULL OR A.AccountNumber  = @p_account_number_filter)    
	AND (@p_entity_id_filter           IS NULL OR A.EntityID   = @p_entity_id_filter)    
	AND (@UtilityID IS NULL OR A.UtilityID = @UtilityID)     

	CREATE CLUSTERED INDEX idx1 ON #Account  (Accountid)  

	INSERT INTO #Contract  
	SELECT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	, C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	FROM LibertyPower.dbo.Contract   C     
	join LibertyPower.dbo.AccountContract AC ON C.ContractID = AC.[ContractID]  
	join #Account A  ON A.AccountID = AC.AccountID  
					AND A.CurrentContractId = AC.ContractID
	WHERE (@p_contract_nbr_filter IS NULL OR Number = @p_contract_nbr_filter)  

	CREATE CLUSTERED INDEX idx1 ON #Contract (Contractid)  
END  

  
IF @p_contract_nbr_filter IS NOT NULL AND ISNULL(@filtered, 0) = 0
BEGIN  
	SET @filtered = 1  

	INSERT INTO #Contract  
	SELECT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	, C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	FROM LibertyPower..Contract C (NOLOCK)    
	WHERE (C.Number = @p_contract_nbr_filter)        
	 
	CREATE CLUSTERED INDEX idx1 on #Contract (Contractid)  

	INSERT INTO #Account    
	SELECT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	, A.origin, A.PorOption, A.ServiceRateClass, A.CurrentContractID, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	, A.CustomerID, A.BillingTypeID, A.TaxStatusID    
	FROM LibertyPower.dbo.Account   A     
	join LibertyPower.dbo.AccountContract AC ON A.AccountID  = AC.AccountID
											AND A.CurrentContractId = AC.ContractID
	join #Contract       C  on C.ContractID = AC.ContractID  
	WHERE 1=1    
	AND (A.CurrentContractID IS NOT NULL)         
	AND (@p_account_number_filter      IS NULL OR A.AccountNumber  = @p_account_number_filter)    
	AND (@p_entity_id_filter           IS NULL OR A.EntityID   = @p_entity_id_filter)    

	CREATE CLUSTERED INDEX idx1 on #Account  (Accountid)  
END  
  

-- default filters  
IF @p_contract_nbr_filter IS NULL
	and @p_account_number_filter IS NULL
	and @p_utility_id_filter='ALL'  
	and @p_entity_id_filter IS NULL
	and @p_retail_mkt_id_filter='ALL'
	AND ISNULL(@filtered, 0) = 0
BEGIN  
	SET @filtered = 1  

	INSERT INTO #Account    
	SELECT top (@p_rec_sel) A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	, A.origin, A.PorOption, A.ServiceRateClass, A.CurrentContractID, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	, A.CustomerID, A.BillingTypeID, A.TaxStatusID    
	FROM LibertyPower..Account A (NOLOCK)    
	WHERE 1=1    
	AND (A.CurrentContractID IS NOT NULL)        
	
	CREATE CLUSTERED INDEX idx1 on #Account  (Accountid)  

	INSERT INTO #Contract  
	SELECT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	, C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	FROM LibertyPower..Contract C (NOLOCK)    
	join LibertyPower.dbo.AccountContract AC ON C.ContractID = AC.[ContractID]  
	join #Account       A  on A.AccountID  = AC.AccountID 
						  AND A.CurrentContractId = AC.ContractID 
	WHERE (@p_contract_nbr_filter IS NULL OR Number = @p_contract_nbr_filter)    

	CREATE CLUSTERED INDEX idx1 on #Contract (Contractid)  
END  

IF isnull(@filtered,0) = 0  
BEGIN  
	INSERT INTO #Account    
	SELECT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	, A.origin, A.PorOption, A.ServiceRateClass, A.CurrentContractID, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	, A.CustomerID, A.BillingTypeID, A.TaxStatusID   
	FROM LibertyPower..Account A (NOLOCK)    
	WHERE 1=1    
	AND (A.CurrentContractID IS NOT NULL )     
	AND (@p_account_number_filter      IS NULL OR A.AccountNumber  = @p_account_number_filter)    
	AND (@p_entity_id_filter           IS NULL OR A.EntityID   = @p_entity_id_filter)    
	
	CREATE CLUSTERED INDEX idx1 on #Account  (Accountid)  

	INSERT INTO #Contract  
	SELECT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	, C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	FROM LibertyPower..Contract C (NOLOCK)    
	join LibertyPower.dbo.AccountContract AC ON C.ContractID = AC.[ContractID]  
	join #Account       A  on A.AccountID  = AC.AccountID  
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
 rate = Round(ACR.Rate,5),     
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
       
 a.origin,    
 h.full_name,       
 CAST(0 AS INT)   AS chgstamp,      
 utility_code = f.UtilityCode    
        
 FROM #Account A (NOLOCK)     
 JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID 
											   AND A.CurrentContractID = AC.ContractID
 JOIN #Contract CONT (NOLOCK) ON AC.ContractID = CONT.ContractID     
 JOIN LibertyPower..[ContractType] CT (NOLOCK) ON CONT.ContractTypeID = CT.ContractTypeID     
 JOIN LibertyPower..ContractTemplateType CTT (NOLOCK) ON CONT.ContractTemplateID = CTT.ContractTemplateTypeID    
 JOIN LibertyPower..AccountStatus AST (NOLOCK) ON AC.AccountContractID = AST.AccountContractID     
     
 JOIN LibertyPower..vw_AccountContractRate ACR (NOLOCK) ON AC.AccountContractID = ACR.AccountContractID --AND IsContractedRate = 1    
 JOIN LibertyPower..AccountType AT (NOLOCK) ON A.AccountTypeID = AT.ID    
     
 JOIN Libertypower..Market M (NOLOCK) ON A.RetailMktID = M.ID -- AND InactiveInd = 0    
     
 JOIN lp_account..enrollment_status b (NOLOCK) ON ([Libertypower].[dbo].ufn_GetLegacyAccountStatus(AST.[Status], AST.SubStatus) = b.[status] )
 
 JOIN lp_account..enrollment_sub_status c (NOLOCK) ON ([Libertypower].[dbo].ufn_GetLegacyAccountStatus(AST.[Status], AST.SubStatus) = c.[status] 
														AND [Libertypower].[dbo].ufn_GetLegacyAccountSubStatus(AST.[Status], AST.SubStatus)  = c.sub_status )
 JOIN lp_common..common_entity d   (NOLOCK) ON A.EntityID = d.entity_id     
 JOIN LibertyPower..Utility f   (NOLOCK) ON A.UtilityID = f.ID    
     
 JOIN LibertyPower.dbo.AccountUsage USAGE (NOLOCK) ON A.AccountID = USAGE.AccountID AND  CONT.StartDate = USAGE.EffectiveDate    
 JOIN LibertyPower.dbo.UsageReqStatus URS (NOLOCK) ON USAGE.UsageReqStatusID = URS.UsageReqStatusID    
     
 JOIN lp_common..common_product g (NOLOCK) ON  ACR.LegacyProductID = g.product_id     
     
 JOIN LibertyPower..Customer CUST (NOLOCK) ON A.CustomerID = CUST.CustomerID     
     
 JOIN lp_account..account_name h (NOLOCK) ON h.AccountNameID = CUST.NameID     
     
 LEFT JOIN LibertyPower.dbo.SalesChannel SC  (NOLOCK) ON CONT.SalesChannelID = SC.ChannelID    
 LEFT JOIN LibertyPower.dbo.[User] USER1   (NOLOCK) ON CONT.CreatedBy = USER1.UserID    
 LEFT JOIN LibertyPower.dbo.CreditAgency CA  (NOLOCK) ON CUST.CreditAgencyID = CA.CreditAgencyID     
 LEFT JOIN Libertypower..BusinessActivity BA  (NOLOCK) ON CUST.BusinessActivityID = BA.BusinessActivityID     
 LEFT JOIN Libertypower..BusinessType BT   (NOLOCK) ON CUST.BusinessTypeID = BT.BusinessTypeID    
 LEFT JOIN LibertyPower.dbo.ContractDealType CDT (NOLOCK) ON CONT.ContractDealTypeID = CDT.ContractDealTypeID    
 LEFT JOIN LibertyPower.dbo.TaxStatus TAX  (NOLOCK) ON A.TaxStatusID = TAX.TaxStatusID    
 LEFT JOIN libertypower.dbo.AccountLatestService ASERVICE (nolock) on A.AccountId = ASERVICE.accountid     
     
   WHERE 1=1    
 AND (@p_utility_id_filter          IN ('NONE','','ALL') OR f.UtilityCode  = @p_utility_id_filter)    
 AND (@p_retail_mkt_id_filter       IN ('NONE','','ALL') OR M.MarketCode   = @p_retail_mkt_id_filter)    
 AND (@p_usage_request_status       IN ('')              OR CASE WHEN UPPER(URS.[Status]) = 'NONE' THEN NULL ELSE UPPER(URS.[Status]) END = @p_usage_request_status)   
 AND (@p_exclude_inactive = 0 OR AST.[Status] NOT IN ('999999','999998','911000'))    


    
    
    
    
