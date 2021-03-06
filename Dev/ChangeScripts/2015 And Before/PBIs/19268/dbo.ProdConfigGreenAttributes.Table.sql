USE [LibertyPower]
GO
/****** Object:  Table [dbo].[ProdConfigGreenAttributes]    Script Date: 10/10/2013 10:19:44 ******/
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
	[Percentage] [decimal](5, 2) NOT NULL,
	[LocationID] [int] NOT NULL,
	[RecTypeID] [int] NOT NULL,
 CONSTRAINT [PK_ProdConfigGreenAttributes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [uc_ProdConfigIDLocIDRecTypeID] UNIQUE NONCLUSTERED 
(
	[ProductConfigurationID] ASC,
	[LocationID] ASC,
	[RecTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
