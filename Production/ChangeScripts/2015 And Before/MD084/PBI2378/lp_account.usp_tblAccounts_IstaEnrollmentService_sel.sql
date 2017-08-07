USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_tblAccounts_IstaEnrollmentService_sel]    Script Date: 11/02/2012 10:46:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
* 07/08/2010 - Jose Munoz
* Ticket : 16918 (Error received in the Enrollment Submission queue when attempting 
                              to send account 10443720003796667 for enrollment. )
                  - Account 10443720003796667:System.MissingMemberException: Public member 'Trim' on type 'DBNull' not found         

      Change  : ServiceClass = isnull(sc.ratecode_file_mapping,v.Service_rate_class),
      To          : ServiceClass = isnull(isnull(sc.ratecode_file_mapping,v.Service_rate_class),''),
                              
*******************************************************************************
* Modified by Sofia Melo - 02/08/2011
* Added ARTerms value for utility 'PECO' (ticket 21257)
* Added ista_zone_id value for zone 'PPL' (ticket 21227)
******************************************************************************* 
-- =============================================
-- Modified José Muñoz 02/24/2011
-- Ticket 21480
-- Remove hardcoded logic for getting the payment terms of a utility 
-- use the new table "UtilityPaymentTerms"
-- =============================================
-- Modified Isabelle Tamanini 04/12/2011
-- Ticket 22422
-- Added column MarketCode to the select clause
-- =============================================
-- Modified José Muñoz 05/04/2011
-- Ticket 22862
-- Added table "lp_account.dbo.AccountPaymentTerm" to search
-- ARTerms values updated by user.
-- =============================================
-- Modified Isabelle Tamanini 09/26/2011
-- SR 1-2679302
-- Added logic to return account type SOHO as RES
-- =============================================
-- Modified Isabelle Tamanini 10/10/2011
-- SR 1-2966641
-- Added GracePeriod to the select clause
-- =============================================
-- Modified Isabelle Tamanini 3/28/2012
-- SR 1-12072021
-- Added ApplyLateFees to the select clause and 
-- fixed the join with UtilityPaymentTerms
-- =============================================
-- Modified Isabelle Tamanini 4/10/2012
-- SR 1-12770042
-- Added table UtilityLateFees to bring the ApplyLateFee
-- value for the account based on utility and market
-- =============================================
-- Modified Isabelle Tamanini 5/24/2012
-- SR 1-16221010
-- Added logic to exclude GRT tax for OH accounts
-- =============================================
-- Modified Gabor Kovacs 5/23/2012
-- Add simple index plan type
-- =============================================
-- Modified José Muñoz 09/25/2012
-- Ticket 1-28758340.  (Timeout Problem)
-- Added table Account_id field to Join to Account_address, Account_Contact 
-- and Account_name tables
-- =============================================
-- Modified Isabelle Tamanini 10/05/2012
-- Grace period for ACE BR accounts should be 6
-- SR1-29463341
-- =============================================
-- Modified Isabelle Tamanini 10/08/2012
-- Modified Customer Name of Dayton accounts so that
-- it returns Name Key + Customer Name
-- SR1-30826374
-- =============================================
-- Modified Cathy Ghazal 11/02/2012
-- use vw_AccountContractRate instead of AccountContractRate
-- MD084
-- =============================================

*/

-- exec usp_tblAccounts_IstaEnrollmentService_sel '6600413011'
ALTER PROCEDURE [dbo].[usp_tblAccounts_IstaEnrollmentService_sel]
      @p_account_number varchar(30),
      @p_utility varchar(15) = null
AS
set nocount on

--DECLARE   @p_account_number varchar(30)
--DECLARE   @p_utility varchar(15) 
--SET @p_account_number = '08008985610002181618'
--SET @p_utility = null

-- Ticket 17446 Start, gathering tax data to send with the other info
DECLARE @TaxStatus VARCHAR(20)
DECLARE @account_id VARCHAR(12)

