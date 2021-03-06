USE [Libertypower]
GO
/****** Object:  Table [dbo].[ProdConfigChannelAccess]    Script Date: 09/26/2012 13:39:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProdConfigChannelAccess]') AND type in (N'U'))
DROP TABLE [dbo].[ProdConfigChannelAccess]
GO
/****** Object:  Table [dbo].[ProdConfigChannelAccess]    Script Date: 09/26/2012 13:39:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProdConfigChannelAccess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProdConfigChannelAccess](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductConfigurationID] [int] NOT NULL,
	[ChannelID] [int] NOT NULL,
 CONSTRAINT [PK_ProdConfigChannelAccess] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
