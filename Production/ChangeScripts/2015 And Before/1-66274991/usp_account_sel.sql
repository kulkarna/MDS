USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_sel]    Script Date: 02/22/2013 15:43:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec usp_account_sel_eric 'libertypower\dmarino', 'ACCS-0038826'

-- =============================================

-- Modified: Jose Munoz 1/28/2010

-- add HeatIndexSourceID and HeatRate for account table

-- Project IT037

-- =============================================

-- =============================================

-- Modified: Jose Munoz 5/11/2010

-- Add evergreen_option_id, evergreen_commission_end, residual_option_id, residual_commission_end

-- initial_pymt_option_id, sales_manager, evergreen_commission_rate Columns

-- Project IT021

-- =============================================

-- =============================================

-- Modified: Hector Gomez 5/18/2010

-- Performance enhancement, removed all HINTS

-- updated the use of Common_Utility to point to

-- Liberty Power database.

-- ONE SELECT statement for variable assignment

-- =============================================

-- Cathy Ghazal

-- Modified: 05/16/2012 to add ContractID

-- =================================================

-- Isabelle Tamanini

-- Modified: 09/06/2012

-- Get payment terms from the utility

-- 1-25299925

--=================================================

-- 0scar Garcia

-- Modified: 02/21/2013

-- Add the account name 

-- 1-66274991

--=================================================

ALTER PROC [dbo].[usp_account_sel](  
  
@p_username nchar(100),  
  
@p_account_id char(12) = 'NONE',  
  
@p_account_number varchar(30) = 'NONE',  
  
@p_utility_id varchar(30) = 'NONE' )  
  
as  
  
-- TEST  
  
--declare @p_account_id varchar(100)  
  
--declare @p_account_number varchar(100)  
  
--set @p_account_id='ACCS-0041803'  
  
--set @p_account_number='10443720008503304'  
  
if @p_account_id = 'NONE'  
  
begin  
  
select @p_account_id = account_id  
  
from account with (NOLOCK) --commented by HECTOR GOMEZ 9/15/2010 INDEX = account_idx1)  
  
where @p_account_number = account_number  
  
and (@p_utility_id = 'NONE' OR @p_utility_id = utility_id)  
  
end  
  
DECLARE @w_customer_name_link int  
  
, @w_customer_name varchar(100)  
  
, @w_customer_address_link int  
  
, @w_customer_address varchar(50)  
  
, @w_customer_suite varchar(10)  
  
, @w_customer_city varchar(28)  
  
, @w_customer_state varchar(02)  
  
, @w_customer_zip varchar(10)  
  
, @w_customer_contact_link int  
  
, @w_customer_first_name varchar(50)  
  
, @w_customer_last_name varchar(50)  
  
, @w_customer_title varchar(20)  
  
, @w_customer_phone varchar(20)  
  
, @w_customer_fax varchar(20)  
  
, @w_customer_email nvarchar(256)  
  
, @w_customer_birthday char(05)  
  
, @w_billing_address_link int  
  
, @w_billing_address varchar(50)  
  
, @w_billing_suite varchar(10)  
  
, @w_billing_city varchar(28)  
  
, @w_billing_state varchar(02)  
  
, @w_billing_zip varchar(10)  
  
, @w_billing_contact_link int  
  
, @w_billing_first_name varchar(50)  
  
, @w_billing_last_name varchar(50)  
  
, @w_billing_title varchar(20)  
  
, @w_billing_phone varchar(20)  
  
, @w_billing_fax varchar(20)  
  
, @w_billing_email nvarchar(256)  
  
, @w_billing_birthday varchar(05)  
  
, @w_owner_name_link int  
  
, @w_owner_name varchar(100)  
  
, @w_service_address_link int  
  
, @w_service_address varchar(50)  
  
, @w_service_suite varchar(10)  
  
, @w_service_city varchar(28)  
  
, @w_service_state varchar(02)  
  
, @w_service_zip varchar(10)

, @w_account_name_link int		--add 0garcia 02/21/2013 1-66274991

, @w_account_name varchar(100)	--add 0garcia 02/21/2013 1-66274991
    

  
-- get the address linkss  
  
select @w_customer_address_link = customer_address_link,  
  
@w_billing_address_link = billing_address_link,  
  
@w_service_address_link = service_address_link,  
  
@w_customer_name_link = customer_name_link, -- ADD JOSE MUNOZ AT 06/11/2010  
  
@w_customer_contact_link = customer_contact_link, -- ADD JOSE MUNOZ AT 06/11/2010  
  
