USE [lp_account]

GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  
-- =============================================  
  
-- Author: Rick Deigsler  
  
-- Create date: 3/22/2007  
  
-- Description: Select account renewal information  
  
-- =================================================  
  
-- Isabelle Tamanini  
  
-- Modified: 04/21/2010 to add the Encrypted Fields  
  
-- =================================================  
  
-- Cathy Ghazal  
  
-- Modified: 05/17/2012 to add ContractID and AccountID_Key  
  
-- exec usp_account_renewal_sel 'libertypower\dmarino', 'ACCS-0038826'  
  
-- =================================================  
  
-- Isabelle Tamanini  
  
-- Modified: 09/06/2012  
  
-- Get payment terms from the utility  
  
-- 1-25299925  
  
-- =============================================  
-- Modify : Thiago Nogueira  
-- Date : 7/25/2013   
-- Ticket: 1-179692237  
-- Changed PriceID to BIGINT  
-- =============================================  
-- Modify: Agata Studzinska
-- Date 12/24/2013
-- SR1-312095281
-- Changed default payment terms from 15 to 16.
-- Replaced views by legacy tables.
-- =============================================
-- Modify : Diogo Lima
-- Date : 12/11/2013 
-- Project: IT121
-- Get Send Enrollment After Date from AccountSubmissionQueue table.
-- =============================================
  
ALTER PROCEDURE [dbo].[usp_account_renewal_sel_new]  
(
@p_username nchar(100) = '',  
@p_account_id varchar(12) = 'NONE',  
@p_account_number varchar(30) = 'NONE')  
  
AS  
  
SET NOCOUNT ON  
  
IF @p_account_id = 'NONE'  
  
BEGIN  
  
--select @p_account_id = account_id  
--from account_renewal with (NOLOCK)   
--where @p_account_number = account_number  

SELECT @p_account_id = A.AccountIdLegacy 
FROM Libertypower..Contract C WITH (NOLOCK) 
JOIN Libertypower..AccountContract  AC WITH (NOLOCK) ON AC.AccountContractID = C.ContractID
JOIN Libertypower..Account A WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentRenewalContractID = c.ContractID
WHERE @p_account_number = A.AccountNumber
  
END  
  
DECLARE @w_account_name_link int   
DECLARE @w_account_name varchar(100) 
DECLARE @w_customer_address_link int  
DECLARE @w_customer_address varchar(50) 
DECLARE @w_customer_suite varchar(10)  
DECLARE @w_customer_city varchar(28)  
DECLARE @w_customer_state varchar(02)  
DECLARE @w_customer_zip varchar(10)  
DECLARE @w_ISTA_account_number varchar(100)  
DECLARE @w_customer_contact_link int  
DECLARE @w_customer_first_name varchar(50)  
DECLARE @w_customer_last_name varchar(50)  
DECLARE @w_customer_title varchar(20)  
DECLARE @w_customer_phone varchar(20)  
DECLARE @w_customer_fax varchar(20)  
DECLARE @w_customer_email nvarchar(256)  
DECLARE @w_customer_birthday char(05)  
DECLARE @w_billing_address_link int  
DECLARE @w_billing_address varchar(50)  
DECLARE @w_billing_suite varchar(10)  
DECLARE @w_billing_city varchar(28)  
DECLARE @w_billing_state varchar(02)  
DECLARE @w_billing_zip varchar(10)  
DECLARE @w_billing_contact_link int  
DECLARE @w_billing_first_name varchar(50)  
DECLARE @w_billing_last_name varchar(50)  
DECLARE @w_billing_title varchar(20)  
DECLARE @w_billing_phone varchar(20)  
DECLARE @w_billing_fax varchar(20)  
DECLARE @w_billing_email nvarchar(256)  
DECLARE @w_billing_birthday varchar(05)  
DECLARE @w_owner_name_link int  
DECLARE @w_owner_name varchar(100)  
DECLARE @w_service_address_link int  
DECLARE @w_service_address varchar(50)  
DECLARE @w_service_suite varchar(10)  
DECLARE @w_service_city varchar(28)  
DECLARE @w_service_state varchar(02)  
DECLARE @w_service_zip varchar(10)  

  
SELECT @w_account_name = ''  
SELECT @w_customer_address = ''  
SELECT @w_customer_suite = ''  
SELECT @w_customer_city = ''  
SELECT @w_customer_state = 'NN'  
SELECT @w_customer_zip = ''  
SELECT @w_customer_first_name = ''  
SELECT @w_customer_last_name = ''  
SELECT @w_customer_title = ''  
SELECT @w_customer_phone = ''  
SELECT @w_customer_fax = ''  
SELECT @w_customer_email = ''  
SELECT @w_customer_birthday = 'NONE'  
SELECT @w_billing_first_name = ''  
SELECT @w_billing_last_name = ''  
SELECT @w_billing_title = ''  
SELECT @w_billing_phone = ''  
SELECT @w_billing_fax = ''  
SELECT @w_billing_email = ''  
SELECT @w_billing_birthday = 'NONE'  
SELECT @w_billing_address = ''  
SELECT @w_billing_suite = ''  
SELECT @w_billing_city = ''  
SELECT @w_billing_state = 'NN'  
SELECT @w_billing_zip = ''  
SELECT @w_owner_name = ''  
SELECT @w_service_address = ''  
SELECT @w_service_suite = ''  
SELECT @w_service_city = ''  
SELECT @w_service_state = 'NN'  
SELECT @w_service_zip = ''  
  
IF @w_account_name_link <> 0  
BEGIN  
	SELECT @w_account_name = full_name  
	FROM account_renewal_name WITH (NOLOCK)  
	WHERE account_id = @p_account_id  
	AND name_link = @w_account_name_link  
END  
  
IF @w_customer_address_link <> 0  
BEGIN  
	SELECT  @w_customer_address = address,  
			@w_customer_suite = suite,  
			@w_customer_city = city,  
			@w_customer_state = state,  
			@w_customer_zip = zip  
	FROM account_renewal_address with (NOLOCK)  
	WHERE account_id = @p_account_id  
	AND address_link = @w_customer_address_link  
END  
  
IF @w_customer_contact_link <> 0  
BEGIN 
	SELECT  @w_customer_first_name = first_name,  
			@w_customer_last_name = last_name,  
			@w_customer_title = title,  
			@w_customer_phone = phone,  
			@w_customer_fax = fax,  
			@w_customer_email = email,  
			@w_customer_birthday = birthday  
	FROM account_renewal_contact WITH (NOLOCK)  
	WHERE account_id = @p_account_id  
	AND contact_link = @w_customer_contact_link  
END  
  
IF @w_billing_contact_link <> 0  
BEGIN 
	SELECT  @w_billing_first_name = first_name,  
			@w_billing_last_name = last_name,  
			@w_billing_title = title,  
			@w_billing_phone = phone,  
			@w_billing_fax = fax,  
			@w_billing_email = email,  
			@w_billing_birthday = birthday  
	FROM account_renewal_contact with (NOLOCK)  
	WHERE account_id = @p_account_id  
	AND contact_link = @w_billing_contact_link  
END  
  
IF @w_billing_address_link <> 0  
BEGIN 
	SELECT	@w_billing_address = address,  
			@w_billing_suite = suite,  
			@w_billing_city = city,  
			@w_billing_state = state,  
			@w_billing_zip = zip  
	FROM account_renewal_address WITH (NOLOCK)  
	WHERE account_id = @p_account_id  
	AND address_link = @w_billing_address_link  
END  
  
IF @w_owner_name_link <> 0  
BEGIN 
	SELECT @w_owner_name = full_name  
	FROM account_renewal_name WITH (NOLOCK)  
	WHERE account_id = @p_account_id  
	AND name_link = @w_owner_name_link  
END
  
IF @w_service_address_link <> 0  
BEGIN  
	SELECT  @w_service_address = address,  
			@w_service_suite = suite,  
			@w_service_city = city,  
			@w_service_state = state,  
			@w_service_zip = zip  
	FROM account_renewal_address WITH (NOLOCK)  
	WHERE account_id = @p_account_id  
	AND address_link = @w_service_address_link  
END 
  
--begin 1-1175782  
DECLARE @w_version_code varchar(50)  
DECLARE @w_template_name varchar(150)  
DECLARE @w_contract_nbr char(12)  
DECLARE @w_deal_date datetime  
  
SELECT @w_contract_nbr = c.Number, @w_deal_date = C.SignedDate 
FROM Libertypower..Contract C WITH (NOLOCK) 
JOIN Libertypower..AccountContract  AC WITH (NOLOCK) ON AC.AccountContractID = C.ContractID
JOIN Libertypower..Account A WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentRenewalContractID = c.ContractID
WHERE A.AccountIdLegacy = @p_account_id 

-- Begin IT121 Diogo Lima 
declare @w_ScheduledSendDate datetime = null

select top 1 @w_ScheduledSendDate = asq.ScheduledSendDate
from Libertypower..Account a with (NOLOCK)
inner join Libertypower..AccountContract ac with (NOLOCK) on a.AccountID = ac.AccountID and a.CurrentRenewalContractID = ac.ContractID
inner join Libertypower..AccountContractRate acr with (NOLOCK) on acr.AccountContractID = ac.AccountContractID
inner join Libertypower..AccountSubmissionQueue asq with (NOLOCK) on acr.AccountContractRateID = asq.AccountContractRateID
where a.AccountIdLegacy = @p_account_id
order by acr.DateCreated desc
-- End IT121 Diogo Lima
 
  
SELECT TOP 1 @w_version_code = tv.VersionCode,  
			 @w_template_name = dt.template_name  
FROM lp_documents..document_history dh WITH (NOLOCK)  
LEFT JOIN lp_documents..TemplateVersions tv WITH (NOLOCK) ON tv.TemplateVersionId = dh.templateVersionId  
INNER JOIN lp_documents..document_template dt WITH (NOLOCK) ON tv.TemplateId = dt.template_id  
WHERE dh.document_type_id = 1  
AND dh.templateVersionId IS NOT NULL  
AND (dh.contract_nbr = @w_contract_nbr OR dh.account_id = @p_account_id)  
ORDER BY dh.date_created DESC  
--end 1-1175782  
  
goto_select:  
  
DECLARE @PriceID bigint,  
		@PriceTier int  
    
SET @PriceTier = 0  
    
--SELECT @PriceID = PriceID  
--FROM lp_account..account_renewal WITH (NOLOCK)  
--WHERE account_id = @p_account_id 
 
SELECT @PriceID = ACR2.PriceID 
FROM Libertypower..Account A WITH (NOLOCK) 
JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID  AND A.CurrentRenewalContractID = AC.ContractID
JOIN Libertypower..Contract CON WITH (NOLOCK) ON CON.ContractID = AC.ContractID
JOIN LibertyPower.dbo.vw_AccountContractRate ACR2  WITH (NOLOCK) ON AC.AccountContractID = ACR2.AccountContractID  
WHERE a.AccountIdLegacy = @p_account_id 

IF @PriceID IS NOT NULL  
 BEGIN  
  SELECT @PriceTier = PriceTier  
  FROM Libertypower..Price WITH (NOLOCK)  
  WHERE ID = @PriceID  
END 

SELECT A.AccountIdLegacy AS account_id, 
	   ACR2.LegacyProductID AS product_id
INTO #a_old
FROM Libertypower..Account A WITH (NOLOCK) 
JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID  AND A.CurrentContractID = AC.ContractID
JOIN Libertypower..Contract CON WITH (NOLOCK) ON CON.ContractID = AC.ContractID
JOIN LibertyPower.dbo.vw_AccountContractRate ACR2  WITH (NOLOCK) ON AC.AccountContractID = ACR2.AccountContractID  
WHERE  a.AccountIdLegacy = @p_account_id

SELECT  A.AccountIdLegacy AS account_id, 
		A.AccountTypeID AS AccountTypeID,
CASE WHEN ACCT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE ACCT.AccountType END AS account_type
INTO #AccountType
FROM Libertypower..Account A WITH (NOLOCK) 
JOIN LibertyPower.dbo.AccountType ACCT WITH (NOLOCK) ON  A.AccountTypeID = ACCT.ID 
WHERE a.AccountIdLegacy = @p_account_id

SELECT A.AccountIdLegacy AS account_id,
	   BILLTYPE.BillingTypeID AS BillingTypeID,
	   BILLTYPE.[Type] AS billing_type
INTO #BillingType
FROM Libertypower..Account A WITH (NOLOCK) 
LEFT JOIN LibertyPower.dbo.BillingType BILLTYPE WITH (NOLOCK) ON  A.BillingTypeID = BILLTYPE.BillingTypeID 
WHERE a.AccountIdLegacy = @p_account_id
  
