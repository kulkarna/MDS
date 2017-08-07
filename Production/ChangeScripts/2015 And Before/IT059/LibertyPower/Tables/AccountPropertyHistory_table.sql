USE [Libertypower]
GO

/****** Object:  Table [dbo].[AccountPropertyHistory]    Script Date: 08/09/2013 21:04:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountPropertyHistory]') AND type in (N'U'))
DROP TABLE [dbo].[AccountPropertyHistory]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[AccountPropertyHistory]    Script Date: 08/09/2013 21:04:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AccountPropertyHistory](
	[AccountPropertyHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[UtilityID] [varchar](80) NOT NULL,
	[AccountNumber] [varchar](50) NOT NULL,
	[FieldName] [varchar](60) NOT NULL,
	[FieldValue] [varchar](200) NOT NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NULL,
	[FieldSource] [varchar](60) NOT NULL,
	[CreatedBy] [varchar](256) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[LockStatus] [varchar](60) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_DeterminantHistory_2] PRIMARY KEY CLUSTERED 
(
	[AccountPropertyHistoryID] ASC
)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION =PAGE ) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [Libertypower]
/****** Object:  Index [idx__temp1]    Script Date: 08/09/2013 21:04:54 ******/
CREATE NONCLUSTERED INDEX [idx__temp1] ON [dbo].[AccountPropertyHistory] 
(
	[UtilityID] ASC,
	[FieldName] ASC
)
INCLUDE ( [Active],
[AccountNumber],
[FieldValue]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 50, DATA_COMPRESSION =PAGE ) ON [PRIMARY]
GO


USE [Libertypower]
/****** Object:  Index [IDX_AccountPropertyHistoryTemp02]    Script Date: 08/09/2013 21:04:54 ******/
CREATE NONCLUSTERED INDEX [IDX_AccountPropertyHistoryTemp02] ON [dbo].[AccountPropertyHistory] 
(
	[UtilityID] ASC,
	[AccountNumber] ASC,
	[Active] ASC,
	[FieldName] ASC,
	[EffectiveDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION =PAGE ) ON [PRIMARY]
GO

/*** overriding check in so we get this file again. Putting the phoenix related indexes in a separate file ************/

