USE [Lp_deal_capture]
GO

---------------------------------------------------------------------------------------------------
-- Added		: Fernando ML Alves
-- PBI                  : 47368
-- Date			: 09/18/2014
-- Description	        : TabletIncompleteContract and InCompleteContractCancelReason have now 
-- 			  Identity (auto increment) primary keys.
---------------------------------------------------------------------------------------------------

/****** Object:  Table [dbo].[CancelContractReason]    Script Date: 08/28/2014 14:33:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CancelContractReason]') AND type in (N'U'))
DROP TABLE [dbo].[CancelContractReason]
GO

USE [Lp_deal_capture]
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




-----------------------------------------------------------------------------------------

USE [Lp_deal_capture]
GO
/****** Object:  Table [dbo].[CancelContractReason]    Script Date: 08/27/2014 16:09:05 ******/
SET IDENTITY_INSERT [dbo].[CancelContractReason] ON
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (1, N'NH        ', N'No answer at door', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (2, N'DM        ', N'Decision maker not home/ Not authorized', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (3, N'NB        ', N'No Bill', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (4, N'DUP       ', N'Customer already with Lp_deal_capture', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (5, N'NE        ', N'Not Eligible', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (6, N'NI        ', N'Not Interested', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (7, N'HS        ', N'Has Supplier', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (8, N'DNK       ', N'Do Not Knock', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (9, N'APT       ', N'Create appointment', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
INSERT [dbo].[CancelContractReason] ([CancelContractReasonId], [Code], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (10, N'OTHER     ', N'Other', 1982, CAST(0x0000A39200000000 AS DateTime), 1982, CAST(0x0000A39200000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[CancelContractReason] OFF

------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

/****** Object:  Table [dbo].[TabletIncompleteContract]    Script Date: 08/28/2014 14:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TabletIncompleteContract]') AND type in (N'U'))
DROP TABLE [dbo].[TabletIncompleteContract]
GO

USE [Lp_deal_capture]
GO

/****** Object:  Table [dbo].[TabletIncompleteContract]    Script Date: 08/28/2014 14:32:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TabletIncompleteContract](
	[TabletIncompleteContractID] [int] IDENTITY(1,1) NOT NULL,
	[ContractNumber] [nvarchar](20) NOT NULL,
	[SalesChannelID] [int] NOT NULL,
	[AgentId] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[AdditionalNotes] [nvarchar](500) NULL,
	[AccountNumber] [nchar](25) NULL,
	[RetailMarketId] [int] NULL,
	[UtilityId] [int] NULL,
	[Zone] [nvarchar](10) NULL,
	[AccountTypeId] [int] NULL,
	[ProductBrandId] [int] NULL,
	[ContractStartDate] [datetime] NULL,
	[Term] [int] NULL,
	[ServiceClassId] [nvarchar](10) NULL,
	[TierId] [int] NULL,
	[PriceId] [bigint] NULL,
	[BACity] [nvarchar](50) NULL,
	[BAState] [nvarchar](50) NULL,
	[BAStreet] [nvarchar](50) NULL,
	[BAZip] [nchar](10) NULL,
	[BCEmail] [nvarchar](50) NULL,
	[BCFax] [nchar](10) NULL,
	[BCFirstName] [nvarchar](50) NULL,
	[BCLastName] [nvarchar](50) NULL,
	[BCPhone] [nchar](10) NULL,
	[BCTitle] [nchar](10) NULL,
	[SACity] [nvarchar](50) NULL,
	[SAState] [nvarchar](50) NULL,
	[SAStreet] [nvarchar](50) NULL,
	[SAZip] [nchar](10) NULL,
	[CISSN] [nchar](10) NULL,
	[CIEmail] [nvarchar](50) NULL,
	[CIFax] [nchar](10) NULL,
	[CIFirstName] [nvarchar](50) NULL,
	[CILastName] [nvarchar](50) NULL,
	[CIPhone] [nchar](10) NULL,
	[CITitle] [nchar](10) NULL,
	[CACity] [nvarchar](50) NULL,
	[CAState] [nvarchar](50) NULL,
	[CAStreet] [nvarchar](50) NULL,
	[CASuite] [nvarchar](50) NULL,
	[CAZip] [nchar](10) NULL,
	[BusinessName] [nvarchar](50) NULL,
	[DBA] [nvarchar](50) NULL,
	[BusinessType] [nchar](10) NULL,
	[DUNS] [nchar](10) NULL,
	[ContractTypeId] [int] NULL,
	[TaxId] [nchar](10) NULL,
	[Language] [nchar](10) NULL,
	[PromoCode] [nvarchar](50) NULL,
	[Origin] [nvarchar](50) NULL,
	[ClientSubmitApplicationKey] [uniqueidentifier] NULL,
	[Review] [nvarchar](2000) NULL,
	[OutCome] [bit] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_TabletIncompleteContract] PRIMARY KEY CLUSTERED 
(
	[TabletIncompleteContractID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO




-----------------------------------------------------------------------
USE [Lp_deal_capture]
GO

/****** Object:  Table [dbo].[InCompleteContractCancelReason]    Script Date: 08/28/2014 14:33:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InCompleteContractCancelReason]') AND type in (N'U'))
DROP TABLE [dbo].[InCompleteContractCancelReason]
GO

USE [Lp_deal_capture]
GO

/****** Object:  Table [dbo].[InCompleteContractCancelReason]    Script Date: 08/28/2014 14:33:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[InCompleteContractCancelReason](
	[InCompleteContractCancelReasonID] [int] IDENTITY(1,1) NOT NULL,
	[TabletIncompleteContractId] [int] NOT NULL,
	[CancelContractReasonId] [int] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_InCompleteContractCancelReason] PRIMARY KEY CLUSTERED 
(
	[InCompleteContractCancelReasonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO


