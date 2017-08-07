USE [Workspace]
GO

/****** Object:  Table [dbo].[AuditRunEdiAccount_814]    Script Date: 8/25/2015 9:07:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AuditRunEdiAccount_814](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AuditRunDate] [datetime] NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AuditRunEdiAccount_814] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON ,DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AuditRunEdiAccount_814] ADD  DEFAULT (getdate()) FOR [AuditRunDate]
GO


