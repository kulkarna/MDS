USE [lp_account]
GO

/****** Object:  View [dbo].[tblAccounts]    Script Date: 6/4/2015 2:08:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*

select * from [dbo].[tblAccounts_jmunoz]

select * from [dbo].[tblAccounts] where Utility = 'CONED'

*/
-- =============================================
-- Modified José Muñoz 01/31/2012
-- Remove the union and diferenciate the Current Contract of the Renewal Contract
-- =============================================
-- Modified Isabelle Tamanini 04/23/2012
-- Added logic from account view to bring the correct contract type
-- SR1-13854619
-- =============================================
-- Modified Cathy Ghazal 11/2/2012
-- user vw_AccountContractRate instead of AccountContractRate
-- MD084
-- =============================================
-- Modified Agata Studzinska 2/6/2013
-- Removed case to bring correct de_enrollemnt date for account in any status
-- SR1-59251192
--===============================================
Create VIEW [dbo].[tblAccounts_06052015]
AS
SELECT
		A.EntityID AS Entity,
		U.WholeSaleMktID AS wholesale_mkt_id,
		K.duns_number AS LPC_duns,
		U.DunsNumber AS utility_duns,
		U.UtilityCode AS Utility,
		A.AccountIdLegacy AS account_id,
		A.AccountNumber AS AccountNumber,
		CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE AT.AccountType	END AS AccountType, -- AT.AccountType AS AccountType,
		B.full_name AS AccountName,
		Z.full_name AS CustomerName,
		BT.[Type] AS BusinessType,
		BA.Activity AS BusinessActivity,
		D.first_name AS ContactName,
		D.last_name AS ContactLastName,
		D.title AS ContactTitle,
		D.phone AS ContactPhone,
		D.fax AS ContactFax,
		D.email AS ContactEmail,
		D.birthday AS ContactBirthday,
		[Libertypower].[dbo].[ufn_GetLegacyContractType] ( CT.[Type] , CTT.ContractTemplateTypeID, CDT.DealType) AS ContractType,
		C.[Number] AS ContractNumber,
		ACR.Term AS ContractTerm,
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
		
		-- f.status_descp + ' ' + f.sub_status_descp AS AccountStatus,
		CASE WHEN (ASS.[Status]			= '07000' AND ASS.SubStatus = '90' AND A.CurrentContractId = AC.ContractID) THEN 'Not Enrolled Done' 
			 WHEN (ASS.[Status]			= '07000' AND ASS.SubStatus = '10' AND A.CurrentContractId = AC.ContractID) THEN 'Pending Enrollment Create Utility File' 
			 WHEN (ASS.[Status]			= '05000' AND A.CurrentRenewalContractId = AC.ContractID) THEN 'Pending Renewal ' --'07000' 
			 WHEN (C.ContractStatusID	=  2	  AND A.CurrentRenewalContractId = AC.ContractID) THEN 'Pending Renewal ' -- '07000' 
			 ELSE f.status_descp + ' '   END + f.sub_status_descp AS AccountStatus,

		CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS Product,
		
		CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.Rate			 ELSE AC_DefaultRate.Rate			 END AS PriceRate,
	
		TX.[Status] AS TaxStatus, --A.TaxStatusID AS TaxStatus,
		NULL AS TaxRate,	
		
		'SALES CHANNEL/' + SCH.ChannelName AS SalesChannelID,
		C.SalesRep AS SalesRep,
		AU.AnnualUsage AS AnnualUsage,
		NULL AS CreditScore,
		CA.Name AS CreditAgency,
		CONVERT(datetime, CONVERT(char(10), C.SubmitDate, 101)) AS SubmitDate,
		AC.RequestedStartDate AS RequestedFlowStartDate,
		
		CASE WHEN ASS.[Status] in ('999998','999999','01000','03000','04000','05000') AND ASS.[SubStatus] not in ('30') THEN CAST('1900-01-01 00:00:00' AS DATETIME)
			 ELSE ISNULL(ASERVICE.StartDate, CAST('1900-01-01 00:00:00' AS DATETIME)) END AS FlowStartDate,
		
		AC.SendEnrollmentDate AS CUBSEffectiveDate,
		
		--CASE WHEN ASS.[Status] in ('999998','999999','01000','03000','04000','05000') THEN CAST('1900-01-01 00:00:00' AS DATETIME)
		--	 WHEN ASS.[Status] in ('13000') AND ASS.[SubStatus] in ('70','80') THEN CAST('1900-01-01 00:00:00' AS DATETIME)
		--	 ELSE ISNULL(ASERVICE.EndDate, CAST('1900-01-01 00:00:00' AS DATETIME)) END AS De_enrollmentDate,
		ASERVICE.EndDate AS De_enrollmentDate, --SR1-59251192
		
		NULL AS Re_enrollmentDate,
		A.CustomerID AS customer_id,
		MARKET.MarketCode AS retail_mkt_id,
		--ACR.RateID AS rate_id,
		CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.RateID			 ELSE AC_DefaultRate.RateID			 END AS rate_id,
		
		CASE WHEN LTRIM(RTRIM(CUST.Duns)) <> '' THEN 'DUNSNBR' 
		WHEN LTRIM(RTRIM(CUST.EmployerId)) <> '' THEN 'EMPLID' 
		WHEN LTRIM(RTRIM(CUST.TaxId)) <> '' THEN 'TAX ID' 
		ELSE CASE WHEN CUST.SsnEncrypted IS NOT NULL AND CUST.SsnEncrypted != '' THEN 'SSN' 
			      ELSE 'NONE' END END AS additional_id_nbr_type,
		
		CASE WHEN LTRIM(RTRIM(CUST.Duns)) <> '' THEN CUST.Duns
		WHEN LTRIM(RTRIM(CUST.EmployerId)) <> '' THEN CUST.EmployerId 
		WHEN LTRIM(RTRIM(CUST.TaxId)) <> '' THEN CUST.TaxId 
		ELSE CASE WHEN CUST.SsnEncrypted IS NOT NULL  AND CUST.SsnEncrypted != '' THEN '***-**-****' ELSE 'NONE' END END AS additional_id_nbr,
	 
		--C.StartDate		AS contract_eff_start_date,
		CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.RateStart  ELSE AC_DefaultRate.RateStart END AS contract_eff_start_date,
		--C.EndDate		AS date_end,
		CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.RateEnd	ELSE AC_DefaultRate.RateEnd   END AS date_end,
		
		 
		C.SignedDate	AS date_deal,
		A.DateCreated	AS date_created,
		USER1.UserName  AS username,
		A.Origin		AS origin,
		A.Zone			AS Zone,
		A.ServiceRateClass	AS Service_rate_class,
		A.StratumVariable	AS StratumVariable,
		--e.field_04_value	AS TripNumber,
		A.BillingGroup		AS TripNumber,
		A.Icap				AS Icap,
		e.field_06_value	AS ProfitabilityFactor,
		A.Tcap				AS Tcap,
		A.LoadProfile		AS LoadProfile,
		A.LossCode			AS LossCode,
		e.field_10_value	AS BankRating,
		MT.MeterTypeCode	AS [Meter Type],
	    
	 --   ASS.[Status]	AS status,
		--ASS.SubStatus   AS sub_status,
		
		CASE WHEN (ASS.[Status]			= '07000' AND ASS.SubStatus = '90' AND A.CurrentContractId = AC.ContractID) THEN '999999' 
			 WHEN (ASS.[Status]			= '07000' AND ASS.SubStatus = '10' AND A.CurrentContractId = AC.ContractID) THEN '05000' 
			 WHEN (ASS.[Status]			= '05000' AND A.CurrentRenewalContractId = AC.ContractID) THEN '07000' 
			 WHEN (C.ContractStatusID	=  2	  AND A.CurrentRenewalContractId = AC.ContractID) THEN '07000' 
			 ELSE ASS.[Status] END AS [status] ,
		
		CASE WHEN (ASS.[Status]			= '07000' AND ASS.SubStatus = '90' AND A.CurrentContractId = AC.ContractID) THEN '10' 
			 WHEN (ASS.[Status]			= '05000' AND A.CurrentRenewalContractId = AC.ContractID) THEN '20' 
			 WHEN (C.ContractStatusID	=  2	  AND A.CurrentRenewalContractId = AC.ContractID) THEN '80' 
			 ELSE ASS.SubStatus END AS sub_status ,

		A.PorOption		AS por_option,
		p.product_category AS ProductCategory,
		p.product_sub_category AS ProductSubCategory,
		BILLT.[Type]	AS billing_type,
		URS.[Status]	AS usage_req_status,
		--db.code1		per douglas
		'' AS DB_GROUP,
		
		--CASE	WHEN not (A.CurrentRenewalContractId is null)	THEN 1
		--		ELSE 0
		--		END AS IS_RENEWAL,
		ISRENEWAL AS IS_RENEWAL,
		ET.[Type]		AS enrollment_type,
		e.field_12_value AS [Carrier Route Code],
		e.field_13_value AS SIC,
		e.field_14_value AS [Accuracy %],
		CASE WHEN LTRIM(RTRIM(CUST.Duns)) <> '' THEN CUST.Duns ELSE '' END AS [DUNS Number],
		-- MANAGERUSER.UserName AS sales_manager	
		ManagerUser.Firstname + ' ' + ManagerUser.Lastname AS sales_manager
		,A.CurrentContractID
		

FROM 
(SELECT *,CurrentContractID as ContractID, IsRenewal = 0 FROM LibertyPower..Account (NOLOCK) WHERE CurrentContractID IS NOT NULL
 UNION ALL
 SELECT *,CurrentRenewalContractID as ContractID, IsRenewal = 1 FROM LibertyPower..Account (NOLOCK) WHERE CurrentRenewalContractID IS NOT NULL
 ) A
JOIN Libertypower.dbo.[AccountContract] AC WITH (NOLOCK) ON A.AccountID = AC.AccountID  AND A.ContractID = AC.ContractID
JOIN LibertyPower.dbo.AccountType AT WITH (NOLOCK) ON A.AccountTypeID = AT.ID 
JOIN LibertyPower.dbo.Customer CUST	 WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID
JOIN Libertypower.dbo.[Contract] C WITH (NOLOCK) ON AC.ContractID = C.ContractID
JOIN Libertypower.dbo.AccountDetail	AD WITH (NOLOCK) ON A.AccountID = AD.AccountID
JOIN Libertypower.dbo.vw_AccountContractRate ACR WITH (NOLOCK) ON AC.AccountContractID = ACR.AccountContractID --AND ACR.IsContractedRate  = 1 
JOIN Libertypower.dbo.AccountContractCommission ACC WITH (NOLOCK) ON AC.AccountContractID = ACC.AccountContractID
JOIN Libertypower.dbo.AccountStatus ASS WITH (NOLOCK) ON AC.AccountContractID = ASS.AccountContractID
JOIN Libertypower.dbo.BillingType  BILLT WITH (NOLOCK) ON A.BillingTypeID = BILLT.BillingTypeID
LEFT JOIN Libertypower.dbo.BusinessActivity BA WITH (NOLOCK) ON CUST.BusinessActivityID = BA.BusinessActivityID
JOIN Libertypower.dbo.ContractType CT WITH (NOLOCK) ON C.ContractTypeID = CT.ContractTypeID
JOIN LibertyPower.dbo.ContractTemplateType CTT	WITH (NOLOCK)	ON C.ContractTemplateID= CTT.ContractTemplateTypeID
LEFT JOIN LibertyPower.dbo.ContractDealType CDT		WITH (NOLOCK)	ON C.ContractDealTypeID = CDT.ContractDealTypeID
JOIN Libertypower.dbo.Market	MARKET WITH (NOLOCK) ON A.RetailMktID = MARKET.ID
JOIN Libertypower.dbo.MeterType	MT WITH (NOLOCK) ON A.MeterTypeID = MT.ID

