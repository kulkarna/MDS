USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_HourlyAccountForecastCreate]    Script Date: 03/14/2013 17:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		Get the hourly account forecast	adjusted for losses 							*
 *	Modified:																					*
 ********************************************************************************************** */
 --exec usp_HourlyAccountForecastCreate '0c6d6340-d147-4f4f-ab8c-d0d5899e7b7a', 'DealCapture-2011-0002845'
  
ALTER	PROCEDURE	[dbo].[usp_HourlyAccountForecastCreate]
(	@BatchNumber AS VARCHAR(50),
	@QuoteNumber AS VARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	DISTINCT
			a.ID as MtMAccountID, u.WholeSaleMktID as ISO, u.UtilityCode as Utility, c.SignedDate as DealDate
	INTO	#Accounts
	FROM	MtMAccount a (nolock)
	INNER	JOIN LibertyPower..Account act (nolock)
	ON		a.AccountID = act.AccountID
	INNER	JOIN	LibertyPower..Contract c (nolock)
	ON		a.ContractID = c.ContractID
	INNER	JOIN LibertyPower..Utility u (nolock)
	ON		u.ID = act.UtilityID			
	WHERE	a.BatchNumber = @BatchNumber
	AND		a.QuoteNumber = @QuoteNumber
		
	--First get the ISO, Utility, Deal Date for hte batch number passed
	SELECT	DISTINCT
			ISO, Utility, DealDate
	INTO	#HRAF
	FROM	#Accounts a 

	-- Get Loss Factors--------------------------------------------------------------------------
	/*the effective date in all the files should be matched to the date_deal of the contract. 
	The effective date should be the least great date than the date_deal. 
	If date_deal is 6/15, and effective dates are 7/1 and 8/1, the effective date to be used is 7/1.
	If no match was found, the effective date to be used, will the most recent one from the file.
	UPDATE: PBI 7314: effective date should the max date <= signed date. if no match is found, error*/
	SELECT	a.ISO, 
			a.Utility as Utility 
			,MAX(s.EffectiveDate) as EffectiveDate
	INTO	#Loss
	FROM	#HRAF a
	INNER	JOIN MtMLossFactorsMostRecentEffectiveDate s (nolock)
	ON		s.ISO = a.ISO		
	AND		s.Utility = a.Utility
	AND		s.EffectiveDate <= a.DealDate
	AND		s.Type = 2		
	GROUP	BY a.ISO, a.Utility

	Select	Distinct
			t2.EffectiveDate, t2.UsageDate, t2.ISO, t2.Utility, 
			t2.Int1,t2.Int2,t2.Int3,t2.Int4,t2.Int5,t2.Int6,t2.Int7,t2.Int8,t2.Int9,t2.Int10,t2.Int11,t2.Int12,
			t2.Int13,t2.Int14,t2.Int15,t2.Int16,t2.Int17,t2.Int18,t2.Int19,t2.Int20,t2.Int21,t2.Int22,t2.Int23,t2.Int24
	INTO	#L
	FROM	#Loss t1
	INNER	JOIN MtMLossFactorsMostRecentEffectiveDate t3 (nolock)
	ON		t1.ISO = t3.ISO
	AND		t1.Utility = t3.Utility
	AND		t1.EffectiveDate = t3.EffectiveDate 
	INNER	JOIN MtMLossFactors t2 (nolock)
	ON		t2.ISO = t3.ISO
	AND		t2.Utility = t3.Utility
	AND		t2.EffectiveDate = t3.EffectiveDate 
	AND		t2.Type = t3.Type
	AND		t2.FileLogID = t3.FileLogID
	WHERE	t2.Type = 2
	-------------------------------------------------------------------------------------------------				
	--adjust the data for losses which will result in MWAF: daily whole sale account forecast
	INSERT	INTO MtMDailyWholesaleLoadForecast
		 (
		MtMAccountID,UsageDate,
		Int1,Int2,Int3,Int4,Int5,Int6,Int7,Int8,Int9,Int10,Int11,Int12,Int13,Int14,
		Int15,Int16,Int17,Int18,Int19,Int20,Int21,Int22,Int23,Int24, CreatedBy
		)
	SELECT	Distinct
			d.MtMAccountID, 
			d.UsageDate, 
			CONVERT(DECIMAL(14,4),d.INT1*(1+ml.Int1)) AS Int1, 
			CONVERT(DECIMAL(14,4),d.INT2*(1+ml.Int2)) AS Int2, 
			CONVERT(DECIMAL(14,4),d.INT3*(1+ml.Int3)) AS Int3, 
			CONVERT(DECIMAL(14,4),d.INT4*(1+ml.Int4)) AS Int4, 
			CONVERT(DECIMAL(14,4),d.INT5*(1+ml.Int5)) AS Int5, 
			CONVERT(DECIMAL(14,4),d.INT6*(1+ml.Int6)) AS Int6, 
			CONVERT(DECIMAL(14,4),d.INT7*(1+ml.Int7)) AS Int7, 
			CONVERT(DECIMAL(14,4),d.INT8*(1+ml.Int8)) AS Int8, 
			CONVERT(DECIMAL(14,4),d.INT9*(1+ml.Int9)) AS Int9, 
			CONVERT(DECIMAL(14,4),d.INT10*(1+ml.Int10)) AS Int10, 
			CONVERT(DECIMAL(14,4),d.INT11*(1+ml.Int11)) AS Int11, 
			CONVERT(DECIMAL(14,4),d.INT12*(1+ml.Int12)) AS Int12, 
			CONVERT(DECIMAL(14,4),d.INT13*(1+ml.Int13)) AS Int13, 
			CONVERT(DECIMAL(14,4),d.INT14*(1+ml.Int14)) AS Int14, 
			CONVERT(DECIMAL(14,4),d.INT15*(1+ml.Int15)) AS Int15, 
			CONVERT(DECIMAL(14,4),d.INT16*(1+ml.Int16)) AS Int16, 
			CONVERT(DECIMAL(14,4),d.INT17*(1+ml.Int17)) AS Int17, 
			CONVERT(DECIMAL(14,4),d.INT18*(1+ml.Int18)) AS Int18, 
			CONVERT(DECIMAL(14,4),d.INT19*(1+ml.Int19)) AS Int19, 
			CONVERT(DECIMAL(14,4),d.INT20*(1+ml.Int20)) AS Int20, 
			CONVERT(DECIMAL(14,4),d.INT21*(1+ml.Int21)) AS Int21, 
			CONVERT(DECIMAL(14,4),d.INT22*(1+ml.Int22)) AS Int22, 
			CONVERT(DECIMAL(14,4),d.INT23*(1+ml.Int23)) AS Int23, 
			CONVERT(DECIMAL(14,4),d.INT24*(1+ml.Int24)) AS Int24,
			d.CreatedBy
			
	FROM	#Accounts m (nolock)
	INNER	JOIN MtMDailyLoadForecast d (nolock)
	ON		m.MtMAccountID = d.MtMAccountID
	INNER	JOIN #L ml
	ON		ml.Utility = m.Utility
	AND		ml.ISO = m.ISO
	AND		ml.UsageDate = d.UsageDate

	SET NOCOUNT OFF;
END