SELECT @TaxStatus = tax_status, @account_id = account_id
FROM lp_account.dbo.account WITH (NOLOCK)
WHERE account_number = @p_account_number AND utility_id = isnull(@p_utility,utility_id)

DECLARE @temp TABLE (TaxTypeID INT, PercentTaxable DECIMAL(9,6), TypeOfTax varchar(20))
INSERT INTO @temp
EXEC libertypower..usp_AccountTaxDetailSelect @TaxStatus,@p_utility,@account_id
-- Ticket 17446 End

SELECT
            A.AccountIdLegacy       AS account_id,
            A.ServiceRateClass            AS Service_rate_class,
            A.Zone                              AS Zone,
            A.AccountTypeID,A.CustomerID,A.ServiceAddressID,A.BillingAddressID,A.AccountIdLegacy,A.AccountID,A.CurrentContractId,A.BillingTypeID,A.RetailMktID,A.MeterTypeID,A.UtilityID,A.EntityID,A.AccountNameID,A.TaxStatusID,A.PorOption,
            A.AccountNumber               AS AccountNumber
INTO #Account
FROM Libertypower.dbo.Account A 
WHERE accountnumber = @p_account_number


SELECT
            BILLT.[Type]                  AS billing_type,
            CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE AT.AccountType END               AS AccountType,
            CASE WHEN a.PorOption = 0 THEN 'NO' ELSE 'YES' END AS por_option,
            C.StartDate                   AS contract_eff_start_date,
            MARKET.MarketCode       AS retail_mkt_id,
            ACR.LegacyProductID           AS Product,
            ACR.RateID                    AS rate_id,
            p.product_category            AS ProductCategory,
            p.product_sub_category  AS ProductSubCategory,
            ----
            TX.[Status] AS TaxStatus, --A.TaxStatusID AS TaxStatus,
            C.SignedDate AS date_deal,
            0 AS IS_RENEWAL,
            U.UtilityCode AS Utility,
            W.[address] AS ServiceStreet,
            W.suite AS ServiceSuite,
            W.city AS ServiceCity,
          W.county AS ServiceCounty,
          W.[state] AS ServiceState,
          W.zip AS ServiceZip,
          CC.[address] AS BillingStreet,
            CC.suite AS BillingSuite,
          CC.city AS BillingCity,
          CC.county AS BillingCounty,
          CC.[state] AS BillingState,
            CC.zip AS BillingZip,
            D.first_name AS ContactName,
            D.last_name AS ContactLastName,
            Z.full_name AS CustomerName,
            D.email AS ContactEmail,
            ACR.Term AS ContractTerm,
            K.duns_number AS LPC_duns,
            D.phone AS ContactPhone,
            ACR.Rate      AS PriceRate,   
            ACR.RateCode  AS rate_code,
            A.account_id,
            A.accountnumber,
            A.Service_rate_class,
            A.Zone,
            MT.MeterTypeCode AS meter_type,
            U.DunsNumber AS utility_duns
            
