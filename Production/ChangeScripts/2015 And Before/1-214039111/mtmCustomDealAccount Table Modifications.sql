USE lp_mtm
GO

ALTER TABLE lp_mtm.dbo.MtMCustomDealAccount
ADD AccountID INT NULL
GO 

ALTER TABLE lp_mtm.dbo.MtMCustomDealAccount
ADD ContractID INT NULL
GO 


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MtMCustomDealAccount_DateCreated]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[MtMCustomDealAccount] DROP CONSTRAINT [DF_MtMCustomDealAccount_DateCreated]
END

GO

ALTER TABLE dbo.MtMCustomDealAccount ADD CONSTRAINT
	DF_MtMCustomDealAccount_DateCreated DEFAULT getdate() FOR DateCreated
GO
