USE [Libertypower]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (select 1 from sys.objects (nolock) where name='usp_GetContractCurentStatus' and type='P')
BEGIN
    DROP PROCEDURE [usp_GetContractCurentStatus]
END
IF EXISTS (select 1 from sys.objects (nolock) where name='usp_GetContractCurrentStatus' and type='P')
BEGIN
    DROP PROCEDURE [usp_GetContractCurrentStatus]
END
GO
CREATE PROCEDURE [dbo].[usp_GetContractCurrentStatus]
(	
   @p_userID int
  , @p_dayRange int = 15
)
AS 

BEGIN
--need to uncomment below line for VS to generate output class structure.
--SET FMTONLY OFF;
SET NOCOUNT ON;


-- ============================================================================
-- Author: Satchi Jena
-- Date: 12/23/2014
-- Description: fetch all contracts that are submitted in last x number of days with status and comments if any.
-- ============================================================================


--EXEC [dbo].[usp_GetContractCurrentStatus] 3076, 15



--Set @p_userID=3244 
DECLARE @startDate DateTime = DATEADD(Day, -1*@p_dayRange,GetDate())
/*
Section for Enrollment Rejections.
*/
SELECT
AT.AccountType
, MA.MarketCode as retail_mkt_id
, U.UtilityCode as Utility
, WT.DateUpdated as Daycreated
, TS.StatusName AS [approval_status]
, TT.TaskName AS [check_type]
, CASE
WHEN ISNULL(WT.TaskComment, '') = 'Usage Request rejected by utility.' THEN
(
select TOP 1 RejectReason
from ISTA.dbo.tbl_814_service aService (nolock) join ISTA.dbo.tbl_814_Service_Reject bService (nolock) on aService.Service_Key = bService.Service_Key
where aService.esiid = a.accountnumber
AND aService.ActionCode = 'R'
) + ' (' + RTrim(LTrim(ISNULL(WT.TaskComment, ''))) + ')'
ELSE ISNULL(WT.TaskComment, '')
END account_comments
, C.Number AS [contract_nbr]
, ISNULL(WT.UpdatedBy, WT.CreatedBy) AS [username]
, case when cdt.DealType = 'New' then 'Enrollment' else cdt.DealType end as [check_request_id]
, Z.Name AS CustomerName
, SS.status_descp + ' ' + SS.sub_status_descp as AccountStatus
, A.AccountNumber
, c.SalesRep
, WT.DateUpdated AS date_comment
, isnull(h.date_eff,wt.DateUpdated) as RejectionDate
, SC.ChannelName as SalesChannel
--,TS.StatusName as Process_id
,isnull(h.process_id,TS.StatusName) as Process_id
,c.SignedDate as deal_date
,USAGE.AnnualUsage
into #temp
FROM LibertyPower.dbo.WIPTaskHeader                     WTH (NOLOCK)
JOIN LibertyPower.dbo.WIPTask						 WT  (NOLOCK) ON WTH.WIPTaskHeaderId = WT.WIPTaskHeaderId
JOIN LibertyPower.dbo.WorkflowTask					 WFT (NOLOCK) ON WT.workflowtaskid = WFT.workflowtaskid
JOIN LibertyPower.dbo.TaskStatus					 TS  (NOLOCK) ON WT.TaskStatusId = TS.TaskStatusId
JOIN LibertyPower.dbo.TaskType					 TT  (NOLOCK) ON WFT.TaskTypeId = TT.TaskTypeId
JOIN LibertyPower.dbo.[Contract]					 C   (NOLOCK) ON WTH.ContractId = C.ContractId
JOIN LibertyPower.dbo.AccountContract				 AC  (NOLOCK) ON C.ContractID = AC.ContractID
JOIN LibertyPower.dbo.Account						 A	(NOLOCK) ON AC.AccountID = A.AccountID --and C.ContractID = A.CurrentRenewalContractID and A.CurrentRenewalContractID IS NOT NULL
left Join LibertyPower.dbo.AccountType				 AT	(NOLOCK) on AT.ID = A.AccountTypeID
JOIN LibertyPower.dbo.Market						 MA	(NOLOCK) ON A.RetailMktID = MA.ID
JOIN LibertyPower.dbo.Utility						 U	(NOLOCK) ON A.UtilityID = U.ID
JOIN LibertyPower.dbo.ContractDealType				 CDT (NOLOCK) ON C.ContractDealTypeID = CDT.ContractDealTypeID
LEFT JOIN Libertypower.dbo.AccountStatus			 ASS	(NOLOCK) ON AC.AccountContractID = ASS.AccountContractID
LEFT JOIN Lp_Account.dbo.enrollment_status_substatus_vw SS	(NOLOCK) ON ASS.Status = SS.status and ASS.SubStatus = SS.sub_status
LEFT JOIN Libertypower.dbo.SalesChannel				 SC	(NOLOCK) ON C.SalesChannelID = SC.ChannelID
LEFT JOIN LibertyPower.dbo.Customer				 CU	(NOLOCK) ON CU.CustomerID	= A.CustomerID
LEFT JOIN LibertyPower.dbo.Name					 Z	(NOLOCK) ON Z.NameID = CU.NameID
LEFT JOIN lp_account.dbo.account_status_history		 h	(nolock) on A.AccountIdLegacy = h.Account_id
			AND h.date_created = (Select max(date_created) 
										from lp_account.dbo.account_status_history h2 (nolock) 
										where h2.Account_id = h.Account_id
										and h2.date_created > c.SubmitDate)
			AND h.STATUS in ('999998', '999999', '911000', '11000')
