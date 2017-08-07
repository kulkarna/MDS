USE LibertyPower
GO


SET IDENTITY_INSERT [dbo].[ThirdPartyApplications] ON
INSERT [dbo].[ThirdPartyApplications] ([ID], [Name], [DateCreated], [CreatedBy]) VALUES (1, N'Offer Engine', GETDATE(), 0)
INSERT [dbo].[ThirdPartyApplications] ([ID], [Name], [DateCreated], [CreatedBy]) VALUES (2, N'Retail Office', GETDATE(), 0)
INSERT [dbo].[ThirdPartyApplications] ([ID], [Name], [DateCreated], [CreatedBy]) VALUES (3, N'Zainet', GETDATE(), 0)
INSERT [dbo].[ThirdPartyApplications] ([ID], [Name], [DateCreated], [CreatedBy]) VALUES (4, N'MatPrice', GETDATE(), 0)
INSERT [dbo].[ThirdPartyApplications] ([ID], [Name], [DateCreated], [CreatedBy]) VALUES (5, N'Pricing', GETDATE(), 0)
SET IDENTITY_INSERT [dbo].[ThirdPartyApplications] OFF


SET IDENTITY_INSERT [dbo].[ExternalEntityType] ON
INSERT [dbo].[ExternalEntityType] ([ID], [Name], [DateCreated], [CreatedBy]) VALUES (1, N'ISO', GETDATE(), 0)
INSERT [dbo].[ExternalEntityType] ([ID], [Name], [DateCreated], [CreatedBy]) VALUES (2, N'Utility', GETDATE(), 0)
INSERT [dbo].[ExternalEntityType] ([ID], [Name], [DateCreated], [CreatedBy]) VALUES (3, N'Third Party Apps', GETDATE(), 0)
SET IDENTITY_INSERT [dbo].[ExternalEntityType] OFF

