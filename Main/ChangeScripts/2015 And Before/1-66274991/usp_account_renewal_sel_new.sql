USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_renewal_sel_new]    Script Date: 02/22/2013 11:43:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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

-- =================================================

-- 0scar Garcia

-- Modified: 02/21/2013

-- Add the account name 

-- 1-66274991

--=================================================


ALTER PROCEDURE [dbo].[usp_account_renewal_sel_new]

(@p_username nchar(100) = '',

@p_account_id varchar(12) = 'NONE',

@p_account_number varchar(30) = 'NONE')

as

if @p_account_id = 'NONE'

begin

select @p_account_id = account_id

from account_renewal with (NOLOCK)

where @p_account_number = account_number

end

declare @w_account_name_link int

declare @w_account_name varchar(100)

declare @w_customer_address_link int

declare @w_customer_address varchar(50)

declare @w_customer_suite varchar(10)

declare @w_customer_city varchar(28)

declare @w_customer_state varchar(02)

declare @w_customer_zip varchar(10)

declare @w_ISTA_account_number varchar(100)

declare @w_customer_contact_link int

declare @w_customer_first_name varchar(50)

declare @w_customer_last_name varchar(50)

declare @w_customer_title varchar(20)

declare @w_customer_phone varchar(20)

declare @w_customer_fax varchar(20)

declare @w_customer_email nvarchar(256)

declare @w_customer_birthday char(05)

declare @w_billing_address_link int

declare @w_billing_address varchar(50)

declare @w_billing_suite varchar(10)

declare @w_billing_city varchar(28)

declare @w_billing_state varchar(02)

declare @w_billing_zip varchar(10)

declare @w_billing_contact_link int

declare @w_billing_first_name varchar(50)

declare @w_billing_last_name varchar(50)

declare @w_billing_title varchar(20)

declare @w_billing_phone varchar(20)

declare @w_billing_fax varchar(20)

declare @w_billing_email nvarchar(256)

declare @w_billing_birthday varchar(05)

declare @w_owner_name_link int

declare @w_owner_name varchar(100)

declare @w_service_address_link int

declare @w_service_address varchar(50)

declare @w_service_suite varchar(10)

declare @w_service_city varchar(28)

declare @w_service_state varchar(02)

declare @w_service_zip varchar(10)

select @w_account_name = ''

select @w_customer_address = ''

select @w_customer_suite = ''

select @w_customer_city = ''

select @w_customer_state = 'NN'

select @w_customer_zip = ''

select @w_customer_first_name = ''

select @w_customer_last_name = ''

select @w_customer_title = ''

select @w_customer_phone = ''

select @w_customer_fax = ''

select @w_customer_email = ''

select @w_customer_birthday = 'NONE'

select @w_billing_first_name = ''

select @w_billing_last_name = ''

select @w_billing_title = ''

select @w_billing_phone = ''

select @w_billing_fax = ''

select @w_billing_email = ''

select @w_billing_birthday = 'NONE'

select @w_billing_address = ''

select @w_billing_suite = ''

select @w_billing_city = ''

select @w_billing_state = 'NN'

select @w_billing_zip = ''

select @w_owner_name = ''

select @w_service_address = ''

select @w_service_suite = ''

select @w_service_city = ''

select @w_service_state = 'NN'

select @w_service_zip = ''

if @w_account_name_link <> 0

begin

select @w_account_name = full_name

from account_renewal_name with (NOLOCK)

where account_id = @p_account_id

and name_link = @w_account_name_link

end

if @w_customer_address_link <> 0

begin

select @w_customer_address = address,

@w_customer_suite = suite,

@w_customer_city = city,

@w_customer_state = state,

@w_customer_zip = zip

from account_renewal_address with (NOLOCK)

where account_id = @p_account_id

and address_link = @w_customer_address_link

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

from account_renewal_contact with (NOLOCK)

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

from account_renewal_contact with (NOLOCK)

where account_id = @p_account_id

and contact_link = @w_billing_contact_link

end

if @w_billing_address_link <> 0

begin

select @w_billing_address = address,

@w_billing_suite = suite,

@w_billing_city = city,

@w_billing_state = state,

@w_billing_zip = zip

from account_renewal_address with (NOLOCK)

where account_id = @p_account_id

and address_link = @w_billing_address_link

end

if @w_owner_name_link <> 0

begin

select @w_owner_name = full_name

from account_renewal_name with (NOLOCK)

where account_id = @p_account_id

and name_link = @w_owner_name_link

end

if @w_service_address_link <> 0

begin

select @w_service_address = address,

@w_service_suite = suite,

@w_service_city = city,

@w_service_state = state,

@w_service_zip = zip

from account_renewal_address with (NOLOCK)

where account_id = @p_account_id

and address_link = @w_service_address_link

end

--begin 1-1175782

declare @w_version_code varchar(50)

declare @w_template_name varchar(150)

declare @w_contract_nbr char(12)

declare @w_deal_date datetime

select @w_contract_nbr = contract_nbr, @w_deal_date = date_deal

from lp_account..account_renewal WITH (NOLOCK)

where account_id = @p_account_id

select top 1 @w_version_code = tv.VersionCode,

@w_template_name = dt.template_name

from lp_documents..document_history dh WITH (NOLOCK)

left join lp_documents..TemplateVersions tv WITH (NOLOCK) on tv.TemplateVersionId = dh.templateVersionId

inner join lp_documents..document_template dt WITH (NOLOCK) on tv.TemplateId = dt.template_id

where dh.document_type_id = 1

and dh.templateVersionId is not null

and (dh.contract_nbr = @w_contract_nbr or dh.account_id = @p_account_id)

order by dh.date_created desc

--end 1-1175782

goto_select:

DECLARE	@PriceID	int,
		@PriceTier	int
		
