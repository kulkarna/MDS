USE [LibertyPower]
GO
/****** Object:  Table [dbo].[ProductGreenRule]    Script Date: 03/13/2013 16:00:40 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductGreenRule_ProductGreenRuleSet]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductGreenRule]'))
ALTER TABLE [dbo].[ProductGreenRule] DROP CONSTRAINT [FK_ProductGreenRule_ProductGreenRuleSet]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductGreenRule_ProductGreenRuleSet]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductGreenRule]'))
ALTER TABLE [dbo].[ProductGreenRule] DROP CONSTRAINT [FK_ProductGreenRule_ProductGreenRuleSet]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductGreenRule]') AND type in (N'U'))
DROP TABLE [dbo].[ProductGreenRule]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductGreenRule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductGreenRule](
	[ProductGreenRuleID] [int] IDENTITY(1,1) NOT NULL,
	[ProductGreenRuleSetID] [int] NOT NULL,
	[SegmentID] [int] NULL,
	[MarketID] [int] NULL,
	[UtilityID] [int] NULL,
	[ServiceClassID] [int] NULL,
	[ZoneID] [int] NULL,
	[ProductTypeID] [int] NULL,
	[ProductBrandID] [int] NULL,
	[StartDate] [datetime] NULL,
	[Term] [int] NULL,
	[Rate] [decimal](18, 10) NULL,
	[CreatedBy] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[PriceTier] [tinyint] NULL,
 CONSTRAINT [PK_ProductGreenRule] PRIMARY KEY CLUSTERED 
(
	[ProductGreenRuleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'VirtualFolder_Path' , N'SCHEMA',N'dbo', N'TABLE',N'ProductGreenRule', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'DailyPricing' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductGreenRule'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductGreenRule_ProductGreenRuleSet]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductGreenRule]'))
ALTER TABLE [dbo].[ProductGreenRule]  WITH NOCHECK ADD  CONSTRAINT [FK_ProductGreenRule_ProductGreenRuleSet] FOREIGN KEY([ProductGreenRuleSetID])
REFERENCES [dbo].[ProductGreenRuleSet] ([ProductGreenRuleSetID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductGreenRule_ProductGreenRuleSet]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductGreenRule]'))
ALTER TABLE [dbo].[ProductGreenRule] CHECK CONSTRAINT [FK_ProductGreenRule_ProductGreenRuleSet]
GO
