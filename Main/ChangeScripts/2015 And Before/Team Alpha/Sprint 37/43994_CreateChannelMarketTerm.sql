USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ChannelMarketTerm]    Script Date: 08/14/2014 14:30:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM SYS.tables with(nolock)where tables.name='ChannelMarketTerm')
BEGIN
    CREATE TABLE [dbo].[ChannelMarketTerm](
	    [ChannelMarketTermID] [int] IDENTITY(1,1) NOT NULL,
	    [ChannelID] [int] NOT NULL,
	    [MarketID] [int] NOT NULL,
	    [MinimumAllowedTerm] [int] NULL,
	    [IsActive] [bit] NULL,
	CONSTRAINT [PK_ChannelMarketTerm] PRIMARY KEY CLUSTERED 
    (
	    [ChannelMarketTermID] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY],

	CONSTRAINT [IX_ChannelMarketTerm] UNIQUE NONCLUSTERED 
    (
	    [ChannelID] ASC,
	    [MarketID] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
    ) ON [PRIMARY];
END

IF NOT EXISTS(Select * from sys.foreign_keys with(nolock) where name ='FK_ChannelMarketTerm_Market')
BEGIN
    ALTER TABLE [dbo].[ChannelMarketTerm]  WITH CHECK ADD  CONSTRAINT [FK_ChannelMarketTerm_Market] FOREIGN KEY([MarketID])
    REFERENCES [dbo].[Market] ([ID])
    ALTER TABLE [dbo].[ChannelMarketTerm] CHECK CONSTRAINT [FK_ChannelMarketTerm_Market]
END

GO

IF NOT EXISTS(Select * from sys.foreign_keys with(nolock) where name ='FK_ChannelMarketTerm_SalesChannel')
BEGIN
    ALTER TABLE [dbo].[ChannelMarketTerm]  WITH CHECK ADD  CONSTRAINT [FK_ChannelMarketTerm_SalesChannel] FOREIGN KEY([ChannelID])
    REFERENCES [dbo].[SalesChannel] ([ChannelID])
    ALTER TABLE [dbo].[ChannelMarketTerm] CHECK CONSTRAINT [FK_ChannelMarketTerm_SalesChannel]
END

IF NOT EXISTS(Select * from sys.default_constraints with(nolock) where name ='DF_ChannelMarketTerm_MinimumAllowedTerm')
BEGIN
    ALTER TABLE [dbo].[ChannelMarketTerm] ADD  CONSTRAINT [DF_ChannelMarketTerm_MinimumAllowedTerm]  DEFAULT ((0)) FOR [MinimumAllowedTerm]
END

IF NOT EXISTS(Select * from sys.default_constraints with(nolock) where name ='DF_ChannelMarketTerms_IsActive')
BEGIN
    ALTER TABLE [dbo].[ChannelMarketTerm] ADD  CONSTRAINT [DF_ChannelMarketTerms_IsActive]  DEFAULT ((1)) FOR [IsActive]
END

GO


