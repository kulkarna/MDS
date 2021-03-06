USE [LibertyPower]
GO
/****** Object:  Table [dbo].[GreenRecType]    Script Date: 11/08/2013 15:56:06 ******/
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
	[RecType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_GreenRecType_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[GreenRecType] ON
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (1, N'Bucket1')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (2, N'Bucket2')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (3, N'Bucket3')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (4, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (5, N'Class2')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (6, N'Class3')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (7, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (8, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (9, N'Class2')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (10, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (11, N'Eligible')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (12, N'NewEligible')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (13, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (14, N'ARESNonWind')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (15, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (16, N'Wind')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (17, N'APS')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (18, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (19, N'Class2NonWaste')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (20, N'Class2Waste')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (21, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (22, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (23, N'Class2')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (24, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (25, N'NewRenewable')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (26, N'Renewable')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (27, N'Green-eAny')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (28, N'Green-eWind')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (29, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (30, N'Class2')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (31, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (32, N'Class1Adj')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (33, N'Class1Sited')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (34, N'SolarAdj')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (35, N'SolarSited')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (36, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (37, N'Class2')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (38, N'Solar')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (39, N'Existing')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (40, N'New')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (41, N'Class1')
INSERT [dbo].[GreenRecType] ([ID], [RecType]) VALUES (42, N'Green-e')
SET IDENTITY_INSERT [dbo].[GreenRecType] OFF
