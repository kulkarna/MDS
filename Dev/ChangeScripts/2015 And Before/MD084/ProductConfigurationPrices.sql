USE [Libertypower]
GO
/****** Object:  Table [dbo].[ProductConfigurationPrices]    Script Date: 09/17/2012 17:20:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductConfigurationPrices]') AND type in (N'U'))
DROP TABLE [dbo].[ProductConfigurationPrices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductConfigurationPrices]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductConfigurationPrices](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductConfigurationID] [int] NOT NULL,
	[PriceID] [bigint] NOT NULL
) ON [PRIMARY]
END
GO
