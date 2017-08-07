USE [Workspace]
GO

/****** Object:  Table [dbo].[AuditEdiAccountHistory867tbl]    Script Date: 8/21/2015 11:55:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AuditEdiAccountHistory867tbl](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AuditRunEdiAccountId] [int] NOT NULL,
	[IstaAccountNumber] [varchar](200) NOT NULL,
	[IstaTableName] [varchar](200) NULL,
	[IstaFieldName] [varchar](200) NULL,
	[IstaValue] [varchar](200) NULL,
	[IstaRecordFieldName] [varchar](200) NULL,
	[IstaRecordFieldValue] [varchar](200) NULL,
	[IstaRecordCreation] [datetime] NOT NULL,
	[LpESAccountNumber] [varchar](200) NULL,
	[LpEaSourceTableName] [varchar](200) NULL,
	[LpEaSourceFieldName] [varchar](200) NULL,
	[LpEaSourceValue] [varchar](200) NULL,
	[LpEaSourceRecordId] [varchar](200) NULL,
	[Comment] [varchar](500) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](100) NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [varchar](100) NULL,
 CONSTRAINT [PK_AuditEdiAccountHistory867tbl] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[AuditEdiAccountHistory867tbl] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[AuditEdiAccountHistory867tbl] ADD  DEFAULT (getdate()) FOR [LastModifiedDate]
GO

ALTER TABLE [dbo].[AuditEdiAccountHistory867tbl]  WITH CHECK ADD  CONSTRAINT [FK_AuditEdiAccountHistory_AuditRunEdiAccount867tbl] FOREIGN KEY([AuditRunEdiAccountId])
REFERENCES [dbo].[AuditRunEdiAccount] ([Id])
GO

ALTER TABLE [dbo].[AuditEdiAccountHistory867tbl] CHECK CONSTRAINT [FK_AuditEdiAccountHistory_AuditRunEdiAccount867tbl]
GO


