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
CREATE TABLE dbo.AccountContractStatusReason
	(
	AccountContractStatusReasonID int NOT NULL IDENTITY (1, 1),
	Name varchar(30) NULL,
	CreatedDate datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AccountContractStatusReason ADD CONSTRAINT
	PK_AccountContractStatusReason PRIMARY KEY CLUSTERED 
	(
	AccountContractStatusReasonID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.AccountContractStatusReason SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

insert into AccountContractStatusReason values ('Internal Cancellation', GETDATE())
go
insert into AccountContractStatusReason values ('Internal Rejection', GETDATE())
go
insert into AccountContractStatusReason values ('External Rejection', GETDATE())
go