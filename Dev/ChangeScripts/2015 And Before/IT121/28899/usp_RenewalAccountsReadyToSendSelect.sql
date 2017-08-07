USE lp_account
GO        

-- =============================================        
-- Created: Isabelle Tamanini 12/10/2012        
-- Returns all ready to send renewals based on SendEnrollmentAfter date        
-- and on searching criteria        
-- =============================================        
-- Modified: Isabelle Tamanini 01/02/2013        
-- Removed join with common_product_rate, since rate_descp is not used for this procedure        
-- 1-48422087        
-- =============================================        
-- Modified: Agata Studzinska 02/27/2013        
-- Returns renewals ready to send as soon as they are in 07000-10         
-- unless the utility has a lead time predetermined on UtilityRateLeadTime        
-- Commented out the searching criteria based on SendEnrollmentAFter date        
-- 1-66004641        
-- =============================================         
-- Modified: Agata Studzinska 3/22/2013        
-- Changed the calculation when renewal should be send,        
-- so that it bases on dates from AccountContractRate table insted of Contract tabel        
-- 1-82118122        
--===============================================        
-- Modified: Rafael Vasques 9/2/2013        
-- Chaning the select of the accounts to look only the new table values.      
-- IT 121 Release 2      
--===============================================        
-- Modified: Jennifer Ford 11/4/2013  
-- Removed extra rows of data and table links not used by business  
-- Added distinct to eliminate dupes from list  
--===============================================      
-- Modified: Diogo Lima 12/12/2013        
-- Changing a filter to consider field ScheduledStartDate from AccountSubmissionQueue table      
-- IT 121 Release 4
--===============================================   
         
ALTER PROCEDURE [dbo].[usp_RenewalAccountsReadyToSendSelect]      
(@p_username                                        nchar(100),        
 @p_view                                            varchar(35) = 'contract_eff_start_date',        
 @p_account_number_filter                           varchar(30) = NULL,        
 @p_contract_nbr_filter                             char(12)= NULL,        
 @p_utility_id_filter                               varchar(15)= NULL,                                              
 @p_entity_id_filter                                varchar(15)= NULL,        
 @p_retail_mkt_id_filter                            varchar(04)= NULL        
 )        
as        
  SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
        
-- Pull just the records that are queued to be sent.  This is to boost performance.      
SELECT distinct ACRR2.*    --11/4 added distinct to eliminate dupes from list  
INTO #MiniAccountContractRate      
FROM libertypower..AccountSubmissionQueue asq (nolock)      
JOIN LibertyPower.dbo.vw_AccountContractRate ACRR2 (nolock) on asq.AccountContractRateID = ACRR2.AccountContractRateID      
WHERE asq.EdiStatus = 1 and asq.Category in (2,3)      
   
Create clustered index CIDX1 on #MiniAccountContractRate(AccountContractID) with fillfactor = 100 --11/4       
        
