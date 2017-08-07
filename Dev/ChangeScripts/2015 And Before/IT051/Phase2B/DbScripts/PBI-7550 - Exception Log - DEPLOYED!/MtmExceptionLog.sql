USE [lp_mtm]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MtMExceptionLog](
	[ExceptionId] [int] IDENTITY(1,1) NOT NULL,
	[ExceptionDescription] [varchar](max) NOT NULL,
	[ExceptionDump] [varchar](max) NULL,
	[ExceptionTypeId] [int] NULL,
	[Severity] [int] NULL,
	[Source] [varchar](max) NULL,
	[BatchNumber] [varchar](max) NULL,
	[AccountId] [int] NULL,
	[Internal] [bit] NULL,
	[AdditionalInfo] [varchar](max) NULL,
	[ExpirationDate] [datetime] NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_MtmExceptionLog] PRIMARY KEY CLUSTERED 
(
	[ExceptionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMExceptionLog] ADD  DEFAULT ((0)) FOR [ExceptionTypeId]
GO

ALTER TABLE [dbo].[MtMExceptionLog] ADD  DEFAULT ((0)) FOR [Severity]
GO

ALTER TABLE [dbo].[MtMExceptionLog] ADD  DEFAULT ((0)) FOR [Internal]
GO

ALTER TABLE [dbo].[MtMExceptionLog] ADD  DEFAULT (getdate()) FOR [DateCreated]
GO
