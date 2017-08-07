USE [Workspace]
GO

/****** Object:  Table [dbo].[AuditRunEdiAccount]    Script Date: 8/21/2015 11:58:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AuditRunEdiAccount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AuditRunDate] [datetime] NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AuditRunEdiAccount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AuditRunEdiAccount] ADD  DEFAULT (getdate()) FOR [AuditRunDate]
GO


