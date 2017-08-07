
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 04/29/2013
-- Description:	Get all the genie contracts for a certain channel
-- for reporting purposes
-- 
-- exec usp_GenieContractsReport '2013-04-29', '2012-01-01', 'AFF'
-- IRE, AFF, DTD, EG1, IRE2, ENE2, IRE3
-- =============================================

CREATE PROCEDURE [usp_GenieContractsReport](
	@prmToDate DateTime,
	@prmFromDate DateTime,
	@prmSalesChannel varchar(100)
) as
BEGIN

SET NOCOUNT ON

	SELECT AC.RequestedStartDate AS RequestedFlowStartDate,
			C.[Number] AS ContractNumber,
			CT.[Type] AS ContractType,
			Z.full_name AS CustomerName,

			D.last_name AS ContactLastName,
			D.first_name AS ContactName,
			D.phone AS ContactPhone,
			D.email AS ContactEmail,
			D.fax AS ContactFax,
			--    cust.SsnClear,
			--    CUST.SsnEncrypted,
			CC.[address] AS BillingStreet,
			CC.suite AS BillingSuite,
			CC.city AS BillingCity,
			CC.[state] AS BillingState,
			CC.zip AS BillingZip,
			W.[address] AS ServiceStreet,
			W.suite AS ServiceSuite,
			W.city AS ServiceCity,
			W.county AS ServiceCounty,
			W.[state] AS ServiceState,
			W.zip AS ServiceZip,
			U.UtilityCode AS Utility,
			A.AccountNumber AS AccountNumber,
			row_number() over (partition by C.[Number]  order by C.SubmitDate) AccountCount,

			A.ServiceRateClass      AS Service_rate_class,
			'SALES CHANNEL/' + SCH.ChannelName AS SalesChannelID,
			A.Zone                  AS Zone,
			C.SalesRep AS SalesRep,
			AU.AnnualUsage/1000  AS AnnualUsage,
			CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS Product,
			ACR.Term AS ContractTerm,
			CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.Rate                ELSE AC_DefaultRate.Rate                 END AS PriceRate,
			C.SubmitDate,
			f.status_descp + ' ' + f.sub_status_descp AS AccountStatus,
			C.SignedDate      AS date_deal,
			A.DateCreated     AS date_created

	FROM
	(SELECT *,CurrentContractID as ContractID, IsRenewal = 0 FROM LibertyPower..Account (NOLOCK) WHERE CurrentContractID IS NOT NULL
	  UNION ALL
	  SELECT *,CurrentRenewalContractID as ContractID, IsRenewal = 1 FROM LibertyPower..Account (NOLOCK) WHERE CurrentRenewalContractID IS NOT NULL
	   ) A
	JOIN Libertypower.dbo.[AccountContract] AC WITH (NOLOCK) ON A.AccountID = AC.AccountID  AND A.ContractID = AC.ContractID
	JOIN LibertyPower.dbo.AccountType AT WITH (NOLOCK) ON A.AccountTypeID = AT.ID
	JOIN LibertyPower.dbo.Customer CUST WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID
	JOIN Libertypower.dbo.[Contract] C WITH (NOLOCK) ON AC.ContractID = C.ContractID
	JOIN Libertypower.dbo.AccountDetail AD WITH (NOLOCK) ON A.AccountID = AD.AccountID
	JOIN Libertypower.dbo.AccountContractRate ACR WITH (NOLOCK) ON AC.AccountContractID = ACR.AccountContractID AND ACR.IsContractedRate  = 1
	JOIN Libertypower.dbo.AccountContractCommission ACC WITH (NOLOCK) ON AC.AccountContractID = ACC.AccountContractID
	JOIN Libertypower.dbo.AccountStatus ASS WITH (NOLOCK) ON AC.AccountContractID = ASS.AccountContractID
	JOIN Libertypower.dbo.BillingType  BILLT WITH (NOLOCK) ON A.BillingTypeID = BILLT.BillingTypeID
	LEFT JOIN Libertypower.dbo.BusinessActivity BA WITH (NOLOCK) ON CUST.BusinessActivityID = BA.BusinessActivityID
	JOIN Libertypower.dbo.ContractType CT WITH (NOLOCK) ON C.ContractTypeID = CT.ContractTypeID
	JOIN Libertypower.dbo.Market  MARKET WITH (NOLOCK) ON A.RetailMktID = MARKET.ID
	JOIN Libertypower.dbo.MeterType     MT WITH (NOLOCK) ON A.MeterTypeID = MT.ID

	left JOIN LibertyPower.dbo.AccountUsage USAGE   WITH (NOLOCK)            ON A.AccountID = USAGE.AccountID AND  C.StartDate = USAGE.EffectiveDate
	left JOIN LibertyPower.dbo.UsageReqStatus URS   WITH (NOLOCK)            ON USAGE.UsageReqStatusID = URS.UsageReqStatusID

	LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID
				FROM LibertyPower.dbo.AccountContractRate ACRR  WITH (NOLOCK)
				WHERE ACRR.IsContractedRate = 0
				GROUP BY ACRR.AccountContractID
				) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
	LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate      WITH (NOLOCK) ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID
	-- END NEW DEFAULT RATE JOIN:

	LEFT JOIN Libertypower.dbo.EnrollmentType ET WITH (NOLOCK) ON AD.EnrollmentTypeID = ET.EnrollmentTypeID
	LEFT JOIN LibertyPower.dbo.CreditAgency CA WITH (NOLOCK) ON CUST.CreditAgencyID = CA.CreditAgencyID
	LEFT JOIN Libertypower.dbo.BusinessType BT WITH (NOLOCK) ON CUST.BusinessTypeID = BT.BusinessTypeID
	LEFT JOIN LibertyPower.dbo.SalesChannel SCH WITH (NOLOCK) ON C.SalesChannelID = SCH.ChannelID
	LEFT JOIN Libertypower.dbo.AccountUsage AU WITH (NOLOCK) ON A.AccountID = AU.AccountID AND C.StartDate = AU.EffectiveDate
	LEFT JOIN LibertyPower.dbo.Utility U WITH (NOLOCK) ON A.UtilityID = U.ID -- J
	LEFT JOIN lp_common.dbo.common_entity AS K WITH (NOLOCK) ON A.EntityID = K.entity_id -- K
	
	LEFT JOIN lp_account.dbo.account_name AS B WITH (NOLOCK) ON B.AccountNameID = A.AccountNameID AND A.AccountIdLegacy = B.account_id -- B
	LEFT JOIN lp_account.dbo.account_name AS Z WITH (NOLOCK) ON Z.AccountNameID = CUST.NameID AND A.AccountIdLegacy = Z.account_id -- Z
	LEFT JOIN lp_account.dbo.account_contact AS D WITH (NOLOCK) ON D.AccountContactID = CUST.ContactID AND A.AccountIdLegacy = D.account_id
	LEFT JOIN lp_account.dbo.account_address AS W WITH (NOLOCK) ON W.AccountAddressID = A.ServiceAddressID AND A.AccountIdLegacy = W.account_id
	LEFT JOIN lp_account.dbo.account_address AS CC WITH (NOLOCK) ON CC.AccountAddressID = A.BillingAddressID AND A.AccountIdLegacy = CC.account_id
	
	LEFT JOIN lp_account.dbo.account_additional_info AS e WITH (NOLOCK) ON e.account_id = A.AccountIdLegacy
	LEFT JOIN Libertypower.dbo.TaxStatus TX WITH (NOLOCK) ON A.TaxStatusID = TX.TaxStatusID
	LEFT JOIN lp_account.dbo.enrollment_status_substatus_vw AS f WITH (NOLOCK) ON ASS.[Status] = f.[status] AND ASS.SubStatus = f.sub_status
	LEFT JOIN LibertyPower.dbo.[User] USER1               WITH (NOLOCK)          ON C.CreatedBy = USER1.UserID
	LEFT JOIN LibertyPower.dbo.[User] MANAGERUSER   WITH (NOLOCK)            ON C.SalesManagerID = MANAGERUSER.UserID
	LEFT JOIN lp_common.dbo.common_product AS p WITH (NOLOCK) ON p.product_id = ISNULL(AC_DefaultRate.LegacyProductID,ACR.LegacyProductID)
	LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID

	WHERE A.CurrentContractID IS NOT NULL
	  and SCH.ChannelName = @prmSalesChannel
	  and
	  --    DateAdd(dd, DateDiff(dd, 0, c.submitdate) , 0 ) = DateAdd(dd, DateDiff(dd, 0, DATEADD(d,-1,GetDate())) , 0 )
	  dateadd(d,0,datediff(d,0, C.SubmitDate))between  dateadd(d,0,datediff(d,0,@prmFromDate))
	  and  dateadd(d,0,datediff(d,0,@prmToDate))
	  and a.origin = 'GENIE'


	UNION


	SELECT  AC.RequestedStartDate AS RequestedFlowStartDate,
			WIC.Contract as ContractNumber,
			WIC.ContractType,
			WIC.CustomerName,
			D.last_name AS ContactLastName,
			D.first_name AS ContactName,
			D.phone AS ContactPhone,
			D.email AS ContactEmail,
			D.fax AS ContactFax,
			CC.[address] AS BillingStreet,
			CC.suite AS BillingSuite,
			CC.city AS BillingCity,
			CC.[state] AS BillingState,
			CC.zip AS BillingZip,
			W.[address] AS ServiceStreet,
			W.suite AS ServiceSuite,
			W.city AS ServiceCity,
			W.county AS ServiceCounty,
			W.[state] AS ServiceState,
			W.zip AS ServiceZip,
			U.UtilityCode AS Utility,
			A.AccountNumber AS AccountNumber,
			WIC.NumberOfAccounts AccountCount,
			A.ServiceRateClass      AS Service_rate_class,
			SC.ChannelName AS SalesChannelID,
			A.Zone AS Zone,
			C.SalesRep AS SalesRep,
			0  AS AnnualUsage,
			'' AS Product,
			'' AS ContractTerm,
			'' AS PriceRate,
			C.SubmitDate,
			WICSt.Status + ' - ' + WICIT.IssueDescription AS AccountStatus,
			C.SignedDate      AS date_deal,
			WIC.Created AS date_created
	FROM (SELECT *,CurrentContractID as ContractID, IsRenewal = 0
			FROM LibertyPower..Account (NOLOCK)
			WHERE CurrentContractID IS NOT NULL
	        
			UNION ALL

			SELECT *,CurrentRenewalContractID as ContractID, IsRenewal = 1
			FROM LibertyPower..Account (NOLOCK)
			WHERE CurrentRenewalContractID IS NOT NULL) A
			
	JOIN Libertypower.dbo.[AccountContract] AC (NOLOCK) ON A.AccountID = AC.AccountID  AND A.ContractID = AC.ContractID
	JOIN LibertyPower.dbo.Customer CUST WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID
	JOIN Libertypower.dbo.[Contract] C (NOLOCK) ON AC.ContractID = C.ContractID
	JOIN OrderManagement.dbo.WorkItemContract WIC on WIC.Contract = C.Number
	JOIN OrderManagement.dbo.WorkItem WI ON WI.id = WIC.WorkItemId
	JOIN OrderManagement.dbo.WorkItemContractIssueTypes WICIT ON WICIT.Id =  WIC.WorkItemContractIssueTypeId
	JOIN OrderManagement.dbo.WorkItemContractStatusTypes WICST ON WICST.id = WICIT.issuetype
	JOIN [Libertypower].[dbo].[User] USR ON USR.userid = WI.userid
	JOIN [Libertypower].[dbo].[SalesChannel] SC (NOLOCK) ON SC.ChannelId = WIC.SalesChannel
	JOIN LibertyPower.dbo.Utility U (NOLOCK) ON U.ID = A.UtilityID
	
	JOIN lp_account.dbo.account_contact AS D WITH (NOLOCK) ON D.AccountContactID = CUST.ContactID AND A.AccountIdLegacy = D.account_id
	JOIN lp_account.dbo.account_address AS W WITH (NOLOCK) ON W.AccountAddressID = A.ServiceAddressID AND A.AccountIdLegacy = W.account_id
	JOIN lp_account.dbo.account_address AS CC WITH (NOLOCK) ON CC.AccountAddressID = A.BillingAddressID AND A.AccountIdLegacy = CC.account_id
	
    WHERE WIC.Contract IS NOT NULL
	  AND A.CurrentContractID IS NOT NULL
	  AND A.AccountNumber IS NOT NULL
	  AND WICST.Status = 'Rejected'
  	  AND WICIT.ID IN (15,16)
	  AND dateadd(d,0,datediff(d,0, wic.modified)) between  dateadd(d,0,datediff(d,0,@prmFromDate))
	  and dateadd(d,0,datediff(d,0,@prmToDate))
	  and SC.ChannelName = @prmSalesChannel
	  --AND wic.modified BETWEEN '2012-09-01' AND '2012-10-08'

	  --order by A.CurrentContractID
	  order by ContractNumber


END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_GenieContractsReport] TO [libertypower\vmotipalli]
    AS [dbo];

