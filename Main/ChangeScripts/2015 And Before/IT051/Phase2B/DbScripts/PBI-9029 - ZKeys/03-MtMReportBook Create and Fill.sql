USE [lp_mtm]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MtMReportBook](
	[BookID] [int] IDENTITY(0,1) NOT NULL,
	[BookName] [varchar](150) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBY] [int] NULL,
 CONSTRAINT [PK_MtMReportBook] PRIMARY KEY CLUSTERED 
(
	[BookID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[MtMReportBook] ON
INSERT [dbo].[MtMReportBook] ([BookID], [BookName], [Inactive], [DateCreated], [CreatedBy], [DateModified], [ModifiedBY]) VALUES (0, N'Non-Custom', 0, GETDATE(), 0, NULL, NULL)
INSERT [dbo].[MtMReportBook] ([BookID], [BookName], [Inactive], [DateCreated], [CreatedBy], [DateModified], [ModifiedBY]) VALUES (1, N'Custom', 0, GETDATE(), 0, NULL, NULL)
SET IDENTITY_INSERT [dbo].[MtMReportBook] OFF

ALTER TABLE [dbo].[MtMReportBook] ADD  CONSTRAINT [DF_MtMReportBook_Inactive]  DEFAULT ((0)) FOR [Inactive]
GO

ALTER TABLE [dbo].[MtMReportBook] ADD  CONSTRAINT [DF_MtMReportBook_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[MtMReportBook] ADD  CONSTRAINT [DF_MtMReportBook_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
