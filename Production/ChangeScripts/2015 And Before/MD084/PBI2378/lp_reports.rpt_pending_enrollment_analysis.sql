USE [lp_reports]
GO
/****** Object:  StoredProcedure [dbo].[rpt_pending_enrollment_analysis]    Script Date: 11/02/2012 13:37:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[rpt_pending_enrollment_analysis]
AS
---- Service Desk Ticket # 974

---- We create these smaller temp tables to speed up the query.
-- 4/17/2012 pedro perez - use new LibertyPower Tables
SELECT	DISTINCT
		A.AccountIdLegacy		AS account_id,		
			A.AccountNumber			AS account_number,
		[Libertypower].[dbo].ufn_GetLegacyAccountStatus(ACS.[Status], ACS.SubStatus) AS [Status] , 
		[Libertypower].[dbo].ufn_GetLegacyAccountSubStatus(ACS.[Status], ACS.SubStatus) AS sub_status 
		into #small_account
FROM LibertyPower.dbo.Account A WITH (NOLOCK)
JOIN LibertyPower.dbo.AccountDetail DETAIL	 WITH (NOLOCK)	ON DETAIL.AccountID = A.AccountID
JOIN LibertyPower.dbo.[Contract] C	WITH (NOLOCK)				ON A.CurrentContractID = C.ContractID
JOIN LibertyPower.dbo.AccountContract AC	WITH (NOLOCK)		ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
JOIN LibertyPower.dbo.AccountContractCommission ACC	WITH (NOLOCK) ON AC.AccountContractID = ACC.AccountContractID
JOIN LibertyPower.dbo.AccountStatus ACS	WITH (NOLOCK)			ON AC.AccountContractID = ACS.AccountContractID
JOIN LibertyPower.dbo.vw_AccountContractRate ACR2	WITH (NOLOCK)	ON AC.AccountContractID = ACR2.AccountContractID --AND ACR2.IsContractedRate = 1

JOIN LibertyPower.dbo.ContractType CT			WITH (NOLOCK)	ON C.ContractTypeID = CT.ContractTypeID
JOIN LibertyPower.dbo.Customer CUST				WITH (NOLOCK)	ON A.CustomerID = CUST.CustomerID
JOIN LibertyPower.dbo.ContractTemplateType CTT	WITH (NOLOCK)	ON C.ContractTemplateID= CTT.ContractTemplateTypeID
JOIN LibertyPower.dbo.AccountType AT			WITH (NOLOCK)	ON A.AccountTypeID = AT.ID
													  									  
JOIN LibertyPower.dbo.Utility U			WITH (NOLOCK)			ON A.UtilityID = U.ID
JOIN LibertyPower.dbo.Market M			WITH (NOLOCK)			ON A.RetailMktID = M.ID
JOIN LibertyPower.dbo.AccountUsage USAGE	WITH (NOLOCK)		ON A.AccountID = USAGE.AccountID AND  C.StartDate = USAGE.EffectiveDate
JOIN LibertyPower.dbo.UsageReqStatus URS	WITH (NOLOCK)		ON USAGE.UsageReqStatusID = URS.UsageReqStatusID

WHERE 
	([Libertypower].[dbo].ufn_GetLegacyAccountStatus(ACS.[Status], ACS.SubStatus) in ('05000','06000') and [Libertypower].[dbo].ufn_GetLegacyAccountSubStatus(ACS.[Status], ACS.SubStatus) = '20')
	OR ([Libertypower].[dbo].ufn_GetLegacyAccountStatus(ACS.[Status], ACS.SubStatus) in ('13000') and [Libertypower].[dbo].ufn_GetLegacyAccountSubStatus(ACS.[Status], ACS.SubStatus) = '70' )	


SELECT *
INTO #small_zaudit
FROM lp_account.dbo.zaudit_account Acct (NOLOCK)
WHERE account_id in (SELECT SA.account_id FROM #small_account SA WHERE Acct.Account_ID = SA.Account_ID)

SELECT a.account_id, max(audit_change_dt) as max_reenroll_date 
INTO #last_reenrollment
FROM 
	#small_account a
		LEFT JOIN #small_zaudit z ON a.account_id = z.account_id and ((z.status = '13000' and z.sub_status = '60') OR (z.status in ('05000','06000') and z.sub_status = '27'))
GROUP BY a.account_id

SELECT a.account_id, a.account_number, a.status, a.sub_status, isnull(max(audit_change_dt),'1900-01-01') as max_diff_status_date 
INTO #small_account2
FROM #small_account a
LEFT JOIN #small_zaudit z ON a.account_id = z.account_id and (z.status <> a.status OR z.sub_status <> a.sub_status)
GROUP BY a.account_id, a.account_number, a.status, a.sub_status


---- Final Output
SELECT a.account_id, min(audit_change_dt) as min_same_status_date
      , datediff(day,min(audit_change_dt),getdate()) as status_age
INTO #account_status_age
FROM 
	#small_account2 a
	LEFT JOIN #small_zaudit z ON a.account_id = z.account_id and z.status = a.status and z.sub_status = a.sub_status and z.audit_change_dt > a.max_diff_status_date 
GROUP BY a.account_id

SELECT *
INTO
	#tmpEDI814
FROM integration.dbo.EDI_814_most_recent_transaction_attempt_vw 

SELECT 
	a.Retail_Mkt_id	-- ADDED BY HECTOR 9/29/2009
	, a.AccountNumber
	, a.AccountName
	, a.annualusage as [Annual Usage]
	  , case
			when error_msg like '%mapp%' then 'The next EDI to be processed for this account is not mapped.'
			when h.max_reenroll_date is not null and h.max_reenroll_date > edi.transaction_date then 'Last reenrollment attempt appears to not have a response.'
            when error_msg like '%current status%' and edi.action_code in ('D','06','08') and edi.request_or_response in ('Q','13') then 'The system does not acknowledge a drop request when pending enrollment confirmation.  Designed as requested.'
			when error_msg like '%current status%' then 'The current status of the account does not permit the EDI received.'
            when edi.reject_or_accept = 'R' and edi.ReasonText is not null then 'It is likely our system does not know how to handle this EDI rejection text.'
			when edi.EDI_814_transaction_id is null then 'Initial enrollment attempt appears to not have a response.' 
            else 'Cannot suggest root cause.  Needs more detailed analysis.'
		end as Analysis
	, lp_enrollment.dbo.ufn_date_format(h.max_reenroll_date, '<MM>/<DD>/<YYYY>') as [Date Last Reenrolled]
	, lp_enrollment.dbo.ufn_date_format(a2.min_same_status_date, '<MM>/<DD>/<YYYY>') as [Date Status Last Changed]
	, a2.Status_Age as [Status Age]
	, edi.transaction_type + '_' + edi.action_code as [Transaction Type]
	, lp_enrollment.dbo.ufn_date_format(edi.transaction_date, '<MM>/<DD>/<YYYY>') as [Transaction Date]
	, lp_enrollment.dbo.ufn_date_format(edi.request_date, '<MM>/<DD>/<YYYY>') as [Request Date]
	, edi.request_or_response as [Request OR Response]
	, edi.reject_or_accept as [Reject OR Accept]
	, edi.reasoncode as ReasonCode
	, edi.reasontext as ReasonText
    , error_msg
FROM lp_account.dbo.tblAccounts a (NOLOCK)
JOIN #account_status_age a2 ON a.account_id = a2.account_id
LEFT JOIN #last_reenrollment h on a.account_id = h.account_id

LEFT JOIN #tmpEDI814 edi (NOLOCK) on a.accountnumber = edi.account_number
WHERE 1=1
and (
		(a.[status] in ('05000','06000') and a.sub_status = '20')
		OR
		(status = '13000' and sub_status = '70')
	)
and a.is_renewal = 0
and status_age >= 4

ORDER BY 1 desc,3,2























