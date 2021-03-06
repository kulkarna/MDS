USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMEnergyTransferPriceCustom]    Script Date: 03/14/2013 17:29:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER	PROCEDURE [dbo].[usp_MtMEnergyTransferPriceCustom]
(	@BatchNumber AS VARCHAR(50),
	@QuoteNumber AS VARCHAR(50)
)
AS

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