SELECT a.AccountIdLegacy as account_id,    
a.AccountNumber as account_number,    
ic.custno,    
ACCT.account_type,
status = ltrim(rtrim(ASS.status)),    
sub_status = ltrim(rtrim(ASS.SubStatus)),    
a.CustomerIdLegacy AS customer_id,    
entity_id = ltrim(rtrim(A.EntityID)),  
CON.Number as contract_nbr,
CASE WHEN UPPER(CT.[Type]) = 'VOICE' THEN UPPER(CT.[Type]) + CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL' ELSE '' END         
    WHEN CTT.ContractTemplateTypeID = 2 THEN 'CORPORATE' + CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL' ELSE '' END -- id 2: custom template        
    WHEN UPPER(CT.[Type]) = 'PAPER' THEN UPPER(CT.[Type]) + CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL' ELSE '' END         
    WHEN UPPER(CT.[Type]) = 'EDI' THEN 'POWER MOVE'         
    ELSE UPPER(CT.[Type]) END AS contract_type,    
retail_mkt_id = rtrim(ltrim(mkt.MarketCode)),  
utility_id = rtrim(ltrim(c.UtilityCode)),  
product_id = rtrim(ltrim(ACR2.LegacyProductID)),  
ACR2.RateID as rate_id,  
ACR2.Rate as rate,  
  
ISNULL(AddConNam.customer_name_link, 0) AS customer_name_link,   
customer_name = z.full_name,    

ISNULL(AddConNam.customer_address_link, 0) AS customer_address_link,  
customer_address = @w_customer_address,  
customer_suite = @w_customer_suite,  
customer_city = @w_customer_city,  
customer_state = @w_customer_state,  
customer_zip = @w_customer_zip,  
  
ISNULL(AddConNam.customer_contact_link, 0) AS customer_contact_link,  
customer_first_name = @w_customer_first_name,  
customer_last_name = @w_customer_last_name,  
customer_title = @w_customer_title,  
customer_phone = @w_customer_phone,    
customer_fax = @w_customer_fax,  
customer_email = @w_customer_email,  
customer_birthday = ltrim(rtrim(@w_customer_birthday)),  
  
ISNULL(AddConNam.billing_address_link, 0) AS billing_address_link,  
billing_address = @w_billing_address,  
billing_suite = @w_billing_suite,  
billing_city = @w_billing_city,  
billing_state = @w_billing_state,  
billing_zip = @w_billing_zip,  
  
ISNULL(AddConNam.billing_contact_link, 0) AS billing_contact_link,  
billing_first_name = @w_billing_first_name,  
billing_last_name = @w_billing_last_name,  
billing_title = @w_billing_title,  
billing_phone = @w_billing_phone,  
billing_fax = @w_billing_fax,  
billing_email = @w_billing_email,  
billing_birthday = ltrim(rtrim(@w_billing_birthday)),  
  
ISNULL(AddConNam.owner_name_link, 0) AS owner_name_link,  
owner_name = @w_owner_name,  
  
ISNULL(AddConNam.service_address_link, 0) AS service_address_link,  
service_address = @w_service_address,  
service_suite = @w_service_suite,  
service_city = @w_service_city,  
service_state = @w_service_state,  
service_zip = @w_service_zip,  
  
LEFT(UPPER(ISNULL(BT.[Type], 'NONE')), 35) AS business_type,         
LEFT(UPPER(ISNULL(BA.Activity, 'NONE')), 35) AS business_activity,     
  
CASE WHEN LTRIM(RTRIM(CUST.Duns)) <> '' THEN 'DUNSNBR'         
    WHEN LTRIM(RTRIM(CUST.EmployerId)) <> '' THEN 'EMPLID'         
    WHEN LTRIM(RTRIM(CUST.TaxId)) <> '' THEN 'TAX ID'         
    ELSE CASE WHEN CUST.SsnEncrypted IS NOT NULL AND CUST.SsnEncrypted != '' THEN 'SSN'         
    ELSE 'NONE' END END AS additional_id_nbr_type, 
  
CASE WHEN LTRIM(RTRIM(CUST.Duns)) <> '' THEN CUST.Duns         
    WHEN LTRIM(RTRIM(CUST.EmployerId)) <> '' THEN CUST.EmployerId         
    WHEN LTRIM(RTRIM(CUST.TaxId)) <> '' THEN CUST.TaxId         
    ELSE CASE WHEN CUST.SsnEncrypted IS NOT NULL AND CUST.SsnEncrypted != '' THEN '***-**-****'  ELSE 'NONE' END END AS additional_id_nbr,  
  
