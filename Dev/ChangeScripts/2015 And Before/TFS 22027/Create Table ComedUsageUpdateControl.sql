USE [lp_transactions]
GO

/****** Object:  Table [dbo].[ComedUsageUpdateControl]    Script Date: 10/14/2013 09:54:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ComedUsageUpdateControl]') AND type in (N'U'))
DROP TABLE [dbo].[ComedUsageUpdateControl]
GO

USE [lp_transactions]
GO

/****** Object:  Table [dbo].[ComedUsageUpdateControl]    Script Date: 10/14/2013 09:54:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ComedUsageUpdateControl](
	[ComedUsageUpdateControlID] [bigint] IDENTITY(1,1) NOT NULL,
	[ComedUsageID] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateUpdateAccount] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ComedUsageUpdateControlID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE ) ON [PRIMARY]
) ON [PRIMARY]

GO


USE [lp_transactions]
GO

/****** Object:  Index [NDX_ComedUsageUpdateControl]    Script Date: 10/14/2013 09:56:19 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ComedUsageUpdateControl]') AND name = N'NDX_ComedUsageUpdateControl')
DROP INDEX [NDX_ComedUsageUpdateControl] ON [dbo].[ComedUsageUpdateControl] WITH ( ONLINE = OFF )
GO

USE [lp_transactions]
GO

/****** Object:  Index [NDX_ComedUsageUpdateControl]    Script Date: 10/14/2013 09:56:19 ******/
CREATE NONCLUSTERED INDEX [NDX_ComedUsageUpdateControl] ON [dbo].[ComedUsageUpdateControl] 
(
	[DateUpdateAccount] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO





