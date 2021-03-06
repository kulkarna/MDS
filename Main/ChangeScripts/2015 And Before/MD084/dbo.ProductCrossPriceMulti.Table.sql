USE [Libertypower]
GO
/****** Object:  Table [dbo].[ProductCrossPriceMulti]    Script Date: 10/03/2012 10:41:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductCrossPriceMulti]') AND type in (N'U'))
DROP TABLE [dbo].[ProductCrossPriceMulti]
GO
/****** Object:  Table [dbo].[ProductCrossPriceMulti]    Script Date: 10/03/2012 10:41:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductCrossPriceMulti]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductCrossPriceMulti](
	[ProductCrossPriceMultiID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCrossPriceID] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[Term] [int] NOT NULL,
	[MarkupRate] [decimal](13, 5) NOT NULL,
	[Price] [decimal](13, 5) NOT NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProductCrossPriceMulti]') AND name = N'ndx_ProductCrosPriceID')
CREATE NONCLUSTERED INDEX [ndx_ProductCrosPriceID] ON [dbo].[ProductCrossPriceMulti] 
(
	[ProductCrossPriceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
