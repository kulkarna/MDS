USE [Lp_enrollment]
GO
/****** Object:  Table [dbo].[StatusTransitionsReasonOther]    Script Date: 03/07/2013 07:42:23 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StatusTransitionsReasonOther_StatusTransitionsReason]') AND parent_object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReasonOther]'))
ALTER TABLE [dbo].[StatusTransitionsReasonOther] DROP CONSTRAINT [FK_StatusTransitionsReasonOther_StatusTransitionsReason]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StatusTransitionsReasonOther_StatusTransitionsReason]') AND parent_object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReasonOther]'))
ALTER TABLE [dbo].[StatusTransitionsReasonOther] DROP CONSTRAINT [FK_StatusTransitionsReasonOther_StatusTransitionsReason]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReasonOther]') AND type in (N'U'))
DROP TABLE [dbo].[StatusTransitionsReasonOther]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReasonOther]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StatusTransitionsReasonOther](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ReasonID] [int] NOT NULL,
	[Reason] [varchar](500) NULL,
 CONSTRAINT [PK_StatusTransitionsReasonOther] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StatusTransitionsReasonOther_StatusTransitionsReason]') AND parent_object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReasonOther]'))
ALTER TABLE [dbo].[StatusTransitionsReasonOther]  WITH CHECK ADD  CONSTRAINT [FK_StatusTransitionsReasonOther_StatusTransitionsReason] FOREIGN KEY([ReasonID])
REFERENCES [dbo].[StatusTransitionsReason] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StatusTransitionsReasonOther_StatusTransitionsReason]') AND parent_object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReasonOther]'))
ALTER TABLE [dbo].[StatusTransitionsReasonOther] CHECK CONSTRAINT [FK_StatusTransitionsReasonOther_StatusTransitionsReason]
GO
