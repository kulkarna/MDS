USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_tmp_UtilIDZone]') AND type in (N'U'))
	DROP TABLE [dbo].[_tmp_UtilIDZone]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_tmp_RiskUtil]') AND type in (N'U'))
	DROP TABLE [dbo].[_tmp_RiskUtil]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_tmp_RiskCodeMap]') AND type in (N'U'))
	DROP TABLE [dbo].[_tmp_RiskCodeMap]

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_tmp_RiskCodeMapNoUtility]') AND type in (N'U'))
	DROP TABLE [dbo].[_tmp_RiskCodeMapNoUtility]
GO


