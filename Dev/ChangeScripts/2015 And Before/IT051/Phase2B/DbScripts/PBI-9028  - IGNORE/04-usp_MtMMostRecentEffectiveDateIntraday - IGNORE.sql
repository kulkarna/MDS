USE [lp_MtM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	2/12/2013																		*
 *	Descp:		Get the Most Recent Effective Date by ISO/ZONE									*
 *	Modified:																					*
 ********************************************************************************************** */
 --exec MtMIntradayMostRecentEffectiveDate
  
ALTER	PROCEDURE	[dbo].[usp_MtMMostRecentEffectiveDateIntraday]

AS
BEGIN
	SET NOCOUNT ON;
	
	TRUNCATE TABLE MtMIntradayMostRecentEffectiveDate
	
	INSERT	INTO MtMIntradayMostRecentEffectiveDate (ISO, SettlementLocationRefID, EffectiveDate, FileLogID)
	
	SELECT	ISO, SettlementLocationRefID, EffectiveDate, MAX(FileLogID) as FileLogID
	FROM	MtMIntraday
	GROUP	by ISO, SettlementLocationRefID, EffectiveDate
	
	SET NOCOUNT OFF;
END



