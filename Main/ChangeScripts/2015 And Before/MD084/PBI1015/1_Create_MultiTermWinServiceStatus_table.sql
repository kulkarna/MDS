USE [LibertyPower]
GO

/****** Object:  Table [dbo].[MultiTermWinServiceStatus]    Script Date: 09/13/2012 15:29:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MultiTermWinServiceStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_ServiceProcessStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MultiTermWinServiceStatus] ADD  CONSTRAINT [DF_ServiceProcessStatus_CreateDate]  DEFAULT (getdate()) FOR [DateCreated]
GO