INTO #tblaccounts
FROM #Account A 
JOIN LibertyPower.dbo.AccountType AT WITH (NOLOCK) ON A.AccountTypeID = AT.ID 
JOIN LibertyPower.dbo.Customer CUST WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID
JOIN Libertypower.dbo.[AccountContract] AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractId = AC.ContractID
JOIN Libertypower.dbo.[Contract] C WITH (NOLOCK) ON AC.ContractID = C.ContractID
JOIN Libertypower.dbo.AccountDetail AD WITH (NOLOCK) ON A.AccountID = AD.AccountID
JOIN Libertypower.dbo.vw_AccountContractRate ACR WITH (NOLOCK) ON AC.AccountContractID = ACR.AccountContractID --AND ACR.IsContractedRate  = 1 
JOIN Libertypower.dbo.AccountStatus ASS WITH (NOLOCK) ON AC.AccountContractID = ASS.AccountContractID
JOIN Libertypower.dbo.BillingType  BILLT WITH (NOLOCK) ON A.BillingTypeID = BILLT.BillingTypeID
LEFT JOIN Libertypower.dbo.BusinessActivity BA WITH (NOLOCK) ON CUST.BusinessActivityID = BA.BusinessActivityID
JOIN Libertypower.dbo.ContractType CT WITH (NOLOCK) ON C.ContractTypeID = CT.ContractTypeID
JOIN Libertypower.dbo.Market  MARKET WITH (NOLOCK) ON A.RetailMktID = MARKET.ID
JOIN Libertypower.dbo.MeterType     MT WITH (NOLOCK) ON A.MeterTypeID = MT.ID
LEFT JOIN Libertypower.dbo.EnrollmentType ET WITH (NOLOCK) ON AD.EnrollmentTypeID = ET.EnrollmentTypeID
LEFT JOIN LibertyPower.dbo.Utility U WITH (NOLOCK) ON A.UtilityID = U.ID -- J 
LEFT JOIN lp_common.dbo.common_entity AS K WITH (NOLOCK) ON A.EntityID = K.entity_id -- K
LEFT JOIN lp_account.dbo.account_name AS B WITH (NOLOCK) ON B.Account_id = A.AccountIDLegacy and B.AccountNameID = A.AccountNameID -- B
LEFT JOIN lp_account.dbo.account_name AS Z WITH (NOLOCK) ON Z.Account_id = A.AccountIDLegacy and Z.AccountNameID = CUST.NameID -- Z
LEFT JOIN lp_account.dbo.account_contact AS D WITH (NOLOCK) ON D.Account_id = A.AccountIDLegacy and D.AccountContactID = CUST.ContactID
LEFT JOIN lp_account.dbo.account_address AS W WITH (NOLOCK) ON W.Account_id = A.AccountIDLegacy and W.AccountAddressID = A.ServiceAddressID
LEFT JOIN lp_account.dbo.account_address AS CC WITH (NOLOCK) ON CC.Account_id = A.AccountIDLegacy and CC.AccountAddressID = A.BillingAddressID
LEFT JOIN lp_account.dbo.account_additional_info AS e WITH (NOLOCK) ON e.account_id = A.AccountIdLegacy
LEFT JOIN Libertypower.dbo.TaxStatus TX WITH (NOLOCK) ON A.TaxStatusID = TX.TaxStatusID 
LEFT JOIN lp_common.dbo.common_product AS p WITH (NOLOCK) ON p.product_id = ACR.LegacyProductID
WHERE accountnumber = @p_account_number