left JOIN LibertyPower.dbo.AccountUsage USAGE	WITH (NOLOCK)		ON A.AccountID = USAGE.AccountID AND  C.StartDate = USAGE.EffectiveDate
			
WHERE 1=1
and c.CreatedBy = @p_userID
and TS.StatusName =  'REJECTED'
and WT.DateUpdated >= @startDate


UNION ALL
/*
Section for UTILITY Rejections
*/
select 
	AT.AccountType
	,MA.MarketCode as retail_mkt_id
	,U.ShortName as Utility
	,ac.date_comment daycreated
	,'REJECTED' approval_status
	,'UTILITY' check_type
	,ac.comment account_comments
	,CT.number contract_nbr
	,ac.username username
	,'ENROLLMENT' check_request_id
	,N.Name AS CustomerName
	,SS.status_descp + ' ' + SS.sub_status_descp as AccountStatus
	,acct.AccountNumber
	,ct.SalesRep
	,AC.date_comment
	, h.date_eff as RejectionDate
	, SC.ChannelName as SalesChannel
	--,ac.process_id
	,isnull(h.process_id,ac.process_id) as process_id
	,ct.SignedDate as deal_date
	,USAGE.AnnualUsage
from Libertypower.dbo.Account Acct (nolock)
join Libertypower.dbo.AccountContract ACon (nolock) on Acon.AccountID = Acct.AccountID
join LIbertypower.dbo.Contract Ct (nolock) on Ct.ContractID = ACon.ContractID
join Libertypower.dbo.SalesChannel SC (nolock) on SC.ChannelID = ct.SalesChannelID
JOIN Libertypower.dbo.Utility U (nolock) on U.ID = Acct.UtilityID
JOIN LibertyPower.dbo.Market MA	(NOLOCK) ON Acct.RetailMktID = MA.ID			
JOIN Libertypower.dbo.AccountType AT (nolock) on AT.ID= Acct.AccountTypeID
join lp_account.dbo.account_comments ac (NOLOCK) on ac.account_id = acct.AccountIdLegacy
and ac.process_id like '%REJECT%' 
LEFT JOIN LibertyPower.dbo.Customer CUST (nolock) on CUST.CustomerID = Acct.CustomerID
LEFT JOIN LibertyPower.dbo.Name N (nolock) on N.NameID = CUST.NameID
LEFT JOIN Libertypower.dbo.AccountStatus	AStat	(NOLOCK) ON ACon.AccountContractID = AStat.AccountContractID
LEFT JOIN Lp_Account.dbo.enrollment_status_substatus_vw	SS	(NOLOCK) ON AStat.Status = SS.status and AStat.SubStatus = SS.sub_status
LEFT JOIN lp_account.dbo.account_status_history			h	(nolock) on Acct.AccountIdLegacy = h.Account_id
			AND h.date_created = (Select max(date_created) 
										from lp_account.dbo.account_status_history h2 (nolock) 
										where h2.Account_id = h.Account_id
										and h2.date_created > ct.SubmitDate)
			AND h.STATUS in ('999998', '999999', '911000', '11000')
left JOIN LibertyPower.dbo.AccountUsage USAGE	WITH (NOLOCK)		ON Acct.AccountID = USAGE.AccountID AND  Ct.StartDate = USAGE.EffectiveDate

where  
ac.date_comment >=@startDate
and not exists (select 'X' from lp_enrollment.dbo.check_account c (nolock)
				where c.contract_nbr = ct.Number
				and c.approval_status = 'REJECTED'
				and c.approval_status_date >=@startDate)
and ac.date_comment = (Select MAX(date_comment) from lp_account.dbo.account_comments ac2 (NOLOCK)
						where ac2.account_id = ac.account_id and ac.process_id = ac2.process_id)
and ct.SignedDate = (select max(SignedDate) from Libertypower.dbo.Contract ct2 (nolock)
					join Libertypower.dbo.AccountContract ACon2 (nolock) on ACon2.contractid = ct2.contractID
					where ACon2.AccountID = Acon.AccountID)
and ct.CreatedBy =@p_userID
and SS.status_descp + ' ' + SS.sub_status_descp in ('Not Enrolled Done','Enrollment Cancelled Done','or Pending Renewal - Renewal Cancelled','')

--Select * from #temp  where accountnumber='0084419027'

CREATE INDEX contractNumber_Temp on #temp(contract_nbr)

/* this is the syntax for concatenating the comments */
select distinct contract_nbr, '[ '+
STUFF((Select case when (account_comments='' or account_comments is null) then ', AccountNumber : ' +AccountNumber + ' [ '+check_type +' : ' +'No Comments' +' ]' else ','+
'AccountNumber : ' +AccountNumber + ' [ '+check_type +' : ' +account_comments +' ]' end
		from #temp t1 (NOLOCK)
		where t2.contract_nbr = t1.contract_nbr
		for XML PATH ('')),1,1,'') + ' ] ' as Notes
Into #finalComments
from #temp T2 (NOLOCK)

CREATE INDEX contractNumber_finalComments on #finalComments(contract_nbr)



--Fetch all the contracts from contract table and Join with rejections to populate the Notes
Select C.Number as ContractNumber,C.SignedDate,N.Name as CustomerName,ACS.NAME
 as [Status], CASE (pb.IsGas) when 1 then 'Gas' else 'Electric' end as [Type] ,fc.Notes as Notes from Libertypower..Contract C (Nolock)
Inner Join Libertypower..AccountContract AC (nolock) on AC.ContractID=C.ContractID
Inner Join LIbertypower..Account A (nolock) on A.AccountID=AC.AccountID
Inner Join Libertypower..Customer CU (NoLock) on CU.CustomerID=A.CustomerID
Inner Join LIbertypower..Name N (NoLock) on N.NameID=CU.NameID
Inner Join LIbertyPower..AccountContractStatus ACS(NoLock) on ACS.AccountContractStatusID=AC.AccountContractStatusID
inner join libertypower..vw_AccountContractRate acr (nolock) on  acr.AccountContractID=ac.AccountContractID  
inner join LibertyPower..Price p (nolock) on acr.PriceID =p.ID
inner join Libertypower..ProductBrand pb (nolock) on pb.ProductBrandID=p.ProductBrandID
Left Join #finalComments fc (nolock) on fc.contract_nbr = c.Number
where 
c.CreatedBy =@p_userID
and c.DateCreated>=@startDate

union all
--API rejected Deals that went to Dealcapture.
Select d.contract_nbr as ContractNumber, d.date_deal as SignedDate,
 dct.first_name + ' ' + dct.last_name as CustomerName,'Rejected' as [Status],
'Electric' as [Type] ,'' as Notes
from Lp_deal_capture..deal_contract d (noLock)
Inner Join Libertypower..[user] u (NoLock)on d.username=u.username  
inner Join Lp_deal_capture..deal_contract_account da (nolock) on d.contract_nbr=da.contract_nbr
inner join [Lp_deal_capture]..[deal_contact]dct with (NoLock) on dct.contract_nbr=d.contract_nbr and d.customer_name_link=dct.contact_link
--Left Join LIbertyPower..Contract c (NoLock) on d.contract_nbr=C.Number
--left Join LIbertypower..Account A(NoLock) on da.account_number=A.AccountNumber
--left Join Libertypower..AccountContract AC (NoLock) on AC.ContractID=C.ContractID
--left Join LIbertyPower..AccountContractStatus ACS(NoLock) on ACS.AccountContractStatusID=AC.AccountContractStatusID
where 
u.UserID =@p_userID
and d.date_created>=@startDate
and d.contract_nbr not in(select distinct number from Libertypower..Contract with(nolock))
order by SignedDate asc 

--where contract_nbr='113003569'
--drop table #temp
--select * from #temp where contract_nbr = '2014-0114374' order by contract_nbr 

-- this is the rest of the rejected logic

--Select contract_nbr,AccountNumber, COUNT(accountnumber) from #temp group by contract_nbr,AccountNumber
--having count(AccountNumber) >1



	
SET NOCOUNT OFF;	
END

