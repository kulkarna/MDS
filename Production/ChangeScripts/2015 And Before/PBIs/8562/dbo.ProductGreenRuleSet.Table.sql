USE [LibertyPower]
GO
/****** Object:  Table [dbo].[ProductGreenRuleSet]    Script Date: 03/13/2013 16:00:40 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductGreenRuleSet_FileContext]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductGreenRuleSet]'))
ALTER TABLE [dbo].[ProductGreenRuleSet] DROP CONSTRAINT [FK_ProductGreenRuleSet_FileContext]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductGreenRuleSet_FileContext]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductGreenRuleSet]'))
ALTER TABLE [dbo].[ProductGreenRuleSet] DROP CONSTRAINT [FK_ProductGreenRuleSet_FileContext]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductGreenRuleSet]') AND type in (N'U'))
DROP TABLE [dbo].[ProductGreenRuleSet]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductGreenRuleSet]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductGreenRuleSet](
	[ProductGreenRuleSetID] [int] IDENTITY(1,1) NOT NULL,
	[FileGuid] [uniqueidentifier] NOT NULL,
	[UploadedBy] [int] NOT NULL,
	[UploadedDate] [datetime] NOT NULL,
	[UploadStatus] [int] NULL,
 CONSTRAINT [PK_ProductGreenRuleSet] PRIMARY KEY CLUSTERED 
(
	[ProductGreenRuleSetID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'VirtualFolder_Path' , N'SCHEMA',N'dbo', N'TABLE',N'ProductGreenRuleSet', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'DailyPricing' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductGreenRuleSet'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductGreenRuleSet_FileContext]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductGreenRuleSet]'))
ALTER TABLE [dbo].[ProductGreenRuleSet]  WITH CHECK ADD  CONSTRAINT [FK_ProductGreenRuleSet_FileContext] FOREIGN KEY([FileGuid])
REFERENCES [dbo].[FileContext] ([FileGuid])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductGreenRuleSet_FileContext]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductGreenRuleSet]'))
ALTER TABLE [dbo].[ProductGreenRuleSet] CHECK CONSTRAINT [FK_ProductGreenRuleSet_FileContext]
GO
