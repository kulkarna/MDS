USE [LibertyPower]
GO

/****** Object:  Table [dbo].[MarginThreshold]    Script Date: 08/02/2012 16:26:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarginThreshold](
	[MarginThresholdID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[MarginLow] [decimal](18, 10) NOT NULL,
	[MarginHigh] [decimal](18, 10) NOT NULL,
	[MarginLimit] [decimal](18, 10) NOT NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NULL
) ON [PRIMARY]

GO