SELECT distinct A.AccountIdLegacy as account_id,      
     A.AccountNumber as account_number,        
     --CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE AT.AccountType END AS account_type, --removed 11/4 JEF       
     ES.status_descp as [status],        
     ESS.sub_status_descp as [sub_status],        
     --ED.entity_descp as entity_id, --removed 11/4 JEF       
     C.Number as contract_nbr,        
     --[Libertypower].[dbo].[ufn_GetLegacyContractType] ( CT.[Type] , CTT.ContractTemplateTypeID, CDT.DealType) AS contract_type, --11/4 JEF       
  M.RetailMktDescp   AS retail_mkt_id,        
  isnull(U.LegacyName, U.FullName)   AS utility_id,         
  g.product_descp AS product_id,        
  --CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateID    ELSE AC_DefaultRate.RateID    END AS rate_id, --11/4 JEF        
  CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Rate     ELSE AC_DefaultRate.Rate    END AS rate,        
     --left(UPPER(isnull(BT.[Type],'NONE')),35)  AS business_type,   --11/4     
  --left(UPPER(isnull(BA.Activity,'NONE')),35)  AS business_activity,  --11/4      
    -- ISNULL(USAGE.AnnualUsage,0) AS annual_usage,  --11/4      
     CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Term  ELSE AC_DefaultRate.Term   END AS term_months,        
   --  'SALES CHANNEL/' + SC.ChannelName AS sales_channel_role, --11/4        
  --USER1.UserName   AS username,   --11/4     
  --C.SalesRep    AS sales_rep,   --11/4     
     CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart  ELSE AC_DefaultRate.RateStart END AS contract_eff_start_date,        
  --CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd ELSE AC_DefaultRate.RateEnd   END AS date_end,        
   --  C.SignedDate   AS date_deal,   --11/4     
  --A.DateCreated   AS date_created,  --11/4      
  --C.SubmitDate   AS date_submit,   --11/4     
    -- LibertyPower.dbo.ufn_GetLegacyFlowStartDate(ACS.[Status], ACS.[SubStatus], ASERVICE.StartDate ) date_flow_start, --11/4        
     asq.ScheduledSendDate AS date_por_enrollment,     --IT121 Diogo Lima   
    -- LibertyPower.dbo.ufn_GetLegacyDateDeenrollment (ACS.[Status], ACS.[SubStatus], ASERVICE.EndDate ) date_deenrollment,   --11/4     
    -- CAST('1900-01-01 00:00:00' AS DATETIME) AS date_reenrollment,    --11/4    
    -- UPPER(TAX.[Status])  AS tax_status,  --11/4      
  --CAST(0 AS INT)   AS tax_rate,   --11/4     
     h.Name as full_name,        
     CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS product_id_key        
INTO #temp        
FROM LibertyPower.dbo.Account A WITH (NOLOCK)        
JOIN LibertyPower.dbo.[Contract] C WITH (NOLOCK)    ON A.CurrentRenewalContractID = C.ContractID        
JOIN LibertyPower.dbo.AccountContract AC WITH (NOLOCK)  ON A.AccountID = AC.AccountID AND A.CurrentRenewalContractID = AC.ContractID        
JOIN LibertyPower.dbo.AccountStatus ACS WITH (NOLOCK)   ON AC.AccountContractID = ACS.AccountContractID        
--JOIN LibertyPower.dbo.vw_AccountContractRate ACR2 WITH (NOLOCK) ON AC.AccountContractID = ACR2.AccountContractID --AND ACR2.IsContractedRate = 1        
JOIN #MiniAccountContractRate ACR2 WITH (NOLOCK) ON AC.AccountContractID = ACR2.AccountContractID      
LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID         
     FROM LibertyPower.dbo.AccountContractRate ACRR WITH (NOLOCK)        
        WHERE ACRR.IsContractedRate = 0         
        GROUP BY ACRR.AccountContractID        
          ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID        
LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate WITH (NOLOCK)          
    ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID         
--JOIN LibertyPower.dbo.ContractType CT   WITH (NOLOCK) ON C.ContractTypeID = CT.ContractTypeID    --11/4    
--JOIN LibertyPower.dbo.Customer CUST    WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID      --11/4  
--JOIN LibertyPower.dbo.ContractTemplateType CTT WITH (NOLOCK) ON C.ContractTemplateID= CTT.ContractTemplateTypeID    --11/4    
--JOIN LibertyPower.dbo.AccountType AT   WITH (NOLOCK) ON A.AccountTypeID = AT.ID          --11/4                        
JOIN LibertyPower.dbo.Utility U   WITH (NOLOCK)   ON A.UtilityID = U.ID        
JOIN LibertyPower.dbo.Market M   WITH (NOLOCK)   ON A.RetailMktID = M.ID        
--LEFT JOIN LibertyPower.dbo.BusinessType BT  WITH (NOLOCK)  ON CUST.BusinessTypeID = BT.BusinessTypeID     --11/4   
--LEFT JOIN LibertyPower.dbo.BusinessActivity BA WITH (NOLOCK)  ON CUST.BusinessActivityID = BA.BusinessActivityID  --11/4      
--LEFT JOIN LibertyPower.dbo.SalesChannel SC  WITH (NOLOCK)  ON C.SalesChannelID = SC.ChannelID                     --11/4   
--LEFT JOIN LibertyPower.dbo.TaxStatus TAX  WITH (NOLOCK)  ON A.TaxStatusID = TAX.TaxStatusID      --11/4  
--LEFT JOIN LibertyPower.dbo.ContractDealType CDT  WITH (NOLOCK) ON C.ContractDealTypeID = CDT.ContractDealTypeID    --11/4    
--JOIN LibertyPower.dbo.AccountUsage USAGE WITH (NOLOCK)  ON A.AccountID = USAGE.AccountID AND  C.StartDate = USAGE.EffectiveDate   --11/4     
--LEFT JOIN LibertyPower.dbo.[User] USER1  WITH (NOLOCK)  ON C.CreatedBy = USER1.UserID        
--LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID               
JOIN enrollment_status ES WITH (NOLOCK) ON [Libertypower].[dbo].ufn_GetLegacyAccountStatus(ACS.[Status], ACS.SubStatus) = ES.[Status]        
JOIN enrollment_sub_status ESS WITH (NOLOCK)  ON [Libertypower].[dbo].ufn_GetLegacyAccountStatus(ACS.[Status], ACS.SubStatus) = ESS.[Status]        
         AND [Libertypower].[dbo].ufn_GetLegacyAccountSubStatus(ACS.[Status], ACS.SubStatus) = ESS.sub_status        
