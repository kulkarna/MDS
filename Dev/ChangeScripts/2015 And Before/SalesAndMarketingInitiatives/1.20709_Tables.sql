/*********************************************************************************************
20709: New Tables Added to LibertyPower Database
1. PromotionType
2. PromotionCode
3. Campaign
4. Qualifier
5. PromotionStatus
6. ContractQualifier
*************************************************************************************************/


USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PromotionType_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PromotionType] DROP CONSTRAINT [DF_PromotionType_CreatedDate]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[PromotionType]    Script Date: 09/25/2013 11:55:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PromotionType]') AND type in (N'U'))
DROP TABLE [dbo].[PromotionType]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[PromotionType]    Script Date: 09/25/2013 11:55:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PromotionType](
	[PromotionTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nchar](20) NOT NULL,
	[Description] [varchar](500) NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PromotionType] PRIMARY KEY CLUSTERED 
(
	[PromotionTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[PromotionType] ADD  CONSTRAINT [DF_PromotionType_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO





----------------------------------------
USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Promotion_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[PromotionCode]'))
ALTER TABLE [dbo].[PromotionCode] DROP CONSTRAINT [FK_Promotion_User]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PromotionCode_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PromotionCode] DROP CONSTRAINT [DF_PromotionCode_CreatedDate]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[PromotionCode]    Script Date: 09/25/2013 11:59:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PromotionCode]') AND type in (N'U'))
DROP TABLE [dbo].[PromotionCode]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[PromotionCode]    Script Date: 09/25/2013 11:59:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PromotionCode](
	[PromotionCodeId] [int] IDENTITY(1,1) NOT NULL,
	[PromotionTypeId] [int] NULL,
	[Code] [nchar](20) NOT NULL,
	[Description] [varchar](1000) NOT NULL,
	[MarketingDescription] [varchar](1000) NULL,
	[LegalDescription] [varchar](1000) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Promotion] PRIMARY KEY CLUSTERED 
(
	[PromotionCodeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[PromotionCode]  WITH CHECK ADD  CONSTRAINT [FK_Promotion_User] FOREIGN KEY([PromotionTypeId])
REFERENCES [dbo].[PromotionType] ([PromotionTypeId])
GO

ALTER TABLE [dbo].[PromotionCode] CHECK CONSTRAINT [FK_Promotion_User]
GO

ALTER TABLE [dbo].[PromotionCode] ADD  CONSTRAINT [DF_PromotionCode_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO




-------------------------------------------------------------------------
USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Campaign_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Campaign] DROP CONSTRAINT [DF_Campaign_CreatedDate]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[Campaign]    Script Date: 09/25/2013 12:01:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Campaign]') AND type in (N'U'))
DROP TABLE [dbo].[Campaign]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[Campaign]    Script Date: 09/25/2013 12:01:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Campaign](
	[CampaignId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nchar](20) NOT NULL,
	[Description] [varchar](250) NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Campaign] PRIMARY KEY CLUSTERED 
(
	[CampaignId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Campaign] ADD  CONSTRAINT [DF_Campaign_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO




---------------------------------------------------------
USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Qualifier_AccountType]') AND parent_object_id = OBJECT_ID(N'[dbo].[Qualifier]'))
ALTER TABLE [dbo].[Qualifier] DROP CONSTRAINT [FK_Qualifier_AccountType]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Qualifier_Campaign]') AND parent_object_id = OBJECT_ID(N'[dbo].[Qualifier]'))
ALTER TABLE [dbo].[Qualifier] DROP CONSTRAINT [FK_Qualifier_Campaign]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Qualifier_DailyPricingPriceTier]') AND parent_object_id = OBJECT_ID(N'[dbo].[Qualifier]'))
ALTER TABLE [dbo].[Qualifier] DROP CONSTRAINT [FK_Qualifier_DailyPricingPriceTier]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Qualifier_Market]') AND parent_object_id = OBJECT_ID(N'[dbo].[Qualifier]'))
ALTER TABLE [dbo].[Qualifier] DROP CONSTRAINT [FK_Qualifier_Market]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Qualifier_ProductType]') AND parent_object_id = OBJECT_ID(N'[dbo].[Qualifier]'))
ALTER TABLE [dbo].[Qualifier] DROP CONSTRAINT [FK_Qualifier_ProductType]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Qualifier_PromotionCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[Qualifier]'))
ALTER TABLE [dbo].[Qualifier] DROP CONSTRAINT [FK_Qualifier_PromotionCode]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Qualifier_SalesChannel]') AND parent_object_id = OBJECT_ID(N'[dbo].[Qualifier]'))
ALTER TABLE [dbo].[Qualifier] DROP CONSTRAINT [FK_Qualifier_SalesChannel]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Qualifier_Utility]') AND parent_object_id = OBJECT_ID(N'[dbo].[Qualifier]'))
ALTER TABLE [dbo].[Qualifier] DROP CONSTRAINT [FK_Qualifier_Utility]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Qualifier_AutoApply]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Qualifier] DROP CONSTRAINT [DF_Qualifier_AutoApply]
END

GO

USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Qualifier_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Qualifier] DROP CONSTRAINT [DF_Qualifier_CreatedDate]
END

GO

/****** Object:  Table [dbo].[Qualifier]    Script Date: 09/20/2013 15:19:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Qualifier]') AND type in (N'U'))
DROP TABLE [dbo].[Qualifier]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[Qualifier]    Script Date: 09/20/2013 15:19:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Qualifier](
	[QualifierId] [int] IDENTITY(1,1) NOT NULL,
	[CampaignId] [int]NOT NULL,
	[PromotionCodeId] [int]NOT NULL,
	[SalesChannelId] [int] NULL,
	[MarketId] [int] NULL,
	[UtilityId] [int] NULL,
	[AccountTypeId] [int] NULL,
	[Term] [int] NULL,
	[ProductTypeId] [int] NULL,
	[SignStartDate] [datetime]NOT NULL,
	[SignEndDate] [datetime] NOT NULL,
	[ContractEffecStartPeriodStartDate] [datetime] NULL,
	[ContractEffecStartPeriodLastDate] [datetime] NULL,
	[PriceTierId] [int] NULL,
	[AutoApply] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Qualifier1] PRIMARY KEY CLUSTERED 
(
	[QualifierId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_Qualifier_AccountType] FOREIGN KEY([AccountTypeId])
REFERENCES [dbo].[AccountType] ([ID])
GO

ALTER TABLE [dbo].[Qualifier] CHECK CONSTRAINT [FK_Qualifier_AccountType]
GO

ALTER TABLE [dbo].[Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_Qualifier_Campaign] FOREIGN KEY([CampaignId])
REFERENCES [dbo].[Campaign] ([CampaignId])
GO

ALTER TABLE [dbo].[Qualifier] CHECK CONSTRAINT [FK_Qualifier_Campaign]
GO

ALTER TABLE [dbo].[Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_Qualifier_DailyPricingPriceTier] FOREIGN KEY([PriceTierId])
REFERENCES [dbo].[DailyPricingPriceTier] ([ID])
GO

ALTER TABLE [dbo].[Qualifier] CHECK CONSTRAINT [FK_Qualifier_DailyPricingPriceTier]
GO

ALTER TABLE [dbo].[Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_Qualifier_Market] FOREIGN KEY([MarketId])
REFERENCES [dbo].[Market] ([ID])
GO

ALTER TABLE [dbo].[Qualifier] CHECK CONSTRAINT [FK_Qualifier_Market]
GO

ALTER TABLE [dbo].[Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_Qualifier_ProductType] FOREIGN KEY([ProductTypeId])
REFERENCES [dbo].[ProductType] ([ProductTypeID])
GO

ALTER TABLE [dbo].[Qualifier] CHECK CONSTRAINT [FK_Qualifier_ProductType]
GO

ALTER TABLE [dbo].[Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_Qualifier_PromotionCode] FOREIGN KEY([PromotionCodeId])
REFERENCES [dbo].[PromotionCode] ([PromotionCodeId])
GO

ALTER TABLE [dbo].[Qualifier] CHECK CONSTRAINT [FK_Qualifier_PromotionCode]
GO

ALTER TABLE [dbo].[Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_Qualifier_SalesChannel] FOREIGN KEY([SalesChannelId])
REFERENCES [dbo].[SalesChannel] ([ChannelID])
GO

ALTER TABLE [dbo].[Qualifier] CHECK CONSTRAINT [FK_Qualifier_SalesChannel]
GO

ALTER TABLE [dbo].[Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_Qualifier_Utility] FOREIGN KEY([UtilityId])
REFERENCES [dbo].[Utility] ([ID])
GO

ALTER TABLE [dbo].[Qualifier] CHECK CONSTRAINT [FK_Qualifier_Utility]
GO

ALTER TABLE [dbo].[Qualifier] ADD  CONSTRAINT [DF_Qualifier_AutoApply]  DEFAULT ((0)) FOR [AutoApply]
GO

ALTER TABLE [dbo].[Qualifier] ADD  CONSTRAINT [DF_Qualifier_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

-------------------------------------------------------------
USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PromotionStatus_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PromotionStatus] DROP CONSTRAINT [DF_PromotionStatus_CreatedDate]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[PromotionStatus]    Script Date: 09/25/2013 12:07:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PromotionStatus]') AND type in (N'U'))
DROP TABLE [dbo].[PromotionStatus]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[PromotionStatus]    Script Date: 09/25/2013 12:07:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PromotionStatus](
	[PromotionStatusId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nchar](10) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PromotionStatus] PRIMARY KEY CLUSTERED 
(
	[PromotionStatusId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[PromotionStatus] ADD  CONSTRAINT [DF_PromotionStatus_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO




------------------------------------------------------------
USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContractQualifier_Account]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContractQualifier]'))
ALTER TABLE [dbo].[ContractQualifier] DROP CONSTRAINT [FK_ContractQualifier_Account]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContractQualifier_Contract]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContractQualifier]'))
ALTER TABLE [dbo].[ContractQualifier] DROP CONSTRAINT [FK_ContractQualifier_Contract]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContractQualifier_PromotionStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContractQualifier]'))
ALTER TABLE [dbo].[ContractQualifier] DROP CONSTRAINT [FK_ContractQualifier_PromotionStatus]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContractQualifier_Qualifier]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContractQualifier]'))
ALTER TABLE [dbo].[ContractQualifier] DROP CONSTRAINT [FK_ContractQualifier_Qualifier]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContractQualifier_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContractQualifier]'))
ALTER TABLE [dbo].[ContractQualifier] DROP CONSTRAINT [FK_ContractQualifier_User]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContractQualifier_User1]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContractQualifier]'))
ALTER TABLE [dbo].[ContractQualifier] DROP CONSTRAINT [FK_ContractQualifier_User1]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ContractQualifier]    Script Date: 09/20/2013 15:25:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContractQualifier]') AND type in (N'U'))
DROP TABLE [dbo].[ContractQualifier]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ContractQualifier]    Script Date: 09/20/2013 15:25:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ContractQualifier](
	[ContractQualifierId] [int] IDENTITY(1,1) NOT NULL,
	[ContractId] [int]NOT NULL,
	[AccountId] [int] NULL,
	[QualifierId] [int] NOT NULL,
	[PromotionStatusId] [int]  NULL,
	[Comment] [varchar](2000) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_ContractQualifier] PRIMARY KEY CLUSTERED 
(
	[ContractQualifierId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ContractQualifier]  WITH CHECK ADD  CONSTRAINT [FK_ContractQualifier_Account] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Account] ([AccountID])
GO

ALTER TABLE [dbo].[ContractQualifier] CHECK CONSTRAINT [FK_ContractQualifier_Account]
GO

ALTER TABLE [dbo].[ContractQualifier]  WITH CHECK ADD  CONSTRAINT [FK_ContractQualifier_Contract] FOREIGN KEY([ContractId])
REFERENCES [dbo].[Contract] ([ContractID])
GO

ALTER TABLE [dbo].[ContractQualifier] CHECK CONSTRAINT [FK_ContractQualifier_Contract]
GO

ALTER TABLE [dbo].[ContractQualifier]  WITH CHECK ADD  CONSTRAINT [FK_ContractQualifier_PromotionStatus] FOREIGN KEY([PromotionStatusId])
REFERENCES [dbo].[PromotionStatus] ([PromotionStatusId])
GO

ALTER TABLE [dbo].[ContractQualifier] CHECK CONSTRAINT [FK_ContractQualifier_PromotionStatus]
GO

ALTER TABLE [dbo].[ContractQualifier]  WITH CHECK ADD  CONSTRAINT [FK_ContractQualifier_Qualifier] FOREIGN KEY([QualifierId])
REFERENCES [dbo].[Qualifier] ([QualifierId])
GO

ALTER TABLE [dbo].[ContractQualifier] CHECK CONSTRAINT [FK_ContractQualifier_Qualifier]
GO

ALTER TABLE [dbo].[ContractQualifier]  WITH CHECK ADD  CONSTRAINT [FK_ContractQualifier_User] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[ContractQualifier] CHECK CONSTRAINT [FK_ContractQualifier_User]
GO

ALTER TABLE [dbo].[ContractQualifier]  WITH CHECK ADD  CONSTRAINT [FK_ContractQualifier_User1] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[ContractQualifier] CHECK CONSTRAINT [FK_ContractQualifier_User1]
GO


--------------------------------------------------
