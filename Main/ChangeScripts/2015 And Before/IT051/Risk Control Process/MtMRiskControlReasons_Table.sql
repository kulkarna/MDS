USE [lp_MtM]
GO
/****** Object:  Table [dbo].[MtMRiskControlReasons]    Script Date: 11/05/2013 15:19:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MtMRiskControlReasons](
	[Id] [int] NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_MTMRiskControlReasons] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [Data_01]
) ON [Data_01]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (0, N'Unknown')
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (1, N'There is no IDR Usage for this account.')
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (2, N'There is no NON-IDR Usage for this account.')
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (3, N'Calendar not found, probably because of wrong  load profile, for this account.')
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (4, N'There is no Wholesale Load for this account.')
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (5, N'There is no Energy Curve for this Settlement Location.')
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (6, N'There is no Intraday for this Settlement Location.')
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (7, N'There is no Shaping for this Settlement Location.')
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (8, N'There is no Supplier Premium for this Settlement Location.')
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (9, N'There is no Energy Curve for this Deal Date.')
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (10, N'There is no Intraday for this Deal Date.')
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (11, N'There is no Shaping for this Deal Date.')
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (12, N'There is no Supplier Premium for this Deal Date.')
INSERT [dbo].[MtMRiskControlReasons] ([Id], [Description]) VALUES (13, N'There is no ETP info on MtMCustomDealAccount table for this account.')