@w_billing_contact_link = billing_contact_link, -- ADD JOSE MUNOZ AT 06/11/2010  
  
@w_owner_name_link = owner_name_link, -- ADD JOSE MUNOZ AT 06/11/2010  
  
@w_service_address_link = service_address_link, -- ADD JOSE MUNOZ AT 06/11/2010  

@w_account_name_link = account_name_link	--add 0garcia 02/21/2013 1-66274991

from lp_account..account (NOLOCK)  
  
where account_id = @p_account_id  
  
----------  
  
SELECT @w_customer_name = ''  
  
--select @w_customer_address = ''  
  
--select @w_customer_suite = ''  
  
--select @w_customer_city = ''  
  
--select @w_customer_state = 'NN'  
  
--select @w_customer_zip = ''  
  
, @w_customer_first_name = ''  
  
, @w_customer_last_name = ''  
  
, @w_customer_title = ''  
  
, @w_customer_phone = ''  
  
, @w_customer_fax = ''  
  
, @w_customer_email = ''  
  
, @w_customer_birthday = 'NONE'  
  
, @w_billing_first_name = ''  
  
, @w_billing_last_name = ''  
  
, @w_billing_title = ''  
  
, @w_billing_phone = ''  
  
, @w_billing_fax = ''  
  
, @w_billing_email = ''  
  
, @w_billing_birthday = 'NONE'  
  
--select @w_billing_address = ''  
  
--select @w_billing_suite = ''  
  
--select @w_billing_city = ''  
  
--select @w_billing_state = 'NN'  
  
--select @w_billing_zip = ''  
  
, @w_owner_name = ''  
  
--select @w_service_address = ''  
  
--select @w_service_suite = ''  
  
--select @w_service_city = ''  
  
--select @w_service_state = 'NN'  
  
--select @w_service_zip = ''  
  
if @w_customer_name_link <> 0  
  
begin  
  
select @w_customer_name = full_name  
  
from account_name with (NOLOCK)  
  
where account_id = @p_account_id  
  
and name_link = @w_customer_name_link  
  
end  
  
if @w_customer_address_link <> 0  
  
BEGIN  
  
select @w_customer_address = [address],  
  
@w_customer_suite = suite,  
  
@w_customer_city = city,  
  
@w_customer_state = [state],  
  
@w_customer_zip = zip  
  
from account_address with (NOLOCK)  
  
where account_id = @p_account_id  
  
and address_link = @w_customer_address_link  
  
PRINT @w_customer_address  
  
end  
  
if @w_customer_contact_link <> 0  
  
begin  
  
select @w_customer_first_name = first_name,  
  
@w_customer_last_name = last_name,  
  
@w_customer_title = title,  
  
@w_customer_phone = phone,  
  
@w_customer_fax = fax,  
  
@w_customer_email = email,  
  
@w_customer_birthday = birthday  
  
from account_contact with (NOLOCK)  
  
where account_id = @p_account_id  
  
and contact_link = @w_customer_contact_link  
  
end  
  
if @w_billing_contact_link <> 0  
  
begin  
  
select @w_billing_first_name = first_name,  
  
@w_billing_last_name = last_name,  
  
@w_billing_title = title,  
  
@w_billing_phone = phone,  
  
@w_billing_fax = fax,  
  
@w_billing_email = email,  
  
@w_billing_birthday = birthday  
  
from account_contact with (NOLOCK)  
  
where account_id = @p_account_id  
  
and contact_link = @w_billing_contact_link  
  
end  
  
if @w_billing_address_link <> 0  
  
BEGIN  
  
select @w_billing_address = address,  
  
@w_billing_suite = suite,  
  
@w_billing_city = city,  
  
@w_billing_state = state,  
  
@w_billing_zip = zip  
  
from account_address with (NOLOCK)  
  
where account_id = @p_account_id  
  
and address_link = @w_billing_address_link  
  
PRINT @w_billing_address  
  
end  
  
if @w_owner_name_link <> 0  
  
begin  
  
select @w_owner_name = full_name  
  
from account_name with (NOLOCK)  
  
where account_id = @p_account_id  
  
and name_link = @w_owner_name_link  
  
end  

--add 0garcia 02/212013 get the account name 1-66274991
if @w_account_name_link <> 0	
  
begin  
  
select @w_account_name = full_name  
  
from account_name with (NOLOCK)  
  
where account_id = @p_account_id  
  
and name_link = @w_account_name_link  
  
end 

  
if @w_service_address_link <> 0  
  
BEGIN  
  
select @w_service_address = address,  
  
