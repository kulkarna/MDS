USE [Libertypower]
GO
/****** Object:  Table [dbo].[ProductConfigurationPrices]    Script Date: 09/20/2012 08:42:01 ******/
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

ALTER TABLE [dbo].ProductConfigurationPrices ADD  CONSTRAINT [PK_ProductConfigurationPrices] PRIMARY KEY CLUSTERED 
(
      [ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ProductConfigurationPrices__PriceID_I_ProductConfigurationID]
ON [dbo].[ProductConfigurationPrices] ([PriceID])
INCLUDE ([ProductConfigurationID])
GO
