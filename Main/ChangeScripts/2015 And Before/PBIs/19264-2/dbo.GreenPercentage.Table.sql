USE [LibertyPower]
GO
/****** Object:  Table [dbo].[GreenPercentage]    Script Date: 11/08/2013 15:56:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GreenPercentage]') AND type in (N'U'))
DROP TABLE [dbo].[GreenPercentage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GreenPercentage]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GreenPercentage](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Percent] [int] NOT NULL,
 CONSTRAINT [PK_GreenPercentage] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET IDENTITY_INSERT [dbo].[GreenPercentage] ON
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (1, 1)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (2, 2)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (3, 3)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (4, 4)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (5, 5)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (6, 6)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (7, 7)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (8, 8)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (9, 9)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (10, 10)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (11, 11)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (12, 12)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (13, 13)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (14, 14)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (15, 15)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (16, 16)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (17, 17)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (18, 18)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (19, 19)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (20, 20)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (21, 21)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (22, 22)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (23, 23)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (24, 24)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (25, 25)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (26, 26)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (27, 27)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (28, 28)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (29, 29)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (30, 30)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (31, 31)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (32, 32)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (33, 33)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (34, 34)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (35, 35)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (36, 36)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (37, 37)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (38, 38)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (39, 39)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (40, 40)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (41, 41)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (42, 42)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (43, 43)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (44, 44)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (45, 45)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (46, 46)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (47, 47)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (48, 48)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (49, 49)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (50, 50)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (51, 51)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (52, 52)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (53, 53)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (54, 54)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (55, 55)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (56, 56)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (57, 57)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (58, 58)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (59, 59)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (60, 60)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (61, 61)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (62, 62)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (63, 63)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (64, 64)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (65, 65)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (66, 66)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (67, 67)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (68, 68)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (69, 69)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (70, 70)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (71, 71)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (72, 72)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (73, 73)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (74, 74)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (75, 75)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (76, 76)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (77, 77)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (78, 78)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (79, 79)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (80, 80)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (81, 81)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (82, 82)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (83, 83)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (84, 84)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (85, 85)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (86, 86)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (87, 87)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (88, 88)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (89, 89)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (90, 90)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (91, 91)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (92, 92)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (93, 93)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (94, 94)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (95, 95)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (96, 96)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (97, 97)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (98, 98)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (99, 99)
INSERT [dbo].[GreenPercentage] ([ID], [Percent]) VALUES (100, 100)
GO
print 'Processed 100 total records'
SET IDENTITY_INSERT [dbo].[GreenPercentage] OFF