ACR2.RateStart as contract_eff_start_date, 
ACR2.Term as term_months,  
ACR2.RateEnd as date_end,  
Con.SignedDate as date_deal,  
A.DateCreated as date_created,  
CON.SubmitDate as date_submit,  
'SALES CHANNEL/' + SC.ChannelName AS sales_channel_role,  
USER1.UserName AS username,  
CON.SalesRep AS sales_rep,  
A.origin,  
  
--IsNull(a.annual_usage,0) as annual_usage,  
  
USAGE.AnnualUsage AS annual_usage,  
ASERVICE.StartDate AS date_flow_start,  
IsNull(@w_ScheduledSendDate,ac.SendEnrollmentDate) as date_por_enrollment, -- IT121 Diogo Lima   
ASERVICE.EndDate AS date_deenrollment,  
CAST('1900-01-01 00:00:00' AS DATETIME) AS date_reenrollment,  
  
UPPER(TAX.[Status]) AS tax_status,         
CAST(0 AS INT) AS tax_rate, --TODO        
CAST(0 AS INT) AS credit_score, --TODO 

CASE WHEN CA.Name IS NULL THEN 'NONE' ELSE UPPER(CA.Name) END AS credit_agency, 
  
--a.SSNEncrypted, -- Added for IT002  
--a.CreditScoreEncrypted, -- Added for IT002  
CUST.SsnEncrypted AS SSNEncrypted,         
CUST.CreditScoreEncrypted AS CreditScoreEncrypted,
  
c.Field01Label field_01_label,  
c.Field01Type field_01_type,  
b.field_01_value,  
c.field02label field_02_label,  
c.field02type field_02_type,  
b.field_02_value,  
c.field03label field_03_label,  
c.field03type field_03_type,  
b.field_03_value,  
c.field04label field_04_label,  
c.field04type field_04_type,  
b.field_04_value,  
c.field05label field_05_label,  
c.field05type field_05_type,  
b.field_05_value,  
c.field06label field_06_label,  
c.field06type field_06_type,  
b.field_06_value,  
c.field07label field_07_label,  
c.field07type field_07_type,  
b.field_07_value,  
c.field08label field_08_label,  
c.field08type field_08_type,  
b.field_08_value,  
c.field09label field_09_label,  
c.field09type field_09_type,  
b.field_09_value,  
c.field10label field_10_label,  
c.field10type field_10_type,  
b.field_10_value,  
rate_code = '',  
  
CASE WHEN A.PorOption = 1 THEN 'YES' ELSE 'NO' END AS por_option,  
BILLTYPE.billing_type AS billing_type,  

renewal_plan_type = case when ltrim(rtrim(p.product_category)) = 'FIXED' then 1  
					when ltrim(rtrim(p.product_sub_category)) = 'PORTFOLIO' then 2  
					when ltrim(rtrim(p.product_sub_category)) = 'CUSTOM' then 3  
					when ltrim(rtrim(p.product_sub_category)) = 'BLOCK-INDEX' then 3  
					when ltrim(rtrim(p.product_sub_category)) = 'FIXED ADDER' then 6  
					else 0 end,  
  
old_plan_type = case when ltrim(rtrim(p_old.product_category)) = 'FIXED' then 1  
				when ltrim(rtrim(p_old.product_sub_category)) = 'PORTFOLIO' then 2  
				when ltrim(rtrim(p_old.product_sub_category)) = 'CUSTOM' then 3  
				when ltrim(rtrim(p_old.product_sub_category)) = 'BLOCK-INDEX' then 3  
				when ltrim(rtrim(p_old.product_sub_category)) = 'FIXED ADDER' then 6  
				else 0 end,  
  
p.product_category,    
p.product_sub_category,  
CAST(0 AS INT) AS chgstamp
--begin 1-1175782  
,VersionCode = @w_version_code  
,TemplateName = @w_template_name  
--end 1-1175782  
--Begin Ticket 1-14644158  
,ISNULL(mktx.SalesTax,0) as SalesTax  
--End Ticket 1-14644158  
,CON.ContractID as ContractID_key
,A.AccountID AS AccountID_Key  
  -- new fields added below this line --------------------------------------------------------  
