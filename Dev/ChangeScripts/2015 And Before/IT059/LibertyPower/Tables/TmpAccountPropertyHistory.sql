USE [Libertypower]
GO

/****** Object:  Table [dbo].[TmpAccountPropertyHistory]    Script Date: 08/22/2013 16:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TmpAccountPropertyHistory]') AND type in (N'U'))
DROP TABLE [dbo].[TmpAccountPropertyHistory]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[TmpAccountPropertyHistory]    Script Date: 08/22/2013 16:21:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TmpAccountPropertyHistory](
	[Utility] [varchar](80) NULL,
	[AccountNumber] [varchar](50) NULL,
	[FieldName] [varchar](60) NULL,
	[FieldValue] [varchar](200) NULL,
	[EffectiveDate] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


