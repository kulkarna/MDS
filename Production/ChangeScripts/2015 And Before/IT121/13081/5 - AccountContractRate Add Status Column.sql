use Libertypower
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
ALTER TABLE dbo.AccountContractRate ADD
	AccountContractRateStatus int NULL
GO
ALTER TABLE dbo.AccountContractRate SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
