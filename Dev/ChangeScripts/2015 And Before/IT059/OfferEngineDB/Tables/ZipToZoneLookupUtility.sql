USE [OfferEngineDB]
GO
/****** Object:  Table [dbo].[ZipToZoneLookupUtility]    Script Date: 11/14/2013 18:18:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ZipToZoneLookupUtility](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UtilityCode] [varchar](80) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [varchar](256) NOT NULL,
 CONSTRAINT [PK_ZipToZoneUtility] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[ZipToZoneLookupUtility] ON
INSERT [dbo].[ZipToZoneLookupUtility] ([ID], [UtilityCode], [DateCreated], [CreatedBy]) VALUES (1, N'NIMO', CAST(0x0000A2760126BCA5 AS DateTime), N'jjohn')
SET IDENTITY_INSERT [dbo].[ZipToZoneLookupUtility] OFF
/****** Object:  Default [DF_ZipToZoneUtility_DateCreated]    Script Date: 11/14/2013 18:18:23 ******/
ALTER TABLE [dbo].[ZipToZoneLookupUtility] ADD  CONSTRAINT [DF_ZipToZoneUtility_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
