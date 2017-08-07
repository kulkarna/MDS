USE [LibertyPower]

-- CREATE TABLE TO HOLD OLD VALUES JUST IN CASE WE NEED TO ROLLBACK
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SubmitEnrollmentDateFix_Log]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SubmitEnrollmentDateFix_Log](
      [SubmitEnrollmentDateFixLogID] INT IDENTITY (1,1),
      [AccountContractID] [int] NOT NULL,
      [SendEnrollmentDateOld] [datetime] NULL,
      [SendEnrollmentDateNew] [datetime] NULL,
      [RecordCreatedOn] [datetime] NOT NULL,
CONSTRAINT [PK_SubmitEnrollmentDateFix_Test] PRIMARY KEY CLUSTERED 
(
      [SubmitEnrollmentDateFixLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_SubmitEnrollmentDateFix_Log_RecordCreatedOn]') AND parent_object_id = OBJECT_ID(N'[dbo].[SubmitEnrollmentDateFix_Log]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SubmitEnrollmentDateFix_Log_RecordCreatedOn]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SubmitEnrollmentDateFix_Log] ADD  CONSTRAINT [DF_SubmitEnrollmentDateFix_Log_RecordCreatedOn]  DEFAULT (getdate()) FOR [RecordCreatedOn]
END
End

--SP_HELP [SubmitEnrollmentDateFix_Log]

-- THE UPDATE CODE BELOW, IS A COPY OF SP [dbo].[ScheduleEnrollmentBasedOnMeterRead], 
-- EXCEPT THAT WE ARE LIMITTING IT TO ACCOUNTS WITH START DATE ON OR AFTER 04/01/2013
BEGIN TRANSACTION

UPDATE	ac 
SET		ac.SendEnrollmentDate = CASE
									WHEN DATEADD(day, 1, mrc.read_date) < DATEADD(day, -(u.EnrollmentLeadDays), c.StartDate) THEN DATEADD(day, 1, mrc.read_date)
									ELSE DATEADD(day, -(u.EnrollmentLeadDays), c.StartDate)
								END
OUTPUT      Inserted.AccountContractID, Inserted.SendEnrollmentDate, Deleted.SendEnrollmentDate, GETDATE() INTO [dbo].[SubmitEnrollmentDateFix_Log] ([AccountContractID], [SendEnrollmentDateNew], [SendEnrollmentDateOld])
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
AND c.StartDate >= '2013-04-01'

SELECT * FROM [dbo].SubmitEnrollmentDateFix_Log (nolock) ORDER BY SubmitEnrollmentDateFixLogID

--ROLLBACK
--COMMIT


/*=========================================================================

            MANUAL TESTING NEEDS TO BE PERFORMED ON THE AFFECTED ACCOUNTS

==========================================================================*/


--IF TESTING FAILS, ROLLBACK USING RESULTS FROM THE [SubmitEnrollmentDateFix_Log] TABLE
/*
SELECT sedt.*, ac.*
FROM LibertyPower..AccountContract ac (nolock)
JOIN [dbo].[SubmitEnrollmentDateFix_Log] sedt (nolock) ON ac.AccountContractID = sedt.AccountContractID
WHERE ac.SendEnrollmentDate <> sedt.SendEnrollmentDateNew

UPDATE      ac SET
        ac.SendEnrollmentDate = sedt.SendEnrollmentDateOld
FROM LibertyPower..AccountContract ac (nolock)
JOIN [dbo].[SubmitEnrollmentDateFix_Log] sedt (nolock) ON ac.AccountContractID = sedt.AccountContractID
WHERE ac.SendEnrollmentDate = sedt.SendEnrollmentDateNew
*/
