USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_sel_list_usage_request]    Script Date: 11/02/2012 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
-- =========================================================================    
-- Jaime Forero   
-- Modified: 2/14/2012
-- Be able to load the usage per utility/market for the Usage Request Page
-- =========================================================================    
-- =========================================================================    
-- Rafael Vasconcelos   
-- Modified: 3/7/2012
-- Added a filter in the last where clause for not returning contracts with pending or rejected steps.
-- ========================================================================= 
-- =========================================================================    
-- Cathy Ghazal   
-- Modified: 11/2/2012
-- replaced AccountContractRate with vw_AccountContractRate, also for Default Rate, getthe max ID
-- =========================================================================     
/*

 exec usp_account_sel_list_usage_request @p_username= 'libertypower\itamanini'
		, @p_usage_request_status = 'pending'
		, @p_utility_id_filter = 'CONED'  
		,  @p_retail_mkt_id_filter = 'NY'
		, @p_account_number_filter = 'ALL'
 
 exec lp_account..[usp_account_sel_list_bak1] @p_username=N'LIBERTYPOWER\itamanini'
		, @p_rec_sel=N'0' 
--		, @p_utility_id_filter = 'COMED'  
		,  @p_retail_mkt_id_filter = 'MD'
--		, @p_usage_request_status = 'pending'
--		, @p_account_number_filter = '0348051043'
	
*/
 
ALTER PROCEDURE [dbo].[usp_account_sel_list_usage_request]    
(@p_username                                        nchar(100) ,    
 @p_account_number_filter                           VARCHAR(30) = 'ALL',    
 @p_contract_nbr_filter                             char(12)= 'ALL',    
 @p_utility_id_filter                               VARCHAR(15)= 'ALL',                                          
 @p_entity_id_filter                                VARCHAR(15)= 'ALL',    
 @p_retail_mkt_id_filter                            VARCHAR(04)= 'ALL',    
 @p_usage_request_status                         VARCHAR(20) = ''
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
 [ContractID] [int] NULL,  
 [AccountTypeID] [int] NULL,  
 [RetailMktID] [int] NULL,  
 [EntityID] [char](15) NULL,  
 [UtilityID] [int] NULL,  
 [CustomerID] [int] NULL,  
 [BillingTypeID] [int] NULL,  
 [TaxStatusID] [int] NULL ,
 [IsRenewal] BIT NULL
) ON [PRIMARY]  
  
Declare @filtered bit

Declare @utilityId int

-- Normalizing parameters

IF @p_retail_mkt_id_filter IN ('NONE','','ALL') 
	SET @p_retail_mkt_id_filter = NULL
	
IF @p_utility_id_filter NOT IN ('NONE','','ALL') 
	SELECT @utilityId = ID FROM LibertyPower..Utility
	WHERE UtilityCode = @p_utility_id_filter AND InactiveInd = 0
ELSE
	SET @utilityId = NULL;

IF @p_entity_id_filter IN  ('NONE','','ALL')
	SET @p_entity_id_filter = NULL;
	

-- selection by Account  
if @p_account_number_filter NOT IN ('NONE','','ALL') 
 begin  
  
	 Set @filtered = 1  
	   
	 INSERT INTO #Account    
	  SELECT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	  , A.origin, A.PorOption, A.ServiceRateClass, A.ContractID, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	  , A.CustomerID, A.BillingTypeID, A.TaxStatusID ,A.[IsRenewal]
	  FROM LibertyPower..AccountExpanded A (NOLOCK) 
	  JOIN LibertyPower..Market			 M (NOLOCK) ON A.RetailMktId = M.ID 
	  WHERE A.AccountNumber  = @p_account_number_filter  
	  AND ISNULL(@p_entity_id_filter, A.EntityID) = A.EntityID 
	  AND ISNULL(@utilityId, A.UtilityID) = A.UtilityID 
	  AND ISNULL(@p_retail_mkt_id_filter, M.MarketCode) = M.MarketCode
	  AND A.IsRenewal = 0
	  
	 Create clustered index idx1 on #Account  (Accountid)  
	  
	 INSERT INTO #Contract  
	  SELECT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	  , C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	  FROM LibertyPower.dbo.[Contract]  C (NOLOCK)
	  JOIN #Account						A ON A.ContractID  = C.ContractID
	  WHERE (@p_contract_nbr_filter IN ('NONE','','ALL') OR Number = @p_contract_nbr_filter)  
	  
	 Create clustered index idx1 on #Contract (Contractid)  
 end  
  
  
  
