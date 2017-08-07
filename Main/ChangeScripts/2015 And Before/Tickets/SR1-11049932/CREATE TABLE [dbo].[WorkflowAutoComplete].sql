USE [LibertyPower]
GO

/****** Object:  Table [dbo].[WorkflowAutoComplete]    Script Date: 05/17/2012 15:20:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WorkflowAutoComplete](
	[WorkflowAutoAcceptID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UserID] [int] NOT NULL,
	[AutoApproveDocument] [bit] NOT NULL,
 CONSTRAINT [PK_WorkflowAutoComplete] PRIMARY KEY CLUSTERED 
(
	[WorkflowAutoAcceptID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[WorkflowAutoComplete]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowAutoComplete_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[WorkflowAutoComplete] CHECK CONSTRAINT [FK_WorkflowAutoComplete_User]
GO