@w_service_suite = suite,  
  
@w_service_city = city,  
  
@w_service_state = state,  
  
@w_service_zip = zip  
  
from account_address with (NOLOCK)  
  
where account_id = @p_account_id  
  
and address_link = @w_service_address_link  
  
PRINT @w_service_address  
  
end  
  
--begin 1-1175782  
  
declare @w_version_code varchar(50)  
  
declare @w_template_name varchar(150)  
  
declare @w_contract_nbr char(12)  
  
declare @w_deal_date datetime  
  
--IT079 refactor  
  
SELECT @w_contract_nbr = c.Number, @w_deal_date = c.SignedDate  
  
FROM LibertyPower..Account (NOLOCK) a  
  
JOIN LibertyPower..[Contract] c (NOLOCK) ON a.CurrentContractID = c.ContractID  
  
WHERE a.AccountIDLegacy = @p_account_id  
  
SELECT *  
  
INTO #document_history  
  
FROM lp_documents..document_history dh  with (NOLOCK)
  
WHERE dh.document_type_id = 1 and (dh.contract_nbr = @w_contract_nbr or dh.account_id = @p_account_id)  
  
select top 1 @w_version_code = tv.VersionCode,  
@w_template_name = dt.template_name  
from #document_history dh  with (NOLOCK)
left join lp_documents..TemplateVersions tv with (NOLOCK) on tv.TemplateVersionId = dh.templateVersionId  
inner join lp_documents..document_template dt with (NOLOCK) on tv.TemplateId = dt.template_id  
where dh.templateVersionId is not null  
order by dh.date_created desc  
OPTION (KEEP PLAN)  
--end 1-1175782  
  
goto_select:  
  
 DECLARE @PriceID int,  
   @PriceTier int  
     
 SET @PriceTier = 0  
     
 SELECT @PriceID = PriceID  
 FROM lp_account..account WITH (NOLOCK)  
 WHERE account_id = @p_account_id    
   
 IF @PriceID IS NOT NULL  
  BEGIN  
   SELECT @PriceTier = PriceTier  
   FROM Libertypower..Price WITH (NOLOCK)  
   WHERE ID = @PriceID  
  END    
    
  
SELECT *  
  
INTO #Account  
  
FROM lp_account..account (nolock)  
  
WHERE account_id = @p_account_id  
  
  
  
select a.account_id,  
  
a.zone, --added in INF95-INF40 merge  
  
a.service_rate_class,--added in INF95-INF40 merge  
  
a.stratum_variable,--added in INF95-INF40 merge  
  
a.billing_group,--added in INF95-INF40 merge  
  
a.icap,--added in INF95-INF40 merge  
  
a.tcap,--added in INF95-INF40 merge  
  
a.load_profile,--added in INF95-INF40 merge  
  
a.loss_code, --added in INF95-INF40 merge  
  
a.meter_type,--added in INF95-INF40 merge  
  
a.requested_flow_start_date,--added in INF95-INF40 merge  
  
a.enrollment_type, --added in INF95-INF40 merge  
  
account_name = acctName.full_name,  
  
account_number = isnull(a.account_number, ''),  
  
account_type = upper(ltrim(rtrim(a.account_type))),  
  
status = ltrim(rtrim(a.status)),  
  
sub_status = ltrim(rtrim(a.sub_status)),  
  
a.customer_id,  
  
entity_id = ltrim(rtrim(a.entity_id)),  
  
a.contract_nbr,  
  
a.contract_type,  
  
retail_mkt_id = rtrim(ltrim(a.retail_mkt_id)),  
  
utility_id = rtrim(ltrim(a.utility_id)),  
  
product_id = rtrim(ltrim(a.product_id)),  
  
a.rate_id,  
  
a.rate,  
  
customer_name_link,  
  
customer_name = @w_customer_name,  
  
a.customer_address_link,  
  
customer_address = @w_customer_address,  
  
customer_suite = @w_customer_suite,  
  
customer_city = @w_customer_city,  
  
customer_state = @w_customer_state,  
  
customer_zip = @w_customer_zip,  
  
a.customer_contact_link,  
  
customer_first_name = @w_customer_first_name,  
  
customer_last_name = @w_customer_last_name,  
  
customer_title = @w_customer_title,  
  
customer_phone = @w_customer_phone,  
  
customer_fax = @w_customer_fax,  
  
customer_email = @w_customer_email,  
  
customer_birthday = ltrim(rtrim(@w_customer_birthday)),  
  
a.billing_address_link,  
  
billing_address = @w_billing_address,  
  
billing_suite = @w_billing_suite,  
  
billing_city = @w_billing_city,  
  
billing_state = @w_billing_state,  
  
billing_zip = @w_billing_zip,  
  
a.billing_contact_link,  
  
billing_first_name = @w_billing_first_name,  
  
billing_last_name = @w_billing_last_name,  
  
billing_title = @w_billing_title,  
  
billing_phone = @w_billing_phone,  
  
billing_fax = @w_billing_fax,  
  
billing_email = @w_billing_email,  
  
billing_birthday = ltrim(rtrim(@w_billing_birthday)),  
  
a.owner_name_link,  
  
owner_name = @w_owner_name,  

a.account_name_link,			--add 0garcia 02/21/2013 1-66274991

account_name = @w_account_name,	--add 0garcia 02/21/2013 1-66274991
  
a.service_address_link,  
  
service_address = @w_service_address,  
  
service_suite = @w_service_suite,  
  
service_city = @w_service_city,  
  
service_state = @w_service_state,  
  
service_zip = @w_service_zip,  
  
a.business_type,  
  
a.business_activity,  
  
a.additional_id_nbr_type,  
  
a.additional_id_nbr,  
  
a.contract_eff_start_date,  
  
a.term_months,  
  
a.date_end,  
  
a.date_deal,  
  
a.date_created,  
  
a.date_submit,  
  
a.sales_channel_role,  
  
a.username,  
  
a.sales_rep,  
  
a.origin,  
  
a.annual_usage,  
  
a.date_flow_start,  
  
a.date_por_enrollment,  
  
a.date_deenrollment,  
  
a.date_reenrollment,  
  
a.tax_status,  
  
a.tax_rate,  
  
a.credit_score,  
  
a.credit_agency,  
  
a.SSNEncrypted, -- Added for IT002  
  
a.CreditScoreEncrypted, -- Added for IT002  
  
-- a.enrollment_type,  
  
-- por_option = ltrim(rtrim(a.por_option)),  
  
-- billing_type = ltrim(rtrim(a.billing_type)),  
  
-- db_group = isnull(ad.deutsche_bank_group_id,0),  
  
-- zone = isnull(a.zone, ''),  
  
-- service_rate_class = isnull(a.service_rate_class, ''),  
  
-- stratum_variable = isnull(a.stratum_variable, ''),  
  
-- billing_group = isnull(a.billing_group, ''),  
  
-- icap = isnull(a.icap, ''),  
  
-- tcap = isnull(a.tcap, ''),  
  
-- load_profile = isnull(a.load_profile, ''),  
  
-- loss_code = isnull(a.loss_code, ''),  
  
-- requested_flow_start_date = isnull(a.requested_flow_start_date, '19000101'),  
  
-- deal_type = isnull(a.deal_type, ''),  
  
-- contract_nbr_to_renew = isnull(a.contract_nbr_to_renew, ''),  
  
-- customer_code = isnull(a.customer_code, ''),  
  
-- customer_group = isnull(a.customer_group, ''),  
  
-- a.chgstamp,  
  
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
  
c.field11label field_11_label, -- added this for INF95-INF40 merge  
  
c.field11type field_11_type, -- added this for INF95-INF40 merge  
  
b.field_11_value,-- added this for INF95-INF40 merge  
  
c.field12label field_12_label, -- added this for INF95-INF40 merge  
  
c.field12type field_12_type, -- added this for INF95-INF40 merge  
  
b.field_12_value,-- added this for INF95-INF40 merge  
  
c.field13label field_13_label, -- added this for INF95-INF40 merge  
  
c.field13type field_13_type, -- added this for INF95-INF40 merge  
  
b.field_13_value,-- added this for INF95-INF40 merge  
  
c.field14label field_14_label, -- added this for INF95-INF40 merge  
  
c.field14type field_14_type, -- added this for INF95-INF40 merge  
  
b.field_14_value,-- added this for INF95-INF40 merge  
  
c.field15label field_15_label, -- added this for INF95-INF40 merge  
  
c.field15type field_15_type, -- added this for INF95-INF40 merge  
  
b.field_15_value,-- added this for INF95-INF40 merge  
  
t1.old_account_number LegacyAccount,  
  
t2.name_key NameKey,  
  
t2.BillingAccount,  
  
--isnull(b.desired_start_date,'') as desired_start_date,  
  
por_option = ltrim(rtrim(a.por_option)),  
  
billing_type = ltrim(rtrim(a.billing_type)),  
  
