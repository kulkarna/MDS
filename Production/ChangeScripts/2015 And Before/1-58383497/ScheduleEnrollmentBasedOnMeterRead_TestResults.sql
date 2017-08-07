USE [LibertyPower]

SELECT TOP 11 a.AccountNumber, 
		u.UtilityCode, 
		a.BillingGroup, 
		CONVERT(VARCHAR, c.StartDate, 101) as StartDate,
		CONVERT(VARCHAR, l.SendEnrollmentDateNew, 101) as OldSendEnrollmentDate,
		CONVERT(VARCHAR, ac.SendEnrollmentDate, 101) as NewSendEnrollmentDate,
		CONVERT(VARCHAR, DATEADD(day, -(u.EnrollmentLeadDays), c.StartDate), 101) as SupposedEnrollmentLeadDate,
		u.EnrollmentLeadDays,
		DATEDIFF(day, l.SendEnrollmentDateNew, ac.SendEnrollmentDate) as Improvement
		--l.RecordCreatedOn
--SELECT AVG(DATEDIFF(day, l.SendEnrollmentDateNew, ac.SendEnrollmentDate)) AverageImprovement
FROM [dbo].[SubmitEnrollmentDateFix_Log] l (nolock) 
JOIN LibertyPower..AccountContract ac (nolock) ON l.AccountContractID = ac.AccountContractID
JOIN LibertyPower..Account a (nolock) ON ac.AccountID = a.AccountID 
JOIN LibertyPower..Contract c (nolock) ON a.CurrentContractID = c.ContractID 
JOIN LibertyPower..AccountStatus s (nolock) ON ac.AccountContractID = s.AccountContractID
JOIN LibertyPower..Utility u ON a.UtilityID = u.ID
JOIN LibertyPower..Market m ON u.MarketID = m.ID
JOIN (
            SELECT      calendar_year,
                        calendar_month,
                        utility_id,
                        CASE
                              WHEN ISNUMERIC(read_cycle_id) = 1 THEN CONVERT(VARCHAR, CAST(read_cycle_id AS INT))
                              ELSE read_cycle_id
                        END as read_cycle_id,
                        read_date
            FROM  [lp_common].[dbo].[meter_read_calendar] (nolock)
      ) as mrc ON u.UtilityCode = mrc.utility_id AND a.BillingGroup = mrc.read_cycle_id
WHERE s.Status = '05000' and s.substatus = '10'
AND mrc.calendar_year = CAST(YEAR(DATEADD(month, -1, c.StartDate)) AS INT)
AND mrc.calendar_month = MONTH(DATEADD(month, -1, c.StartDate))
--AND ac.SendEnrollmentDate > DATEADD(day, -(u.EnrollmentLeadDays), c.StartDate)	-- CHECK IF THERE'S ANY METER-READ DATE LATER THAN WINDOW DATE
ORDER BY l.RecordCreatedOn DESC

--select * from [SubmitEnrollmentDateFix_Log] order by RecordCreatedOn desc