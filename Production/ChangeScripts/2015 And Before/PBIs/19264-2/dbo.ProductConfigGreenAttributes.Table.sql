USE [LibertyPower]
GO
/****** Object:  Table [dbo].[ProductConfigGreenAttributes]    Script Date: 11/08/2013 15:56:06 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductConfigGreenAttributes_GreenLocationRecType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]'))
ALTER TABLE [dbo].[ProductConfigGreenAttributes] DROP CONSTRAINT [FK_ProductConfigGreenAttributes_GreenLocationRecType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductConfigGreenAttributes_GreenPercentage]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]'))
ALTER TABLE [dbo].[ProductConfigGreenAttributes] DROP CONSTRAINT [FK_ProductConfigGreenAttributes_GreenPercentage]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductConfigGreenAttributes_ProductConfiguration]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]'))
ALTER TABLE [dbo].[ProductConfigGreenAttributes] DROP CONSTRAINT [FK_ProductConfigGreenAttributes_ProductConfiguration]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductConfigGreenAttributes_GreenLocationRecType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]'))
ALTER TABLE [dbo].[ProductConfigGreenAttributes] DROP CONSTRAINT [FK_ProductConfigGreenAttributes_GreenLocationRecType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductConfigGreenAttributes_GreenPercentage]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]'))
ALTER TABLE [dbo].[ProductConfigGreenAttributes] DROP CONSTRAINT [FK_ProductConfigGreenAttributes_GreenPercentage]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductConfigGreenAttributes_ProductConfiguration]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]'))
ALTER TABLE [dbo].[ProductConfigGreenAttributes] DROP CONSTRAINT [FK_ProductConfigGreenAttributes_ProductConfiguration]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]') AND type in (N'U'))
DROP TABLE [dbo].[ProductConfigGreenAttributes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductConfigGreenAttributes](
	[ProductConfigurationID] [int] NOT NULL,
	[PercentageID] [int] NOT NULL,
	[GreenLocationRecTypeID] [int] NOT NULL,
 CONSTRAINT [PK_ProductConfigGreenAttributes] PRIMARY KEY CLUSTERED 
(
	[ProductConfigurationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductConfigGreenAttributes_GreenLocationRecType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]'))
ALTER TABLE [dbo].[ProductConfigGreenAttributes]  WITH CHECK ADD  CONSTRAINT [FK_ProductConfigGreenAttributes_GreenLocationRecType] FOREIGN KEY([GreenLocationRecTypeID])
REFERENCES [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductConfigGreenAttributes_GreenLocationRecType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]'))
ALTER TABLE [dbo].[ProductConfigGreenAttributes] CHECK CONSTRAINT [FK_ProductConfigGreenAttributes_GreenLocationRecType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductConfigGreenAttributes_GreenPercentage]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]'))
ALTER TABLE [dbo].[ProductConfigGreenAttributes]  WITH CHECK ADD  CONSTRAINT [FK_ProductConfigGreenAttributes_GreenPercentage] FOREIGN KEY([PercentageID])
REFERENCES [dbo].[GreenPercentage] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductConfigGreenAttributes_GreenPercentage]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]'))
ALTER TABLE [dbo].[ProductConfigGreenAttributes] CHECK CONSTRAINT [FK_ProductConfigGreenAttributes_GreenPercentage]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductConfigGreenAttributes_ProductConfiguration]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]'))
ALTER TABLE [dbo].[ProductConfigGreenAttributes]  WITH CHECK ADD  CONSTRAINT [FK_ProductConfigGreenAttributes_ProductConfiguration] FOREIGN KEY([ProductConfigurationID])
REFERENCES [dbo].[ProductConfiguration] ([ProductConfigurationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductConfigGreenAttributes_ProductConfiguration]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductConfigGreenAttributes]'))
ALTER TABLE [dbo].[ProductConfigGreenAttributes] CHECK CONSTRAINT [FK_ProductConfigGreenAttributes_ProductConfiguration]
GO