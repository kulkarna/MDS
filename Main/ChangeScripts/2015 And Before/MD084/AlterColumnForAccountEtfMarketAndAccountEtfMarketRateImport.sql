USE [Libertypower]
GO

/*****************  AccountEtfMarketRate  ***************************************************/

/****** Object:  Index [IX_AccountEtfMarketRate_EffectiveDate_RetailMarket_Utility_Zone_ServiceClass_Term_DropMonthIndicator]    Script Date: 10/02/2012 17:34:25 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AccountEtfMarketRate]') AND name = N'IX_AccountEtfMarketRate_EffectiveDate_RetailMarket_Utility_Zone_ServiceClass_Term_DropMonthIndicator')
ALTER TABLE [dbo].[AccountEtfMarketRate] DROP CONSTRAINT [IX_AccountEtfMarketRate_EffectiveDate_RetailMarket_Utility_Zone_ServiceClass_Term_DropMonthIndicator]
GO


ALTER TABLE AccountEtfMarketRate
ALTER COLUMN DropMonthIndicator int NOT NULL

/****** Object:  Index [IX_AccountEtfMarketRate_EffectiveDate_RetailMarket_Utility_Zone_ServiceClass_Term_DropMonthIndicator]    Script Date: 10/02/2012 17:35:14 ******/
ALTER TABLE [dbo].[AccountEtfMarketRate] ADD  CONSTRAINT [IX_AccountEtfMarketRate_EffectiveDate_RetailMarket_Utility_Zone_ServiceClass_Term_DropMonthIndicator] UNIQUE NONCLUSTERED 
(
	[EffectiveDate] ASC,
	[RetailMarket] ASC,
	[Utility] ASC,
	[Zone] ASC,
	[ServiceClass] ASC,
	[Term] ASC,
	[DropMonthIndicator] ASC,
	[AccountType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


/*****************  AccountEtfMarketRateImport  ***************************************************/

/****** Object:  Index [IX_AccountEtfMarketRateImport_EffectiveDate_RetailMarket_Utility_Zone_ServiceClass_Term_DropMonthIndicator]    Script Date: 10/02/2012 17:35:46 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AccountEtfMarketRateImport]') AND name = N'IX_AccountEtfMarketRateImport_EffectiveDate_RetailMarket_Utility_Zone_ServiceClass_Term_DropMonthIndicator')
ALTER TABLE [dbo].[AccountEtfMarketRateImport] DROP CONSTRAINT [IX_AccountEtfMarketRateImport_EffectiveDate_RetailMarket_Utility_Zone_ServiceClass_Term_DropMonthIndicator]
GO


ALTER TABLE AccountEtfMarketRateImport
ALTER COLUMN DropMonthIndicator int NOT NULL

/****** Object:  Index [IX_AccountEtfMarketRateImport_EffectiveDate_RetailMarket_Utility_Zone_ServiceClass_Term_DropMonthIndicator]    Script Date: 10/02/2012 17:36:13 ******/
ALTER TABLE [dbo].[AccountEtfMarketRateImport] ADD  CONSTRAINT [IX_AccountEtfMarketRateImport_EffectiveDate_RetailMarket_Utility_Zone_ServiceClass_Term_DropMonthIndicator] UNIQUE NONCLUSTERED 
(
	[EffectiveDate] ASC,
	[RetailMarket] ASC,
	[Utility] ASC,
	[Zone] ASC,
	[ServiceClass] ASC,
	[Term] ASC,
	[DropMonthIndicator] ASC,
	[AccountType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO