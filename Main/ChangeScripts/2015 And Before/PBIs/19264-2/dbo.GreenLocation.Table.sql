USE [LibertyPower]
GO
/****** Object:  Table [dbo].[GreenLocation]    Script Date: 11/08/2013 15:56:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GreenLocation]') AND type in (N'U'))
DROP TABLE [dbo].[GreenLocation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GreenLocation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GreenLocation](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Location] [varchar](50) NOT NULL,
 CONSTRAINT [PK_GreenLocation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[GreenLocation] ON
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (1, N'CA')
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (2, N'CT')
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (3, N'DC')
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (4, N'DE')
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (5, N'IL')
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (6, N'MA')
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (7, N'MD')
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (8, N'ME')
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (9, N'National')
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (10, N'NJ')
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (11, N'OH')
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (12, N'PA')
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (13, N'RI')
INSERT [dbo].[GreenLocation] ([ID], [Location]) VALUES (14, N'TX')
SET IDENTITY_INSERT [dbo].[GreenLocation] OFF
