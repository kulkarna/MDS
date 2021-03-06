USE [LibertyPower]
GO
/****** Object:  Table [dbo].[ProdConfigGreenAttributes]    Script Date: 09/16/2013 16:45:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProdConfigGreenAttributes]') AND type in (N'U'))
DROP TABLE [dbo].[ProdConfigGreenAttributes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProdConfigGreenAttributes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProdConfigGreenAttributes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductConfigurationID] [int] NOT NULL,
	[PercentageID] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[RecTypeID] [int] NULL,
 CONSTRAINT [PK_ProdConfigGreenAttributes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
