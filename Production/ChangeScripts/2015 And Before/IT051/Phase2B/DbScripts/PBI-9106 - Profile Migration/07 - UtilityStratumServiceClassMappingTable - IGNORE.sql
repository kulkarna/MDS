USE [LibertyPower]
GO

/****** Object:  Table [dbo].[UtilityStratumServiceClassMapping]    Script Date: 05/14/2013 13:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[UtilityStratumServiceClassMapping](
	[CustomerServiceClass] [varchar](50) NOT NULL,
	[LoadShapeServiceClass] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UtilityStratumServiceClassMapping] PRIMARY KEY CLUSTERED 
(
	[CustomerServiceClass] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


