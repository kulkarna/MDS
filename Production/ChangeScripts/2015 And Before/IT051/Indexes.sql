

CREATE NONCLUSTERED INDEX idx_ReportStatus_ReportID ON dbo.MtMReportStatus (ReportID ASC)
CREATE NONCLUSTERED INDEX idx_ReportStatus_Inactive ON dbo.MtMReportStatus (Inactive ASC)

CREATE NONCLUSTERED INDEX idx_Report_CounterParty ON dbo.MtMReport (CounterPartyID ASC)

CREATE NONCLUSTERED INDEX idx_ReportCounterParty_CP ON dbo.MtMReportCounterParty (CounterPartyID ASC)

CREATE NONCLUSTERED INDEX idx_ReportZkeyD_CP ON dbo.MtMReportZkeyDetail (CounterPartyID ASC)
CREATE NONCLUSTERED INDEX idx_ReportZkeyD_Zkey ON dbo.MtMReportZkeyDetail (ZkeyID ASC)

CREATE NONCLUSTERED INDEX idx_ReportZkey_Zkey ON dbo.MtMReportZkey (ZkeyID ASC)

CREATE NONCLUSTERED INDEX idx_MtMAccount_Status ON dbo.MtMAccount (Status ASC)
CREATE NONCLUSTERED INDEX idx_MtMAccount_Contract ON dbo.MtMAccount (ContractID ASC)
CREATE NONCLUSTERED INDEX idx_MtMAccount_Account ON dbo.MtMAccount (AccountID ASC)
CREATE NONCLUSTERED INDEX idx_MtMAccount_Zone ON dbo.MtMAccount (Zone ASC)
CREATE NONCLUSTERED INDEX idx_MtMAccount_BatchQuote ON dbo.MtMAccount (BatchNumber, QuoteNumber ASC)

CREATE NONCLUSTERED INDEX idx_ZainetZone_U ON dbo.MtMZainetZones (UtilityID ASC)
CREATE NONCLUSTERED INDEX idx_ZainetZone_Z ON dbo.MtMZainetZones (Zone ASC)

CREATE NONCLUSTERED INDEX idx_WLoadForecast_ID ON dbo.MtMDailyWholesaleLoadForecast (ID ASC)
CREATE CLUSTERED INDEX idx_WLoadForecast_MtMAccountID ON dbo.MtMDailyWholesaleLoadForecast (MtMAccountID ASC)
CREATE NONCLUSTERED INDEX idx_WLoadForecast_UD ON dbo.MtMDailyWholesaleLoadForecast (UsageDate ASC)

CREATE NONCLUSTERED INDEX idx_LoadForecast_ID ON dbo.MtMDailyLoadForecast (ID ASC)
CREATE CLUSTERED INDEX idx_LoadForecast_MtMAccountID ON dbo.MtMDailyLoadForecast (MtMAccountID ASC)
CREATE NONCLUSTERED INDEX idx_LoadForecast_UD ON dbo.MtMDailyLoadForecast (UsageDate ASC)

CREATE NONCLUSTERED INDEX idx_TLoadForecast_BatchQuote ON dbo.MtMDailyLoadForecastTemp (BatchNumber, QuoteNumber ASC)

drop index AccountStatus.idx_AccountStatus_SbST

CREATE NONCLUSTERED INDEX idx_AccountStatus_ST ON dbo.AccountStatus (Status ASC)
CREATE NONCLUSTERED INDEX idx_AccountStatus_SbST ON dbo.AccountStatus (Status,SubStatus)

CREATE CLUSTERED INDEX idx_Attrition_ISOZone_ED ON dbo.MtMAttrition (EffectiveDate,ISO,Zone  ASC)
CREATE NONCLUSTERED INDEX idx_Attrition_DM ON dbo.MtMAttrition (DeliveryMonth ASC)

CREATE CLUSTERED INDEX idx_LossFactors_ISOUtility_ED ON dbo.MtMLossFactors (EffectiveDate,ISO,Utility  ASC)
CREATE NONCLUSTERED INDEX idx_LossFactors_UD ON dbo.MtMLossFactors (UsageDate ASC)
CREATE NONCLUSTERED INDEX idx_LossFactors_Type ON MtMLossFactors ([Type] ASC)

CREATE CLUSTERED INDEX idx_EnergyCurves_ISOZone_ED ON dbo.MtMEnergyCurves (EffectiveDate,ISO,Zone  ASC)
CREATE NONCLUSTERED INDEX idx_EnergyCurves_UD ON dbo.MtMEnergyCurves (UsageDate ASC)
CREATE NONCLUSTERED INDEX idx_EnergyCurves_ISOZone ON dbo.MtMEnergyCurves (ISO,Zone ASC)


CREATE CLUSTERED INDEX idx_SupplierPremiums_ISOZone_ED ON dbo.MtMSupplierPremiums (EffectiveDate,ISO,Zone  ASC)
CREATE NONCLUSTERED INDEX idx_SupplierPremiums_UD ON dbo.MtMSupplierPremiums (UsageDate ASC)
CREATE NONCLUSTERED INDEX idx_SupplierPremiums_ISOZone ON dbo.MtMSupplierPremiums (ISO,Zone  ASC)

CREATE CLUSTERED INDEX idx_Shaping_ISOZone_ED ON dbo.MtMShaping (EffectiveDate, ISO,Zone  ASC)
CREATE NONCLUSTERED INDEX idx_Shaping_UD ON dbo.MtMShaping (UsageDate ASC)
CREATE NONCLUSTERED INDEX idx_Shaping_ISOZone ON dbo.MtMShaping (ISO,Zone  ASC)

CREATE CLUSTERED INDEX idx_Intraday_ISOZone_ED ON dbo.MtMIntraday (EffectiveDate, ISO,Zone  ASC)
CREATE NONCLUSTERED INDEX idx_Intraday_UD ON dbo.MtMIntraday (UsageDate ASC)
CREATE NONCLUSTERED INDEX idx_Intraday_ISOZone ON dbo.MtMIntraday (ISO,Zone  ASC)


CREATE INDEX idx_UsageConsolidated_AccountNumber_toDate_I_UsageType_TotalKwh on UsageConsolidated (AccountNumber,toDate) Include (UsageType,TotalKwh)
