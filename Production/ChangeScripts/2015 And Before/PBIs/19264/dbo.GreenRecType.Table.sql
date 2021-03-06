USE [LibertyPower]
GO
/****** Object:  Table [dbo].[GreenRecType]    Script Date: 09/16/2013 16:23:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GreenRecType]') AND type in (N'U'))
DROP TABLE [dbo].[GreenRecType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GreenRecType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GreenRecType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LocationID] [int] NOT NULL,
	[RecType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_GreenRecType_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[GreenRecType] ON
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (1, 1, N'Bucket1')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (2, 1, N'Bucket2')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (3, 1, N'Bucket3')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (4, 2, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (5, 2, N'Class2')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (6, 2, N'Class3')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (7, 2, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (8, 3, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (9, 3, N'Class2')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (10, 3, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (11, 4, N'Eligible')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (12, 4, N'NewEligible')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (13, 4, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (14, 5, N'ARESNonWind')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (15, 5, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (16, 5, N'Wind')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (17, 6, N'APS')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (18, 6, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (19, 6, N'Class2NonWaste')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (20, 6, N'Class2Waste')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (21, 6, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (22, 6, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (23, 7, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (24, 7, N'Class2')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (25, 7, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (26, 8, N'NewRenewable')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (27, 8, N'Renewable')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (28, 9, N'Green-eAny')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (29, 9, N'Green-eWind')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (30, 10, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (31, 10, N'Class2')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (32, 10, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (33, 11, N'Class1Adj')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (34, 11, N'Class1Sited')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (35, 11, N'SolarAdj')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (36, 11, N'SolarSited')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (37, 12, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (38, 12, N'Class2')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (39, 12, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (40, 13, N'Existing')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (41, 13, N'New')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (42, 14, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [LocationID], [RecType]) VALUES (43, 14, N'Green-e')
SET IDENTITY_INSERT [dbo].[GreenRecType] OFF
