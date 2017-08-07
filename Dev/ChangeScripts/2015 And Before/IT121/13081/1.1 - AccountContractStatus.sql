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
CREATE TABLE dbo.AccountContractStatus
	(
	AccountContractStatusID int NOT NULL IDENTITY (1, 1),
	Name varchar(30) not NULL,
	CreatedDate datetime not NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AccountContractStatus ADD CONSTRAINT
	PK_AccountContractStatus PRIMARY KEY CLUSTERED 
	(
	AccountContractStatusID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.AccountContractStatus SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


insert into AccountContractStatus values ('Pending', GETDATE())
go
insert into AccountContractStatus values ('Approved', GETDATE())
go
insert into AccountContractStatus values ('Rejected', GETDATE())
go