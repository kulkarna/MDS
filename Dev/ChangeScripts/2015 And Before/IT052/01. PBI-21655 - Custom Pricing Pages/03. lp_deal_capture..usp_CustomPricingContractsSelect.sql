USE [lp_deal_capture]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CustomPricingContractsSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_CustomPricingContractsSelect]
GO

-- =============================================
-- 11/6/2013 Gail M.
-- returns contracts associated with a custom rate
-- =============================================
CREATE PROC [dbo].[usp_CustomPricingContractsSelect]
( @DealPricingDtlId int ) 
AS 
BEGIN 

	SET NOCOUNT ON;

	-- join on product_id , rate_id since PriceId mauy not be reliable
	SELECT DISTINCT c.ContractID , c.Number , c.StartDate , c.ContractStatusID , c.ContractDealTypeID
	FROM Lp_deal_capture..deal_pricing_detail dpd 
		JOIN LibertyPower..AccountContractRate acr (NOLOCK)
			ON acr.RateID = dpd.rate_id
			AND acr.LegacyProductID = dpd.product_id
		JOIN LibertyPower..AccountContract acc (NOLOCK)
			ON acc.AccountContractID = acr.AccountContractID 
		JOIN LibertyPower..Contract c (NOLOCK)
			ON c.ContractID = acc.ContractID
	WHERE dpd.deal_pricing_detail_id = @DealPricingDtlId
	
	SET NOCOUNT OFF;

END 
GO 