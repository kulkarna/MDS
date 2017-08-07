USE [lp_account]
GO

/****** Object:  View [dbo].[tblAccounts_vw]    Script Date: 11/02/2012 10:50:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Modified Alejandro Iturbe 07/19/2012
-- Added logic from account view to bring the correct contract type
-- SR1-21091775 (This is based on Isabelle Tamanini's fix on tblAccounts view 04/23/2012)
-- =============================================
-- Modified Cathy Ghazal 11/02/2012
-- use vw_AccountContractRate instead of AccountContractRate
-- MD084
-- =============================================



ALTER VIEW [dbo].[tblAccounts_vw]
AS
SELECT Entity				=	A.EntityId
	,Utility				=	U.UtilityCode
	,Account_id				=	A.AccountidLegacy
	,AccountNumber			=	A.AccountNumber
	,AccountType			=	CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE AT.AccountType	END -- AT.AccountType AS AccountType, -- AT.AccountType
	,AccountName			=	B.name
	,CustomerName			=	Z.name
	,BusinessType			=	BT.[Type]
	,BusinessActivity		=	BA.Activity
	,ContactName			=	D.firstname
	,ContactLastName		=	D.lastname
	,ContactTitle			=	D.title
	,ContactPhone			=	D.phone
	,ContactFax				=	D.fax
	,ContactEmail			=	D.email
	,ContactBirthday		=	D.birthdate
	--,ContractType			=	CT.[Type]
	,[Libertypower].[dbo].[ufn_GetLegacyContractType] ( CT.[Type] , CTT.ContractTemplateTypeID, CDT.DealType) AS ContractType
	,ContractNumber			=	C.[Number]
	,ContractTerm			=	ACR.Term
	,ServiceStreet			=	W.[address1]
	,ServiceSuite			=	W.Address2
	,ServiceCity			=	W.city
	,ServiceCounty			=	W.county
	,ServiceState			=	W.[state]
	,ServiceZip				=	W.zip
	,BillingStreet			=	CC.[address1]
	,BillingSuite			=	CC.address2
	,BillingCity			=	CC.city
	,BillingCounty			=	CC.county
	,BillingState			=	CC.[state]
	,BillingZip				=	CC.zip
	,AccountStatus			=	CASE WHEN (ASS.[Status]			= '07000' AND ASS.SubStatus = '90' AND A.CurrentContractId = AC.ContractID) THEN 'Not Enrolled Done' 
									WHEN (ASS.[Status]			= '07000' AND ASS.SubStatus = '10' AND A.CurrentContractId = AC.ContractID) THEN 'Pending Enrollment Create Utility File' 
									WHEN (ASS.[Status]			= '05000' AND A.CurrentRenewalContractId = AC.ContractID) THEN 'Pending Renewal ' --'07000' 
									WHEN (C.ContractStatusID	=  2	  AND A.CurrentRenewalContractId = AC.ContractID) THEN 'Pending Renewal ' -- '07000' 
									ELSE f.status_descp + ' '   END + f.sub_status_descp 


	,Product				=	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.LegacyProductID		ELSE AC_DefaultRate.LegacyProductID		END
	,PriceRate				=	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.Rate				ELSE AC_DefaultRate.Rate				END
	,TaxStatus				=	TX.[Status]
	,TaxRate				=	CAST(0 AS FLOAT)
	,SalesChannelID			=	'SALES CHANNEL/' + SCH.ChannelName
	,SalesRep				=	C.SalesRep
	,AnnualUsage			=	AU.AnnualUsage
	,CreditScore			=	CAST(0 AS REAL)
	,CreditAgency			=	CA.Name
	,SubmitDate				=	CONVERT(datetime, CONVERT(char(10), C.SubmitDate, 101))
	,FlowStartDate			=	CASE WHEN ASS.[Status] in ('999998','999999','01000','03000','04000','05000') AND ASS.[SubStatus] not in ('30') THEN CAST('1900-01-01 00:00:00' AS DATETIME)
									ELSE ISNULL(ASERVICE.StartDate, CAST('1900-01-01 00:00:00' AS DATETIME)) END
	,CUBSEffectiveDate		=	AC.SendEnrollmentDate
	,De_enrollmentDate		=	CASE WHEN ASS.[Status] in ('999998','999999','01000','03000','04000','05000') THEN CAST('1900-01-01 00:00:00' AS DATETIME)
									WHEN ASS.[Status] in ('13000') AND ASS.[SubStatus] in ('70','80') THEN CAST('1900-01-01 00:00:00' AS DATETIME)
									ELSE ISNULL(ASERVICE.EndDate, CAST('1900-01-01 00:00:00' AS DATETIME)) END
	,Re_enrollmentDate		=	CAST('1900-01-01' AS DATETIME)
	,customer_id			=	A.CustomerID
	,retail_mkt_id			=	MARKET.MarketCode
	,rate_id				=	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.RateID			 ELSE AC_DefaultRate.RateID			 END 
	,additional_id_nbr_type	=	CASE WHEN LTRIM(RTRIM(CUST.Duns))		<> '' THEN 'DUNSNBR' 
									WHEN LTRIM(RTRIM(CUST.EmployerId))	<> '' THEN 'EMPLID' 
									WHEN LTRIM(RTRIM(CUST.TaxId))		<> '' THEN 'TAX ID' 
									ELSE 
										CASE WHEN CUST.SsnEncrypted IS NOT NULL AND CUST.SsnEncrypted != '' THEN 'SSN' 
										ELSE 'NONE' END 
									END
	,additional_id_nbr		=	CASE WHEN LTRIM(RTRIM(CUST.Duns))		<> '' THEN CUST.Duns
									WHEN LTRIM(RTRIM(CUST.EmployerId))	<> '' THEN CUST.EmployerId 
									WHEN LTRIM(RTRIM(CUST.TaxId))		<> '' THEN CUST.TaxId 
									ELSE 
										CASE WHEN CUST.SsnEncrypted IS NOT NULL  AND CUST.SsnEncrypted != '' THEN '***-**-****' 
										ELSE 'NONE' END 
									END
		
	,contract_eff_start_date	=	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.RateStart  ELSE AC_DefaultRate.RateStart END
	,date_end					=	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.RateEnd	ELSE AC_DefaultRate.RateEnd   END 
	,date_deal					=	C.SignedDate
	,date_created				=	A.DateCreated
	,username					=	USER1.UserName
	,origin						=	A.Origin
	,Zone						=	A.Zone
	,Service_rate_class			=	A.ServiceRateClass 
	,StratumVariable			=	A.StratumVariable
	,TripNumber					=	A.BillingGroup
	,icap						=	A.Icap -- previously field05
	,tcap						=	A.Tcap 
	,load_profile				=	A.LoadProfile
	,loss_code					=	A.LossCode
	,[status]					=	CASE WHEN (ASS.[Status]			= '07000' AND ASS.SubStatus = '90' AND A.CurrentContractId = AC.ContractID) THEN '999999' 
										WHEN (ASS.[Status]			= '07000' AND ASS.SubStatus = '10' AND A.CurrentContractId = AC.ContractID) THEN '05000' 
										WHEN (ASS.[Status]			= '05000' AND A.CurrentRenewalContractId = AC.ContractID) THEN '07000' 
										WHEN (C.ContractStatusID	=  2	  AND A.CurrentRenewalContractId = AC.ContractID) THEN '07000' 
										ELSE ASS.[Status] END 
	,sub_status					=	CASE WHEN (ASS.[Status]			= '07000' AND ASS.SubStatus = '90' AND A.CurrentContractId = AC.ContractID) THEN '10' 
									WHEN (ASS.[Status]			= '05000' AND A.CurrentRenewalContractId = AC.ContractID) THEN '20' 
									WHEN (C.ContractStatusID	=  2	  AND A.CurrentRenewalContractId = AC.ContractID) THEN '80' 
									ELSE ASS.SubStatus END
	,current_usage_quantity		=	AU.AnnualUsage
	,Annualized_Quantity		=	''
	,ProductDescription			=	P.product_descp
	,billing_type				=	BILLT.[Type]
	,ProductRateDescription		=	pr.rate_descp
	,[Billing Cycle]			=	S.LDCBillingCycle
	,Sales_Manager				=	ManagerUser.Firstname + ' ' + ManagerUser.Lastname
FROM         
	libertypower.dbo.account A WITH (NOLOCK) 
	LEFT JOIN LibertyPower.dbo.Utility U WITH (NOLOCK) 
	ON U.ID								= A.UtilityID
	JOIN LibertyPower.dbo.AccountType AT WITH (NOLOCK) 
	ON AT.ID							= A.AccountTypeID
	--LEFT JOIN lp_account.dbo.account_name B WITH (NOLOCK) 	ON B.AccountNameID					= A.AccountNameID
	LEFT JOIN LibertyPower.dbo.Name B WITH (NOLOCK)	ON B.NameID = A.AccountNameID
	JOIN LibertyPower.dbo.Customer CUST	 WITH (NOLOCK) 
	ON CUST.CustomerID					= A.CustomerID
	--LEFT JOIN lp_account.dbo.account_name Z WITH (NOLOCK) 	ON Z.AccountNameID					= CUST.NameID -- Z
	LEFT JOIN LibertyPower.dbo.Name Z WITH (NOLOCK)	ON Z.NameID = CUST.NameID
	
	LEFT JOIN Libertypower.dbo.BusinessType BT WITH (NOLOCK) 
	ON BT.BusinessTypeID				= CUST.BusinessTypeID 
	LEFT JOIN Libertypower.dbo.BusinessActivity BA WITH (NOLOCK) 
	ON BA.BusinessActivityID			= CUST.BusinessActivityID 
	--LEFT JOIN lp_account.dbo.account_contact D WITH (NOLOCK) ON D.AccountContactID				= CUST.ContactID
	LEFT JOIN LibertyPower.dbo.Contact D WITH (NOLOCK)	ON D.ContactID = CUST.ContactID

	JOIN Libertypower.dbo.[AccountContract] AC WITH (NOLOCK) 
	ON A.AccountID						= AC.AccountID 
	AND A.CurrentContractId				= AC.ContractID
	JOIN Libertypower.dbo.[Contract] C WITH (NOLOCK) 
	ON C.ContractID						= AC.ContractID
	JOIN Libertypower.dbo.ContractType CT WITH (NOLOCK) 
	ON CT.ContractTypeID				= C.ContractTypeID
	JOIN LibertyPower.dbo.ContractTemplateType CTT	WITH (NOLOCK)	
	ON C.ContractTemplateID= CTT.ContractTemplateTypeID
	JOIN LibertyPower.dbo.ContractDealType CDT WITH (NOLOCK)	
	ON C.ContractDealTypeID = CDT.ContractDealTypeID
	
	JOIN Libertypower.dbo.vw_AccountContractRate ACR WITH (NOLOCK) 
	ON ACR.AccountContractID			= AC.AccountContractID
	--AND ACR.IsContractedRate			= 1 
	
	--LEFT JOIN lp_account.dbo.account_address W WITH (NOLOCK) 
	--ON W.AccountAddressID				= A.ServiceAddressID
	LEFT JOIN LibertyPower.dbo.Address W WITH (NOLOCK) ON W.AddressID = A.ServiceAddressID
	--LEFT JOIN lp_account.dbo.account_address CC WITH (NOLOCK) ON CC.AccountAddressID				= A.BillingAddressID
	LEFT JOIN LibertyPower.dbo.Address CC WITH (NOLOCK) ON CC.AddressID = A.BillingAddressID
	JOIN Libertypower.dbo.AccountStatus ASS WITH (NOLOCK) 
	ON ASS.AccountContractID			= AC.AccountContractID
	LEFT JOIN dbo.enrollment_status_substatus_vw f WITH (NOLOCK) 
	ON f.[status]						= ASS.[Status]
	AND f.sub_status					= ASS.SubStatus
	
	
	--LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)	
	--ON AC_DefaultRate.AccountContractID	= AC.AccountContractID
	--AND AC_DefaultRate.IsContractedRate	= 0 -- temporary measure, should be changed later
	
	-- NEW DEFAULT RATE JOIN:
	LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
			   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
			   WHERE ACRR.IsContractedRate = 0 
			   GROUP BY ACRR.AccountContractID
			  ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
	LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
	 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
	-- END NEW DEFAULT RATE JOIN:
	
	
	
	
	LEFT JOIN Libertypower.dbo.TaxStatus TX WITH (NOLOCK) 
	ON TX.TaxStatusID					= A.TaxStatusID
	LEFT JOIN LibertyPower.dbo.SalesChannel SCH WITH (NOLOCK) 
	ON SCH.ChannelID					= C.SalesChannelID
	LEFT JOIN Libertypower.dbo.AccountUsage AU WITH (NOLOCK) 
	ON AU.AccountID						= A.AccountID
	AND AU.EffectiveDate				= C.StartDate
	LEFT JOIN LibertyPower.dbo.CreditAgency CA WITH (NOLOCK) 
	ON CA.CreditAgencyID				= CUST.CreditAgencyID
	LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) 
	ON ASERVICE.AccountID				= A.AccountID
	JOIN Libertypower.dbo.Market	MARKET WITH (NOLOCK) 
	ON MARKET.ID						= A.RetailMktID
	LEFT JOIN LibertyPower.dbo.[User] USER1	WITH (NOLOCK)		
	ON USER1.UserID						= A.ModifiedBy 
	LEFT JOIN lp_common.dbo.common_product P WITH (NOLOCK) 
	ON P.product_id						= ISNULL(AC_DefaultRate.LegacyProductID,ACR.LegacyProductID)
	JOIN Libertypower.dbo.BillingType  BILLT WITH (NOLOCK) 
	ON BILLT.BillingTypeID				= A.BillingTypeID
	LEFT JOIN lp_common.dbo.common_product_rate PR WITH (NOLOCK) 
	ON PR.product_id					= P.product_id 
	and PR.rate_id						= ISNULL(AC_DefaultRate.AccountContractRateID, ACR.RateID)
	LEFT JOIN (	SELECT esiid ,MAX(LDCBillingCycle) AS LDCBillingCycle 
				FROM ISTA.dbo.tbl_814_service WITH (NOLOCK) 
				WHERE esiid IS NOT NULL GROUP BY esiid) S 
	ON S.esiid							= A.AccountNumber
	LEFT JOIN LibertyPower.dbo.[User] MANAGERUSER	WITH (NOLOCK)		
	ON MANAGERUSER.UserID				= C.SalesManagerID

GO


