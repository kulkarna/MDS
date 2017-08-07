USE [lp_MtM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[zAuditMtMCustomDealAccount](
	[zAuditDealAccountID] [int] IDENTITY(1,1) NOT NULL,
	[ID] [int] NOT NULL,
	[CustomDealID] [int] NULL,
	[AccountNumber] [varchar](50) NULL,
	[Utility] [varchar](50) NULL,
	[DeliveryLocation] [varchar](50) NULL,
	[SettlementLocation] [varchar](50) NULL,
	[MeterType] [varchar](50) NULL,
	[ProfileID] [varchar](50) NULL,
	[LossFactorID] [varchar](50) NULL,
	[AccountType] [varchar](50) NULL,
	[BillingType] [varchar](50) NULL,
	[PureShapingPremiumFactor] [decimal](9, 6) NULL,
	[VolShapingPremiumFactor] [decimal](9, 6) NULL,
	[ContractRate] [decimal](9, 6) NULL,
	[Margin] [decimal](9, 6) NULL,
	[Commission] [decimal](9, 6) NULL,
	[TotalCost] [decimal](9, 6) NULL,
	[Energy] [decimal](9, 6) NULL,
	[Shaping] [decimal](9, 6) NULL,
	[Intraday] [decimal](9, 6) NULL,
	[AncillaryServices] [decimal](9, 6) NULL,
	[ARR] [decimal](9, 6) NULL,
	[Capacity] [decimal](9, 6) NULL,
	[Losses] [decimal](9, 6) NULL,
	[VoluntaryGreen] [decimal](9, 6) NULL,
	[MLC] [decimal](9, 6) NULL,
	[Transmission] [decimal](9, 6) NULL,
	[RUC] [decimal](9, 6) NULL,
	[RMR] [decimal](9, 6) NULL,
	[RPS] [decimal](9, 6) NULL,
	[FinancingFee] [decimal](9, 6) NULL,
	[PORBarDebtFee] [decimal](9, 6) NULL,
	[InvoicingCost] [decimal](9, 6) NULL,
	[Bandwidth] [decimal](9, 6) NULL,
	[PUCAssessmentFee] [decimal](9, 6) NULL,
	[PaymentTermPremium] [decimal](9, 6) NULL,
	[PostingCollateral] [decimal](9, 6) NULL,
	[CustomBilling] [decimal](9, 6) NULL,
	[MiscFee] [decimal](9, 6) NULL,
	[DateCreated] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[ModifiedBy] [varchar](50) NULL,
	[DateModified] [datetime] NULL,
	[DealPricingID] [int] NULL,
	[InActive] [bit] NULL,
	[AccountID] [int] NULL,
	[ContractID] [int] NULL,
	[DeliveryLocationRefID] [int] NULL,
	[SettlementLocationRefID] [int] NULL,
	[LoadProfileRefID] [int] NULL,
	[AccountTypeID] [int] NULL,
	[BillingTypeID] [int] NULL,
	[AuditChangeDate] [datetime] NOT NULL DEFAULT GETDATE() ,
	 
 CONSTRAINT [PK_MtMZAuditCustomDealAccount] PRIMARY KEY CLUSTERED 
(
	[zAuditDealAccountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON , DATA_COMPRESSION=PAGE ) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


