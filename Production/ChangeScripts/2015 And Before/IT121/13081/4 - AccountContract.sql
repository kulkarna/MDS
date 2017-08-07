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
GO
ALTER TABLE dbo.AccountContract ADD
	AccountContractStatusID int  FOREIGN KEY REFERENCES AccountContractStatus(AccountContractStatusID)	
GO
ALTER TABLE dbo.AccountContract ADD
	AccountContractStatusReasonID int  FOREIGN KEY REFERENCES AccountContractStatusReason(AccountContractStatusReasonID)
GO
ALTER TABLE dbo.AccountContract ADD CONSTRAINT
	DF_AccountContract_AccountContractStatus DEFAULT 1 FOR AccountContractStatusID
GO


ALTER TABLE dbo.AccountContract SET (LOCK_ESCALATION = TABLE)
GO



/*
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
GO
ALTER TABLE dbo.AccountContract ADD
	AccountContractStatus varchar(30) NULL
GO
ALTER TABLE dbo.AccountContract ADD CONSTRAINT
	DF_AccountContract_AccountContractStatus DEFAULT 'Pending' FOR AccountContractStatus
GO
ALTER TABLE dbo.AccountContract SET (LOCK_ESCALATION = TABLE)
GO
*/
