/* ------------------------------------------------------------

DESCRIPTION: Schema Synchronization Script for Object(s) \r\n
    tables:
        [dbo].[MtMComponent], [dbo].[MtMCustomDealAccount], [dbo].[MtMCustomDealEntry], [dbo].[MtMCustomDealHeader], [dbo].[MtMFunction], [dbo].[MtMFunctionFilter], [dbo].[MtMFunctionFilterValue], [dbo].[MtMInputField], [dbo].[MtMInputFieldType], [dbo].[MtMInputHeader], [dbo].[MtMRECPercentage], [dbo].[MtMRECPrice]

     Make LPCNOCSQL9\TRANSACTIONS.lp_MtM Equal vm2lpcnocsql9\TRANSACTIONS.lp_MtM_UAT

   AUTHOR:	[Insert Author Name]

   DATE:	3/13/2013 1:06:01 PM

   LEGAL:	2012[Insert Company Name]

   ------------------------------------------------------------ */

SET NOEXEC OFF
SET ANSI_WARNINGS ON
SET XACT_ABORT ON
SET IMPLICIT_TRANSACTIONS OFF
SET ARITHABORT ON
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
GO
USE [lp_MtM]
GO

BEGIN TRAN
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[MtMRECPrice]
Print 'Create Table [dbo].[MtMRECPrice]'
GO
CREATE TABLE [dbo].[MtMRECPrice] (
		[ID]                 [int] IDENTITY(1, 1) NOT NULL,
		[Market]             [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[REC_Class]          [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Effective_Date]     [datetime] NULL,
		[Value]              [decimal](18, 2) NULL,
		[Date]               [datetime] NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_MtMREC to [dbo].[MtMRECPrice]
Print 'Add Primary Key PK_MtMREC to [dbo].[MtMRECPrice]'
GO
ALTER TABLE [dbo].[MtMRECPrice]
	ADD
	CONSTRAINT [PK_MtMREC]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[MtMRECPrice] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[MtMRECPercentage]
Print 'Create Table [dbo].[MtMRECPercentage]'
GO
CREATE TABLE [dbo].[MtMRECPercentage] (
		[ID]                 [int] IDENTITY(1, 1) NOT NULL,
		[Market]             [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[REC_Class]          [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Effective_Date]     [datetime] NULL,
		[Value]              [decimal](18, 2) NULL,
		[Date]               [datetime] NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_MtMRECPercentage to [dbo].[MtMRECPercentage]
Print 'Add Primary Key PK_MtMRECPercentage to [dbo].[MtMRECPercentage]'
GO
ALTER TABLE [dbo].[MtMRECPercentage]
	ADD
	CONSTRAINT [PK_MtMRECPercentage]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[MtMRECPercentage] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[MtMComponent]
Print 'Create Table [dbo].[MtMComponent]'
GO
CREATE TABLE [dbo].[MtMComponent] (
		[ID]                [int] IDENTITY(1, 1) NOT NULL,
		[FrequencyID]       [int] NOT NULL,
		[ComponentName]     [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_MtMComponent to [dbo].[MtMComponent]
Print 'Add Primary Key PK_MtMComponent to [dbo].[MtMComponent]'
GO
ALTER TABLE [dbo].[MtMComponent]
	ADD
	CONSTRAINT [PK_MtMComponent]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[MtMComponent] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[MtMCustomDealHeader]
Print 'Create Table [dbo].[MtMCustomDealHeader]'
GO
CREATE TABLE [dbo].[MtMCustomDealHeader] (
		[ID]                         [int] IDENTITY(1, 1) NOT NULL,
		[PricingRequest]             [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CustomerName]               [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[SalesChannel]               [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ProductCode]                [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ContractStartDate]          [datetime] NULL,
		[Term]                       [int] NULL,
		[HasPassThrough]             [bit] NULL,
		[BackToBack]                 [bit] NULL,
		[ExpectedTermUsage]          [int] NULL,
		[CommissionCap]              [int] NULL,
		[PriceAggregation]           [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[IndexType]                  [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[AggregationDeal]            [bit] NULL,
		[Zkey]                       [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[FileName]                   [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PassEnergy]                 [bit] NULL,
		[PassShaping]                [bit] NULL,
		[PassIntraday]               [bit] NULL,
		[PassAncillaryServices]      [bit] NULL,
		[PassARR]                    [bit] NULL,
		[PassCapacity]               [bit] NULL,
		[PassLosses]                 [bit] NULL,
		[PassVoluntaryGreen]         [bit] NULL,
		[PassMLC]                    [bit] NULL,
		[PassTransmission]           [bit] NULL,
		[PassRUC]                    [bit] NULL,
		[PassRMR]                    [bit] NULL,
		[PassRPS]                    [bit] NULL,
		[PassFinancingFee]           [bit] NULL,
		[PassPORBadDebtFee]          [bit] NULL,
		[PassInvoicingCost]          [bit] NULL,
		[PassBandwidth]              [bit] NULL,
		[PassPUCAssessmentFee]       [bit] NULL,
		[PassPaymentTermPremium]     [bit] NULL,
		[PassPostingCollateral]      [bit] NULL,
		[PassCustomBilling]          [bit] NULL,
		[PassMiscFee]                [bit] NULL,
		[DateCreated]                [datetime] NULL,
		[CreatedBy]                  [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_MtMCustomDealHeader to [dbo].[MtMCustomDealHeader]
Print 'Add Primary Key PK_MtMCustomDealHeader to [dbo].[MtMCustomDealHeader]'
GO
ALTER TABLE [dbo].[MtMCustomDealHeader]
	ADD
	CONSTRAINT [PK_MtMCustomDealHeader]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[MtMCustomDealHeader] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[MtMCustomDealEntry]
Print 'Create Table [dbo].[MtMCustomDealEntry]'
GO
CREATE TABLE [dbo].[MtMCustomDealEntry] (
		[ID]                    [int] IDENTITY(1, 1) NOT NULL,
		[PricingRequest]        [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ExpirationDate]        [datetime] NULL,
		[CustomerName]          [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[SalesChannel]          [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ContractStartDate]     [datetime] NULL,
		[Term]                  [int] NULL,
		[AmountOfAccounts]      [int] NULL,
		[ExpectedTermUsage]     [int] NULL,
		[HasPassThrough]        [bit] NULL,
		[BackToBack]            [bit] NULL,
		[Market]                [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[MarketTax]             [decimal](9, 6) NULL,
		[TransferRate]          [decimal](9, 6) NULL,
		[GrossMargin]           [decimal](9, 6) NULL,
		[RateDescp]             [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Utility]               [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[AccountType]           [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Product]               [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[IndexType]             [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[BillingType]           [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CommissionCap]         [decimal](9, 6) NULL,
		[Commission]            [decimal](9, 6) NULL,
		[ContractRate]          [decimal](9, 6) NULL,
		[Cost]                  [decimal](9, 6) NULL,
		[ETP]                   [decimal](9, 6) NULL,
		[MtM]                   [int] NULL,
		[PriceId]               [int] NULL,
		[DateCreated]           [datetime] NULL,
		[CreatedBy]             [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_MtMCustomDealEntry to [dbo].[MtMCustomDealEntry]
Print 'Add Primary Key PK_MtMCustomDealEntry to [dbo].[MtMCustomDealEntry]'
GO
ALTER TABLE [dbo].[MtMCustomDealEntry]
	ADD
	CONSTRAINT [PK_MtMCustomDealEntry]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[MtMCustomDealEntry] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[MtMInputHeader]
Print 'Create Table [dbo].[MtMInputHeader]'
GO
CREATE TABLE [dbo].[MtMInputHeader] (
		[ID]                  [int] IDENTITY(1, 1) NOT NULL,
		[DataFrequencyID]     [int] NOT NULL,
		[InputName]           [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[StorageName]         [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[DateModified]        [datetime] NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_MtMComponentHeader to [dbo].[MtMInputHeader]
Print 'Add Primary Key PK_MtMComponentHeader to [dbo].[MtMInputHeader]'
GO
ALTER TABLE [dbo].[MtMInputHeader]
	ADD
	CONSTRAINT [PK_MtMComponentHeader]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[MtMInputHeader] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[MtMInputFieldType]
Print 'Create Table [dbo].[MtMInputFieldType]'
GO
CREATE TABLE [dbo].[MtMInputFieldType] (
		[ID]              [int] IDENTITY(1, 1) NOT NULL,
		[Description]     [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_MtMComponentFieldTypes to [dbo].[MtMInputFieldType]
Print 'Add Primary Key PK_MtMComponentFieldTypes to [dbo].[MtMInputFieldType]'
GO
ALTER TABLE [dbo].[MtMInputFieldType]
	ADD
	CONSTRAINT [PK_MtMComponentFieldTypes]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[MtMInputFieldType] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[MtMFunction]
Print 'Create Table [dbo].[MtMFunction]'
GO
CREATE TABLE [dbo].[MtMFunction] (
		[ID]              [int] IDENTITY(1, 1) NOT NULL,
		[ComponentID]     [int] NOT NULL,
		[Expression]      [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CreatedBy]       [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CreatedDate]     [datetime] NULL,
		[OrderNumber]     [int] NULL,
		[Type]            [int] NULL,
		[IsResult]        [bit] NULL,
		[Name]            [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[UniqueID]        [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_MtMFormula to [dbo].[MtMFunction]
Print 'Add Primary Key PK_MtMFormula to [dbo].[MtMFunction]'
GO
ALTER TABLE [dbo].[MtMFunction]
	ADD
	CONSTRAINT [PK_MtMFormula]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[MtMFunction] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[MtMInputField]
Print 'Create Table [dbo].[MtMInputField]'
GO
CREATE TABLE [dbo].[MtMInputField] (
		[ID]              [int] IDENTITY(1, 1) NOT NULL,
		[InputID]         [int] NOT NULL,
		[FieldTypeID]     [int] NOT NULL,
		[ColumnName]      [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_MTMComponentKey to [dbo].[MtMInputField]
Print 'Add Primary Key PK_MTMComponentKey to [dbo].[MtMInputField]'
GO
ALTER TABLE [dbo].[MtMInputField]
	ADD
	CONSTRAINT [PK_MTMComponentKey]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[MtMInputField] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[MtMCustomDealAccount]
Print 'Create Table [dbo].[MtMCustomDealAccount]'
GO
CREATE TABLE [dbo].[MtMCustomDealAccount] (
		[ID]                           [int] IDENTITY(1, 1) NOT NULL,
		[CustomDealID]                 [int] NOT NULL,
		[AccountNumber]                [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Utility]                      [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[DeliveryPointFixedPrice]      [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Zone]                         [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[MeterType]                    [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ProfileID]                    [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[LossFactorID]                 [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[AccountType]                  [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[BillingType]                  [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PureShapingPremiumFactor]     [decimal](9, 6) NULL,
		[VolShapingPremiumFactor]      [decimal](9, 6) NULL,
		[ContractRate]                 [decimal](9, 6) NULL,
		[Margin]                       [decimal](9, 6) NULL,
		[Commission]                   [decimal](9, 6) NULL,
		[TotalCost]                    [decimal](9, 6) NULL,
		[Energy]                       [decimal](9, 6) NULL,
		[Shaping]                      [decimal](9, 6) NULL,
		[Intraday]                     [decimal](9, 6) NULL,
		[AncillaryServices]            [decimal](9, 6) NULL,
		[ARR]                          [decimal](9, 6) NULL,
		[Capacity]                     [decimal](9, 6) NULL,
		[Losses]                       [decimal](9, 6) NULL,
		[VoluntaryGreen]               [decimal](9, 6) NULL,
		[MLC]                          [decimal](9, 6) NULL,
		[Transmission]                 [decimal](9, 6) NULL,
		[RUC]                          [decimal](9, 6) NULL,
		[RMR]                          [decimal](9, 6) NULL,
		[RPS]                          [decimal](9, 6) NULL,
		[FinancingFee]                 [decimal](9, 6) NULL,
		[PORBarDebtFee]                [decimal](9, 6) NULL,
		[InvoicingCost]                [decimal](9, 6) NULL,
		[Bandwidth]                    [decimal](9, 6) NULL,
		[PUCAssessmentFee]             [decimal](9, 6) NULL,
		[PaymentTermPremium]           [decimal](9, 6) NULL,
		[PostingCollateral]            [decimal](9, 6) NULL,
		[CustomBilling]                [decimal](9, 6) NULL,
		[MiscFee]                      [decimal](9, 6) NULL,
		[DateCreated]                  [datetime] NULL,
		[CreatedBy]                    [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_MtMCustomDealAccount to [dbo].[MtMCustomDealAccount]
Print 'Add Primary Key PK_MtMCustomDealAccount to [dbo].[MtMCustomDealAccount]'
GO
ALTER TABLE [dbo].[MtMCustomDealAccount]
	ADD
	CONSTRAINT [PK_MtMCustomDealAccount]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[MtMCustomDealAccount] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[MtMFunctionFilter]
Print 'Create Table [dbo].[MtMFunctionFilter]'
GO
CREATE TABLE [dbo].[MtMFunctionFilter] (
		[ID]            [int] IDENTITY(1, 1) NOT NULL,
		[FormulaID]     [int] NOT NULL,
		[FieldID]       [int] NOT NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_MtMFormulaFilter_1 to [dbo].[MtMFunctionFilter]
Print 'Add Primary Key PK_MtMFormulaFilter_1 to [dbo].[MtMFunctionFilter]'
GO
ALTER TABLE [dbo].[MtMFunctionFilter]
	ADD
	CONSTRAINT [PK_MtMFormulaFilter_1]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[MtMFunctionFilter] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[MtMFunctionFilterValue]
Print 'Create Table [dbo].[MtMFunctionFilterValue]'
GO
CREATE TABLE [dbo].[MtMFunctionFilterValue] (
		[ID]                  [int] NOT NULL,
		[FormulaFilterID]     [int] NOT NULL,
		[Value]               [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_MtMFormulaFilterValue to [dbo].[MtMFunctionFilterValue]
Print 'Add Primary Key PK_MtMFormulaFilterValue to [dbo].[MtMFunctionFilterValue]'
GO
ALTER TABLE [dbo].[MtMFunctionFilterValue]
	ADD
	CONSTRAINT [PK_MtMFormulaFilterValue]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[MtMFunctionFilterValue] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key FK_MtMCustomDealAccount_MtMCustomDealHeader on [dbo].[MtMCustomDealAccount]
Print 'Create Foreign Key FK_MtMCustomDealAccount_MtMCustomDealHeader on [dbo].[MtMCustomDealAccount]'
GO
ALTER TABLE [dbo].[MtMCustomDealAccount]
	WITH NOCHECK
	ADD CONSTRAINT [FK_MtMCustomDealAccount_MtMCustomDealHeader]
	FOREIGN KEY ([CustomDealID]) REFERENCES [dbo].[MtMCustomDealHeader] ([ID])
ALTER TABLE [dbo].[MtMCustomDealAccount]
	CHECK CONSTRAINT [FK_MtMCustomDealAccount_MtMCustomDealHeader]

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key FK_MtMFormula_MtMComponent on [dbo].[MtMFunction]
Print 'Create Foreign Key FK_MtMFormula_MtMComponent on [dbo].[MtMFunction]'
GO
ALTER TABLE [dbo].[MtMFunction]
	WITH CHECK
	ADD CONSTRAINT [FK_MtMFormula_MtMComponent]
	FOREIGN KEY ([ComponentID]) REFERENCES [dbo].[MtMComponent] ([ID])
ALTER TABLE [dbo].[MtMFunction]
	CHECK CONSTRAINT [FK_MtMFormula_MtMComponent]

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key FK_MtMFormulaFilter_MtMFormula on [dbo].[MtMFunctionFilter]
Print 'Create Foreign Key FK_MtMFormulaFilter_MtMFormula on [dbo].[MtMFunctionFilter]'
GO
ALTER TABLE [dbo].[MtMFunctionFilter]
	WITH CHECK
	ADD CONSTRAINT [FK_MtMFormulaFilter_MtMFormula]
	FOREIGN KEY ([FormulaID]) REFERENCES [dbo].[MtMFunction] ([ID])
ALTER TABLE [dbo].[MtMFunctionFilter]
	CHECK CONSTRAINT [FK_MtMFormulaFilter_MtMFormula]

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key FK_MtMFormulaFilter_MtMInputField on [dbo].[MtMFunctionFilter]
Print 'Create Foreign Key FK_MtMFormulaFilter_MtMInputField on [dbo].[MtMFunctionFilter]'
GO
ALTER TABLE [dbo].[MtMFunctionFilter]
	WITH CHECK
	ADD CONSTRAINT [FK_MtMFormulaFilter_MtMInputField]
	FOREIGN KEY ([FieldID]) REFERENCES [dbo].[MtMInputField] ([ID])
ALTER TABLE [dbo].[MtMFunctionFilter]
	CHECK CONSTRAINT [FK_MtMFormulaFilter_MtMInputField]

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key FK_MtMFormulaFilterValue_MtMFormulaFilter on [dbo].[MtMFunctionFilterValue]
Print 'Create Foreign Key FK_MtMFormulaFilterValue_MtMFormulaFilter on [dbo].[MtMFunctionFilterValue]'
GO
ALTER TABLE [dbo].[MtMFunctionFilterValue]
	WITH CHECK
	ADD CONSTRAINT [FK_MtMFormulaFilterValue_MtMFormulaFilter]
	FOREIGN KEY ([FormulaFilterID]) REFERENCES [dbo].[MtMFunctionFilter] ([ID])
ALTER TABLE [dbo].[MtMFunctionFilterValue]
	CHECK CONSTRAINT [FK_MtMFormulaFilterValue_MtMFormulaFilter]

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key FK_MTMComponentFields_MtMComponentFieldTypes on [dbo].[MtMInputField]
Print 'Create Foreign Key FK_MTMComponentFields_MtMComponentFieldTypes on [dbo].[MtMInputField]'
GO
ALTER TABLE [dbo].[MtMInputField]
	WITH CHECK
	ADD CONSTRAINT [FK_MTMComponentFields_MtMComponentFieldTypes]
	FOREIGN KEY ([FieldTypeID]) REFERENCES [dbo].[MtMInputFieldType] ([ID])
ALTER TABLE [dbo].[MtMInputField]
	CHECK CONSTRAINT [FK_MTMComponentFields_MtMComponentFieldTypes]

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key FK_MTMComponentKey_MtMComponentHeader on [dbo].[MtMInputField]
Print 'Create Foreign Key FK_MTMComponentKey_MtMComponentHeader on [dbo].[MtMInputField]'
GO
ALTER TABLE [dbo].[MtMInputField]
	WITH CHECK
	ADD CONSTRAINT [FK_MTMComponentKey_MtMComponentHeader]
	FOREIGN KEY ([InputID]) REFERENCES [dbo].[MtMInputHeader] ([ID])
ALTER TABLE [dbo].[MtMInputField]
	CHECK CONSTRAINT [FK_MTMComponentKey_MtMComponentHeader]

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Extended Property MS_Description on [dbo].[MtMComponent]
Print 'Create Extended Property MS_Description on [dbo].[MtMComponent]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'What the frequency of value data for Zainet file', 'SCHEMA', N'dbo', 'TABLE', N'MtMComponent', 'COLUMN', N'FrequencyID'
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF

