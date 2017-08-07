USE [lp_MtM]
GO

/****** Object:  Table [dbo].[MtMRiskControlExecution]    Script Date: 02/10/2014 11:20:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MtMRiskControlExecution](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Guid] [varchar](50) NOT NULL,
	[State] [smallint] NOT NULL,
	[Type] [smallint] NOT NULL,
	[RecordDate] [datetime] NOT NULL,
	[ErrorDescription] [varchar](500) NULL,
 CONSTRAINT [PK_MtMRiskControlExecution] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [Data_01]
) ON [Data_01]

GO

SET ANSI_PADDING OFF
GO