IF @p_contract_nbr_filter NOT IN ('NONE','','ALL')  AND ISNULL(@filtered, 0) = 0
 BEGIN  
  
	 Set @filtered = 1  
	  
	 INSERT INTO #Contract  
	  SELECT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	  , C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	  FROM LibertyPower..Contract C (NOLOCK)    
	  WHERE (C.Number = @p_contract_nbr_filter)    
	     
	 Create clustered index idx1 on #Contract (Contractid)  
	  
	 INSERT INTO #Account    
	  SELECT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	  , A.origin, A.PorOption, A.ServiceRateClass, A.ContractID, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	  , A.CustomerID, A.BillingTypeID, A.TaxStatusID ,A.[IsRenewal]
	  FROM LibertyPower..AccountExpanded A (NOLOCK)    
	  JOIN #Contract            C ON C.ContractID = A.ContractID 
	  JOIN LibertyPower..Market M ON M.ID = A.RetailMktId 
	  WHERE
	 	  ISNULL(@p_entity_id_filter, A.EntityID) = A.EntityID 
	  AND ISNULL(@p_retail_mkt_id_filter, M.MarketCode) = M.MarketCode 
	  AND ISNULL(@utilityId, A.UtilityID) = A.UtilityID 
	  AND A.IsRenewal = 0
	  
	 Create clustered index idx1 on #Account  (Accountid)  
   
 END  
  
 -- FOR USAGE WITH Usage Request.aspx page

IF @p_usage_request_status = 'pending' AND ISNULL(@filtered, 0) = 0
 BEGIN  
	  
	 Set @filtered = 1  
	 -- We need to find the 'pending' accounts
	 INSERT INTO #Account    
	  SELECT DISTINCT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	  , A.origin, A.PorOption, A.ServiceRateClass, A.ContractID, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	  , A.CustomerID, A.BillingTypeID, A.TaxStatusID, A.[IsRenewal]  
	  FROM LibertyPower.dbo.AccountExpanded  A (NOLOCK)
	  JOIN LibertyPower.dbo.Contract     C (NOLOCK) ON A.ContractId = C.ContractId
	  JOIN LibertyPower.dbo.AccountUsage AU(NOLOCK) ON A.AccountID = AU.AccountID
												   AND AU.EffectiveDate = C.StartDate
												   AND AU.UsageReqStatusID = 6 --PENDING
	  JOIN LibertyPower..Market			M (NOLOCK) ON M.ID = A.RetailMktId 
	  --select * from LibertyPower.dbo.UsageReqStatus  URS  (NOLOCK) ON AU.UsageReqStatusID = URS.UsageReqStatusID
	  WHERE 
		  ISNULL(@p_entity_id_filter, A.EntityID) = A.EntityID 
	  AND ISNULL(@p_retail_mkt_id_filter, M.MarketCode) = M.MarketCode 
	  AND ISNULL(@utilityId, A.UtilityID) = A.UtilityID 
	  AND A.IsRenewal = 0
	  
	 Create clustered index idx1 on #Account  (Accountid)  
	  
	 INSERT INTO #Contract  
	  SELECT DISTINCT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	  , C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	  FROM LibertyPower.dbo.Contract  C (NOLOCK) 
	  JOIN #Account					 A  ON A.ContractID  = C.ContractID  
	 
	 Create clustered index idx1 on #Contract (Contractid)  
	  
 END  


    
  
IF ISNULL(@filtered,0) = 0  
BEGIN  
	 INSERT INTO #Account    
	  SELECT DISTINCT A.AccountID, A.AccountIdLegacy, A.AccountNumber, A.CustomerIdLegacy, A.DateCreated
	  , A.origin, A.PorOption, A.ServiceRateClass, A.ContractID, A.AccountTypeID, A.RetailMktID, A.EntityID, A.UtilityID
	  , A.CustomerID, A.BillingTypeID, A.TaxStatusID, A.[IsRenewal]  
	  FROM LibertyPower..AccountExpanded A (NOLOCK)
	  JOIN LibertyPower..Market			M (NOLOCK) ON A.RetailMktId = M.ID	  
	  WHERE
		  ISNULL(@p_entity_id_filter, A.EntityID) = A.EntityID 
	  AND ISNULL(@p_retail_mkt_id_filter, M.MarketCode) = M.MarketCode
	  AND ISNULL(@utilityId, A.UtilityID) = A.UtilityID 
	  AND A.IsRenewal = 0 
	     
	  --Create clustered index idx1 on #Account  (Accountid)  
	    
	 INSERT INTO #Contract  
	  SELECT DISTINCT C.Number, C.SalesRep, C.Contractid, C.SignedDate, C.SubmitDate, C.ContractTypeID, C.ContractTemplateID
	  , C.StartDate, C.SalesChannelID, C.CreatedBy, C.SalesManagerID, C.ContractDealTypeID    
	  FROM LibertyPower..Contract C (NOLOCK)    
	  JOIN #Account				  A  on A.ContractID  = C.ContractID  
	  
	 Create clustered index idx1 on #Contract (Contractid)  
 END  
  
 set rowcount 0 --@p_rec_sel    
 
 SELECT  DISTINCT
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
		 --product_id = g.product_descp, 
		 CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS product_id,    
		 
		 rate_id = ACR.RateID,     
		 rate = ACR.Rate,        
		 UPPER(BT.[Type]) AS business_type,      
		 UPPER(BA.Activity) AS business_activity,    
		     
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
		     
		 a.origin ,   
		 h.full_name,    
		 CAST(0 AS INT)   AS chgstamp,   
		 utility_code = f.UtilityCode    
		 
 FROM #Account A (NOLOCK)     
 JOIN LibertyPower..AccountDetail DETAIL (NOLOCK) ON DETAIL.AccountID = A.AccountID    
 JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID 
											   AND A.ContractId = AC.ContractID
 JOIN #Contract CONT (NOLOCK) ON A.ContractID = CONT.ContractID     
 JOIN LibertyPower..[ContractType] CT (NOLOCK) ON CONT.ContractTypeID = CT.ContractTypeID     
 JOIN LibertyPower..ContractTemplateType CTT (NOLOCK) ON CONT.ContractTemplateID = CTT.ContractTemplateTypeID    
 JOIN LibertyPower..AccountStatus AST (NOLOCK) ON AC.AccountContractID = AST.AccountContractID     
 JOIN LibertyPower..AccountContractCommission ACC (NOLOCK) ON AC.AccountContractID = ACC.AccountContractID    
     
 JOIN LibertyPower..vw_AccountContractRate ACR (NOLOCK) ON AC.AccountContractID = ACR.AccountContractID --AND IsContractedRate = 1    
 --LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	(NOLOCK)  ON AC.AccountContractID = AC_DefaultRate.AccountContractID AND AC_DefaultRate.IsContractedRate = 0 -- temporary measure, should be changed later

-- NEW DEFAULT RATE JOIN:
LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
		   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
	       WHERE ACRR.IsContractedRate = 0 
	       GROUP BY ACRR.AccountContractID
          ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
-- END NEW DEFAULT RATE JOIN:



 JOIN LibertyPower..AccountType AT (NOLOCK) ON A.AccountTypeID = AT.ID    
     
 JOIN Libertypower..Market M (NOLOCK) ON A.RetailMktID = M.ID -- AND InactiveInd = 0    
     
 JOIN lp_account..enrollment_status b (NOLOCK) ON AST.[Status] = b.[status]     
 JOIN lp_account..enrollment_sub_status c (NOLOCK) ON AST.[Status] = c.[status] AND AST.SubStatus = c.sub_status     
 JOIN lp_common..common_entity d   (NOLOCK) ON A.EntityID = d.entity_id     
 JOIN LibertyPower..Utility f   (NOLOCK) ON A.UtilityID = f.ID    
     
 JOIN LibertyPower.dbo.AccountUsage USAGE (NOLOCK) ON A.AccountID = USAGE.AccountID AND  CONT.StartDate = USAGE.EffectiveDate    
 JOIN LibertyPower.dbo.UsageReqStatus URS (NOLOCK) ON USAGE.UsageReqStatusID = URS.UsageReqStatusID    
     
 JOIN lp_common..common_product g (NOLOCK) ON  (ACR.LegacyProductID = g.product_id OR ACR.LegacyProductId = 'NA')   
     
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
 --JOIN lp_account..account acctView on A.accountid = acctview.accountid     
WHERE  
 1=1 
 AND NOT EXISTS(SELECT * FROM lp_enrollment..check_account chk WHERE CONT.Number = chk.Contract_nbr AND (chk.approval_status = 'PENDING' OR chk.approval_status = 'REJECTED'))
ORDER BY A.AccountIdLegacy DESC