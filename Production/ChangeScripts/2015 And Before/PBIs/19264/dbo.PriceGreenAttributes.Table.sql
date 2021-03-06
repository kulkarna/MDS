USE [LibertyPower]
GO
/****** Object:  Table [dbo].[PriceGreenAttributes]    Script Date: 09/16/2013 16:45:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceGreenAttributes]') AND type in (N'U'))
DROP TABLE [dbo].[PriceGreenAttributes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceGreenAttributes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PriceGreenAttributes](
	[ProductCrossPriceID] [int] NOT NULL,
	[ProdConfigGreenAttributesID] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PriceGreenAttributes]') AND name = N'idxIDs')
CREATE CLUSTERED INDEX [idxIDs] ON [dbo].[PriceGreenAttributes] 
(
	[ProductCrossPriceID] ASC,
	[ProdConfigGreenAttributesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