left JOIN LibertyPower.dbo.AccountUsage USAGE	WITH (NOLOCK)		ON A.AccountID = USAGE.AccountID AND  C.StartDate = USAGE.EffectiveDate
left JOIN LibertyPower.dbo.UsageReqStatus URS	WITH (NOLOCK)		ON USAGE.UsageReqStatusID = URS.UsageReqStatusID
-- NEW DEFAULT RATE JOIN:
LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
		   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
	       WHERE ACRR.IsContractedRate = 0 
	       GROUP BY ACRR.AccountContractID
          ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
-- END NEW DEFAULT RATE JOIN:

LEFT JOIN Libertypower.dbo.EnrollmentType ET WITH (NOLOCK) ON AD.EnrollmentTypeID = ET.EnrollmentTypeID
LEFT JOIN LibertyPower.dbo.CreditAgency CA WITH (NOLOCK) ON CUST.CreditAgencyID = CA.CreditAgencyID
LEFT JOIN Libertypower.dbo.BusinessType BT WITH (NOLOCK) ON CUST.BusinessTypeID = BT.BusinessTypeID
LEFT JOIN LibertyPower.dbo.SalesChannel SCH WITH (NOLOCK) ON C.SalesChannelID = SCH.ChannelID
LEFT JOIN Libertypower.dbo.AccountUsage AU WITH (NOLOCK) ON A.AccountID = AU.AccountID AND C.StartDate = AU.EffectiveDate
LEFT JOIN LibertyPower.dbo.Utility U WITH (NOLOCK) ON A.UtilityID = U.ID -- J 
LEFT JOIN lp_common.dbo.common_entity AS K WITH (NOLOCK) ON A.EntityID = K.entity_id -- K
LEFT JOIN lp_account.dbo.account_name AS B WITH (NOLOCK) ON B.account_id = A.AccountIDLegacy AND B.AccountNameID = A.AccountNameID -- B
LEFT JOIN lp_account.dbo.account_name AS Z WITH (NOLOCK) ON Z.account_id = A.AccountIDLegacy AND Z.AccountNameID = CUST.NameID -- Z
LEFT JOIN lp_account.dbo.account_contact AS D WITH (NOLOCK) ON D.account_id = A.AccountIDLegacy AND D.AccountContactID = CUST.ContactID
LEFT JOIN lp_account.dbo.account_address AS W WITH (NOLOCK) ON W.account_id = A.AccountIDLegacy AND W.AccountAddressID = A.ServiceAddressID
LEFT JOIN lp_account.dbo.account_address AS CC WITH (NOLOCK) ON CC.account_id = A.AccountIDLegacy AND CC.AccountAddressID = A.BillingAddressID
LEFT JOIN lp_account.dbo.account_additional_info AS e WITH (NOLOCK) ON e.account_id = A.AccountIdLegacy
LEFT JOIN Libertypower.dbo.TaxStatus TX WITH (NOLOCK) ON A.TaxStatusID = TX.TaxStatusID 
LEFT JOIN dbo.enrollment_status_substatus_vw AS f WITH (NOLOCK) 
				ON ASS.[Status] = f.[status] AND ASS.SubStatus = f.sub_status
LEFT JOIN LibertyPower.dbo.[User] USER1			WITH (NOLOCK)		ON C.CreatedBy = USER1.UserID
LEFT JOIN LibertyPower.dbo.[User] MANAGERUSER	WITH (NOLOCK)		ON C.SalesManagerID = MANAGERUSER.UserID
LEFT JOIN lp_common.dbo.common_product AS p WITH (NOLOCK) ON p.product_id = ISNULL(AC_DefaultRate.LegacyProductID,ACR.LegacyProductID)
LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID
WHERE A.CurrentContractID IS NOT NULL 










GO


