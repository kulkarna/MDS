USE [LibertyPower]
GO

/****** Object:  Table [dbo].[MarketSalesTax]    Script Date: 05/04/2012 13:33:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS(select * from libertypower.sys.tables where [name] = 'MarketSalesTax')
BEGIN
	CREATE TABLE [dbo].[MarketSalesTax](
		[MarketSalesTaxId] [int] IDENTITY(1,1) NOT NULL,
		[MarketId] [int] NOT NULL,
		[SalesTax] [float] NOT NULL,
		[EffectiveStartDate] [datetime] NOT NULL,
		[EffectiveEndDate] [datetime] NULL,
		[DateCreated] [datetime] NOT NULL,
	 CONSTRAINT [PK_MarketSalesTax] PRIMARY KEY CLUSTERED 
	(
		[MarketSalesTaxId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	GO

	ALTER TABLE [dbo].[MarketSalesTax]  WITH CHECK ADD  CONSTRAINT [FK_MarketSalesTax_Market] FOREIGN KEY([MarketId])
	REFERENCES [dbo].[Market] ([ID])
	GO

	ALTER TABLE [dbo].[MarketSalesTax] CHECK CONSTRAINT [FK_MarketSalesTax_Market]
	GO

	ALTER TABLE [dbo].[MarketSalesTax] ADD  CONSTRAINT [DF_MarketSalesTax_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
	GO

	INSERT INTO [MarketSalesTax]
	(MarketID, SalesTax, EffectiveStartDate, EffectiveEndDate)
	SELECT 9, .07, '2012-05-07', null
END