,A.AccountID  
,db_group = 0  
 --,py.paymentTerm -- ticket 8139  
,paymentTerm = CASE WHEN (py.paymentTerm = 0) or (py.paymentTerm is null) then isnull(up.[ARTerms], 16)  --SR1-312095281
               ELSE py.paymentTerm END  
  
,c.field11label field_11_label -- added this for INF95-INF40 merge  
,c.field11type field_11_type -- added this for INF95-INF40 merge  
,b.field_11_value-- added this for INF95-INF40 merge  
,c.field12label field_12_label -- added this for INF95-INF40 merge  
,c.field12type field_12_type -- added this for INF95-INF40 merge  
,b.field_12_value-- added this for INF95-INF40 merge  
,c.field13label field_13_label -- added this for INF95-INF40 merge  
,c.field13type field_13_type -- added this for INF95-INF40 merge  
,b.field_13_value-- added this for INF95-INF40 merge  
,c.field14label field_14_label -- added this for INF95-INF40 merge  
,c.field14type field_14_type -- added this for INF95-INF40 merge  
,b.field_14_value-- added this for INF95-INF40 merge  
,c.field15label field_15_label -- added this for INF95-INF40 merge  
,c.field15type field_15_type -- added this for INF95-INF40 merge  
,b.field_15_value-- added this for INF95-INF40 merge  
  
,A.Zone  
,A.ServiceRateClass as service_rate_class  
,A.StratumVariable as stratum_variable  
,A.BillingGroup as billing_group  
,A.Icap  
,A.Tcap  
,A.LoadProfile as load_profile  
,A.LossCode as loss_code  
,A.MeterTypeID as meter_type  
,PriceTier = @PriceTier  
,acr2.PriceID  
,at.account_type_id AS AccountTypeID  
,pr.rate_descp  
,accl.LanguageId  
,ac.RequestedStartDate AS requested_flow_start_date  
,ad.EnrollmentTypeID AS enrollment_type  
,t2.name_key NameKey  
,t2.BillingAccount  
,t1.old_account_number as LegacyAccount  
  
--FROM account_renewal a WITH (NOLOCK)  
FROM Libertypower..Account A WITH (NOLOCK) 
JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID  AND A.CurrentRenewalContractID = AC.ContractID
JOIN Libertypower..Contract CON WITH (NOLOCK) ON CON.ContractID = AC.ContractID
JOIN LibertyPower.dbo.vw_AccountContractRate ACR2  WITH (NOLOCK) ON AC.AccountContractID = ACR2.AccountContractID
JOIN Libertypower..AccountStatus ASS WITH (NOLOCK) ON ASS.AccountContractID = AC.AccountContractID
JOIN Libertypower..Utility C WITH (NOLOCK) ON a.UtilityID = c.ID
JOIN lp_common..common_product p WITH (NOLOCK) ON ACR2.LegacyProductID = p.product_id
LEFT JOIN account_additional_info b WITH (NOLOCK) ON a.AccountIdLegacy = b.account_id  
LEFT JOIN dbo.vw_AccountAddressNameContactIds AddConNam WITH (NOLOCK) ON  A.AccountID = AddConNam.AccountID
LEFT JOIN dbo.account_renewal_name z WITH (NOLOCK) ON z.account_id = a.AccountIdLegacy AND z.name_link = AddConNam.customer_name_link 
--JOIN account a_old ON a.account_id = a_old.account_id  
JOIN #a_old WITH (NOLOCK) ON a.AccountIdLegacy = #a_old.account_id  
JOIN lp_common..common_product p_old WITH (NOLOCK) ON #a_old.product_id = p_old.product_id  
LEFT JOIN ISTA.dbo.Premise ip WITH (NOLOCK) ON A.AccountNumber = ip.premno  
LEFT JOIN ISTA.dbo.Customer ic WITH (NOLOCK) ON ip.custid = ic.custid  
--Begin Ticket 1-14644158  
LEFT JOIN LibertyPower..Market mkt WITH (NOLOCK) ON A.RetailMktID = mkt.ID  
LEFT JOIN LibertyPower..MarketSalesTax mktx WITH (NOLOCK) ON mkt.ID = mktx.MarketID AND (@w_deal_date BETWEEN mktx.EffectiveStartDate AND ISNULL(mktx.EffectiveEndDate, GETDATE()))  
--End Ticket 1-14644158  
JOIN #AccountType ACCT WITH (NOLOCK) ON  A.AccountTypeID = ACCT.AccountTypeID
LEFT JOIN AccountPaymentTerm py WITH (NOLOCK) on a.AccountIdLegacy = py.accountId   
LEFT JOIN lp_common..product_account_type at WITH (NOLOCK) on left(ltrim(rtrim(ACCT.account_type)), 3) = left(ltrim(rtrim(at.account_type)), 3)  
LEFT JOIN lp_common..common_product_rate pr WITH (NOLOCK) on ACR2.LegacyProductID  = pr.product_id and acr2.RateID = pr.rate_id  
LEFT JOIN account_number_history t1 WITH (NOLOCK) on a.AccountIdLegacy = t1.account_id   
LEFT JOIN account_info t2 WITH (NOLOCK) on a.AccountIdLegacy = t2.account_id  
JOIN LibertyPower.dbo.ContractType CT   WITH (NOLOCK) ON CON.ContractTypeID = CT.ContractTypeID  
JOIN LibertyPower.dbo.AccountDetail ad  WITH (NOLOCK) ON ad.AccountID = A.AccountID  
  
