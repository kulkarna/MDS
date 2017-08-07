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
Create TABLE dbo.zAuditAccountSubmissionQueue
	(
	zAuditAccountSubmissionQueueID int NOT NULL IDENTITY (1, 1), 
	AccountSubmissionQueueID int NULL,
	Category varchar(50) NULL,
	Type varchar(50) NULL,
	EdiStatus varchar(50) NULL,
	ScheduledSendDate datetime NULL,
	DesiredEffectiveDate datetime NULL,
	CreateDate datetime NULL,
	AccountContractRateID int null,
	[AuditChangeType] varchar(50) null,
	[ColumnsUpdated] varchar(350) null,
	[ColumnsChanged] varchar(350) null
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.zAuditAccountSubmissionQueue ADD CONSTRAINT
	PK_zAuditAccountSubmissionQueue PRIMARY KEY CLUSTERED 
	(
	zAuditAccountSubmissionQueueID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,Data_compression=page) ON [PRIMARY]

GO
COMMIT




