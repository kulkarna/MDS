USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TabletDocumentSubmission]') AND type in (N'U'))
DROP TABLE [dbo].[TabletDocumentSubmission]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TabletDocumentSubmission](
	[TabletDocumentSubmissionID] [int] IDENTITY(1,1) NOT NULL,
	[ContractNumber] [varchar](50) NOT NULL,
	[FileName] [varchar](250) NOT NULL,
	[DocumentTypeID] [int] NOT NULL,
	[SalesAgentID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TabletDocumentSubmission] PRIMARY KEY CLUSTERED 
(
	[TabletDocumentSubmissionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [IX_TabletDocumentSubmission] ON [dbo].[TabletDocumentSubmission] 
(
	[ContractNumber] ASC,
	[FileName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO


