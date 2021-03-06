USE [LibertyPower]
GO
/****** Object:  Table [dbo].[GreenLocationRecType]    Script Date: 11/08/2013 15:56:06 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GreenLocationRecType_GreenLocation]') AND parent_object_id = OBJECT_ID(N'[dbo].[GreenLocationRecType]'))
ALTER TABLE [dbo].[GreenLocationRecType] DROP CONSTRAINT [FK_GreenLocationRecType_GreenLocation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GreenLocationRecType_GreenRecType]') AND parent_object_id = OBJECT_ID(N'[dbo].[GreenLocationRecType]'))
ALTER TABLE [dbo].[GreenLocationRecType] DROP CONSTRAINT [FK_GreenLocationRecType_GreenRecType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GreenLocationRecType_GreenLocation]') AND parent_object_id = OBJECT_ID(N'[dbo].[GreenLocationRecType]'))
ALTER TABLE [dbo].[GreenLocationRecType] DROP CONSTRAINT [FK_GreenLocationRecType_GreenLocation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GreenLocationRecType_GreenRecType]') AND parent_object_id = OBJECT_ID(N'[dbo].[GreenLocationRecType]'))
ALTER TABLE [dbo].[GreenLocationRecType] DROP CONSTRAINT [FK_GreenLocationRecType_GreenRecType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GreenLocationRecType]') AND type in (N'U'))
DROP TABLE [dbo].[GreenLocationRecType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GreenLocationRecType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GreenLocationRecType](
	[GreenLocationRecTypeID] [int] IDENTITY(1,1) NOT NULL,
	[LocationID] [int] NOT NULL,
	[RecTypeID] [int] NOT NULL,
 CONSTRAINT [PK_GreenLocationRecType] PRIMARY KEY CLUSTERED 
(
	[GreenLocationRecTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GreenLocationRecType_GreenLocation]') AND parent_object_id = OBJECT_ID(N'[dbo].[GreenLocationRecType]'))
ALTER TABLE [dbo].[GreenLocationRecType]  WITH CHECK ADD  CONSTRAINT [FK_GreenLocationRecType_GreenLocation] FOREIGN KEY([LocationID])
REFERENCES [dbo].[GreenLocation] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GreenLocationRecType_GreenLocation]') AND parent_object_id = OBJECT_ID(N'[dbo].[GreenLocationRecType]'))
ALTER TABLE [dbo].[GreenLocationRecType] CHECK CONSTRAINT [FK_GreenLocationRecType_GreenLocation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GreenLocationRecType_GreenRecType]') AND parent_object_id = OBJECT_ID(N'[dbo].[GreenLocationRecType]'))
ALTER TABLE [dbo].[GreenLocationRecType]  WITH CHECK ADD  CONSTRAINT [FK_GreenLocationRecType_GreenRecType] FOREIGN KEY([RecTypeID])
REFERENCES [dbo].[GreenRecType] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GreenLocationRecType_GreenRecType]') AND parent_object_id = OBJECT_ID(N'[dbo].[GreenLocationRecType]'))
ALTER TABLE [dbo].[GreenLocationRecType] CHECK CONSTRAINT [FK_GreenLocationRecType_GreenRecType]
GO
SET IDENTITY_INSERT [dbo].[GreenLocationRecType] ON
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (1, 1, 1)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (2, 1, 2)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (3, 1, 3)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (4, 2, 4)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (5, 2, 5)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (6, 2, 6)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (7, 2, 7)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (8, 3, 8)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (9, 3, 9)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (10, 3, 10)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (11, 4, 11)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (12, 4, 12)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (13, 4, 13)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (14, 5, 14)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (15, 5, 15)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (16, 5, 16)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (17, 6, 17)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (18, 6, 18)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (19, 6, 19)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (20, 6, 20)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (21, 6, 21)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (22, 7, 22)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (23, 7, 23)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (24, 7, 24)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (25, 8, 25)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (26, 8, 26)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (27, 9, 27)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (28, 9, 28)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (29, 10, 29)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (30, 10, 30)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (31, 10, 31)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (32, 11, 32)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (33, 11, 33)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (34, 11, 34)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (35, 11, 35)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (36, 12, 36)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (37, 12, 37)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (38, 12, 38)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (39, 13, 39)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (40, 13, 40)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (41, 14, 41)
INSERT [dbo].[GreenLocationRecType] ([GreenLocationRecTypeID], [LocationID], [RecTypeID]) VALUES (42, 14, 42)
SET IDENTITY_INSERT [dbo].[GreenLocationRecType] OFF
