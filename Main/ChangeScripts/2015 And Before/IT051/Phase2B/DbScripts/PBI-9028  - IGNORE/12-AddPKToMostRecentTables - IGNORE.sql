USE [lp_MtM]
GO
/**************************** A T T R I T I O N *********************************/
ALTER TABLE [dbo].[MtMAttritionMostRecentEffectiveDate] ADD  CONSTRAINT [PK_MtMAttritionD_ILE] PRIMARY KEY CLUSTERED 
(
	[ISO] ASC,
	[SettlementLocationRefID] ASC,
	[EffectiveDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO

/*********************** E N E R G Y    C U R V E S **************************/
ALTER TABLE [dbo].[MtMEnergyCurvesMostRecentEffectiveDate] ADD  CONSTRAINT [PK_MtMEnergyCurvesD_ILE] PRIMARY KEY CLUSTERED 
(
	[ISO] ASC,
	[SettlementLocationRefID] ASC,
	[EffectiveDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO

/******************* I N T R A D A Y  ****************************/
ALTER TABLE [dbo].[MtMIntradayMostRecentEffectiveDate] ADD  CONSTRAINT [PK_MtMIntradayD_ILE] PRIMARY KEY CLUSTERED 
(
	[ISO] ASC,
	[SettlementLocationRefID] ASC,
	[EffectiveDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO

/******************** S H A P I N G ****************************************/
ALTER TABLE [dbo].[MtMShapingMostRecentEffectiveDate] ADD  CONSTRAINT [PK_MtMShapingD_ILE] PRIMARY KEY CLUSTERED 
(
	[ISO] ASC,
	[SettlementLocationRefID] ASC,
	[EffectiveDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO

/************************ S U P P L I E R      P R E M I U M S ****************/
ALTER TABLE [dbo].[MtMSupplierPremiumsMostRecentEffectiveDate] ADD  CONSTRAINT [PK_MtMSupplierPremiumsD_ILE] PRIMARY KEY CLUSTERED 
(
	[ISO] ASC,
	[SettlementLocationRefID] ASC,
	[EffectiveDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO


