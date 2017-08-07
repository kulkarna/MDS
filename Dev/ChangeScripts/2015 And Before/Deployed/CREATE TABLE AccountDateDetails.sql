USE [Libertypower]
GO

/****** Object:  Table [dbo].[AccountDateDetails]    Script Date: 04/19/2012 14:19:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AccountDateDetails](
	[AccountDateDetailsID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AccountID] [int] NOT NULL,
	[ExpirationDate] [datetime] NOT NULL,
	[NumberOfDays] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[Modified] [datetime] NULL,
 CONSTRAINT [PK_AccountDateDetails] PRIMARY KEY CLUSTERED 
(
	[AccountDateDetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AccountDateDetails] ADD CONSTRAINT [CreatedDefaultValue] DEFAULT (GETDATE()) FOR Created
GO

ALTER TABLE [dbo].[AccountDateDetails] ADD CONSTRAINT [ModifiedDefaultValue] DEFAULT (GETDATE()) FOR Modified
GO

ALTER TABLE [dbo].[AccountDateDetails]  WITH CHECK ADD  CONSTRAINT [FK_AccountDateDetails_Account] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Account] ([AccountID])
GO

ALTER TABLE [dbo].[AccountDateDetails] CHECK CONSTRAINT [FK_AccountDateDetails_Account]
GO

ALTER TABLE [dbo].[AccountDateDetails]  WITH CHECK ADD  CONSTRAINT [FK_AccountDateDetails_User] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[AccountDateDetails] CHECK CONSTRAINT [FK_AccountDateDetails_User]
GO

ALTER TABLE [dbo].[AccountDateDetails]  WITH CHECK ADD  CONSTRAINT [FK_AccountDateDetails_User1] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[AccountDateDetails] CHECK CONSTRAINT [FK_AccountDateDetails_User1]
GO