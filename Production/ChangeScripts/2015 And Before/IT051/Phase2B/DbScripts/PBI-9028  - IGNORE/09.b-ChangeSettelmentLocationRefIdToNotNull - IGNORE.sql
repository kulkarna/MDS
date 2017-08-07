USE lp_MtM
GO


ALTER TABLE MtMAttrition ALTER COLUMN SettlementLocationRefID INT NOT NULL

GO

ALTER TABLE MtMIntraday ALTER COLUMN SettlementLocationRefID INT NOT NULL

GO

ALTER TABLE MtMShaping ALTER COLUMN SettlementLocationRefID INT NOT NULL

GO

ALTER TABLE MtMSupplierPremiums ALTER COLUMN SettlementLocationRefID INT NOT NULL

GO

ALTER TABLE MtMEnergyCurves ALTER COLUMN SettlementLocationRefID INT NOT NULL
