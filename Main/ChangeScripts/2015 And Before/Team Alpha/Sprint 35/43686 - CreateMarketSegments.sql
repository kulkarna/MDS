USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ChannelMarketSegments]    Script Date: 07/21/2014 13:54:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 from sys.tables where sys.tables.name = 'ChannelMarketSegments')
BEGIN
    CREATE TABLE [dbo].[ChannelMarketSegments](
	    [ChannelMarketSegmentID] [int] IDENTITY(1,1) NOT NULL,
	    [ChannelID][int] NOT NULL,
	    [MarketID] [int] NOT NULL,
	    [SegmentID] [int] NOT NULL,
	    
	CONSTRAINT [PK_ChannelMarketSegments] PRIMARY KEY CLUSTERED 
    (
	    [ChannelMarketSegmentID] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON,DATA_COMPRESSION = PAGE) ON [PRIMARY]
    ) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_MarketSegments]    Script Date: 07/21/2014 13:54:45 ******/
IF NOT EXISTS(Select 1 from  sys.indexes where name = 'IX_ChannelMarketSegments')
    BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [IX_ChannelMarketSegments] ON [dbo].[ChannelMarketSegments] 
    (
	[ChannelID] ASC,
	[MarketID] ASC,
	[SegmentID] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
    END
GO
IF NOT EXISTS(SELECT 1 FROM SYS.FOREIGN_KEYS WHERE NAME ='FK_ChannelMarketSegments_AccountType')
BEGIN
    ALTER TABLE [dbo].[ChannelMarketSegments]  WITH CHECK ADD  CONSTRAINT [FK_ChannelMarketSegments_AccountType] FOREIGN KEY([SegmentID])
    REFERENCES [dbo].[AccountType] ([ID])
    ALTER TABLE [dbo].[ChannelMarketSegments] CHECK CONSTRAINT [FK_ChannelMarketSegments_AccountType]
    
END
IF NOT EXISTS(SELECT 1 FROM SYS.FOREIGN_KEYS WHERE NAME ='FK_ChannelMarketSegments_Market')
BEGIN
    ALTER TABLE [dbo].[ChannelMarketSegments]  WITH CHECK ADD  CONSTRAINT [FK_ChannelMarketSegments_Market] FOREIGN KEY([MarketID])
    REFERENCES [dbo].[Market] ([ID])

    ALTER TABLE [dbo].[ChannelMarketSegments] CHECK CONSTRAINT [FK_ChannelMarketSegments_Market]
END
IF NOT EXISTS(SELECT 1 FROM SYS.FOREIGN_KEYS WHERE NAME ='FK_ChannelMarketSegments_SalesChannel')
BEGIN
    ALTER TABLE [dbo].[ChannelMarketSegments]  WITH CHECK ADD  CONSTRAINT [FK_ChannelMarketSegments_SalesChannel] FOREIGN KEY([ChannelID])
    REFERENCES [dbo].[SalesChannel] ([ChannelID])

    ALTER TABLE [dbo].[ChannelMarketSegments] CHECK CONSTRAINT [FK_ChannelMarketSegments_SalesChannel]
END
GO





