USE [Libertypower]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DeterminantAlias_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeterminantAlias] DROP CONSTRAINT [DF_DeterminantAlias_DateCreated]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DeterminantAlias_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeterminantAlias] DROP CONSTRAINT [DF_DeterminantAlias_Active]
END

GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[DeterminantAlias]    Script Date: 10/15/2013 09:54:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeterminantAlias]') AND type in (N'U'))
DROP TABLE [dbo].[DeterminantAlias]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[DeterminantAlias]    Script Date: 10/15/2013 09:54:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DeterminantAlias](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UtilityCode] [varchar](50) NOT NULL,
	[FieldName] [varchar](60) NOT NULL,
	[OriginalValue] [varchar](60) NOT NULL,
	[AliasValue] [varchar](60) NOT NULL,
	[UserIdentity] [varchar](256) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[DeterminantAlias] ADD  CONSTRAINT [DF_DeterminantAlias_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[DeterminantAlias] ADD  CONSTRAINT [DF_DeterminantAlias_Active]  DEFAULT ((1)) FOR [Active]
GO


