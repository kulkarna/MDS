/****** Object:  Table [dbo].[RECONEDI_Status]    Script Date: 6/26/2014 5:21:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_Status](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StatusID] [int] NOT NULL,
	[SubStatusID] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_RECONEDI_Status] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[RECONEDI_Status] ON 

INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (1, 6, 0, N'Cancelling')
INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (2, 3, 2, N'Collect EDI Information ')
INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (3, 3, 4, N'Collect Forecast Information ')
INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (4, 3, 5, N'Collect Mark to Market Information ')
INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (5, 5, 0, N'Complete')
INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (6, 3, 1, N'Create Enrollment Account List ')
INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (7, 99, 0, N'Error')
INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (8, 4, 0, N'Execution Canceled')
INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (9, 3, 7, N'ISO Control Update')
INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (10, 1, 0, N'New')
INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (11, 2, 0, N'Pending')
INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (12, 3, 3, N'Process EDI Information ')
INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (13, 3, 6, N'Reconciling')
INSERT [dbo].[RECONEDI_Status] ([ID], [StatusID], [SubStatusID], [Description]) VALUES (14, 3, 0, N'Running')
SET IDENTITY_INSERT [dbo].[RECONEDI_Status] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_Status]    Script Date: 6/26/2014 5:21:09 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [idx_RECONEDI_Status] ON [dbo].[RECONEDI_Status]
(
	[Description] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [idx1_RECONEDI_Status]    Script Date: 6/26/2014 5:21:09 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [idx1_RECONEDI_Status] ON [dbo].[RECONEDI_Status]
(
	[StatusID] ASC,
	[SubStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
