USE [LibertyPower]
GO
/****** Object:  Table [dbo].[PriceGreenAttributes]    Script Date: 11/18/2013 08:51:42 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PriceGreenAttributes_ProductConfigGreenAttributes]') AND parent_object_id = OBJECT_ID(N'[dbo].[PriceGreenAttributes]'))
ALTER TABLE [dbo].[PriceGreenAttributes] DROP CONSTRAINT [FK_PriceGreenAttributes_ProductConfigGreenAttributes]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PriceGreenAttributes_ProductConfigGreenAttributes]') AND parent_object_id = OBJECT_ID(N'[dbo].[PriceGreenAttributes]'))
ALTER TABLE [dbo].[PriceGreenAttributes] DROP CONSTRAINT [FK_PriceGreenAttributes_ProductConfigGreenAttributes]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceGreenAttributes]') AND type in (N'U'))
DROP TABLE [dbo].[PriceGreenAttributes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceGreenAttributes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PriceGreenAttributes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCrossPriceID] [int] NOT NULL,
	[ProductConfigurationID] [int] NOT NULL,
 CONSTRAINT [PK_PriceGreenAttributes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PriceGreenAttributes]') AND name = N'ndx_ProdConfig_CrossPrice_IDs')
CREATE UNIQUE NONCLUSTERED INDEX [ndx_ProdConfig_CrossPrice_IDs] ON [dbo].[PriceGreenAttributes] 
(
	[ProductConfigurationID] ASC,
	[ProductCrossPriceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PriceGreenAttributes_ProductConfigGreenAttributes]') AND parent_object_id = OBJECT_ID(N'[dbo].[PriceGreenAttributes]'))
ALTER TABLE [dbo].[PriceGreenAttributes]  WITH NOCHECK ADD  CONSTRAINT [FK_PriceGreenAttributes_ProductConfigGreenAttributes] FOREIGN KEY([ProductConfigurationID])
REFERENCES [dbo].[ProductConfigGreenAttributes] ([ProductConfigurationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PriceGreenAttributes_ProductConfigGreenAttributes]') AND parent_object_id = OBJECT_ID(N'[dbo].[PriceGreenAttributes]'))
ALTER TABLE [dbo].[PriceGreenAttributes] CHECK CONSTRAINT [FK_PriceGreenAttributes_ProductConfigGreenAttributes]
GO
