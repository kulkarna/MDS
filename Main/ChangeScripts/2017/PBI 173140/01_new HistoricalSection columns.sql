USE [lp_transactions]
GO

/****** Object:  Table [dbo].[EdiUsage]    ******/
ALTER TABLE [dbo].[EdiUsage]
ADD HistoricalSection VARCHAR(10) NULL


/****** Object:  Table [dbo].[EdiUsageDuplicate]    ******/
ALTER TABLE [dbo].[EdiUsageDuplicate]
ADD HistoricalSection VARCHAR(10) NULL