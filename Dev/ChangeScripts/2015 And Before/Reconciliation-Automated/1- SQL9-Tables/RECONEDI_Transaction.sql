/****** Object:  Table [dbo].[RECONEDI_Transaction]    Script Date: 6/21/2014 8:23:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_Transaction](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[Action] [char](1) NOT NULL,
	[ProcessType] [varchar](100) NOT NULL,
	[TransactionType] [varchar](100) NOT NULL,
	[TransactionStatus] [varchar](100) NOT NULL,
	[StatusCode] [varchar](100) NOT NULL,
	[ChangeReason] [varchar](100) NOT NULL,
	[ChangeDescription] [varchar](100) NOT NULL,
 CONSTRAINT [PK_RECONEDI_Transaction] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[RECONEDI_Transaction] ON 

INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (1, N'*', N'D', N'ENROLLMENT', N'E', N'A', N'B30', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (2, N'*', N'I', N'CANCEL', N'8', N'7', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (3, N'*', N'I', N'CANCEL', N'8', N'A', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (4, N'*', N'I', N'CHANGE', N'C', N'*', N'*', N'TD', N'DTM150')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (5, N'*', N'I', N'CHANGE', N'C', N'*', N'*', N'TD', N'DTM151')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (6, N'*', N'I', N'CHANGE', N'C', N'7', N'*', N'DTM150', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (7, N'*', N'I', N'CHANGE', N'C', N'7', N'*', N'DTM151', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (8, N'*', N'I', N'DROP', N'25', N'A', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (9, N'*', N'I', N'DROP', N'25', N'null', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (10, N'*', N'I', N'DROP', N'6', N'A', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (11, N'*', N'I', N'DROP', N'6', N'null', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (12, N'*', N'I', N'DROP', N'D', N'7', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (13, N'*', N'I', N'DROP', N'D', N'A', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (14, N'*', N'I', N'DROP', N'D', N'F', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (15, N'*', N'I', N'DROP', N'D', N'null', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (16, N'*', N'I', N'DROP', N'D', N'WQ', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (17, N'*', N'I', N'ENROLLMENT', N'5', N'A', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (18, N'*', N'I', N'ENROLLMENT', N'E', N'7', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (19, N'*', N'I', N'ENROLLMENT', N'E', N'A', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (20, N'*', N'I', N'ENROLLMENT', N'E', N'F', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (21, N'*', N'I', N'ENROLLMENT', N'E', N'WQ', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (22, N'*', N'I', N'ENROLLMENT', N'R', N'7', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (23, N'*', N'I', N'ENROLLMENT', N'R', N'A', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (24, N'*', N'I', N'ENROLLMENT', N'R', N'null', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (25, N'*', N'I', N'REJECT', N'2', N'R', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (26, N'*', N'I', N'REJECT', N'5', N'R', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (27, N'*', N'I', N'REJECT', N'E', N'R', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (28, N'*', N'I', N'REJECT', N'E', N'U', N'*', N'*', N'*')
INSERT [dbo].[RECONEDI_Transaction] ([ID], [ISO], [Action], [ProcessType], [TransactionType], [TransactionStatus], [StatusCode], [ChangeReason], [ChangeDescription]) VALUES (29, N'ERCOT', N'I', N'REJECT DROP', N'25', N'R', N'*', N'*', N'*')
SET IDENTITY_INSERT [dbo].[RECONEDI_Transaction] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_Transaction]    Script Date: 6/21/2014 8:23:13 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [idx_RECONEDI_Transaction] ON [dbo].[RECONEDI_Transaction]
(
	[ISO] ASC,
	[Action] ASC,
	[ProcessType] ASC,
	[TransactionType] ASC,
	[TransactionStatus] ASC,
	[StatusCode] ASC,
	[ChangeReason] ASC,
	[ChangeDescription] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