USE [LibertyPower]
GO
/****** Object:  Table [dbo].[ExternalEntity]    Script Date: 04/26/2013 11:33:24 ******/
SET IDENTITY_INSERT [dbo].[ExternalEntity] ON
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (1, CAST(0x0000A18C00000000 AS DateTime), 0, 0, 1, 1, 1)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (2, CAST(0x0000A18C00000000 AS DateTime), 0, 0, 1, 2, 1)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (3, CAST(0x0000A18900000000 AS DateTime), 0, 0, 1, 3, 1)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (4, CAST(0x0000A18900000000 AS DateTime), 0, 0, 1, 4, 1)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (5, CAST(0x0000A18900000000 AS DateTime), 0, 0, 1, 5, 1)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (6, CAST(0x0000A18900000000 AS DateTime), 0, 0, 1, 6, 1)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (7, CAST(0x0000A18900000000 AS DateTime), 0, 0, 1, 1, 3)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (8, CAST(0x0000A18900000000 AS DateTime), 0, 0, 2, 2, 3)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (9, CAST(0x0000A18900000000 AS DateTime), 0, 0, 2, 3, 3)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (10, CAST(0x0000A19600CB8A4C AS DateTime), 0, 0, 2, 4, 3)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (11, CAST(0x0000A19600CB8A4E AS DateTime), 0, 0, 2, 5, 3)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (16, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 1, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (17, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 2, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (18, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 3, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (19, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 4, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (20, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 5, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (21, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 8, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (22, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 9, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (23, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 10, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (24, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 11, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (25, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 12, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (26, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 13, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (27, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 14, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (28, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 15, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (29, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 16, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (30, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 17, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (31, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 18, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (32, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 19, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (33, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 20, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (34, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 21, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (35, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 22, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (36, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 23, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (37, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 24, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (38, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 25, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (39, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 26, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (40, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 27, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (41, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 28, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (42, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 29, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (43, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 30, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (44, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 31, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (45, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 32, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (46, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 33, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (47, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 34, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (48, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 35, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (49, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 36, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (50, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 37, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (51, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 38, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (52, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 39, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (53, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 40, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (54, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 41, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (55, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 42, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (56, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 43, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (57, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 44, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (58, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 45, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (59, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 46, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (60, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 47, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (61, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 48, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (62, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 49, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (63, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 50, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (64, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 51, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (65, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 55, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (66, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 56, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (67, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 58, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (68, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 59, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (69, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 60, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (70, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 61, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (71, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 62, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (72, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 63, 2)
INSERT [dbo].[ExternalEntity] ([ID], [DateCreated], [CreatedBy], [Inactive], [ShowAs], [EntityKey], [EntityTypeID]) VALUES (73, CAST(0x0000A1AC00BDF222 AS DateTime), 0, 0, 0, 64, 2)
SET IDENTITY_INSERT [dbo].[ExternalEntity] OFF


SET IDENTITY_INSERT [dbo].[Property] ON
INSERT [dbo].[Property] ([ID], [Name], [Inactive], [DateCreated], [CreatedBy]) VALUES (1, N'Location', 0, GETDATE(), 0)
INSERT [dbo].[Property] ([ID], [Name], [Inactive], [DateCreated], [CreatedBy]) VALUES (2, N'Profile', 0, GETDATE(), 0)
INSERT [dbo].[Property] ([ID], [Name], [Inactive], [DateCreated], [CreatedBy]) VALUES (3, N'Service Class', 0, GETDATE(), 0)
SET IDENTITY_INSERT [dbo].[Property] OFF


SET IDENTITY_INSERT [dbo].[PropertyType] ON
INSERT [dbo].[PropertyType] ([ID], [PropertyID], [Name], [Inactive], [DateCreated], [CreatedBy]) VALUES (1, 1, N'Zone', 0, GETDATE(), 0)
INSERT [dbo].[PropertyType] ([ID], [PropertyID], [Name], [Inactive], [DateCreated], [CreatedBy]) VALUES (2, 1, N'Hub', 0, GETDATE(), 0)
SET IDENTITY_INSERT [dbo].[PropertyType] OFF


SET IDENTITY_INSERT [dbo].[PropertyTypeEntityTypeMap] ON
INSERT [dbo].[PropertyTypeEntityTypeMap] ([ID], [PropertyID], [ExternalEntityTypeID], [Inactive], [DateCreated], [CreatedBy], [Modified], [ModifiedBy]) VALUES (1, 1, 1, 0, CAST(0x0000A1B601118019 AS DateTime), 0, NULL, NULL)
INSERT [dbo].[PropertyTypeEntityTypeMap] ([ID], [PropertyID], [ExternalEntityTypeID], [Inactive], [DateCreated], [CreatedBy], [Modified], [ModifiedBy]) VALUES (3, 1, 3, 0, CAST(0x0000A1B60111921C AS DateTime), 0, NULL, NULL)
INSERT [dbo].[PropertyTypeEntityTypeMap] ([ID], [PropertyID], [ExternalEntityTypeID], [Inactive], [DateCreated], [CreatedBy], [Modified], [ModifiedBy]) VALUES (4, 2, 2, 0, CAST(0x0000A1B60111A4BE AS DateTime), 0, NULL, NULL)
INSERT [dbo].[PropertyTypeEntityTypeMap] ([ID], [PropertyID], [ExternalEntityTypeID], [Inactive], [DateCreated], [CreatedBy], [Modified], [ModifiedBy]) VALUES (6, 2, 3, 0, CAST(0x0000A1B60111B5B3 AS DateTime), 0, NULL, NULL)
INSERT [dbo].[PropertyTypeEntityTypeMap] ([ID], [PropertyID], [ExternalEntityTypeID], [Inactive], [DateCreated], [CreatedBy], [Modified], [ModifiedBy]) VALUES (7, 3, 2, 0, CAST(0x0000A1B60111A4BE AS DateTime), 0, NULL, NULL)
INSERT [dbo].[PropertyTypeEntityTypeMap] ([ID], [PropertyID], [ExternalEntityTypeID], [Inactive], [DateCreated], [CreatedBy], [Modified], [ModifiedBy]) VALUES (8, 3, 3, 0, CAST(0x0000A1B60111B5B3 AS DateTime), 0, NULL, NULL)
SET IDENTITY_INSERT [dbo].[PropertyTypeEntityTypeMap] OFF
