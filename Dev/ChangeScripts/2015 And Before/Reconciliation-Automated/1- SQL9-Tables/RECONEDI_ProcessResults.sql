/****** Object:  Table [dbo].[RECONEDI_ProcessResults]    Script Date: 6/26/2014 6:30:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RECONEDI_ProcessResults](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [int] NOT NULL,
	[LineID] [int] NOT NULL,
	[ParentReconReasonID] [int] NOT NULL,
	[ReconReasonID] [int] NOT NULL,
	[SummaryQueryID] [int] NOT NULL,
	[DetailQueryID] [int] NOT NULL,
	[InactiveInd] [bit] NOT NULL,
 CONSTRAINT [PK_RECONEDI_ProcessResults] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[RECONEDI_ProcessResults] ON 

INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (1, 1, 10, 0, 11, 1, 2, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (4, 1, 20, 0, 12, 3, 4, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (5, 1, 30, 0, 13, 5, 0, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (6, 1, 40, 0, 14, 6, 8, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (8, 1, 50, 0, 15, 10, 11, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (9, 1, 60, 0, 16, 12, 14, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (10, 1, 70, 0, 17, 15, 16, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (13, 2, 10, 16, 21, 12, 14, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (14, 2, 20, 16, 22, 12, 14, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (15, 2, 30, 16, 23, 12, 14, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (16, 2, 40, 16, 24, 12, 14, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (17, 2, 50, 16, 25, 12, 14, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (18, 2, 60, 16, 26, 12, 14, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (19, 2, 70, 16, 27, 12, 14, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (20, 2, 80, 16, 28, 12, 14, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (21, 2, 90, 16, 0, 12, 14, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (22, 3, 10, 17, 31, 15, 16, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (23, 3, 20, 17, 32, 15, 16, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (24, 3, 30, 17, 33, 15, 16, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (25, 3, 40, 17, 34, 15, 16, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (26, 3, 50, 17, 35, 15, 16, 0)
INSERT [dbo].[RECONEDI_ProcessResults] ([ID], [GroupID], [LineID], [ParentReconReasonID], [ReconReasonID], [SummaryQueryID], [DetailQueryID], [InactiveInd]) VALUES (30, 3, 90, 17, 0, 15, 16, 0)
SET IDENTITY_INSERT [dbo].[RECONEDI_ProcessResults] OFF
/****** Object:  Index [idx_RECONEDI_ProcessResults]    Script Date: 6/26/2014 6:30:54 PM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_ProcessResults] ON [dbo].[RECONEDI_ProcessResults]
(
	[GroupID] ASC,
	[LineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