db_group = 0, --isnull(ad.deutsche_bank_group_id,0), -- 11/24/2009 Douglas Marino No longer necessary, it was cousing duplicates for accounts that alredy existed and where re-submitted (i.e. Not enrolled accounts)  
  
a.chgstamp,  
  
--p.paymentTerm, -- ticket 8139  
  
paymentTerm = CASE WHEN (p.paymentTerm = 0) or (p.paymentTerm is null) then isnull(up.[ARTerms], 16)  
              ELSE p.paymentTerm END,  
  
a.HeatIndexSourceID, -- Project IT037  
  
a.HeatRate -- Project IT037  
  
,a.evergreen_commission_end --IT021  
  
,a.residual_option_id --IT021  
  
,a.residual_commission_end --IT021  
  
,a.initial_pymt_option_id --IT021  
  
,a.sales_manager --IT021  
  
,a.evergreen_commission_rate --IT021  
  
--begin 1-1175782  
  
,VersionCode = @w_version_code  
  
,TemplateName = @w_template_name  
  
--end 1-1175782  
  
,a.AccountID  
  
--Rafael Vasconcelos  
  
--Begin ticket 1-5867575  
  
,accl.LanguageId  
  
--End ticket 1-5867575  
  
--Rafael Vasconcelos  
  
--Begin Ticket 1-14644158  
  
,ISNULL(mktx.SalesTax,0) as SalesTax  
  
--End Ticket 1-14644158  
  
,a.ContractID_key --Mark to MArket  
  
,PriceTier = @PriceTier  
  
,a.PriceID  
  
,at.account_type_id AS AccountTypeID  
,pr.rate_descp  
  
FROM #Account a (NOLOCK)  
Left JOIN account_additional_info b (NOLOCK) ON a.account_id = b.account_id  
JOIN Libertypower..Utility c (NOLOCK) ON a.utility_id = c.UtilityCode  
--LEFT JOIN dbo.account_deutsche_link ad ON a.account_id = ad.account_id -- 11/24/2009 Douglas Marino No longer necessary, it was cousing duplicates for accounts that alredy existed and where re-submitted (i.e. Not enrolled accounts)  
join account_name acctName (NOLOCK) ON acctName.account_id = a.account_id and acctName.name_link = a.account_name_link  
left join account_number_history t1 (NOLOCK) on a.account_id = t1.account_id -- INF83 TR010  
left join account_info t2 (NOLOCK) on a.account_id = t2.account_id -- INF83 TR010  
left join AccountPaymentTerm p (NOLOCK) on a.account_id = p.accountId -- ticket 8139  
left join LibertyPower..AccountLanguage accl (NOLOCK) on a.account_number = accl.AccountNumber -- Ticket 1-5867575  
--Rafael Vasconcelos  
--Begin Ticket 1-14644158  
LEFT JOIN LibertyPower..Market mkt WITH (NOLOCK) ON a.retail_mkt_id = mkt.MarketCode  
LEFT JOIN LibertyPower..MarketSalesTax mktx WITH (NOLOCK) ON mkt.ID = mktx.MarketID AND (@w_deal_date BETWEEN mktx.EffectiveStartDate AND ISNULL(mktx.EffectiveEndDate, GETDATE()))  
  
--End Ticket 1-14644158  
left join lp_common..product_account_type at WITH (NOLOCK) on left(ltrim(rtrim(a.account_type)), 3) = left(ltrim(rtrim(at.account_type)), 3)  
left join lp_common..common_product_rate pr WITH (NOLOCK) on a.product_id = pr.product_id and a.rate_id = pr.rate_id  
JOIN Libertypower..BillingType bt on a.billing_type = bt.Type  
LEFT JOIN LibertyPower.dbo.UtilityPaymentTerms up WITH (NOLOCK) on up.MarketId = mkt.ID  
                  and (up.UtilityId = c.ID OR up.UtilityId = 0)   
                  and (up.BillingTypeID = bt.BillingTypeID OR (up.BillingTypeID IS NULL AND NOT EXISTS (SELECT 1 FROM LibertyPower.dbo.UtilityPaymentTerms ut WITH (NOLOCK)  
                   WHERE c.id = up.utilityid  
                   and c.marketid = up.marketid  
                   and c.BillingType = bt.Type)))  
                  and (up.AccountType = a.account_type OR (up.AccountType IS NULL AND NOT EXISTS (SELECT 1 FROM LibertyPower.dbo.UtilityPaymentTerms uta WITH (NOLOCK)  
                   WHERE uta.utilityid = up.utilityid  
                   and uta.marketid = up.marketid)))  
OPTION (KEEP PLAN)  