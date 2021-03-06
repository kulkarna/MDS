/****** Object:  Table [dbo].[RECONEDI_MTMStatus]    Script Date: 6/26/2014 5:18:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_MTMStatus](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Category] [varchar](50) NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[SubStatus] [varchar](15) NOT NULL,
 CONSTRAINT [PK_RECONEDI_MTMStatus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[RECONEDI_MTMStatus] ON 

INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (1, N'Fixed Price Load Obligation', N'11000', N'10')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (2, N'Fixed Price Load Obligation', N'11000', N'20')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (3, N'Fixed Price Load Obligation', N'11000', N'30')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (4, N'Fixed Price Load Obligation', N'11000', N'40')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (5, N'Fixed Price Load Obligation', N'11000', N'50')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (6, N'Fixed Price Load Obligation', N'03000', N'20')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (7, N'Fixed Price Load Obligation', N'04000', N'20')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (8, N'Fixed Price Load Obligation', N'05000', N'10')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (9, N'Fixed Price Load Obligation', N'05000', N'20')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (10, N'Fixed Price Load Obligation', N'05000', N'27')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (11, N'Fixed Price Load Obligation', N'05000', N'30')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (12, N'Fixed Price Load Obligation', N'06000', N'10')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (13, N'Fixed Price Load Obligation', N'06000', N'20')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (14, N'Fixed Price Load Obligation', N'06000', N'27')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (15, N'Fixed Price Load Obligation', N'06000', N'30')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (16, N'Fixed Price Load Obligation', N'07000', N'10')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (17, N'Fixed Price Load Obligation', N'07000', N'20')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (18, N'Fixed Price Load Obligation', N'905000', N'10')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (19, N'Fixed Price Load Obligation', N'906000', N'10')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (20, N'Enrollment', N'01000', N'10')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (21, N'Enrollment', N'01000', N'15')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (22, N'Enrollment', N'10000', N'10')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (23, N'Enrollment', N'10000', N'20')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (24, N'Enrollment', N'13000', N'60')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (25, N'Enrollment', N'13000', N'70')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (26, N'Enrollment', N'13000', N'80')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (27, N'Enrollment', N'03000', N'10')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (28, N'Enrollment', N'04000', N'10')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (29, N'Enrollment', N'05000', N'25')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (30, N'Enrollment', N'06000', N'25')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (31, N'Enrollment', N'09000', N'20')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (32, N'DE-Enrollment', N'11000', N'10')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (33, N'DE-Enrollment', N'11000', N'20')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (34, N'DE-Enrollment', N'11000', N'30')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (35, N'DE-Enrollment', N'11000', N'40')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (36, N'DE-Enrollment', N'11000', N'50')
INSERT [dbo].[RECONEDI_MTMStatus] ([ID], [Category], [Status], [SubStatus]) VALUES (37, N'DE-Enrollment', N'911000', N'10')
SET IDENTITY_INSERT [dbo].[RECONEDI_MTMStatus] OFF
