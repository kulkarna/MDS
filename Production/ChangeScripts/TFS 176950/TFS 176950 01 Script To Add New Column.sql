
USE [ZE_LibertyPower]
GO

/****** Object:  Table [ZE_DATA].[ISONE_SR_RTNCPCSTLMNTS_D]    Script Date: 5/3/2017 9:35:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

ALTER TABLE [ZE_DATA].[ISONE_SR_RTNCPCSTLMNTS_D]
	ADD [PART_RPD_RES_P_O_C_NCPC_CHR] NUMERIC(19,9) NULL
GO

SET ANSI_PADDING ON
GO