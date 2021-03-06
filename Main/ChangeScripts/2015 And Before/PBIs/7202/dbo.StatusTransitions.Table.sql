USE [Lp_enrollment]
GO
/****** Object:  Table [dbo].[StatusTransitions]    Script Date: 03/07/2013 07:41:04 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_StatusTransitions_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[StatusTransitions] DROP CONSTRAINT [DF_StatusTransitions_DateCreated]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusTransitions]') AND type in (N'U'))
DROP TABLE [dbo].[StatusTransitions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusTransitions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StatusTransitions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OldStatus] [varchar](15) NOT NULL,
	[OldSubStatus] [varchar](15) NOT NULL,
	[NewStatus] [varchar](15) NOT NULL,
	[NewSubStatus] [varchar](15) NOT NULL,
	[RequiresStartDate] [smallint] NOT NULL,
	[RequiresEndDate] [smallint] NOT NULL,
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_StatusTransitions_DateCreated]  DEFAULT (getdate()),
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
 CONSTRAINT [PK_StatusTransitions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[StatusTransitions] ON
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (1, N'01000', N'10', N'999999', N'10', 0, 0, CAST(0x0000A169009F045F AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (2, N'01000', N'10', N'999998', N'10', 0, 0, CAST(0x0000A169009F1CA4 AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (3, N'05000', N'10', N'05000', N'20', 0, 0, CAST(0x0000A169009FFFFC AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (4, N'05000', N'10', N'905000', N'10', 1, 0, CAST(0x0000A169009FFFFC AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (5, N'05000', N'10', N'999998', N'10', 0, 0, CAST(0x0000A169009FFFFC AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (6, N'05000', N'20', N'905000', N'10', 1, 0, CAST(0x0000A169009FFFFC AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (7, N'05000', N'20', N'999998', N'10', 0, 0, CAST(0x0000A169009FFFFC AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (8, N'05000', N'25', N'999998', N'10', 0, 0, CAST(0x0000A169009FFFFC AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (9, N'05000', N'20', N'05000', N'30', 1, 0, CAST(0x0000A16900A01C3C AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (10, N'05000', N'30', N'905000', N'10', 1, 0, CAST(0x0000A16900A06F58 AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (11, N'05000', N'30', N'999998', N'10', 0, 1, CAST(0x0000A16900A08A2F AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (12, N'11000', N'50', N'911000', N'10', 0, 0, CAST(0x0000A16900A0AF9B AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (13, N'11000', N'40', N'911000', N'10', 0, 1, CAST(0x0000A16900A0AF9B AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (14, N'11000', N'30', N'911000', N'10', 0, 1, CAST(0x0000A16900A0AF9B AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (15, N'11000', N'30', N'11000', N'50', 0, 1, CAST(0x0000A16900A0AF9B AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (16, N'11000', N'30', N'905000', N'10', 0, 0, CAST(0x0000A16900A0AF9B AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (17, N'13000', N'60', N'905000', N'10', 1, 0, CAST(0x0000A16900A0F8D8 AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (18, N'13000', N'60', N'911000', N'10', 0, 0, CAST(0x0000A16900A126D4 AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (19, N'13000', N'70', N'905000', N'10', 1, 0, CAST(0x0000A16900A1433F AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (20, N'13000', N'80', N'905000', N'10', 1, 0, CAST(0x0000A16900A17E52 AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (21, N'13000', N'70', N'911000', N'10', 0, 0, CAST(0x0000A16900A19403 AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (22, N'13000', N'80', N'911000', N'10', 0, 0, CAST(0x0000A16900A1A46C AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (23, N'905000', N'10', N'911000', N'10', 0, 1, CAST(0x0000A16900A0AF9B AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (24, N'905000', N'10', N'999998', N'10', 0, 0, CAST(0x0000A16900A0AF9B AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (25, N'905000', N'10', N'11000', N'50', 0, 1, CAST(0x0000A16900A0D667 AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (26, N'911000', N'10', N'905000', N'10', 1, 0, CAST(0x0000A16900A0C377 AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
INSERT [dbo].[StatusTransitions] ([ID], [OldStatus], [OldSubStatus], [NewStatus], [NewSubStatus], [RequiresStartDate], [RequiresEndDate], [DateCreated], [ActiveFrom], [ActiveTo]) VALUES (27, N'999998', N'10', N'905000', N'10', 1, 0, CAST(0x0000A16900DD120F AS DateTime), CAST(0x0000A17400000000 AS DateTime), CAST(0x0006216700000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[StatusTransitions] OFF
