USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMMostRecentEffectiveDateAttrition]    Script Date: 03/26/2013 11:44:03 ******/
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
 --exec usp_MtMMostRecentEffectiveDateAttrition
  
ALTER	PROCEDURE	[dbo].[usp_MtMMostRecentEffectiveDateAttrition]

AS
BEGIN
	SET NOCOUNT ON;
	
	TRUNCATE TABLE MtMAttritionMostRecentEffectiveDate
	
	INSERT	INTO MtMAttritionMostRecentEffectiveDate (ISO, SettlementLocationRefID, EffectiveDate, FileLogID)
	
	SELECT	ISO, SettlementLocationRefID, EffectiveDate, MAX(FileLogID) as FileLogID
	FROM	MtMAttrition
	GROUP	by ISO, SettlementLocationRefID, EffectiveDate
	
	SET NOCOUNT OFF;
END



