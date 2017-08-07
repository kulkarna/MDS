USE Libertypower
GO

/****** Object:  Table [dbo].[MtMMonthlyAccountForecast]    Script Date: 08/22/2011 12:13:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/************************************************************************************************/

CREATE TABLE [dbo].[MtMDailyWholesaleLoadForecast](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MtMAccountID] [int] NULL,
	[UsageDate] [datetime] NULL,
	[ETP] [float] NULL,
	[Int1] [decimal](14, 4) NULL,
	[Int2] [decimal](14, 4) NULL,
	[Int3] [decimal](14, 4) NULL,
	[Int4] [decimal](14, 4) NULL,
	[Int5] [decimal](14, 4) NULL,
	[Int6] [decimal](14, 4) NULL,
	[Int7] [decimal](14, 4) NULL,
	[Int8] [decimal](14, 4) NULL,
	[Int9] [decimal](14, 4) NULL,
	[Int10] [decimal](14, 4) NULL,
	[Int11] [decimal](14, 4) NULL,
	[Int12] [decimal](14, 4) NULL,
	[Int13] [decimal](14, 4) NULL,
	[Int14] [decimal](14, 4) NULL,
	[Int15] [decimal](14, 4) NULL,
	[Int16] [decimal](14, 4) NULL,
	[Int17] [decimal](14, 4) NULL,
	[Int18] [decimal](14, 4) NULL,
	[Int19] [decimal](14, 4) NULL,
	[Int20] [decimal](14, 4) NULL,
	[Int21] [decimal](14, 4) NULL,
	[Int22] [decimal](14, 4) NULL,
	[Int23] [decimal](14, 4) NULL,
	[Int24] [decimal](14, 4) NULL,
	[Inactive] [bit] NULL,
	[DateCreated] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMDailyWholesaleLoadForecast] ADD  CONSTRAINT [DF_MtMDailyWholesaleLoadForecast_Inactive]  DEFAULT ((0)) FOR [Inactive]
GO

ALTER TABLE [dbo].[MtMDailyWholesaleLoadForecast] ADD  CONSTRAINT [DF_MtMDailyWholesaleLoadForecast_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[MtMZainetZones]    Script Date: 04/25/2012 13:01:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MtMZainetZones](
	[UtilityID] [int] NOT NULL,
	[Zone] [varchar](50) NOT NULL,
	[ZainetZone] [varchar](50) NOT NULL,
 CONSTRAINT [PK_MtMZainetZones] PRIMARY KEY CLUSTERED 
(
	[UtilityID] ASC,
	[Zone] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/********************************* IMPORT DATA FROM EXCEL FILE  *************************/


