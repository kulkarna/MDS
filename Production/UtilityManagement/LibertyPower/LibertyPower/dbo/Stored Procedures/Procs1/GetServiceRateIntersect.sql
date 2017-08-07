
CREATE procedure [dbo].[GetServiceRateIntersect]  

 as


IF EXISTS (select * from sys.objects where name = 'ACRData')
Drop table ACRdata

SELECT m.MarketCode, u.UtilityCode, a.AccountID, a.AccountIdLegacy, a.AccountNumber, ac.ContractID,c.Number, c.ContractDealTypeID, c.SignedDate, c.ContractStatusID, c.StartDate, c.EndDate
      , acr.AccountContractRateID, ac.AccountContractID, acr.Rate, acr.RateStart, acr.RateEnd
INTO ACRdata
FROM LibertyPower..Account a (nolock)
JOIN LibertyPower..AccountContract ac (nolock) ON a.AccountID = ac.AccountID 
JOIN LibertyPower..Contract c (nolock) ON ac.ContractID = c.ContractID
JOIN LibertyPower..AccountStatus s (nolock) ON ac.AccountContractID = s.AccountContractID
JOIN LibertyPower..AccountContractRate acr (nolock) ON ac.AccountContractID = acr.AccountContractID
JOIN LibertyPower..Utility u (nolock) ON a.UtilityID = u.ID
JOIN LibertyPower..Market m (nolock) ON u.MarketID = m.ID
WHERE 1=1
and acr.IsContractedRate = 1
--and c.ContractStatusID = 3 -- Approved

IF EXISTS (select * from sys.objects where name = '#ACRDatesN')
 drop table #ACRDatesN

 
select acr1.AccountContractRateID
      , RateEnd2 = min(case when acr2.RateStart < acr1.RateEnd then acr2.RateStart-1 else acr1.RateEnd end) -- if there is overlap, then the current record should end 1 day before the next rate.
into #ACRDatesN
from ACRdata acr1
left join ACRdata acr2 on acr1.AccountID = acr2.AccountID 
     and acr1.ContractID <> acr2.ContractID 
     and acr2.SignedDate > acr1.SignedDate                                                         
group by acr1.AccountContractRateID
having COUNT(acr1.AccountContractRateID) > 1


IF EXISTS (select * from sys.objects where name = 'RateServiceIntersect' and type = 'U')
 drop table RateServiceIntersect
 

SELECT ACR.*
        , S.EndDate RateEnd2, S.StartDate as ServiceStartDate, S.EndDate as ServiceEndDate
        , CASE WHEN S.StartDate > ACR.RateStart THEN S.StartDate ELSE ACR.RateStart END AS ActualStartOfRate
        , S.EndDate  AS ActualEndOfRate
INTO RateServiceIntersect
FROM ACRdata ACR
LEFT JOIN #ACRDatesN d ON ACR.AccountContractRateID = d.AccountContractRateID
JOIN Libertypower..AccountService S (NOLOCK) ON ACR.AccountIdLegacy = S.account_id
     AND S.StartDate <= S.EndDate 
     AND (S.EndDate >= ACR.RateStart OR S.EndDate IS NULL)
where d.AccountContractRateID is null


insert INTO RateServiceIntersect
SELECT ACR.*
        ,S.EndDate RateEnd2 , S.StartDate as ServiceStartDate, S.EndDate as ServiceEndDate
        , CASE WHEN S.StartDate > ACR.RateStart THEN S.StartDate ELSE ACR.RateStart END AS ActualStartOfRate
        , case when S.EndDate is null then acr.RateEnd else S.EndDate end AS ActualEndOfRate
FROM ACRdata ACR
LEFT JOIN #ACRDatesN d ON ACR.AccountContractRateID = d.AccountContractRateID
JOIN Libertypower..AccountService S (NOLOCK) ON ACR.AccountIdLegacy = S.account_id
     AND (S.StartDate <= S.EndDate or S.EndDate is null)
     AND (S.EndDate >= ACR.RateStart OR S.EndDate IS NULL)
where d.AccountContractRateID is null
and acr.ContractID not in (Select ContractID from RateServiceIntersect)


insert INTO RateServiceIntersect
SELECT ACR.*
        ,S.EndDate RateEnd2 , S.StartDate as ServiceStartDate, S.EndDate as ServiceEndDate
        , CASE WHEN S.StartDate > ACR.RateStart THEN S.StartDate ELSE ACR.RateStart END AS ActualStartOfRate
        , case when S.EndDate is null then acr.RateEnd else S.EndDate end AS ActualEndOfRate
FROM ACRdata ACR
 JOIN Libertypower..AccountService S (NOLOCK) ON ACR.AccountIdLegacy = S.account_id
     AND (S.StartDate <= S.EndDate or S.EndDate is null)
     AND (S.EndDate >= ACR.RateStart OR S.EndDate IS NULL)
where 
 acr.ContractID not in (Select ContractID from RateServiceIntersect)
order by AccountID,ContractID,AccountContractID,AccountContractRateID


--to grab future start accounts with no service dates
insert into RateServiceIntersect
SELECT ACR.*
        , null RateEnd2,null ServiceStartDate, null ServiceEndDate
        , null AS ActualStartOfRate
        , null AS ActualEndOfRate
FROM ACRdata ACR
inner join libertypower..AccountStatus b on acr.AccountContractID = b.AccountContractID
where acr.StartDate > GETDATE()
and acr.ContractID not in (Select ContractID from RateServiceIntersect)
and b.Status not in ('999999','999998')


select a.AccountContractID,a.AccountID,a.ContractID 
into #grabme
from libertypower..AccountContract a (nolock)
left join RateServiceIntersect b (nolock)
	on a.AccountContractID = b.AccountContractID and a.AccountID = b.AccountID and a.ContractID = b.ContractID
where b.AccountContractID is null and b.ContractID is null and b.AccountID is null


 select m.MarketCode, u.UtilityCode,g.AccountID,a.AccountIdLegacy, a.AccountNumber,g.ContractID,c.Number, c.ContractDealTypeID, c.SignedDate, c.ContractStatusID, c.StartDate, c.EndDate,
	acr.AccountContractRateID,g.AccountContractID,acr.Rate, acr.RateStart, acr.RateEnd
into #grabmenext
 from #grabme g
 join LibertyPower..Account a (nolock) on g.AccountID = a.AccountID
 JOIN LibertyPower..AccountContract ac (nolock) ON g.AccountContractID = ac.AccountContractID
 JOIN LibertyPower..Contract c (nolock) ON g.ContractID = c.ContractID
 JOIN LibertyPower..AccountContractRate acr (nolock) ON g.AccountContractID = acr.AccountContractID
 JOIN LibertyPower..Utility u (nolock) ON a.UtilityID = u.ID
JOIN LibertyPower..Market m (nolock) ON u.MarketID = m.ID
 WHERE 1=1
and acr.IsContractedRate = 1


insert into RateServiceIntersect
select distinct a.*,x.EndDate RateEnd2, w.startdt ServiceStartDate, x.EndDate ServiceEndDate,
	CASE WHEN w.startdt > A.RateStart THEN w.startdt ELSE A.RateStart END AS ActualStartOfRate,
    case when x.EndDate is null then a.RateEnd else x.EndDate end AS ActualEndOfRate
from #grabmenext a
left join
(select account_id,MIN(startDAte) startdt
from LibertyPower..AccountService
group by account_id) w on a.AccountIdLegacy = w.account_id
left join
(Select account_id, max(DateCreated) createdt
from LibertyPower..AccountService
where EndDate > StartDate or EndDate is null
group by account_id
)z on w.account_id = z.account_id
left join 
(Select account_id, startdate,enddate,DateCreated
from LibertyPower..AccountService
where EndDate > StartDate or EndDate is null
) x on w.account_id = x.account_id
	and w.startdt = x.StartDate and x.DateCreated = z.createdt
left join RateServiceIntersect r on a.AccountID = r.AccountID and a.AccountContractID = r.AccountContractID
	and a.ContractID = r.ContractID
where 
	r.AccountID is null and r.AccountContractID is null and r.ContractID is null


	drop table #grabme
	drop table #grabmenext
	drop table #ACRDatesN
	drop table ACRdata	