USE [lp_MtM]
GO
/**************************** A T T R I T I O N *********************************/

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMAttrition]') AND name = N'IX_MtMAttrition')
DROP INDEX [IX_MtMAttrition] ON [dbo].[MtMAttrition] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMAttrition]') AND name = N'MtMAtt_Unique')
DROP INDEX MtMAtt_Unique ON [dbo].[MtMAttrition] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [PK_MtMAttritionMostRecentEffectiveDate]    Script Date: 03/27/2013 10:39:00 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMAttritionMostRecentEffectiveDate]') AND name = N'PK_MtMAttritionMostRecentEffectiveDate')
ALTER TABLE [dbo].[MtMAttritionMostRecentEffectiveDate] DROP CONSTRAINT [PK_MtMAttritionMostRecentEffectiveDate]
GO

/*********************** E N E R G Y    C U R V E S **************************/

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMEnergyCurves]') AND name = N'idx_MtMEnergyCurves_IZEF')
DROP INDEX [idx_MtMEnergyCurves_IZEF] ON [dbo].[MtMEnergyCurves] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMEnergyCurves]') AND name = N'MtMEC_Unique')
DROP INDEX MtMEC_Unique ON [dbo].[MtMEnergyCurves] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMEnergyCurvesMostRecentEffectiveDate]') AND name = N'PK_MtMEnergyCurvesMostRecentEffectiveDate')
ALTER TABLE [dbo].[MtMEnergyCurvesMostRecentEffectiveDate] DROP CONSTRAINT [PK_MtMEnergyCurvesMostRecentEffectiveDate]
GO

/******************* I N T R A D A Y  ****************************/

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMIntraday]') AND name = N'idx_MtMIntraday_IZEF')
DROP INDEX [idx_MtMIntraday_IZEF] ON [dbo].[MtMIntraday] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMIntraday]') AND name = N'MtMIntraday_Unique')
DROP INDEX MtMIntraday_Unique ON [dbo].[MtMIntraday] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMIntradayMostRecentEffectiveDate]') AND name = N'PK_MtMIntradayMostRecentEffectiveDate')
ALTER TABLE [dbo].[MtMIntradayMostRecentEffectiveDate] DROP CONSTRAINT [PK_MtMIntradayMostRecentEffectiveDate]
GO

/******************** S H A P I N G ****************************************/

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMShaping]') AND name = N'idx_MtMShaping_IZEF')
DROP INDEX [idx_MtMShaping_IZEF] ON [dbo].[MtMShaping] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMShaping]') AND name = N'MtMSh_Unique')
DROP INDEX MtMSh_Unique ON [dbo].[MtMShaping] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMShapingMostRecentEffectiveDate]') AND name = N'PK_MtMShapingMostRecentEffectiveDate')
ALTER TABLE [dbo].[MtMShapingMostRecentEffectiveDate] DROP CONSTRAINT [PK_MtMShapingMostRecentEffectiveDate]
GO

/************************ S U P P L I E R      P R E M I U M S ****************/

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMSupplierPremiums]') AND name = N'idx_MtMSupplierPremiums_IZEF')
DROP INDEX [idx_MtMSupplierPremiums_IZEF] ON [dbo].[MtMSupplierPremiums] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMSupplierPremiums]') AND name = N'MtMSP_Unique')
DROP INDEX MtMSP_Unique ON [dbo].[MtMSupplierPremiums] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MtMSupplierPremiumsMostRecentEffectiveDate]') AND name = N'PK_MtMSupplierPremiumsMostRecentEffectiveDate')
ALTER TABLE [dbo].[MtMSupplierPremiumsMostRecentEffectiveDate] DROP CONSTRAINT [PK_MtMSupplierPremiumsMostRecentEffectiveDate]
GO

