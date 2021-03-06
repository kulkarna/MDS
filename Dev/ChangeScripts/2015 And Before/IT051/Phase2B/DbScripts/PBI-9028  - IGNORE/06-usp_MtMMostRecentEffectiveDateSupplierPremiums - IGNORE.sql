USE [lp_MtM]
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	2/12/2013																		*
 *	Descp:		Get the Most Recent Effective Date by ISO/ZONE									*
 *	Modified:																					*
 ********************************************************************************************** */
 --exec usp_MtMMostRecentEffectiveDateSupplierPremiums
  
ALTER	PROCEDURE	[dbo].[usp_MtMMostRecentEffectiveDateSupplierPremiums]

AS
BEGIN
	SET NOCOUNT ON;
	
	TRUNCATE TABLE MtMSupplierPremiumsMostRecentEffectiveDate
	
	INSERT	INTO MtMSupplierPremiumsMostRecentEffectiveDate (ISO, SettlementLocationRefID, EffectiveDate, FileLogID)
	
	SELECT	ISO, SettlementLocationRefID, EffectiveDate, MAX(FileLogID) as FileLogID
	FROM	MtMSupplierPremiums
	GROUP	by ISO, SettlementLocationRefID, EffectiveDate
	
	SET NOCOUNT OFF;
END

