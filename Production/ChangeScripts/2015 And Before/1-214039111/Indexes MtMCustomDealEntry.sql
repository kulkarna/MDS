USE [lp_MtM]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMCustomDealAEntry]') AND name = N'IDX_MtMCustomDealEntry_CustomDealId')
	DROP INDEX [IDX_MtMCustomDealEntry_CustomDealId] ON [dbo].[MtMCustomDealEntry] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IDX_MtMCustomDealEntry_CustomDealId] ON [dbo].[MtMCustomDealEntry] 
(
	[CustomDealID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMCustomDealEntry]') AND name = N'IDX_MtMCustomDealEntry_PriceId')
	DROP INDEX [IDX_MtMCustomDealEntry_PriceId] ON [dbo].[MtMCustomDealEntry] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IDX_MtMCustomDealEntry_PriceId] ON [dbo].[MtMCustomDealEntry] 
(
	[PriceId] ASC
)
INCLUDE ( [InActive]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMCustomDealEntry]') AND name = N'IDX_MtMCustomDealEntry_PR')
	DROP INDEX [IDX_MtMCustomDealEntry_PR] ON [dbo].[MtMCustomDealEntry] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IDX_MtMCustomDealEntry_PR] ON [dbo].[MtMCustomDealEntry] 
(
	[PricingRequest] ASC
)
INCLUDE ( [InActive]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO





