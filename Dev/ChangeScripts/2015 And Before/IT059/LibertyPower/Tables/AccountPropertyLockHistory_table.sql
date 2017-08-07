USE [Libertypower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AccountPropertyLockHistory_AccountPropertyHistory]') AND parent_object_id = OBJECT_ID(N'[dbo].[AccountPropertyLockHistory]'))
ALTER TABLE [dbo].[AccountPropertyLockHistory] DROP CONSTRAINT [FK_AccountPropertyLockHistory_AccountPropertyHistory]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[AccountPropertyLockHistory]    Script Date: 08/09/2013 21:06:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountPropertyLockHistory]') AND type in (N'U'))
DROP TABLE [dbo].[AccountPropertyLockHistory]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[AccountPropertyLockHistory]    Script Date: 08/09/2013 21:06:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AccountPropertyLockHistory](
	[AccountPropertyLockHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountPropertyHistoryID] [bigint] NOT NULL,
	[LockStatus] [varchar](60) NOT NULL,
	[CreatedBy] [varchar](256) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_AccountPropertyLockHistory] PRIMARY KEY CLUSTERED 
(
	[AccountPropertyLockHistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION =PAGE ) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [Libertypower]
/****** Object:  Index [idxLockStatus_AccountPropertyLockHistory]    Script Date: 08/09/2013 21:06:54 ******/
CREATE NONCLUSTERED INDEX [idxLockStatus_AccountPropertyLockHistory] ON [dbo].[AccountPropertyLockHistory] 
(
	[AccountPropertyHistoryID] ASC
)
INCLUDE ( [LockStatus],
[CreatedBy],
[DateCreated]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON,  DATA_COMPRESSION =PAGE ) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AccountPropertyLockHistory]  WITH CHECK ADD  CONSTRAINT [FK_AccountPropertyLockHistory_AccountPropertyHistory] FOREIGN KEY([AccountPropertyHistoryID])
REFERENCES [dbo].[AccountPropertyHistory] ([AccountPropertyHistoryID])
GO

ALTER TABLE [dbo].[AccountPropertyLockHistory] CHECK CONSTRAINT [FK_AccountPropertyLockHistory_AccountPropertyHistory]
GO