LEFT JOIN LibertyPower..AccountLanguage accl (NOLOCK) on a.AccountNumber = accl.AccountNumber  
LEFT JOIN LibertyPower.dbo.ContractDealType CDT WITH (NOLOCK) ON CON.ContractDealTypeID = CDT.ContractDealTypeID 
JOIN LibertyPower.dbo.ContractTemplateType CTT WITH (NOLOCK) ON  CON.ContractTemplateID = CTT.ContractTemplateTypeID   

JOIN LibertyPower.dbo.Customer CUST WITH (NOLOCK) ON  A.CustomerID = CUST.CustomerID 
LEFT JOIN LibertyPower.dbo.BusinessType BT WITH (NOLOCK) ON  CUST.BusinessTypeID = BT.BusinessTypeID         
LEFT JOIN LibertyPower.dbo.BusinessActivity BA WITH (NOLOCK) ON  CUST.BusinessActivityID = BA.BusinessActivityID
LEFT JOIN LibertyPower.dbo.SalesChannel SC WITH (NOLOCK) ON  CON.SalesChannelID = SC.ChannelID  
LEFT JOIN LibertyPower.dbo.[User] USER1 WITH (NOLOCK) ON CON.CreatedBy = USER1.UserID 
LEFT JOIN LibertyPower.dbo.AccountUsage USAGE WITH (NOLOCK) ON A.AccountID = USAGE.AccountID AND USAGE.EffectiveDate = CON.StartDate
LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON  A.AccountID = ASERVICE.AccountID 
LEFT JOIN LibertyPower.dbo.TaxStatus TAX WITH (NOLOCK) ON  A.TaxStatusID = TAX.TaxStatusID
LEFT JOIN LibertyPower.dbo.CreditAgency CA WITH (NOLOCK) ON  CUST.CreditAgencyID = CA.CreditAgencyID 
LEFT JOIN #BillingType BILLTYPE WITH (NOLOCK) ON  A.BillingTypeID = BILLTYPE.BillingTypeID 
  
LEFT JOIN LibertyPower.dbo.UtilityPaymentTerms up WITH (NOLOCK) on up.MarketId = mkt.ID  
                  and (up.UtilityId = c.ID OR up.UtilityId = 0)   
                  and (up.BillingType = BILLTYPE.billing_type OR (up.BillingType IS NULL AND NOT EXISTS (SELECT 1 FROM LibertyPower.dbo.UtilityPaymentTerms ut WITH (NOLOCK)  
                   WHERE c.id = up.utilityid  
                   and c.marketid = up.marketid  
                   and c.BillingType = BILLTYPE.billing_type)))  
                  and (up.AccountType = ACCT.account_type OR (up.AccountType IS NULL AND NOT EXISTS (SELECT 1 FROM LibertyPower.dbo.UtilityPaymentTerms uta WITH (NOLOCK)  
                   WHERE uta.utilityid = up.utilityid  
                   and uta.marketid = up.marketid  
                   and uta.AccountType = ACCT.account_type)))  
  
WHERE a.AccountIdLegacy = @p_account_id  
  
SET NOCOUNT OFF