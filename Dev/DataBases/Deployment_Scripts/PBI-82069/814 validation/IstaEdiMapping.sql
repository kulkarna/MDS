USE [Workspace]
GO

/****** Object:  Table [dbo].[IstaEdiMapping]    Script Date: 8/25/2015 9:13:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IstaEdiMapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Ista814FieldName] [varchar](500) NULL,
	[Ista867FieldName] [varchar](500) NULL,
	[EDIFieldName] [varchar](500) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](100) NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [varchar](100) NULL,
 CONSTRAINT [PK_IstaEdiMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON , DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[IstaEdiMapping] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[IstaEdiMapping] ADD  DEFAULT (getdate()) FOR [LastModifiedDate]
GO


