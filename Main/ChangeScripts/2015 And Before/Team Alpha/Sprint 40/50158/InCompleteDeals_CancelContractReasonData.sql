---------------------------------------------------------------------------------------------------
-- Added			: Fernando ML Alves
-- PBI            	: 50158
-- Date				: 09/25/2014
-- Description	: Tables and initial data to save incomplete contracts metadata and reasons for cancellation.
-- Modification  : Inserts in CancelContractReason for initial data are now matching BA requirements.
---------------------------------------------------------------------------------------------------

USE [Lp_deal_capture]
GO

/****** Object:  Table [dbo].[CancelContractReason]    Script Date: 08/28/2014 14:33:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CancelContractReason]') AND type in (N'U'))
DROP TABLE [dbo].[CancelContractReason]
GO

/****** Object:  Table [dbo].[CancelContractReason]    Script Date: 08/28/2014 14:33:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CancelContractReason](
	[CancelContractReasonId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nchar](10) NULL,
	[Description] [nvarchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_CancelContractReason] PRIMARY KEY CLUSTERED 
(
	[CancelContractReasonId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [Lp_deal_capture]
GO
/****** Object:  Table [dbo].[CancelContractReason]    Script Date: 08/27/2014 16:09:05 ******/
SET IDENTITY_INSERT [dbo].[CancelContractReason] ON
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (1, N'NH        ', N'No answer at door', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (2, N'DM        ', N'Decision maker not home/ Not authorized', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (3, N'NB        ', N'No Bill', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (4, N'DUP       ', N'Customer already with Liberty Power', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (5, N'GP       ', N'Customer on Government/Utility program', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (6, N'NE        ', N'Not Eligible', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (7, N'NI        ', N'Not Interested', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (8, N'HS        ', N'Has Supplier', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (9, N'DNK       ', N'Do Not Knock', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (10, N'APT       ', N'Create appointment', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (11, N'OTHER     ', N'Other', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[CancelContractReason] OFF