SET	@PriceTier = 0
		
SELECT	@PriceID = PriceID
FROM	lp_account..account_renewal WITH (NOLOCK)
WHERE	account_id = @p_account_id 	

IF @PriceID IS NOT NULL
	BEGIN
		SELECT	@PriceTier = PriceTier
		FROM	Libertypower..Price WITH (NOLOCK)
		WHERE	ID = @PriceID
	END		

SELECT a.account_id,

a.account_number,

ic.custno,

account_type = ltrim(rtrim(a.account_type)),

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

a.customer_name_link,

customer_name = z.full_name,

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

a.account_name_link,				--add 0garcia 02/21/2013 1-66274991

account_name = @w_account_name,		--add 0garcia 02/21/2013 1-66274991

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

--IsNull(a.annual_usage,0) as annual_usage,

a.annual_usage as annual_usage,

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

por_option = ltrim(rtrim(a.por_option)),

billing_type = ltrim(rtrim(a.billing_type)),

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

a.chgstamp

--begin 1-1175782

,VersionCode = @w_version_code

,TemplateName = @w_template_name

--end 1-1175782

--Begin Ticket 1-14644158

,ISNULL(mktx.SalesTax,0) as SalesTax

--End Ticket 1-14644158

,a.ContractID_key

,a.AccountID_Key

-- new fields added below this line --------------------------------------------------------
,la.AccountID

,db_group = 0

--,py.paymentTerm -- ticket 8139
,paymentTerm = CASE WHEN (py.paymentTerm = 0) or (py.paymentTerm is null) then isnull(up.[ARTerms], 15)
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

,la.Zone

,la.ServiceRateClass as service_rate_class

,la.StratumVariable as stratum_variable

,la.BillingGroup as billing_group

,la.Icap

,la.Tcap

,la.LoadProfile as load_profile

,la.LossCode as loss_code

,la.MeterTypeID as meter_type

,PriceTier = @PriceTier

,a.PriceID

,at.account_type_id AS AccountTypeID
,pr.rate_descp

,accl.LanguageId

,ac.RequestedStartDate AS requested_flow_start_date

,ad.EnrollmentTypeID AS enrollment_type

,t2.name_key NameKey

,t2.BillingAccount

,t1.old_account_number as LegacyAccount

FROM account_renewal a WITH (NOLOCK)

LEFT JOIN dbo.account_renewal_name z WITH (NOLOCK) ON z.account_id = a.account_id AND z.name_link = a.customer_name_link

Left JOIN account_additional_info b (NOLOCK) ON a.account_id = b.account_id

JOIN Libertypower..Utility c (NOLOCK) ON a.utility_id = c.UtilityCode

JOIN lp_common..common_product p WITH (NOLOCK) ON a.product_id = p.product_id

JOIN account a_old WITH (NOLOCK) ON a.account_id = a_old.account_id

JOIN lp_common..common_product p_old WITH (NOLOCK) ON a_old.product_id = p_old.product_id

LEFT JOIN ISTA.dbo.Premise ip WITH (NOLOCK) ON a.account_number = ip.premno

LEFT JOIN ISTA.dbo.Customer ic WITH (NOLOCK) ON ip.custid = ic.custid

--Begin Ticket 1-14644158

LEFT JOIN LibertyPower..Market mkt WITH (NOLOCK) ON a.retail_mkt_id = mkt.MarketCode

LEFT JOIN LibertyPower..MarketSalesTax mktx WITH (NOLOCK) ON mkt.ID = mktx.MarketID AND (@w_deal_date BETWEEN mktx.EffectiveStartDate AND ISNULL(mktx.EffectiveEndDate, GETDATE()))

--End Ticket 1-14644158

left join AccountPaymentTerm py (NOLOCK) on a.account_id = py.accountId 
left join lp_common..product_account_type at WITH (NOLOCK) on left(ltrim(rtrim(a.account_type)), 3) = left(ltrim(rtrim(at.account_type)), 3)
left join lp_common..common_product_rate pr WITH (NOLOCK) on a.product_id = pr.product_id and a.rate_id = pr.rate_id
left join account_number_history t1 (NOLOCK) on a.account_id = t1.account_id 
left join account_info t2 (NOLOCK) on a.account_id = t2.account_id

inner join LibertyPower.dbo.Account la WITH (NOLOCK) on a.account_id = la.AccountIdLegacy
JOIN LibertyPower.dbo.AccountContract ac	WITH (NOLOCK) ON la.AccountID = ac.AccountID AND la.CurrentRenewalContractID = ac.ContractID
JOIN LibertyPower.dbo.AccountDetail ad	 WITH (NOLOCK)	ON ad.AccountID = la.AccountID

left join LibertyPower..AccountLanguage accl (NOLOCK) on a.account_number = accl.AccountNumber

LEFT JOIN LibertyPower.dbo.UtilityPaymentTerms up WITH (NOLOCK) on up.MarketId = mkt.ID
															   and (up.UtilityId = c.ID OR up.UtilityId = 0) 
															   and (up.BillingType = a.billing_type OR (up.BillingType IS NULL AND NOT EXISTS (SELECT 1 FROM LibertyPower.dbo.UtilityPaymentTerms ut WITH (NOLOCK)
																	  WHERE c.id = up.utilityid
																	  and c.marketid = up.marketid
																	  and c.BillingType = a.billing_type)))
															   and (up.AccountType = a.account_type OR (up.AccountType IS NULL AND NOT EXISTS (SELECT 1 FROM LibertyPower.dbo.UtilityPaymentTerms uta WITH (NOLOCK)
																	  WHERE uta.utilityid = up.utilityid
																	  and uta.marketid = up.marketid
																	  and uta.AccountType = a.account_type)))

WHERE a.account_id = @p_account_id

