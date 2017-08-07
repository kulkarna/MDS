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
CREATE TABLE dbo.AccountSubmissionCategory
	(
	AccountSubmissionCategoryID int NOT NULL IDENTITY (1, 1),
	Name varchar(30) not NULL,
	CreatedDate datetime not NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AccountSubmissionCategory ADD CONSTRAINT
	PK_AccountSubmissionCategory PRIMARY KEY CLUSTERED 
	(
	AccountSubmissionCategoryID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.AccountSubmissionCategory SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


insert into AccountSubmissionCategory values ('Service', GETDATE())
go
insert into AccountSubmissionCategory values ('Rate', GETDATE())
go
insert into AccountSubmissionCategory values ('EDIRate', GETDATE())
go