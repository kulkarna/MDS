USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_check_account_details]    Script Date: 11/02/2012 10:55:13 ******/
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
-- Cathy Ghazal
-- Modified: 11/02/2012     
-- replaced AccountContractRate with vw_AccountContractRate
-- MD084    
-- =========================================================================    
    
--577411834600001 CONED              
/*

EXEC [usp_account_check_account_details] 50, null, '2012-0009298'


*/
    
ALTER procedure [dbo].[usp_account_check_account_details]    
(
 @p_rec_sel                 INT=50,
 @p_account_number_filter   VARCHAR(30) = 'ALL',    
 @p_contract_nbr_filter     CHAR(12)= 'ALL'
)    
AS    
  Set transaction isolation level read uncommitted  
    
  
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
 [AccountTypeID] [int] NULL,  
 [RetailMktID] [int] NULL,  
 [EntityID] [char](15) NULL,  
 [UtilityID] [int] NULL,  
 [CustomerID] [int] NULL,  
 [BillingTypeID] [int] NULL,  
 [TaxStatusID] [int] NULL
) ON [PRIMARY]  
  
Declare @filtered bit  
    
-- selection by Account  
if @p_account_number_filter NOT IN ('NONE','','ALL') 
 begin  
  
	 Set @filtered = 1  
	   
	 INSERT INTO #Account    
	 SELECT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	 , A.origin, A.PorOption, A.ServiceRateClass, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	 , A.CustomerID, A.BillingTypeID, A.TaxStatusID   
	 FROM LibertyPower..Account A (NOLOCK)    
	 WHERE A.AccountNumber  = @p_account_number_filter  
	  
	 CREATE CLUSTERED INDEX idx1 on #Account  (Accountid)  
	  
	 INSERT INTO #Contract  
		SELECT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
		,C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
		FROM #Account       A  
		JOIN LibertyPower.dbo.AccountContract AC(NOLOCK)ON A.AccountID = AC.AccountID
		JOIN LibertyPower.dbo.Contract   C (NOLOCK)		ON AC.ContractID = C.ContractID
		WHERE (@p_contract_nbr_filter IN ('NONE','','ALL') OR Number = @p_contract_nbr_filter)  

	 CREATE CLUSTERED INDEX idx1 on #Contract (Contractid)  
 end  
  
IF @p_contract_nbr_filter NOT IN ('NONE','','ALL')  AND ISNULL(@filtered, 0) = 0
BEGIN  
	  
	 SET @filtered = 1  
	  
	 INSERT INTO #Contract  
	  SELECT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	  , C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	 FROM LibertyPower..[Contract] C (NOLOCK)    
	 WHERE C.Number = @p_contract_nbr_filter
	     
	 CREATE CLUSTERED INDEX idx1 ON #Contract (Contractid)  
	  
	 INSERT INTO #Account    
	 SELECT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	 , A.origin, A.PorOption, A.ServiceRateClass, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	 , A.CustomerID, A.BillingTypeID, A.TaxStatusID
	 FROM #Contract       C
	 JOIN LibertyPower.dbo.AccountContract AC (NOLOCK) ON C.ContractID = AC.ContractID 
	 JOIN LibertyPower.dbo.Account A		(NOLOCK) ON AC.AccountID = A.AccountID 
	  
	 CREATE CLUSTERED INDEX idx1 ON #Account  (Accountid)  
	   
END  
  
  
if isnull(@filtered,0) = 0  
 begin  
  INSERT INTO #Account    
  SELECT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
  , A.origin, A.PorOption, A.ServiceRateClass, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
  , A.CustomerID, A.BillingTypeID, A.TaxStatusID   
 -- INTO #Account    
  FROM LibertyPower..Account A (NOLOCK) 
     
  --Create clustered index idx1 on #Account  (Accountid)  
    
  Insert INTO #Contract  
  SELECT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
  , C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
  FROM LibertyPower..Contract C (NOLOCK)    
  --join LibertyPower.dbo.AccountContract AC ON C.ContractID = AC.[ContractID]  
  --join #Account       A  on A.AccountID  = AC.AccountID  
 
  Create clustered index idx1 on #Contract (Contractid)  
 end  
  
 set rowcount @p_rec_sel    
    
 SELECT    
 A.AccountIdLegacy AS account_id,    
 A.AccountNumber AS account_number,      
 AT.AccountType AS account_type,    
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
     
 isnull(r.rate_descp, '') rate_descp,    
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
 JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID
              
 JOIN #Contract CONT (NOLOCK) ON AC.ContractID = CONT.ContractID     
 JOIN LibertyPower..[ContractType] CT (NOLOCK) ON CONT.ContractTypeID = CT.ContractTypeID     
 JOIN LibertyPower..ContractTemplateType CTT (NOLOCK) ON CONT.ContractTemplateID = CTT.ContractTemplateTypeID    
 JOIN LibertyPower..AccountStatus AST (NOLOCK) ON AC.AccountContractID = AST.AccountContractID     
 JOIN LibertyPower..AccountContractCommission ACC (NOLOCK) ON AC.AccountContractID = ACC.AccountContractID    
     
 JOIN LibertyPower..vw_AccountContractRate ACR (NOLOCK) ON AC.AccountContractID = ACR.AccountContractID --AND IsContractedRate = 1    
 JOIN LibertyPower..AccountType AT (NOLOCK) ON A.AccountTypeID = AT.ID    
     
 JOIN Libertypower..Market M (NOLOCK) ON A.RetailMktID = M.ID -- AND InactiveInd = 0    
     
 JOIN lp_account..enrollment_status b (NOLOCK) ON AST.[Status] = b.[status]     
 JOIN lp_account..enrollment_sub_status c (NOLOCK) ON AST.[Status] = c.[status] AND AST.SubStatus = c.sub_status     
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
    
     
   WHERE 1=1    
    
    
    
    
    
    
    
    
    
    