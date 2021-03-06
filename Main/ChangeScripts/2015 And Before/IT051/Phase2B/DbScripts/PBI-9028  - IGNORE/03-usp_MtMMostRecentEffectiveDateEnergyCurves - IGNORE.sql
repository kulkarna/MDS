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
 --exec usp_MtMMostRecentEffectiveDateEnergyCurves
  
ALTER	PROCEDURE	[dbo].[usp_MtMMostRecentEffectiveDateEnergyCurves]

AS
BEGIN
	SET NOCOUNT ON;
	
/*	TRUNCATE TABLE MtMEnergyCurvesMostRecentEffectiveDate
	
	INSERT	INTO MtMEnergyCurvesMostRecentEffectiveDate (ISO, Zone, EffectiveDate, FileLogID)
	
	SELECT	ISO, Zone, EffectiveDate, MAX(FileLogID) as FileLogID
	FROM	MtMEnergyCurves
	GROUP	by ISO, Zone, EffectiveDate
*/
	DECLARE @ID AS INT
	SET		@ID = (SELECT MAX(FileLogID) FROM MtMEnergyCurves)

	SELECT	DISTINCT ISO, SettlementLocationRefID, EffectiveDate 
	INTO	#Date
	FROM	MtMEnergyCurves
	WHERE	FileLogID = @ID

	DELETE	M
	FROM	MtMEnergyCurvesMostRecentEffectiveDate M
	INNER	JOIN #Date d
	ON		d.ISO = m.ISO
	AND		d.SettlementLocationRefID = m.SettlementLocationRefID
	AND		d.EffectiveDate = m.EffectiveDate

	INSERT	INTO MtMEnergyCurvesMostRecentEffectiveDate (ISO, SettlementLocationRefID, EffectiveDate, FileLogID)
		
	SELECT	ISO, SettlementLocationRefID, EffectiveDate, @ID FileLogID
	FROM	#Date
	

	
	SET NOCOUNT OFF;
END



