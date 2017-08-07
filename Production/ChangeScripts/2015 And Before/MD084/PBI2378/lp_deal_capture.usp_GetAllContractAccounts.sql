USE [lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllContractAccounts]    Script Date: 11/02/2012 13:23:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================
-- Author: Jaime Forero
-- Date: 2/8/2012
-- Description: Created function for the queries and reports section of deal capture
-- ============================================================================
-- Author: Cathy Ghazal
-- Date: 11/2/2012
-- Description: use vw_AccountContractRate instead of AccountContractRate
-- ============================================================================
/*

EXEC [dbo].[usp_GetAllContractAccounts] 'libertypower\jforero'


SELECT * FROM [ufn_account_detail_JFORERO]('libertypower\jforero')
--order by account_id;

SELECT * FROM [ufn_AllContractAccounts]('libertypower\CASA', '2000-01-01', '2012-12-31',null) -- ,'10443720006633976') 
where account_number = '10443720006633976'

*/

ALTER PROCEDURE [dbo].[usp_GetAllContractAccounts]
(
	@p_username NCHAR(100)
  , @p_date_start DATETIME = NULL
  , @p_date_end DATETIME = NULL
  , @p_account_number VARCHAR(50) = NULL
  , @p_contract_nbr VARCHAR(50) = NULL
)
AS 

