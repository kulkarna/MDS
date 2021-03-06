USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMEnergyTransferPriceCustom]    Script Date: 07/25/2013 16:33:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the ETP for the custom deals																		*
 *  To Run:		exec usp_MtMEnergyTransferPriceCustom	'', ''															*
  *	Modified:	7/25: Replace DealPricingID with CustomDealID															*
 ************************************************************************************************************************/

ALTER	PROCEDURE [dbo].[usp_MtMEnergyTransferPriceCustom]
(	@BatchNumber AS VARCHAR(50),
	@QuoteNumber AS VARCHAR(50)
)
AS

BEGIN

SET NOCOUNT ON; 

IF PATINDEX('%CustomDealUpload%', @QuoteNumber) > 0
BEGIN
		UPDATE l
		SET		l.ETP = ca.Energy*1000
		FROM	MtMDailyWholesaleLoadForecast l
		INNER	JOIN MtMAccount m (nolock)
		ON		l.MtMAccountID = m.ID
		INNER	JOIN LibertyPower..Account a (nolock)
		ON		m.AccountID = a.AccountID
		INNER	JOIN MtMCustomDealAccount ca (nolock)
		ON		a.AccountNumber = ca.AccountNumber
		AND		m.CustomDealID = ca.CustomDealID
		WHERE	m.BatchNumber = @BatchNumber
		AND		m.QuoteNumber = @QuoteNumber
END

-- AS Of 6/13/2013, ETP will be caculated for daily customs
/*
ELSE -- Daily Custom
	BEGIN
	UPDATE	l
	SET		l.ETP = d.ETP
	FROM	MtMDailyWholesaleLoadForecast l

	INNER	JOIN MtMAccount m
	ON		l.MtMAccountID = m.ID

	Inner	Join MtMZainetAccountInfo z
	ON		m.AccountID = z.AccountID
	AND		m.ContractID = z.ContractID

	INNER	JOIN lp_deal_capture.dbo.deal_pricing_detail d
	ON		z.product_id = d.product_id
	and		z.RateID = d.rate_id
	
	WHERE	m.BatchNumber = @BatchNumber
	AND		m.QuoteNumber = @QuoteNumber
	AND		z.IsCustom = 1
		
END
*/
SET NOCOUNT OFF; 	
END
