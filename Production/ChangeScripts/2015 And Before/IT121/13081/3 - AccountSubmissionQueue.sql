Use LibertyPower
go

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
Create  TABLE dbo.AccountSubmissionQueue
	(
	AccountSubmissionQueueID int NOT NULL IDENTITY (1, 1),
	Category varchar(50) NULL,
	Type varchar(50) NULL,
	EdiStatus varchar(50) NULL,
	ScheduledSendDate datetime NULL,
	DesiredEffectiveDate datetime NULL,
	CreateDate datetime NULL,
	AccountContractRateID int FOREIGN KEY REFERENCES AccountContractRate(AccountContractRateID)
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AccountSubmissionQueue ADD CONSTRAINT
	PK_AccountSubmissionQueue PRIMARY KEY CLUSTERED 
	(
	AccountSubmissionQueueID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.AccountSubmissionQueue SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
