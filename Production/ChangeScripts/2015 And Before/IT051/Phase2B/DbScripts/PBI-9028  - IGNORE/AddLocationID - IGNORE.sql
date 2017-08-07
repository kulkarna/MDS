USE lp_MtM
GO

ALTER TABLE MtMEnergyCurves ADD SettlementLocationRefID INT 

GO

ALTER TABLE MtMEnergyCurves ADD  CONSTRAINT [DF_MtMEnergyCurves_SettlementLocationRefID]  DEFAULT ((0)) FOR [SettlementLocationRefID]

GO

TRUNCATE TABLE MtMEnergyCurvesMostRecentEffectiveDate
GO

ALTER TABLE MtMEnergyCurvesMostRecentEffectiveDate ADD SettlementLocationRefID INT NOT NULL

GO

ALTER TABLE MtMSupplierPremiums ADD SettlementLocationRefID INT 

GO

ALTER TABLE MtMSupplierPremiums ADD  CONSTRAINT [DF_MtMSupplierPremiums_SettlementLocationRefID]  DEFAULT ((0)) FOR [SettlementLocationRefID]

GO

TRUNCATE TABLE MtMSupplierPremiumsMostRecentEffectiveDate
GO

ALTER TABLE MtMSupplierPremiumsMostRecentEffectiveDate ADD SettlementLocationRefID INT  NOT NULL

GO

ALTER TABLE MtMShaping ADD SettlementLocationRefID INT 

GO

ALTER TABLE MtMShaping ADD  CONSTRAINT [DF_MtMShaping_SettlementLocationRefID]  DEFAULT ((0)) FOR [SettlementLocationRefID]

GO

TRUNCATE TABLE MtMShapingMostRecentEffectiveDate
GO

ALTER TABLE MtMShapingMostRecentEffectiveDate ADD SettlementLocationRefID INT NOT NULL

GO

ALTER TABLE MtMIntraday ADD SettlementLocationRefID INT 

GO

ALTER TABLE MtMIntraday ADD  CONSTRAINT [DF_MtMIntraday_SettlementLocationRefID]  DEFAULT ((0)) FOR [SettlementLocationRefID]

GO

TRUNCATE TABLE MtMIntradayMostRecentEffectiveDate
GO

ALTER TABLE MtMIntradayMostRecentEffectiveDate ADD SettlementLocationRefID INT NOT NULL

GO

ALTER TABLE MtMAttrition ADD SettlementLocationRefID INT 

GO

ALTER TABLE MtMAttrition ADD  CONSTRAINT [DF_MtMAttrition_SettlementLocationRefID]  DEFAULT ((0)) FOR [SettlementLocationRefID]

GO

TRUNCATE TABLE MtMAttritionMostRecentEffectiveDate
GO

ALTER TABLE MtMAttritionMostRecentEffectiveDate ADD SettlementLocationRefID INT NOT NULL

GO


