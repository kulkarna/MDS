USE [lp_mtm]
GO

/****** Object:  Index [IDX_MtMCustomDealHeader_PR]    Script Date: 09/04/2013 12:08:43 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMCustomDealHeader]') AND name = N'IDX_MtMCustomDealHeader_PR')
DROP INDEX [IDX_MtMCustomDealHeader_PR] ON [dbo].[MtMCustomDealHeader] WITH ( ONLINE = OFF )
GO

USE [lp_mtm]
GO

/****** Object:  Index [IDX_MtMCustomDealHeader_PR]    Script Date: 09/04/2013 12:08:43 ******/
CREATE NONCLUSTERED INDEX [IDX_MtMCustomDealHeader_PR] ON [dbo].[MtMCustomDealHeader] 
(
	[PricingRequest] ASC
)
INCLUDE ( [InActive]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


