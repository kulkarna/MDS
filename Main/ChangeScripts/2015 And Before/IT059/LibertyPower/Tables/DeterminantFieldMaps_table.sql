USE [Libertypower]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DeterminantFieldMaps_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeterminantFieldMaps] DROP CONSTRAINT [DF_DeterminantFieldMaps_DateCreated]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DeterminantFieldMaps_CreatedBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeterminantFieldMaps] DROP CONSTRAINT [DF_DeterminantFieldMaps_CreatedBy]
END

GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[DeterminantFieldMaps]    Script Date: 10/15/2013 10:12:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeterminantFieldMaps]') AND type in (N'U'))
DROP TABLE [dbo].[DeterminantFieldMaps]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[DeterminantFieldMaps]    Script Date: 10/15/2013 10:12:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DeterminantFieldMaps](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UtilityCode] [varchar](80) NOT NULL,
	[DeterminantFieldName] [varchar](60) NOT NULL,
	[DeterminantValue] [varchar](200) NOT NULL,
	[MappingRuleType] [varchar](60) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NULL,
	[CreatedBy] [varchar](256) NOT NULL,
 CONSTRAINT [PK_DeterminantFieldMaps] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [Libertypower]
/****** Object:  Index [idx__DateCreated_I]    Script Date: 10/15/2013 10:12:36 ******/
CREATE NONCLUSTERED INDEX [idx__DateCreated_I] ON [dbo].[DeterminantFieldMaps] 
(
	[DateCreated] ASC
)
INCLUDE ( [DeterminantFieldName],
[DeterminantValue],
[ID],
[UtilityCode]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DeterminantFieldMaps] ADD  CONSTRAINT [DF_DeterminantFieldMaps_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[DeterminantFieldMaps] ADD  CONSTRAINT [DF_DeterminantFieldMaps_CreatedBy]  DEFAULT ('unknown') FOR [CreatedBy]
GO


