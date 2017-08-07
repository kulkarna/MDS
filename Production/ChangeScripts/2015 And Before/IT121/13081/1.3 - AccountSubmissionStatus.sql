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
CREATE TABLE dbo.AccountSubmissionStatus
	(
	AccountSubmissionStatusID int NOT NULL IDENTITY (1, 1),
	Name varchar(30) not NULL,
	CreatedDate datetime not NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AccountSubmissionStatus ADD CONSTRAINT
	PK_AccountSubmissionStatus PRIMARY KEY CLUSTERED 
	(
	AccountSubmissionStatusID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.AccountSubmissionStatus SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


insert into AccountSubmissionStatus values ('Pending', GETDATE())
go
insert into AccountSubmissionStatus values ('Sent', GETDATE())
go
insert into AccountSubmissionStatus values ('Confirmed', GETDATE())
go
insert into AccountSubmissionStatus values ('Rejected', GETDATE())
go