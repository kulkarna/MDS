

-- Modified: DEV 8/20/2007	PROD 9/7/2007 
-- Modified By: Gail Mangaroo 
-- Return new field ( category_descp ) added to enrollment_sub_status and 
-- only return comments from specified processes...
-- =========================================================================
-- Modified by GM 11/14/2007 
-- combined process_id and comments column from account_comments
-- =========================================================================
-- Modified by EH 02/11/2008 
-- added column date_flow_start
-- =========================================================================
-- Modified by Jose Munoz 08/26/2010 
-- Ticket 17799
-- added column CreditScoreEncrypted
-- isnull(a.CreditScoreEncrypted, '') CreditScoreEncrypted -- ADD ticket 17799
-- =========================================================================
-- Modified by Isabelle Tamanini 03/01/2010 
-- Ticket 21532
-- Added columns rate, contract_eff_start_date, date_end and date_deenrollment
-- =========================================================================
-- Modified by Jose Munoz 03/01/2011 
-- Ticket 21532
-- Added columns rate, contract_eff_start_date, date_end and date_deenrollment
-- =========================================================================
--
--       select * from ufn_account_detail('libertypower\jforero')
--		select * from ufn_account_detail_JFORERO('libertypower\jforero')

/*


SELECT * FROM [ufn_account_detail_BASE]('libertypower\jforero') order by account_id;

SELECT * FROM [ufn_account_detail_JFORERO]('libertypower\jforero')order by account_id;



*/


CREATE function [dbo].[ufn_account_detail_eric]
(@p_username                                        nchar(100))
returns table
as                  
return
(



/*
		select a.account_id,
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
       from deal_contract_account a with (NOLOCK INDEX = deal_contract_account_idx3),
            ufn_account_sales_channel(@p_username) b,
            deal_contract c with (NOLOCK INDEX = deal_contract_idx),
            deal_name d with (NOLOCK INDEX = deal_name_idx),
            deal_name e with (NOLOCK INDEX = deal_name_idx),
            deal_address f with (NOLOCK INDEX = deal_address_idx),
            deal_address g with (NOLOCK INDEX = deal_address_idx),
            deal_contact h with (NOLOCK INDEX = deal_contact_idx), 
            deal_contact i with (NOLOCK INDEX = deal_contact_idx)
       where a.sales_channel_role                   = b.sales_channel_role
       and   a.contract_nbr                         = c.contract_nbr
       and  (c.status                            like 'DRAFT%'
       or    c.status                               = 'RUNNING')
       and   a.contract_nbr                         = d.contract_nbr
       and   a.account_name_link                    = d.name_link
       and   a.contract_nbr                         = e.contract_nbr
       and   a.customer_name_link                   = e.name_link
       and   a.contract_nbr                         = f.contract_nbr
       and   a.service_address_link                 = f.address_link
       and   a.contract_nbr                         = g.contract_nbr
       and   a.billing_address_link                 = g.address_link
       and   a.contract_nbr                         = h.contract_nbr
       and   a.billing_contact_link                 = h.contact_link
       and   a.contract_nbr                         = i.contract_nbr
       and   a.customer_contact_link                = i.contact_link
       
      
       
-- ==================================================================================================       
       
       
       union
    
       
       
       */
       
       select A.AccountIDLegacy AS account_id,
              A.AccountNumber  AS account_number,
              UTIL.UtilityCode AS utility_id,
              account_name                          = e.full_name,
              customer_name                         = f.full_name,
              BA.Activity AS business_activity,
              BT.[Type] AS business_type,
              service_address                       = g.address,
              service_suite                         = g.suite,
              service_city                          = g.city,
              service_state                         = g.state,
              service_zip                           = g.zip,
              billing_address                       = h.address,
              billing_suite                         = h.suite,
              billing_city                          = h.city,
              billing_state                         = h.state,
              billing_zip                           = h.zip,
              billing_first_name                    = i.first_name,
              billing_last_name                     = i.last_name,
              billing_title                         = i.title,
              billing_phone                         = i.phone,
              billing_fax                           = i.fax,
              billing_email                         = i.email,   
              billing_birthday                      = i.birthday,
              customer_first_name                   = j.first_name,
              customer_last_name                    = j.last_name,
              customer_title                        = j.title,
              customer_phone                        = j.phone,
              customer_fax                          = j.fax,
              customer_email                        = j.email,   
              customer_birthday                     = j.birthday,
              LibertyPower.dbo.ufn_GetLegacyContractType(CT.[Type],ContractTemplateID, CDT.DealType)   AS contract_type,
              CONT.Number AS contract_nbr,
              CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Term		ELSE AC_DefaultRate.Term	  END AS term_months,
              CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS product_id,
			  'SALES CHANNEL/' + SC.ChannelName AS sales_channel_role,
              CONT.SalesRep  AS sales_rep,
              date_submit                           = convert(datetime, convert(char(08), CONT.SignedDate, 112)),
              AU.AnnualUsage AS annual_usage,
              0 AS credit_score,
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
		--    SELECT TOP(1000) * 
		FROM LibertyPower..Account A WITH (NOLOCK)   
		JOIN LibertyPower..[AccountContract]  AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
		JOIN LibertyPower..[Contract] CONT WITH (NOLOCK)  ON AC.ContractID = CONT.ContractID
		JOIN LibertyPower..SalesChannel SC WITH (NOLOCK)  ON CONT.SalesChannelId = SC.ChannelID
		JOIN [lp_deal_capture].[dbo].[vw_ufn_account_sales_channel_username] b WITH (NOLOCK) 
									ON  'SALES CHANNEL/' + SC.ChannelName = b.sales_channel_role AND  b.username = @p_username 
		
		--JOIN ufn_account_sales_channel(@p_username) b ON 'SALES CHANNEL/' + SC.ChannelName = b.sales_channel_role
		JOIN LibertyPower..[AccountStatus] AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
		JOIN lp_account..enrollment_status c with (NOLOCK INDEX = enrollment_status_idx) ON  AST.[Status] = c.[status]
		JOIN lp_account..enrollment_sub_status d with (NOLOCK INDEX = enrollment_sub_status_idx) ON  AST.[Status]= d.[status] AND AST.[SubStatus] = d.sub_status
		JOIN LibertyPower..Customer CUST WITH (NOLOCK)  ON A.CustomerID = CUST.CustomerID
		JOIN LibertyPower..Utility UTIL WITH (NOLOCK)  ON A.UtilityID = UTIL.ID
		JOIN LibertyPower..[ContractType] CT WITH (NOLOCK)  ON CONT.ContractTypeID = CT.ContractTypeID
		JOIN LibertyPower..[ContractDealType] CDT WITH (NOLOCK)  ON CONT.ContractDealTypeID = CDT.ContractDealTypeID
		JOIN LibertyPower..AccountUsage AU WITH (NOLOCK)  ON A.AccountID = AU.AccountID AND AU.EffectiveDate = CONT.StartDate
		JOIN LibertyPower.dbo.AccountContractRate ACR2	WITH (NOLOCK)	ON AC.AccountContractID = ACR2.AccountContractID AND ACR2.IsContractedRate = 1
		JOIN LibertyPower..Market MKT WITH (NOLOCK)  ON A.RetailMktID = MKT.ID
		
		LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)	ON AC.AccountContractID = AC_DefaultRate.AccountContractID AND AC_DefaultRate.IsContractedRate = 0 -- temporary measure, should be changed later
		LEFT JOIN LibertyPower..BusinessActivity BA WITH (NOLOCK)  ON CUST.BusinessActivityID = BA.BusinessActivityID
		LEFT JOIN LibertyPower..BusinessType BT WITH (NOLOCK)  ON CUST.BusinessTypeID = BT.BusinessTypeID
		LEFT JOIN lp_account..account_name e with (NOLOCK INDEX = account_name_idx) ON A.AccountNameID = e.AccountNameID
		LEFT JOIN lp_account..account_name f with (NOLOCK INDEX = account_name_idx) ON CUST.NameID = f.AccountNameID
        LEFT JOIN lp_account..account_address g with (NOLOCK INDEX = account_address_idx) ON A.ServiceAddressID = g.AccountAddressID
        LEFT JOIN lp_account..account_address h with (NOLOCK INDEX = account_address_idx) ON A.BillingAddressID = h.AccountAddressID
        LEFT JOIN lp_account..account_contact i with (NOLOCK INDEX = account_contact_idx) ON A.BillingContactID = i.AccountContactID
        LEFT JOIN lp_account..account_contact j with (NOLOCK INDEX = account_contact_idx) ON CUST.ContactID = j.AccountContactID
        
		LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID
 

-- ==================================================================================================


-- account renewals  -----------------------------------------------------------------------------

/*
       union
       
       
       
       
       
		select a.account_id,
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
       from lp_contract_renewal..deal_contract_account a with (NOLOCK INDEX = deal_contract_account_idx3),
            ufn_account_sales_channel(@p_username) b,
            deal_contract c with (NOLOCK INDEX = deal_contract_idx),
            deal_name d with (NOLOCK INDEX = deal_name_idx),
            deal_name e with (NOLOCK INDEX = deal_name_idx),
            deal_address f with (NOLOCK INDEX = deal_address_idx),
            deal_address g with (NOLOCK INDEX = deal_address_idx),
            deal_contact h with (NOLOCK INDEX = deal_contact_idx), 
            deal_contact i with (NOLOCK INDEX = deal_contact_idx)
       where a.sales_channel_role                   = b.sales_channel_role
       and   a.contract_nbr                         = c.contract_nbr
       and  (c.status                            like 'DRAFT%'
       or    c.status                               = 'RUNNING')
       and   a.contract_nbr                         = d.contract_nbr
       and   a.account_name_link                    = d.name_link
       and   a.contract_nbr                         = e.contract_nbr
       and   a.customer_name_link                   = e.name_link
       and   a.contract_nbr                         = f.contract_nbr
       and   a.service_address_link                 = f.address_link
       and   a.contract_nbr                         = g.contract_nbr
       and   a.billing_address_link                 = g.address_link
       and   a.contract_nbr                         = h.contract_nbr
       and   a.billing_contact_link                 = h.contact_link
       and   a.contract_nbr                         = i.contract_nbr
       and   a.customer_contact_link                = i.contact_link
       
       
       
       
       
       
-- ==================================================================================================       
*/

       union
      
       select A.AccountIDLegacy AS account_id,
              A.AccountNumber  AS account_number,
              UTIL.UtilityCode AS utility_id,
              account_name                          = e.full_name,
              customer_name                         = f.full_name,
              BA.Activity AS business_activity,
              BT.[Type] AS business_type,
              service_address                       = g.address,
              service_suite                         = g.suite,
              service_city                          = g.city,
              service_state                         = g.state,
              service_zip                           = g.zip,
              billing_address                       = h.address,
              billing_suite                         = h.suite,
              billing_city                          = h.city,
              billing_state                         = h.state,
              billing_zip                           = h.zip,
              billing_first_name                    = i.first_name,
              billing_last_name                     = i.last_name,
              billing_title                         = i.title,
              billing_phone                         = i.phone,
              billing_fax                           = i.fax,
              billing_email                         = i.email,   
              billing_birthday                      = i.birthday,
              customer_first_name                   = j.first_name,
              customer_last_name                    = j.last_name,
              customer_title                        = j.title,
              customer_phone                        = j.phone,
              customer_fax                          = j.fax,
              customer_email                        = j.email,   
              customer_birthday                     = j.birthday,
              LibertyPower.dbo.ufn_GetLegacyContractType(CT.[Type],ContractTemplateID, CDT.DealType)   AS contract_type,
              CONT.Number AS contract_nbr,
              CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Term		ELSE AC_DefaultRate.Term	  END AS term_months,
              CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS product_id,
			  'SALES CHANNEL/' + SC.ChannelName AS sales_channel_role,
              CONT.SalesRep  AS sales_rep,
              date_submit                           = convert(datetime, convert(char(08), CONT.SignedDate, 112)),
              AU.AnnualUsage AS annual_usage,
              0 AS credit_score,
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
		--    SELECT TOP(1000) * 
		FROM LibertyPower..Account A WITH (NOLOCK)   
		JOIN LibertyPower..[AccountContract]  AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentRenewalContractID = AC.ContractID
		JOIN LibertyPower..[Contract] CONT WITH (NOLOCK)  ON AC.ContractID = CONT.ContractID
		JOIN LibertyPower..SalesChannel SC WITH (NOLOCK)  ON CONT.SalesChannelId = SC.ChannelID
		JOIN [lp_deal_capture].[dbo].[vw_ufn_account_sales_channel_username] b WITH (NOLOCK) 
									ON  'SALES CHANNEL/' + SC.ChannelName = b.sales_channel_role AND  b.username = @p_username 
		
		--JOIN ufn_account_sales_channel(@p_username) b ON 'SALES CHANNEL/' + SC.ChannelName = b.sales_channel_role
		JOIN LibertyPower..[AccountStatus] AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
		JOIN lp_account..enrollment_status c with (NOLOCK INDEX = enrollment_status_idx) ON  AST.[Status] = c.[status]
		JOIN lp_account..enrollment_sub_status d with (NOLOCK INDEX = enrollment_sub_status_idx) ON  AST.[Status]= d.[status] AND AST.[SubStatus] = d.sub_status
		JOIN LibertyPower..Customer CUST WITH (NOLOCK)  ON A.CustomerID = CUST.CustomerID
		JOIN LibertyPower..Utility UTIL WITH (NOLOCK)  ON A.UtilityID = UTIL.ID
		JOIN LibertyPower..[ContractType] CT WITH (NOLOCK)  ON CONT.ContractTypeID = CT.ContractTypeID
		JOIN LibertyPower..[ContractDealType] CDT WITH (NOLOCK)  ON CONT.ContractDealTypeID = CDT.ContractDealTypeID
		JOIN LibertyPower..AccountUsage AU WITH (NOLOCK)  ON A.AccountID = AU.AccountID AND AU.EffectiveDate = CONT.StartDate
		JOIN LibertyPower.dbo.AccountContractRate ACR2	WITH (NOLOCK)	ON AC.AccountContractID = ACR2.AccountContractID AND ACR2.IsContractedRate = 1
		JOIN LibertyPower..Market MKT WITH (NOLOCK)  ON A.RetailMktID = MKT.ID
		
		LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)	ON AC.AccountContractID = AC_DefaultRate.AccountContractID AND AC_DefaultRate.IsContractedRate = 0 -- temporary measure, should be changed later
		LEFT JOIN LibertyPower..BusinessActivity BA WITH (NOLOCK)  ON CUST.BusinessActivityID = BA.BusinessActivityID
		LEFT JOIN LibertyPower..BusinessType BT WITH (NOLOCK)  ON CUST.BusinessTypeID = BT.BusinessTypeID
		LEFT JOIN lp_account..account_name e with (NOLOCK INDEX = account_name_idx) ON A.AccountNameID = e.AccountNameID
		LEFT JOIN lp_account..account_name f with (NOLOCK INDEX = account_name_idx) ON CUST.NameID = f.AccountNameID
        LEFT JOIN lp_account..account_address g with (NOLOCK INDEX = account_address_idx) ON A.ServiceAddressID = g.AccountAddressID
        LEFT JOIN lp_account..account_address h with (NOLOCK INDEX = account_address_idx) ON A.BillingAddressID = h.AccountAddressID
        LEFT JOIN lp_account..account_contact i with (NOLOCK INDEX = account_contact_idx) ON A.BillingContactID = i.AccountContactID
        LEFT JOIN lp_account..account_contact j with (NOLOCK INDEX = account_contact_idx) ON CUST.ContactID = j.AccountContactID
        
		LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID
 
 
 
 
 
 
 
 
 
 
 /*
       select a.account_id,
              a.account_number,
              a.utility_id,
              account_name                          = e.full_name,
              customer_name                         = f.full_name,
              a.business_activity,
              a.business_type,
              service_address                       = g.address,
              service_suite                         = g.suite,
              service_city                          = g.city,
              service_state                         = g.state,
              service_zip                           = g.zip,
              billing_address                       = h.address,
              billing_suite                         = h.suite,
              billing_city                          = h.city,
              billing_state                         = h.state,
              billing_zip                           = h.zip,
              billing_first_name                    = i.first_name,
              billing_last_name                     = i.last_name,
              billing_title                         = i.title,
              billing_phone                         = i.phone,
              billing_fax                           = i.fax,
              billing_email                         = i.email,   
              billing_birthday                      = i.birthday,
              customer_first_name                   = j.first_name,
              customer_last_name                    = j.last_name,
              customer_title                        = j.title,
              customer_phone                        = j.phone,
              customer_fax                          = j.fax,
              customer_email                        = j.email,   
              customer_birthday                     = j.birthday,
              a.contract_type,
              a.contract_nbr,
              a.term_months,
              a.product_id,
              a.sales_channel_role,
              a.sales_rep,
              date_submit                           = convert(datetime, convert(char(08), a.date_deal, 112)),
              a.annual_usage,
              a.credit_score,
              status                                = c.status_descp,
              sub_status                            = d.sub_status_descp,
			  comments = 							(select top 1 comment 
													from lp_account..account_comments with (NOLOCK INDEX = account_comments_idx) 
													where account_id = a.account_id and 
														process_id in ('TPV','CREDIT CHECK', 'CHECK ACCOUNT', 'ACCOUNT', 'LETTER')
													order by date_comment desc),

			  category_descp  = case when ltrim(rtrim(isnull(d.category_descp, ''))) = ''
									then  c.status_descp 
									else d.category_descp 
								end, 
			  --'Not Yet Available' as date_flow_start,
			  date_flow_start	= convert(varchar(10), a.date_flow_start, 101), -- Add ticket 21532 - by José Muñoz
		      a.retail_mkt_id,
		      isnull(a.CreditScoreEncrypted, '') CreditScoreEncrypted, -- ADD ticket 17799
		      --begin SD21532
		      a.rate, 
			  a.contract_eff_start_date, 
			  a.date_end,
			  a.date_deenrollment,
			  --end SD21532
			  a.date_deal
       from lp_account..account_renewal a with (NOLOCK INDEX = account_idx2),
            ufn_account_sales_channel(@p_username) b,
            lp_account..enrollment_status c with (NOLOCK INDEX = enrollment_status_idx),
            lp_account..enrollment_sub_status d with (NOLOCK INDEX = enrollment_sub_status_idx),
            lp_account..account_renewal_name e with (NOLOCK),
            lp_account..account_renewal_name f with (NOLOCK),
            lp_account..account_renewal_address g with (NOLOCK),
            lp_account..account_renewal_address h with (NOLOCK),
            lp_account..account_renewal_contact i with (NOLOCK), 
            lp_account..account_renewal_contact j with (NOLOCK )
       where a.sales_channel_role                   = b.sales_channel_role
       and   a.status                               = c.status
       and   a.status                               = d.status
       and   a.sub_status                           = d.sub_status
       and   a.account_id                           = e.account_id
       and   a.account_name_link                    = e.name_link
       and   a.account_id                           = f.account_id
       and   a.customer_name_link                   = f.name_link
       and   a.account_id                           = g.account_id
       and   a.service_address_link                 = g.address_link
       and   a.account_id                           = h.account_id
       and   a.billing_address_link                 = h.address_link
       and   a.account_id                           = i.account_id
       and   a.billing_contact_link                 = i.contact_link
       and   a.account_id                           = j.account_id
       and   a.customer_contact_link                = j.contact_link

*/


)
