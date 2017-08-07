USE lp_mtm

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

	ALTER TABLE dbo.MtMCustomDealAccount
		DROP CONSTRAINT FK_MtMCustomDealAccount_MtMCustomDealHeader
	GO

	ALTER TABLE dbo.MtMCustomDealAccount
		DROP CONSTRAINT DF_MtMCustomDealAccount_DateCreated
	GO
	
	ALTER TABLE dbo.MtMCustomDealAccount
		DROP CONSTRAINT DF_MtMCustomDealAccount_InActive
	GO
	
	CREATE TABLE dbo.Tmp_MtMCustomDealAccount
		(
		ID int NOT NULL IDENTITY (1, 1),
		CustomDealID int NOT NULL,
		AccountNumber varchar(50) NULL,
		Utility varchar(50) NULL,
		DeliveryLocation varchar(50) NULL,
		SettlementLocation varchar(50) NULL,
		ZoneBackUp varchar(50) NULL,
		MeterType varchar(50) NULL,
		ProfileID varchar(50) NULL,
		LossFactorID varchar(50) NULL,
		AccountType varchar(50) NULL,
		BillingType varchar(50) NULL,
		PureShapingPremiumFactor decimal(9, 6) NULL,
		VolShapingPremiumFactor decimal(9, 6) NULL,
		ContractRate decimal(9, 6) NULL,
		Margin decimal(9, 6) NULL,
		Commission decimal(9, 6) NULL,
		TotalCost decimal(9, 6) NULL,
		Energy decimal(9, 6) NULL,
		Shaping decimal(9, 6) NULL,
		Intraday decimal(9, 6) NULL,
		AncillaryServices decimal(9, 6) NULL,
		ARR decimal(9, 6) NULL,
		Capacity decimal(9, 6) NULL,
		Losses decimal(9, 6) NULL,
		VoluntaryGreen decimal(9, 6) NULL,
		MLC decimal(9, 6) NULL,
		Transmission decimal(9, 6) NULL,
		RUC decimal(9, 6) NULL,
		RMR decimal(9, 6) NULL,
		RPS decimal(9, 6) NULL,
		FinancingFee decimal(9, 6) NULL,
		PORBarDebtFee decimal(9, 6) NULL,
		InvoicingCost decimal(9, 6) NULL,
		Bandwidth decimal(9, 6) NULL,
		PUCAssessmentFee decimal(9, 6) NULL,
		PaymentTermPremium decimal(9, 6) NULL,
		PostingCollateral decimal(9, 6) NULL,
		CustomBilling decimal(9, 6) NULL,
		MiscFee decimal(9, 6) NULL,
		DateCreated datetime NULL,
		CreatedBy varchar(50) NULL,
		ModifiedBy varchar(50) NULL,
		DateModified datetime NULL,
		DealPricingID int NULL,
		InActive bit NOT NULL,
		AccountID int NULL,
		ContractID int NULL,
		DeliveryLocationRefID int NULL,
		SettlementLocationRefID int NULL,
		LoadProfileRefID int NULL,
		AccountTypeID int NULL,
		BillingTypeID int NULL
		)  ON [PRIMARY]
	GO
	
	
	ALTER TABLE dbo.Tmp_MtMCustomDealAccount ADD CONSTRAINT
		DF_MtMCustomDealAccount_DateCreated DEFAULT (getdate()) FOR DateCreated
	GO

	ALTER TABLE dbo.Tmp_MtMCustomDealAccount ADD CONSTRAINT
		DF_MtMCustomDealAccount_InActive DEFAULT ((0)) FOR InActive
	GO

	SET IDENTITY_INSERT dbo.Tmp_MtMCustomDealAccount ON
	GO
	IF EXISTS(SELECT * FROM dbo.MtMCustomDealAccount)
		 EXEC('INSERT INTO dbo.Tmp_MtMCustomDealAccount (ID, CustomDealID, AccountNumber, Utility, DeliveryLocation, ZoneBackUp, MeterType, ProfileID, LossFactorID, AccountType, BillingType, PureShapingPremiumFactor, VolShapingPremiumFactor, ContractRate, Margin, Commission, TotalCost, Energy, Shaping, Intraday, AncillaryServices, ARR, Capacity, Losses, VoluntaryGreen, MLC, Transmission, RUC, RMR, RPS, FinancingFee, PORBarDebtFee, InvoicingCost, Bandwidth, PUCAssessmentFee, PaymentTermPremium, PostingCollateral, CustomBilling, MiscFee, DateCreated, CreatedBy, ModifiedBy, DateModified, DealPricingID, InActive, AccountID, ContractID)
			SELECT ID, CustomDealID, AccountNumber, Utility, DeliveryPointFixedPrice, Zone, MeterType, ProfileID, LossFactorID, AccountType, BillingType, PureShapingPremiumFactor, VolShapingPremiumFactor, ContractRate, Margin, Commission, TotalCost, Energy, Shaping, Intraday, AncillaryServices, ARR, Capacity, Losses, VoluntaryGreen, MLC, Transmission, RUC, RMR, RPS, FinancingFee, PORBarDebtFee, InvoicingCost, Bandwidth, PUCAssessmentFee, PaymentTermPremium, PostingCollateral, CustomBilling, MiscFee, DateCreated, CreatedBy, ModifiedBy, DateModified, DealPricingID, InActive, AccountID, ContractID FROM dbo.MtMCustomDealAccount WITH (HOLDLOCK TABLOCKX)')
	GO
	SET IDENTITY_INSERT dbo.Tmp_MtMCustomDealAccount OFF
	GO

	DROP TABLE dbo.MtMCustomDealAccount
	GO

	EXECUTE sp_rename N'dbo.Tmp_MtMCustomDealAccount', N'MtMCustomDealAccount', 'OBJECT' 
	GO

	ALTER TABLE dbo.MtMCustomDealAccount ADD CONSTRAINT
		PK_MtMCustomDealAccount PRIMARY KEY CLUSTERED 
		(
		ID
		) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	GO

	CREATE NONCLUSTERED INDEX IDX_MtMCustomDealAccount_CustomDealId ON dbo.MtMCustomDealAccount
		(
		CustomDealID
		) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	GO

	CREATE NONCLUSTERED INDEX IDX_MtMCustomDealAccount_AcctCont ON dbo.MtMCustomDealAccount
		(
		ContractID,
		AccountID
		) INCLUDE (InActive) 
	 WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	GO

	ALTER TABLE dbo.MtMCustomDealAccount WITH NOCHECK ADD CONSTRAINT
		FK_MtMCustomDealAccount_MtMCustomDealHeader FOREIGN KEY
		(
		CustomDealID
		) REFERENCES dbo.MtMCustomDealHeader
		(
		ID
		) ON UPDATE  NO ACTION 
		 ON DELETE  NO ACTION 
		
	GO

