-- =============================================
-- Author:		Carlos Lima
-- Create date: 2013-02-06
-- Description:	Schedules enrollment submission dates on the day after the meter read on the previous month 
--				OR the start date minus the Utility's enrollment window, whichever is earlier.
-- =============================================
CREATE PROCEDURE [dbo].[ScheduleEnrollmentBasedOnMeterRead]
	@AccountID int = NULL
AS
BEGIN
	SET NOCOUNT ON
	
	UPDATE	ac 
	SET		ac.SendEnrollmentDate = CASE
										WHEN DATEADD(day, 1, mrc.read_date) <= DATEADD(day, -(u.EnrollmentLeadDays), c.StartDate) THEN DATEADD(day, 1, mrc.read_date)
										ELSE DATEADD(day, -(u.EnrollmentLeadDays), c.StartDate)
									END
	OUTPUT      Inserted.AccountContractID, Inserted.SendEnrollmentDate, Deleted.SendEnrollmentDate, GETDATE() INTO [dbo].[SubmitEnrollmentDateFix_Log](AccountContractID, SendEnrollmentDateNew, SendEnrollmentDateOld, RecordCreatedOn)
	FROM LibertyPower..AccountContract ac (nolock)
	JOIN LibertyPower..Account a (nolock) ON ac.AccountID = a.AccountID 
	JOIN LibertyPower..Contract c (nolock) ON a.CurrentContractID = c.ContractID 
	JOIN LibertyPower..AccountStatus s (nolock) ON ac.AccountContractID = s.AccountContractID
	JOIN LibertyPower..Utility u (nolock) ON a.UtilityID = u.ID
	JOIN LibertyPower..Market m (nolock) ON u.MarketID = m.ID
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
	AND m.MarketCode NOT IN('TX', 'CA')
	AND DATEADD(day, 1, mrc.read_date) < SendEnrollmentDate
	AND (@AccountID IS NULL OR (@AccountID IS NOT NULL AND a.AccountID = @AccountID))
END