BEGIN

	Set transaction isolation level read uncommitted
		
	--DECLARE @p_username NCHAR(100); SET @p_username   = 'libertypower\I2C'
	--DECLARE @p_date_start DATETIME; SET @p_date_start = '2012-01-01'
	--DECLARE @p_date_end DATETIME  ; SET @p_date_end   = '2012-12-31'
	
	--DECLARE @Channels TABLE (sales_channel_role VARCHAR(100), ChannelID INT, ChannelName VARCHAR(100))
	CREATE TABLE #Channels  (sales_channel_role VARCHAR(100), ChannelID INT, ChannelName VARCHAR(100))
	INSERT INTO #Channels
	SELECT sales_channel_role, ChannelID, ChannelName
	FROM LibertyPower..ChannelUser_vw
	WHERE UserName = @p_username

	Create clustered index idx1 on #Channels(ChannelID) with fillfactor = 100
	
	-- =====================================================================================
	-- Contracts from lp_contract_renewal
	--DECLARE @NewContract TABLE (contract_nbr VARCHAR(12), status VARCHAR(15))
	CREATE TABLE #NewContract (contract_nbr VARCHAR(12), status VARCHAR(15))
	INSERT INTO #NewContract
	SELECT contract_nbr, status
	FROM deal_contract (NOLOCK)
	WHERE sales_channel_role IN (SELECT sales_channel_role FROM #Channels)
	AND contract_nbr = ISNULL(@p_contract_nbr ,contract_nbr )
	AND (@p_date_start IS NULL OR date_deal > @p_date_start)
	AND (@p_date_end IS NULL   OR date_deal < @p_date_end)

	Create clustered index idx1 on #NewContract(contract_nbr) with fillfactor = 100

	-- Contracts from lp_contract_renewal
	--DECLARE @RenewalContract TABLE (contract_nbr VARCHAR(12), status VARCHAR(15))
	CREATE TABLE #RenewalContract (contract_nbr VARCHAR(12), status VARCHAR(15))
	INSERT INTO #RenewalContract
	SELECT contract_nbr, status
	FROM lp_contract_renewal..deal_contract_account (NOLOCK)
	WHERE contract_nbr = ISNULL(@p_contract_nbr ,contract_nbr )
	AND sales_channel_role IN (SELECT sales_channel_role FROM #Channels)
	AND (@p_date_start IS NULL OR date_deal > @p_date_start)
	AND (@p_date_end IS NULL   OR date_deal < @p_date_end)

	Create clustered index idx1 on #RenewalContract(contract_nbr) with fillfactor = 100

	-- =====================================================================================
	-- Contracts from LibertyPower
	
	--DECLARE @ExistingContract TABLE (ContractID INT, Number VARCHAR(12), SalesRep VARCHAR(64), SignedDate DATETIME, sales_channel_role VARCHAR(100), ContractTypeID INT, ContractDealTypeID INT, ContractTemplateID INT, StartDate DATETIME)
	CREATE TABLE #ExistingContract (ContractID INT, Number VARCHAR(12), sales_channel_role VARCHAR(100)) -- , SalesRep VARCHAR(64), SignedDate DATETIME, sales_channel_role VARCHAR(100), ContractTypeID INT, ContractDealTypeID INT, ContractTemplateID INT, StartDate DATETIME)
	INSERT INTO #ExistingContract
	SELECT C.ContractID, C.Number , sales_channel_role -- , C.SalesRep, C.SignedDate, sales_channel_role, C.ContractTypeID, C.ContractDealTypeID, C.ContractTemplateID, C.StartDate
	FROM LibertyPower..[Contract] C WITH (NOLOCK)
	JOIN #Channels SC ON SC.ChannelID = C.SalesChannelId
	WHERE Number = ISNULL(@p_contract_nbr ,Number )
	  AND (@p_date_start IS NULL OR C.SignedDate > @p_date_start)
	  AND (@p_date_end IS NULL   OR C.SignedDate < @p_date_end)

	Create clustered index idx1 on #ExistingContract(ContractID) with fillfactor = 100


	-- Contracts from LibertyPower
	--DECLARE @Account TABLE (AccountID INT, ContractID INT,IsRenewal BIT)
	CREATE TABLE #Account (AccountID INT, ContractID INT,IsRenewal BIT)
		 
	INSERT INTO #Account
	SELECT A.AccountID, A.ContractID, A.IsRenewal
	FROM 
	(SELECT AccountID, CurrentContractID as ContractID, IsRenewal = 0 FROM LibertyPower..Account (NOLOCK) WHERE CurrentContractID IS NOT NULL
	 AND AccountNumber = ISNULL(@p_account_number ,AccountNumber )
	 UNION ALL
	 SELECT AccountID,  CurrentRenewalContractID as ContractID, IsRenewal = 1 FROM LibertyPower..Account (NOLOCK) WHERE CurrentRenewalContractID IS NOT NULL
	 AND AccountNumber = ISNULL(@p_account_number ,AccountNumber )
	 ) A
	JOIN #ExistingContract C ON A.ContractID = C.ContractID
	
	Create clustered index idx1 on #Account(AccountID) with fillfactor = 100
	
	--select count(*) from #NewContract
	--select count(*) from #RenewalContract
	--select count(*) from #ExistingContract
	--select count(*) from #Account

	
	SELECT
		  'DC Account' AS TType , 
		  dca.account_id,
		  dca.account_number,
		  dca.utility_id,
		  account_name                          = d.full_name,
		  customer_name                         = e.full_name,
		  dca.business_activity,
		  dca.business_type,
		  service_address                       = f.address,
		  service_suite                         = f.suite,
		  service_city                          = f.city,
		  service_state                         = f.state,
		  service_zip                           = f.zip,
		  billing_address                       = g.address,
		  billing_suite                         = g.suite,
		  billing_city                          = g.city,
		  billing_state                         = g.state,
		  billing_zip                           = g.zip,
		  billing_first_name                    = h.first_name,
		  billing_last_name                     = h.last_name,
		  billing_title                         = h.title,
		  billing_phone                         = h.phone,
		  billing_fax                           = h.fax,
		  billing_email                         = h.email,   
		  billing_birthday                      = h.birthday,
		  customer_first_name                   = i.first_name,
		  customer_last_name                    = i.last_name,
		  customer_title                        = i.title,
		  customer_phone                        = i.phone,
		  customer_fax                          = i.fax,
		  customer_email                        = i.email,   
		  customer_birthday                     = i.birthday,
		  dca.contract_type,
		  dca.contract_nbr,
		  dca.term_months,
		  dca.product_id,
		  dca.sales_channel_role,
		  dca.sales_rep,
		  date_submit                           = convert(datetime, convert(char(08), dca.date_deal, 112)),
		  annual_usage                          = 0,
		  credit_score                          = 0,
		  status                                = c.status,
		  sub_status                            = ' ',
		  comments = null,
		  category_descp = null,
		  'Not Yet Available' as date_flow_start,
		  dca.retail_mkt_id,
		  isnull(dca.CreditScoreEncrypted, '') CreditScoreEncrypted, -- ADD ticket 17799
		  --begin SD21532
		  dca.rate, 
		  dca.contract_eff_start_date, 
		  dca.date_end,
		  null as date_deenrollment,
		  --end SD21532
		  dca.date_deal
	FROM deal_contract_account dca (NOLOCK) --ON a.account_id = dca.account_id
	JOIN #NewContract c ON dca.contract_nbr = c.contract_nbr
	JOIN deal_name d (NOLOCK)	  ON dca.contract_nbr = d.contract_nbr AND dca.account_name_link = d.name_link
	JOIN deal_name e (NOLOCK)	  ON dca.contract_nbr = e.contract_nbr AND dca.customer_name_link = e.name_link
	JOIN deal_address f (NOLOCK)  ON dca.contract_nbr = f.contract_nbr AND dca.service_address_link = f.address_link
	JOIN deal_address g (NOLOCK)  ON dca.contract_nbr = g.contract_nbr AND dca.billing_address_link = g.address_link
	JOIN deal_contact h (NOLOCK)  ON dca.contract_nbr = h.contract_nbr AND dca.billing_contact_link = h.contact_link
	JOIN deal_contact i (NOLOCK)  ON dca.contract_nbr = i.contract_nbr AND dca.customer_contact_link = i.contact_link
	WHERE (c.status like 'DRAFT%' or c.status = 'RUNNING')
    
	-- ==================================================================================================

	-- account renewals  -----------------------------------------------------------------------------

	UNION
	       
	select
		  'DC Renewal' AS TType ,
		  a.account_id,
		  a.account_number,
		  a.utility_id,
		  account_name                          = d.full_name,
		  customer_name                         = e.full_name,
		  a.business_activity,
		  a.business_type,
		  service_address                       = f.address,
		  service_suite                         = f.suite,
		  service_city                          = f.city,
		  service_state                         = f.state,
		  service_zip                           = f.zip,
		  billing_address                       = g.address,
		  billing_suite                         = g.suite,
		  billing_city                          = g.city,
		  billing_state                         = g.state,
		  billing_zip                           = g.zip,
		  billing_first_name                    = h.first_name,
		  billing_last_name                     = h.last_name,
		  billing_title                         = h.title,
		  billing_phone                         = h.phone,
		  billing_fax                           = h.fax,
		  billing_email                         = h.email,   
		  billing_birthday                      = h.birthday,
		  customer_first_name                   = i.first_name,
		  customer_last_name                    = i.last_name,
		  customer_title                        = i.title,
		  customer_phone                        = i.phone,
		  customer_fax                          = i.fax,
		  customer_email                        = i.email,   
		  customer_birthday                     = i.birthday,
		  a.contract_type,
		  a.contract_nbr,
		  a.term_months,
		  a.product_id,
		  a.sales_channel_role,
		  a.sales_rep,
		  date_submit                           = convert(datetime, convert(char(08), a.date_deal, 112)),
		  annual_usage                          = 0,
		  credit_score                          = 0,
		  status                                = c.status,
		  sub_status                            = ' ',
		  comments = null,
		  category_descp = null,
		  'Not Yet Available' as date_flow_start,
		  a.retail_mkt_id,
		  isnull(a.CreditScoreEncrypted, '') CreditScoreEncrypted, -- ADD ticket 17799
		  --begin SD21532
		  a.rate, 
		  a.contract_eff_start_date, 
		  a.date_end,
		  null as date_deenrollment,
		  --end SD21532
		  a.date_deal
	FROM lp_contract_renewal..deal_contract_account a (NOLOCK) --ON a1.account_id = a.account_id
	JOIN #RenewalContract c ON a.contract_nbr = c.contract_nbr
	JOIN lp_contract_renewal..deal_name d (NOLOCK)    ON a.contract_nbr = d.contract_nbr AND a.account_name_link = d.name_link
	JOIN lp_contract_renewal..deal_name e (NOLOCK)    ON a.contract_nbr = e.contract_nbr AND a.customer_name_link = e.name_link
	JOIN lp_contract_renewal..deal_address f (NOLOCK) ON a.contract_nbr = f.contract_nbr AND a.service_address_link = f.address_link
	JOIN lp_contract_renewal..deal_address g (NOLOCK) ON a.contract_nbr = g.contract_nbr AND a.billing_address_link = g.address_link
	JOIN lp_contract_renewal..deal_contact h (NOLOCK) ON a.contract_nbr = h.contract_nbr AND a.billing_contact_link = h.contact_link
	JOIN lp_contract_renewal..deal_contact i (NOLOCK) ON a.contract_nbr = i.contract_nbr AND a.customer_contact_link = i.contact_link
	WHERE (c.status like 'DRAFT%' or c.status = 'RUNNING')
	
	-- ==================================================================================================       
	       
	UNION
	   
	SELECT
		  'Account' AS TType ,
		  A.AccountIDLegacy AS account_id,
		  A.AccountNumber  AS account_number,
		  UTIL.UtilityCode AS utility_id,
		  account_name                          = e.name,
		  customer_name                         = f.name,
		  BA.Activity AS business_activity,
		  BT.[Type] AS business_type,
		  service_address                       = g.Address1,
		  service_suite                         = g.Address1,
		  service_city                          = g.City,
		  service_state                         = g.State,
		  service_zip                           = g.Zip,
		  billing_address                       = h.Address1,
		  billing_suite                         = h.Address2,
		  billing_city                          = h.City,
		  billing_state                         = h.State,
		  billing_zip                           = h.zip,
		  billing_first_name                    = i.firstname,
		  billing_last_name                     = i.lastname,
		  billing_title                         = i.title,
		  billing_phone                         = i.phone,
		  billing_fax                           = i.fax,
		  billing_email                         = i.email,   
		  billing_birthday                      = '',--convert(varchar(5),month(i.birthdate) + '/' + day(i.birthdate)),
		  customer_first_name                   = j.firstname,
		  customer_last_name                    = j.lastname,
		  customer_title                        = j.title,
		  customer_phone                        = j.phone,
		  customer_fax                          = j.fax,
		  customer_email                        = j.email,   
		  customer_birthday                     = '',--convert(varchar(5),month(j.birthdate) + '/' + day(j.birthdate))
		  LibertyPower.dbo.ufn_GetLegacyContractType(CT.[Type],ContractTemplateID, CDT.DealType)   AS contract_type,
		  CONT.Number AS contract_nbr,
		  CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Term		ELSE AC_DefaultRate.Term	  END AS term_months,
		  CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS product_id,
		  --'SALES CHANNEL/' + SC.ChannelName AS sales_channel_role,
		  TEMP_CONT.sales_channel_role,
		  CONT.SalesRep  AS sales_rep,
		  date_submit                           = convert(datetime, convert(char(08), CONT.SignedDate, 112)),
		  AU.AnnualUsage AS annual_usage,
		  CAST(0 AS REAL)AS credit_score,
		  status                                = c.status_descp,
		  sub_status                            = d.sub_status_descp,
		  comments = 							(select top 1 isnull(process_id, '') + ' - ' +  isnull(comment , '')
												from lp_account..account_comments with (NOLOCK INDEX = account_comments_idx) 
												where account_id = A.AccountIDLegacy and 
													process_id in ('TPV','CREDIT CHECK', 'CHECK ACCOUNT', 'ACCOUNT', 'LETTER')
												order by date_comment desc),

		  category_descp  = case when ltrim(rtrim(isnull(d.category_descp, ''))) = ''
								then  c.status_descp 
								else d.category_descp 
							end ,
		  case when LibertyPower.dbo.ufn_GetLegacyFlowStartDate(AST.[Status],AST.[SubStatus],ASERVICE.StartDate) < '1/1/1901' then 'Not Yet Available'
			   else lp_enrollment.dbo.ufn_date_format(LibertyPower.dbo.ufn_GetLegacyFlowStartDate(AST.[Status],AST.[SubStatus],ASERVICE.StartDate),'<Month> <DD> <YYYY>') end as date_flow_start,
		  MKT.MarketCode AS retail_mkt_id,
		  isnull(CUST.CreditScoreEncrypted, '') CreditScoreEncrypted, -- ADD ticket 17799
		  --begin SD21532
		  CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Rate			ELSE AC_DefaultRate.Rate	  END AS rate, 
		  CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart	ELSE AC_DefaultRate.RateStart END AS contract_eff_start_date,
		  CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd		ELSE AC_DefaultRate.RateEnd   END AS date_end,
		  LibertyPower.dbo.ufn_GetLegacyDateDeenrollment(AST.[Status],AST.[SubStatus],ASERVICE.EndDate)  AS date_deenrollment,
		  --end SD21532
		  CONT.SignedDate AS date_deal
	    --SELECT TOP(10) * 
	FROM #Account TEMP_A  --ON A.AccountIDLegacy = a1.account_id
	JOIN LibertyPower..[Account]  A WITH (NOLOCK) ON TEMP_A.AccountID = A.AccountID 
	JOIN LibertyPower..[AccountContract]  AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND TEMP_A.ContractID = AC.ContractID -- (A.CurrentContractID = AC.ContractID OR A.CurrentRenewalContractID = AC.ContractID)
	JOIN #ExistingContract TEMP_CONT ON AC.ContractID = TEMP_CONT.ContractID
	JOIN LibertyPower..[Contract] CONT ON AC.ContractID = CONT.ContractID
	
	JOIN LibertyPower..[AccountStatus] AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	JOIN lp_account..enrollment_status c with (NOLOCK INDEX = enrollment_status_idx) ON  AST.[Status] = c.[status]
	JOIN lp_account..enrollment_sub_status d with (NOLOCK INDEX = enrollment_sub_status_idx) ON  AST.[Status]= d.[status] AND AST.[SubStatus] = d.sub_status
	JOIN LibertyPower..Customer CUST WITH (NOLOCK)  ON A.CustomerID = CUST.CustomerID
	JOIN LibertyPower..Utility UTIL WITH (NOLOCK)  ON A.UtilityID = UTIL.ID
	JOIN LibertyPower..[ContractType] CT WITH (NOLOCK)  ON CONT.ContractTypeID = CT.ContractTypeID
	JOIN LibertyPower..[ContractDealType] CDT WITH (NOLOCK)  ON CONT.ContractDealTypeID = CDT.ContractDealTypeID
	JOIN LibertyPower..AccountUsage AU WITH (NOLOCK)  ON A.AccountID = AU.AccountID AND AU.EffectiveDate = CONT.StartDate
	JOIN LibertyPower.dbo.vw_AccountContractRate ACR2	WITH (NOLOCK)	ON AC.AccountContractID = ACR2.AccountContractID --AND ACR2.IsContractedRate = 1
	JOIN LibertyPower..Market MKT WITH (NOLOCK)  ON A.RetailMktID = MKT.ID

	--LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)	ON AC.AccountContractID = AC_DefaultRate.AccountContractID AND AC_DefaultRate.IsContractedRate = 0 -- temporary measure, should be changed later
	-- NEW DEFAULT RATE JOIN:
	LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
			   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
			   WHERE ACRR.IsContractedRate = 0 
			   GROUP BY ACRR.AccountContractID
			  ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
	LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
	 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
	-- END NEW DEFAULT RATE JOIN:
	
	LEFT JOIN LibertyPower..BusinessActivity BA WITH (NOLOCK)  ON CUST.BusinessActivityID = BA.BusinessActivityID
	LEFT JOIN LibertyPower..BusinessType BT WITH (NOLOCK)  ON CUST.BusinessTypeID = BT.BusinessTypeID
	LEFT JOIN LibertyPower..Name e  ON A.AccountNameID = e.NameID
	LEFT JOIN LibertyPower..Name f ON CUST.NameID = f.NameID
	LEFT JOIN LibertyPower..Address g ON A.ServiceAddressID = g.AddressID
	LEFT JOIN LibertyPower..Address h ON A.BillingAddressID = h.AddressID
	LEFT JOIN LibertyPower..Contact i ON A.BillingContactID = i.ContactID
	LEFT JOIN LibertyPower..Contact j ON CUST.ContactID = j.ContactID
	LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID

	
END

