use libertypower
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
CREATE TABLE dbo.AccountSubmissionType
	(
	AccountSubmissionTypeID int NOT NULL IDENTITY (1, 1),
	Name varchar(30) NULL,
	CreatedDate datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AccountSubmissionType ADD CONSTRAINT
	PK_AccountSubmissionType PRIMARY KEY CLUSTERED 
	(
	AccountSubmissionTypeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.AccountSubmissionType SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


insert into AccountSubmissionType values ('Enroll', GETDATE())
go
insert into AccountSubmissionType values ('Drop', GETDATE())
go
insert into AccountSubmissionType values ('Renewal', GETDATE())
go
insert into AccountSubmissionType values ('MultiTerm', GETDATE())
go