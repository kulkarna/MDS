USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMEnergyTransferPriceCustom]    Script Date: 08/12/2013 11:35:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the ETP for the custom deals																		*
 *  To Run:		exec usp_MtMEnergyTransferPriceCustom	'', ''															*
  *	Modified:																											*
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
		SET		l.ETP = d.ETP*1000
		FROM	MtMDailyWholesaleLoadForecast l
		INNER	JOIN MtMAccount m
		ON		l.MtMAccountID = m.ID
		INNER	JOIN lp_deal_capture.dbo.deal_pricing_detail d
		ON		D.deal_pricing_id = m.DealPricingID
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
