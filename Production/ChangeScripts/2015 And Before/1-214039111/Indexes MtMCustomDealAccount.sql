USE [lp_MtM]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMCustomDealAccount]') AND name = N'IDX_MtMCustomDealAccount_CustomDealId')
	DROP INDEX [IDX_MtMCustomDealAccount_CustomDealId] ON [dbo].[MtMCustomDealAccount] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IDX_MtMCustomDealAccount_CustomDealId] ON [dbo].[MtMCustomDealAccount] 
(
	[CustomDealID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMCustomDealAccount]') AND name = N'IDX_MtMCustomDealAccount_AcctCont')
	DROP INDEX [IDX_MtMCustomDealAccount_AcctCont] ON [dbo].[MtMCustomDealAccount] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IDX_MtMCustomDealAccount_AcctCont] ON [dbo].[MtMCustomDealAccount] 
(
	[ContractId] ASC
	, [AccountId] ASC
)
INCLUDE ( [InActive]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