SELECT distinct
            AccountNumber, 
            replace(AccountNumber,utility,'') as account_number, -- Some accounts have a utility appended as a workaround
            -- Ticket 22862 BEGIN
            ARTerms = CASE WHEN (at.paymentTerm = 0) or (at.paymentTerm is null) then isnull(up.[ARTerms], 15)
                        ELSE at.paymentTerm END,
          -- ARTerms = isnull(up.[ARTerms], 15),            -- Ticket 21480
          -- Ticket 22862 END
          -- ARTerms = convert(int,up.[ARTerms]),  -- Ticket 21480

            v.account_id,
            BillingAccountNumber = ai.BillingAccount,
            BillingAddress1 = billingstreet,
            BillingAddress2 = billingsuite,
            BillingCity,
            BillingContact = isnull(ContactName + ' ' + ContactLastName,CustomerName),
            BillingState,
            v.billing_type,
            BillingZip,
            comments = '',
            ContactEmail,
            ContactPhone = substring(replace(v.ContactPhone,'-',''),1,10),
            CustomerGroup = 'NA', --isnull(db_group,'NA'),
            customerName = case when v.utility = 'AMEREN' then left(CustomerName,35) 
						   when v.utility='DAYTON' then left(isnull(name_key, ''), URD.required_length) + ' '+CustomerName
						   else CustomerName end,-- Changed to use CustomerName, from AccountName, on 2009-04-06 
            customerType = case when v.accounttype in ('Residential','SOHO') then 'RES' else v.accounttype end, 
            DBA = '',
            defaultrate = .10,
            defaultplantype = case 
				when dp.product_category = 'FIXED' then 0 
				when dp.product_category = 'VARIABLE' and dp.product_sub_category = 'PORTFOLIO' then 1 
				when dp.product_category = 'VARIABLE' and dp.product_sub_category in ('CUSTOM') then 2
				when dp.product_category = 'VARIABLE' and dp.product_sub_category in ('BLOCK-INDEXED') then 4
				when dp.product_category = 'VARIABLE' and dp.product_sub_category in ('HYBRID') then 4							
				when dp.product_category = 'VARIABLE' and dp.product_sub_category in ('FIXED ADDER') then 7
				when dp.product_category = 'VARIABLE' then 1
			else 0 end,
            defaultratecode = v.rate_code, --not currently in DB
            defaultRateEffectiveDate = dateadd(month, contractterm, v.contract_eff_start_date), --same as rate end date
            --dr.rate as defaultRate, --never has a set rate as all default products are variable
            defaultRateEndDate = dateadd(month, 12, dateadd(month, contractterm, v.contract_eff_start_date)), --default product start date PLUS 12 month term
            defaultProductCode = ltrim(rtrim(p.default_expire_product_id)) + '___0',
            --'' as defaultRatecode, --not set as default product is variable not fixed
            defaultratecategory = dp.product_category,
            defaultratesubcategory = CASE WHEN v.retail_mkt_id <> 'TX' and dp.product_sub_category = 'FIXED ADDER' THEN 'CUSTOM' ELSE dp.product_sub_category END,
            digitalSignature = 'Liberty',  
            '' as federalTaxId, 
            firstName = ContactName, 
            had_error_before = 0,
                  --case 
                  --    when (SELECT top 1 record_id FROM error_log WHERE appname = 'ISTA Enrollment Submission' and record_id = v.account_id) is null then 0 
                  --    else 1 
                  --end ,
            isratecoderequired = 'false',
            ista_zone_id = 
                  case when not (ProductCategory = 'VARIABLE' and ProductSubCategory = 'PORTFOLIO') and v.retail_mkt_id = 'TX' then null
                        when v.utility = 'O&R' then 10 -- work around for the bad data on ISTA's side
                        when utility_duns = '006929509' then 51 --COMED
                        when utility_duns = '006973358' then 58 --JCPL
                        when utility_duns = '006973812' then 57 --PSEG
                        --when z.zone = 'PPL' or v.zone = 'PPL' then 91 -- ticket 21227 
                         when z.ista_mapping is not null then z.ista_mapping
                        when z.ista_mapping is null and utility_duns = '156171464' then 47
                        when z.ista_mapping is null and utility_duns = '006920284' then 48
                        when z.ista_mapping is null and utility_duns = '006920284DC' then 49
                        when z.ista_mapping is null then 0
                        end,
            ista_class_id = ISNULL(sc.ista_mapping, 4),
            lastName = ContactLastName, 
            lifeSupport = 'false',  
            lpc_duns = case when v.utility in ('DELDE') then '784087293P' else v.lpc_duns end,
            --= case when v.utility in ('DELDE') then '784087293P' 
            --                when v.utility = 'CMP' then '7840872930001'   
            --                when v.retail_mkt_id = 'ME' then '784087293PROD'   
            --                else lpc_duns end,
            meter = case when v.utility = 'COMED' then '111111111'
                              else (SELECT MAX(meter_number) FROM account_meters WHERE account_id = v.account_id) end,
            MeterCharge = case when v.retail_mkt_id = 'TX' 
                                          and (v.product not like '%NOMC%' OR v.accounttype in ('Residential','SOHO')) 
                                       then 4.00
                               else 0 end,
            ai.MeterDataMgmtAgent, ai.MeterServiceProvider, ai.MeterInstaller, ai.MeterReader, ai.MeterOwner, 
            ai.SchedulingCoordinator,
            middlename = '',
            NameKey = case when v.utility like 'nstar%' and v.accounttype not in ('RES','Residential','SOHO') then 'star'
                           when v.utility like 'nstar%' and v.accounttype in ('RES','Residential','SOHO') then left(ContactLastName,4)
                                    else left(isnull(ai.name_key, ''), URD.required_length) end,
            notificationWaiver = 'false',
            
            plantype = case when (not ar.account_id is null) and not (ar.[status] = '07000' and ar.sub_status in ('80','90')) 
				then
					case when dpd2.HasPassThrough = 1 then 4
					when p2.product_category = 'FIXED' then 0 
					when p2.product_category = 'VARIABLE' and p2.product_sub_category = 'PORTFOLIO' then 1 
					when p2.product_category = 'VARIABLE' and p2.product_sub_category in ('CUSTOM') then 2
					when p2.product_category = 'VARIABLE' and p2.product_sub_category in ('BLOCK-INDEXED') then 4
					when p2.product_category = 'VARIABLE' and p2.product_sub_category in ('HYBRID') then 4							
					when p2.product_category = 'VARIABLE' and p2.product_sub_category in ('FIXED ADDER') then 7
					when p2.product_category = 'VARIABLE' and p2.product_sub_category in ('FIXED ADDER PASSTHRU') then 2 
					when p2.product_category = 'VARIABLE' then 1 
					else 0 end
				else
					case when dpd.HasPassThrough = 1 then 4
					when ProductCategory = 'FIXED' then 0 
					when ProductCategory = 'VARIABLE' and ProductSubCategory = 'PORTFOLIO' then 1 
					when ProductCategory = 'VARIABLE' and ProductSubCategory in ('CUSTOM') then 2
					when ProductCategory = 'VARIABLE' and ProductSubCategory in ('BLOCK-INDEXED') then 4
					when ProductCategory = 'VARIABLE' and ProductSubCategory in ('HYBRID') then 4							
					when ProductCategory = 'VARIABLE' and ProductSubCategory in ('FIXED ADDER') then 7
					when ProductCategory = 'VARIABLE' and ProductSubCategory in ('FIXED ADDER PASSTHRU') then 2 
					when ProductCategory = 'VARIABLE' then 1 
					else 0 end
				end,
            por_option              = case  when v.utility = 'COMED' AND v.billing_type = 'DUAL' then 'false'
                                                      when v.utility = 'COMED' AND v.billing_type = 'BR' then 'true'
                                                      when v.por_option = 'YES' then 'true' 
                                                      else 'false' end,
            printLayout             = 'Standard',
            ProductCategory         = case when (not ar.account_id is null) and not (ar.[status] = '07000' and ar.sub_status in ('80','90'))
                                          then (select product_category FROM lp_common.dbo.common_product WITH (NOLOCK) WHERE  product_id = ar.product_id)
                                          else ProductCategory end ,    
            productCode             = case when (not ar.account_id is null) and not (ar.[status] = '07000' and ar.sub_status in ('80','90'))
                                          then ltrim(rtrim(ar.product_id)) + '___' + convert(varchar, ar.rate_id)
                                          else ltrim(rtrim(v.product)) + '___' + convert(varchar, v.rate_id)end ,
            salutation              = '',
            ServiceClass            = isnull(isnull(sc.ratecode_file_mapping,v.Service_rate_class),''), -- Alter Ticket 16918
            servicestreet,
            servicesuite,
            servicecity,
            spanishBill = 'false', 
            TdspTemplate = 'ALL_IN', 
--          usageclass = case when Service_rate_class is null or Service_rate_class = '' then 4 else Service_rate_class end,
            servicestate,
            servicezip,
            Taxable = CASE WHEN v.TaxStatus = 'EXEMPT' AND v.retail_mkt_id = 'PA' THEN 'true'
                                 WHEN v.TaxStatus = 'EXEMPT' AND v.retail_mkt_id = 'TX' THEN 'true'
                                 WHEN v.TaxStatus = 'EXEMPT' THEN 'false'
                                 ELSE 'true' END, 
            TaxCode = CASE WHEN v.TaxStatus = 'EXEMPT' AND v.retail_mkt_id = 'PA' THEN 127
                                 WHEN v.TaxStatus = 'EXEMPT' AND v.retail_mkt_id = 'TX' THEN 48
                                 WHEN v.TaxStatus = 'EXEMPT' THEN 0
                                 WHEN v.retail_mkt_id = 'NY' THEN 79 
                                 WHEN v.retail_mkt_id in ('MD','DC','DE','CT','OH') THEN 111 
                                 ELSE 127 END, 
            TaxStatus,
            -- Ticket 17446 Start
            Tax_State = CASE WHEN v.TaxStatus = 'EXEMPT' and v.retail_mkt_id <> 'PA' THEN 1.0
                                    WHEN v.retail_mkt_id <> 'PA' THEN 0.0
                                    ELSE 1.0 - (select top 1 isnull(PercentTaxable,100)/100.0 from @temp where TypeOfTax = 'State') END,
            Tax_County = CASE WHEN v.TaxStatus = 'EXEMPT' and v.retail_mkt_id <> 'PA' THEN 1.0
                                      WHEN v.retail_mkt_id <> 'PA' THEN 0.0
                                    ELSE 1.0 - (select top 1 isnull(PercentTaxable,100)/100.0 from @temp where TypeOfTax = 'County') END,
            Tax_City = CASE WHEN v.TaxStatus = 'EXEMPT' and v.retail_mkt_id <> 'PA' THEN 1.0
                                      WHEN v.retail_mkt_id <> 'PA' THEN 0.0
                                    ELSE 1.0 - (select top 1 isnull(PercentTaxable,100)/100.0 from @temp where TypeOfTax = 'City') END,
            Tax_Special = CASE WHEN v.TaxStatus = 'EXEMPT' and v.retail_mkt_id <> 'PA' THEN 1.0
                                      WHEN v.retail_mkt_id <> 'PA' THEN 0.0
                                    ELSE 1.0 - (select top 1 isnull(PercentTaxable,100)/100.0 from @temp where TypeOfTax = 'Special') END,
            Tax_PUC = CASE WHEN v.TaxStatus = 'EXEMPT' and v.retail_mkt_id <> 'PA' THEN 1.0
                                      WHEN v.retail_mkt_id <> 'PA' THEN 0.0
                                    ELSE 1.0 - (select top 1 isnull(PercentTaxable,100)/100.0 from @temp where TypeOfTax = 'PUC') END,
            Tax_GRT = CASE WHEN (v.TaxStatus = 'EXEMPT' and v.retail_mkt_id <> 'PA') OR v.retail_mkt_id = 'OH' THEN 1.0
                                      WHEN v.retail_mkt_id <> 'PA' THEN 0.0
                                    ELSE 1.0 - (select top 1 isnull(PercentTaxable,100)/100.0 from @temp where TypeOfTax = 'GRT') END,
            Tax_Franchise = CASE WHEN v.TaxStatus = 'EXEMPT' and v.retail_mkt_id <> 'PA' THEN 1.0
                                      WHEN v.retail_mkt_id <> 'PA' THEN 0.0
                                    ELSE 1.0 - (select top 1 isnull(PercentTaxable,100)/100.0 from @temp where TypeOfTax = 'Franchise') END,

            --Tax_State = 0.0,
            --Tax_County = 0.0,
            --Tax_City = 0.0,
            --Tax_Special = 0.0,
            --Tax_PUC = 0.0,
            --Tax_GRT = 0.0,
            --Tax_Franchise = 0.0,

            -- Ticket 17446 End
            utility,
            utility_duns = CASE WHEN utility_duns = '007909427' THEN '007909427AC' ELSE utility_duns END,
            --rateEffectiveDate = dateadd(dd,-2,getdate()),
            --rate = pricerate,
            --rateEndDate = getdate(),
            --rateEndDate = dateadd(month, contractterm, getdate()),
            rateEffectiveDate = case when (not ar.account_id is null) and not (ar.[status] = '07000' and ar.sub_status in ('80','90')) 
                                          then lp_enrollment.dbo.ufn_date_format(ar.contract_eff_start_date ,'<YYYY>-<MM>-<DD>')
                                          else lp_enrollment.dbo.ufn_date_format(getdate(),'<YYYY>-<MM>-<DD>') end , -- Add Ticket 17013
            ContractStartDate = case when v.utility = 'PPL' then v.date_deal  -- ticket 12538
                                                      else lp_enrollment.dbo.ufn_date_format(getdate(),'<YYYY>-<MM>-<DD>') end,
            rate  = case when (not ar.account_id is null) and not (ar.[status] = '07000' and ar.sub_status in ('80','90')) then ar.rate else v.pricerate end , -- ADD Ticket 17013
            rateEndDate       = case when (not ar.account_id is null) and not (ar.[status] = '07000' and ar.sub_status in ('80','90')) then dateadd(month, ar.term_months, ar.contract_eff_start_date)
                                    else dateadd(month, contractterm, getdate()) end , -- Add Ticket 17013
            ContractEndDate = case when (not ar.account_id is null) and not (ar.[status] = '07000' and ar.sub_status in ('80','90')) then dateadd(month, ar.term_months, ar.contract_eff_start_date)
                                    else dateadd(month, contractterm, v.contract_eff_start_date) end,
            ratecode = v.rate_code, --not currently in DB
            ratecategory = v.productcategory,
            ratesubcategory = CASE WHEN v.retail_mkt_id <> 'TX' and v.productsubcategory = 'FIXED ADDER' THEN 'CUSTOM' ELSE v.productsubcategory END,
            VariableTypeID = CASE WHEN v.product like '%Flex%' THEN 2 ELSE 1 END,
            Zone = isnull(z.Zone, v.Zone), v.account_id, v.meter_type,
            MarketCode = v.retail_mkt_id, -- SD22422
            --SR 1-2966641
            GracePeriod = CASE WHEN (v.utility = 'DELDE' OR v.utility = 'ACE') AND v.billing_type = 'BR' THEN 6
                                ELSE 3
                                END,
            ApplyLateFees = ISNULL(ulf.[ApplyLateFees], 1)
      --INTO #AccountRecord
      FROM #tblaccounts v
      --LEFT JOIN account a WITH (NOLOCK)       ON v.account_id                           = a.account_id
      LEFT JOIN account_renewal ar WITH (NOLOCK)      ON ar.account_id                    = v.account_id 
                                                                              and ar.contract_eff_start_date    <= getdate()-- ADD Ticket 17013
      LEFT JOIN account_info ai WITH (NOLOCK)   ON v.account_id                           = ai.account_id
      LEFT JOIN lp_common.dbo.common_product p WITH (NOLOCK)      ON v.product                              = p.product_id
      LEFT JOIN lp_common.dbo.common_product dp WITH (NOLOCK)     ON dp.product_id                    = p.default_expire_product_id
      LEFT JOIN lp_common.dbo.common_product_rate pr WITH (NOLOCK)      ON v.Product                              = pr.product_id 
                                                                                                      AND v.rate_id                             = pr.rate_id 
      LEFT JOIN lp_deal_capture..deal_pricing_detail dpd WITH (NOLOCK)  ON dpd.product_id                   = pr.product_id 
                                                                                                            AND dpd.rate_id                           = pr.rate_id 
      LEFT JOIN lp_common.dbo.common_product p2 WITH (NOLOCK)     ON ar.product_id                    = p2.product_id
      LEFT JOIN lp_common.dbo.common_product dp2 WITH (NOLOCK)    ON dp2.product_id                   = p2.default_expire_product_id
      LEFT JOIN lp_common.dbo.common_product_rate pr2 WITH (NOLOCK)     ON ar.product_id                    = pr2.product_id 
                                                                                                            AND ar.rate_id                            = pr2.rate_id 
      LEFT JOIN lp_deal_capture..deal_pricing_detail dpd2 WITH (NOLOCK)       ON dpd2.product_id                     = pr2.product_id 
                                                                                                            AND dpd2.rate_id                    = pr2.rate_id 
      LEFT JOIN lp_common.dbo.service_rate_class sc WITH (NOLOCK)       ON pr.service_rate_class_id            = sc.service_rate_class_id
      LEFT JOIN lp_common.dbo.zone z WITH (NOLOCK)    ON pr.zone_id                             = z.zone_id
-- Ticket 21480 begin 
      LEFT JOIN LibertyPower.dbo.Utility ut WITH (NOLOCK)   ON ut.UtilityCode                   = v.utility
      LEFT JOIN LibertyPower.dbo.Market mk WITH (NOLOCK)    ON mk.MarketCode                    = v.retail_mkt_id
                                                                                          and mk.ID                               = ut.MarketId
      LEFT JOIN LibertyPower.dbo.UtilityPaymentTerms up WITH (NOLOCK)   ON up.MarketId                            = mk.ID
      AND (up.UtilityId                        = ut.ID OR up.UtilityId    = 0) 
       AND (up.BillingType                = v.billing_type OR (up.BillingType   IS NULL AND NOT EXISTS (SELECT 1 FROM LibertyPower.dbo.UtilityPaymentTerms ut WITH (NOLOCK)
              WHERE ut.utilityid    = up.utilityid
              and ut.marketid       = up.marketid
              and ut.BillingType    = v.billing_type)))
      AND (up.AccountType                = v.AccountType OR (up.AccountType        IS NULL AND NOT EXISTS (SELECT 1 FROM LibertyPower.dbo.UtilityPaymentTerms uta WITH (NOLOCK)
              WHERE uta.utilityid   = up.utilityid
              and uta.marketid            = up.marketid
              and uta.AccountType   = v.AccountType)))
-- Ticket 21480 End
-- Ticket 22862 Begin
      LEFT JOIN lp_account.dbo.AccountPaymentTerm at WITH (NOLOCK)      ON at.accountid   = v.account_id
-- Ticket 22862 End
      LEFT JOIN LibertyPower.dbo.UtilityLateFees ulf WITH (NOLOCK)    ON ulf.UtilityId = ut.ID
                                                                                                   AND ulf.MarketId  = mk.ID
	  LEFT JOIN lp_common.dbo.utility_required_data URD (NOLOCK) ON URD.utility_id = ut.UtilityCode
	  AND URD.account_info_field = 'name_key'
                                                                                                   
     WHERE v.accountnumber = @p_account_number
      AND v.IS_RENEWAL = 0
      AND v.utility = isnull(@p_utility,v.utility)
      -- Ticket 13791.  Added 2010-06-30.  To prevent SC1 and SC2 from being sent out with wrong billing_type.
      -- AND NOT (a.service_rate_class like 'SC[1,2]%' and v.billing_type = 'DUAL' and a.utility_id = 'NIMO')
      -- This changed has been reversed by Billing on 2010-08-05.
      AND NOT (v.billing_type <> 'DUAL' and v.utility = 'NIMO')

set nocount off
