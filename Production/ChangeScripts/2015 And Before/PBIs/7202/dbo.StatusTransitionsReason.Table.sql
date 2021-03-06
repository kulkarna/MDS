USE [Lp_enrollment]
GO
/****** Object:  Table [dbo].[StatusTransitionsReason]    Script Date: 03/07/2013 07:42:23 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StatusTransitionsReason_StatusTransitions]') AND parent_object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReason]'))
ALTER TABLE [dbo].[StatusTransitionsReason] DROP CONSTRAINT [FK_StatusTransitionsReason_StatusTransitions]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StatusTransitionsReason_StatusTransitionsReasonCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReason]'))
ALTER TABLE [dbo].[StatusTransitionsReason] DROP CONSTRAINT [FK_StatusTransitionsReason_StatusTransitionsReasonCode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StatusTransitionsReason_StatusTransitions]') AND parent_object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReason]'))
ALTER TABLE [dbo].[StatusTransitionsReason] DROP CONSTRAINT [FK_StatusTransitionsReason_StatusTransitions]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StatusTransitionsReason_StatusTransitionsReasonCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReason]'))
ALTER TABLE [dbo].[StatusTransitionsReason] DROP CONSTRAINT [FK_StatusTransitionsReason_StatusTransitionsReasonCode]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_StatusTransitionsReason_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[StatusTransitionsReason] DROP CONSTRAINT [DF_StatusTransitionsReason_DateCreated]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReason]') AND type in (N'U'))
DROP TABLE [dbo].[StatusTransitionsReason]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReason]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StatusTransitionsReason](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[ReasonCodeID] [int] NOT NULL,
	[StatusTransitionsID] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_StatusTransitionsReason_DateCreated]  DEFAULT (getdate()),
 CONSTRAINT [PK_StatusTransitionsReason] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StatusTransitionsReason_StatusTransitions]') AND parent_object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReason]'))
ALTER TABLE [dbo].[StatusTransitionsReason]  WITH CHECK ADD  CONSTRAINT [FK_StatusTransitionsReason_StatusTransitions] FOREIGN KEY([StatusTransitionsID])
REFERENCES [dbo].[StatusTransitions] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StatusTransitionsReason_StatusTransitions]') AND parent_object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReason]'))
ALTER TABLE [dbo].[StatusTransitionsReason] CHECK CONSTRAINT [FK_StatusTransitionsReason_StatusTransitions]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StatusTransitionsReason_StatusTransitionsReasonCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReason]'))
ALTER TABLE [dbo].[StatusTransitionsReason]  WITH CHECK ADD  CONSTRAINT [FK_StatusTransitionsReason_StatusTransitionsReasonCode] FOREIGN KEY([ReasonCodeID])
REFERENCES [dbo].[StatusTransitionsReasonCode] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StatusTransitionsReason_StatusTransitionsReasonCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReason]'))
ALTER TABLE [dbo].[StatusTransitionsReason] CHECK CONSTRAINT [FK_StatusTransitionsReason_StatusTransitionsReasonCode]
GO