--JOIN lp_common..common_entity ED ON A.EntityId = ED.entity_id    --11/4    
--JOIN Libertypower..common_retail_market_table x with (nolock) on x.retail_mkt_id = A.RetailMktId        
--JOIN lp_common..common_retail_market e with (NOLOCK) on e.retail_mkt_id = x.retail_mkt_id and e.wholesale_mkt_id = x.wholesale_mkt_id        
JOIN lp_common..common_product g WITH (NOLOCK) ON (CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL         
          THEN ACR2.LegacyProductID         
          ELSE AC_DefaultRate.LegacyProductID         
          END ) = g.product_id        
LEFT JOIN lp_account.dbo.[vw_AccountAddressNameContactIds] AddConNam WITH (NOLOCK) ON A.AccountID = AddConNam.AccountID -- this way boosts 100ms less        
        
JOIN Libertypower..Name h WITH (NOLOCK) ON a.AccountNameID = h.NameID       
LEFT JOIN Libertypower..UtilityRateLeadTime RLT WITH (NOLOCK) ON RLT.UtilityID = U.ID        
left join libertypower..AccountSubmissionQueue asq  with(nolock) on asq.AccountContractRateID = ACR2.AccountContractRateID      
        
WHERE  1=1        
--#Rafael Vasques it 121 Change Begin      
--and ACS.[Status] = '07000' AND ACS.SubStatus = '10'        
--and asq.EdiStatus = 1      
--and AC.SendEnrollmentDate <= getdate()        
--and ((RLT.LeadTime IS NULL) OR (dateadd(dd, -COALESCE(RLT.LeadTime,0), (CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart  ELSE AC_DefaultRate.RateStart END)) <= GETDATE())) --1-66004641, 1-82118122        
-- Begin IT121 Diogo Lima
and (asq.ScheduledSendDate <= GETDATE())
-- End IT121 Diogo Lima
--#Rafael Vasques it 121 Change End      
and isnull(@p_contract_nbr_filter, C.Number) = C.Number        
and isnull(@p_account_number_filter, A.AccountNumber) = A.AccountNumber        
and isnull(@p_utility_id_filter, U.UtilityCode) = U.UtilityCode        
and isnull(@p_entity_id_filter, A.EntityId) = A.EntityId        
and isnull(@p_retail_mkt_id_filter, M.MarketCode) = M.MarketCode        
        
DECLARE @sql VARCHAR(MAX)        
        
SET @sql = 'SELECT top 50 t.* --, r.rate_descp        
   FROM #temp t        
   --JOIN lp_common..common_product_rate r WITH (NOLOCK) ON t.product_id_key = r.product_id and t.rate_id = r.rate_id        
   Order BY '+ @p_view        
         
EXEC(@sql)        
         
SET NOCOUNT OFF; 