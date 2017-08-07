USE [lp_MtM]
GO
/**************************** A T T R I T I O N *********************************/
CREATE CLUSTERED INDEX idx_MtMAttrition_ILEF ON [dbo].[MtMAttrition] 
(
	[ISO] ASC,
	[SettlementLocationRefID] ASC,
	[EffectiveDate] ASC,
	[FileLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO

CREATE UNIQUE NONCLUSTERED INDEX [MtMAtt_Unique] ON [dbo].[MtMAttrition] 
(
	[FileLogID] ASC,
	[EffectiveDate] ASC,
	[DeliveryMonth] ASC,
	[ISO] ASC,
	[SettlementLocationRefID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/*********************** E N E R G Y    C U R V E S **************************/

CREATE CLUSTERED INDEX [idx_MtMEnergyCurves_ILEF] ON [dbo].[MtMEnergyCurves] 
(
	[ISO] ASC,
	[SettlementLocationRefID] ASC,
	[EffectiveDate] ASC,
	[FileLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO

CREATE UNIQUE NONCLUSTERED INDEX [MtMEC_Unique] ON [dbo].[MtMEnergyCurves] 
(
	[FileLogID] ASC,
	[EffectiveDate] ASC,
	[UsageDate] ASC,
	[ISO] ASC,
	[SettlementLocationRefID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO

/******************* I N T R A D A Y  ****************************/

CREATE CLUSTERED INDEX [idx_MtMIntraday_ILEF] ON [dbo].[MtMIntraday] 
(
	[ISO] ASC,
	[SettlementLocationRefID] ASC,
	[EffectiveDate] ASC,
	[FileLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO

CREATE UNIQUE NONCLUSTERED INDEX [MtMIntraday_Unique] ON [dbo].[MtMIntraday] 
(
	[FileLogID] ASC,
	[EffectiveDate] ASC,
	[UsageDate] ASC,
	[ISO] ASC,
	[SettlementLocationRefID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/******************** S H A P I N G ****************************************/

CREATE CLUSTERED INDEX [idx_MtMShaping_ILEF] ON [dbo].[MtMShaping] 
(
	[ISO] ASC,
	[SettlementLocationRefID] ASC,
	[EffectiveDate] ASC,
	[FileLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO

CREATE UNIQUE NONCLUSTERED INDEX [MtMSh_Unique] ON [dbo].[MtMShaping] 
(
	[FileLogID] ASC,
	[EffectiveDate] ASC,
	[UsageDate] ASC,
	[ISO] ASC,
	[SettlementLocationRefID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/************************ S U P P L I E R      P R E M I U M S ****************/

CREATE CLUSTERED INDEX [idx_MtMSupplierPremiums_ILEF] ON [dbo].[MtMSupplierPremiums] 
(
	[ISO] ASC,
	[SettlementLocationRefID] ASC,
	[EffectiveDate] ASC,
	[FileLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO

CREATE UNIQUE NONCLUSTERED INDEX [MtMSP_Unique] ON [dbo].[MtMSupplierPremiums] 
(
	[FileLogID] ASC,
	[EffectiveDate] ASC,
	[UsageDate] ASC,
	[ISO] ASC,
	[SettlementLocationRefID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




