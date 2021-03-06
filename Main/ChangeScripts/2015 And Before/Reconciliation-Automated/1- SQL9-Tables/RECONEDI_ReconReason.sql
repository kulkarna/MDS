/****** Object:  Table [dbo].[RECONEDI_ReconReason]    Script Date: 6/26/2014 5:21:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_ReconReason](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ReconReasonID] [int] NOT NULL,
	[ReconReason] [varchar](100) NOT NULL,
	[ReconReasonDescp] [varchar](400) NOT NULL,
	[InactiveInd] [bit] NULL,
 CONSTRAINT [PK_RECONEDI_ReconStatus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[RECONEDI_ReconReason] ON 

INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (1, 0, N'Unknown', N'Unknown', 1)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (2, 11, N'EDI Enrollment Info', N'EDI Enrollment Info', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (3, 12, N'Mark to Market Info', N'Mark to Market Info', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (4, 13, N'Variance', N'Variance', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (5, 14, N'Common Info EDI', N'Common Info EDI', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (6, 15, N'Common Info MTM', N'Common Info MTM', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (7, 16, N'Missing Info in EDI', N'Missing Info in EDI', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (8, 17, N'Missing Info in MTM', N'Missing Info in MTM', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (9, 21, N'Submitted after process date', N'Submitted after process date', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (10, 22, N'Contracts that have status of Rejected', N'Contracts that have status of Rejected', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (11, 23, N'Contracts with Overlaps', N'Contracts with Overlaps', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (12, 24, N'Reenrolled after contract end', N'Reenrolled after contract end', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (13, 25, N'Deenrolled after invoice same as drop date', N'Deenrolled after invoice same as drop date', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (14, 26, N'Last Invoice within 5 days of drop', N'Last Invoice within 5 days of drop', 1)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (15, 27, N'Wrong Status', N'Wrong Status', 1)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (16, 28, N'Dropped No New EDI', N'Dropped No New EDI', 1)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (17, 31, N'Account-Contracts missing in excluded list (Back to Back)', N'Account-Contracts missing in excluded list (Back to Back)', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (18, 32, N'ETPd - Failed(Zainet)', N'ETPd - Failed(Zainet)', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (19, 33, N'Failed (ETP)', N'Failed (ETP)', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (20, 34, N'Failed (Forecasting)', N'Failed (Forecasting)', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (21, 35, N'Timing contract end after process date but before MtM data', N'Timing contract end after process date but before MtM data', 0)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (22, 92, N'Accounts without contracts', N'Accounts without contracts', 1)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (23, 93, N'Excluded Account list', N'Excluded Account list', 1)
INSERT [dbo].[RECONEDI_ReconReason] ([ID], [ReconReasonID], [ReconReason], [ReconReasonDescp], [InactiveInd]) VALUES (24, 94, N'Not Current Contract', N'Not Current Contract', 1)
SET IDENTITY_INSERT [dbo].[RECONEDI_ReconReason] OFF
/****** Object:  Index [idx_RECONEDI_ReconReason]    Script Date: 6/26/2014 5:21:09 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [idx_RECONEDI_ReconReason] ON [dbo].[RECONEDI_ReconReason]
(
	[ReconReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
