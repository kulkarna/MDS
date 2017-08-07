USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMZainetGetAccountInfo]    Script Date: 10/03/2013 12:42:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	PROCEDURE [dbo].[usp_MtMZainetGetAccountInfo]

AS

BEGIN

	SET NOCOUNT ON;

	TRUNCATE TABLE	MtMZainetAccountInfo
	
	INSERT	INTO	MtMZainetAccountInfo	(
						AccountID, AccountNumber, AccountIdLegacy, ContractID, ContractNumber, AccountContractID, ContractDealTypeID, UtilityID, UtilityCode, 
						SignedDate, StartDate, EndDate, ISO, IsoId, MarketCode, product_id, RateID, IsCustom, BackToBack, IsDaily, Status, SubStatus, BillingGroup, DateCreated)
	SELECT	DISTINCT
			act.AccountID,
			act.AccountNumber,
			act.AccountIdLegacy,
			ac.ContractID, 
			c.Number as ContractNumber,
			ac.AccountContractID,
			c.ContractDealTypeID,
			act.UtilityID, 
			u.UtilityCode,
			c.SignedDate, 
			acr.RateStart as StartDate,
			acr.RateEnd as EndDate,
			u.WholeSaleMktID as ISO,
			w.ID AS IsoId,
			mk.MarketCode,
			p.product_id, 
			acr.RateID, 
			p.IsCustom, 
			d.BackToBack,
			isDaily = CASE WHEN ISNULL(dp.Pricing_Request_ID,'') = '' THEN 1 ELSE 0 END,
			actS.Status,
			actS.SubStatus,
			act.BillingGroup,
			c.DateCreated		

	FROM	LibertyPower..Account	act (nolock)
	
	INNER	JOIN LibertyPower..AccountContract ac (nolock)
	ON		act.AccountID = ac.AccountID
	AND		(act.CurrentContractID = ac.ContractID OR act.CurrentRenewalContractID = ac.ContractID)
	
	INNER	JOIN  LibertyPower..Contract c (nolock)
	ON		ac.ContractID = c.ContractID
	
	INNER	JOIN LibertyPower..Utility u (nolock)
	ON		act.UtilityID = u.ID
	
	INNER	JOIN LibertyPower..Market mk (nolock)
	ON		u.MarketID = mk.ID
	
	INNER	JOIN LibertyPower..WholesaleMarket w (nolock)
	ON		w.WholesaleMktId  = u.WholeSaleMktID
		
	INNER	JOIN LibertyPower..vw_AccountContractRate acr (nolock)
	ON		ac.AccountContractID = acr.AccountContractID
	--AND		acr.IsContractedRate = 1

	INNER	JOIN LibertyPower..AccountStatus actS (nolock)
	ON		actS.AccountContractID = ac.AccountContractID
		
	--INNER	JOIN [LibertyPower].[dbo].[Price] pr(NOLOCK)
	--ON		acr.PriceID = pr.ID 
	--AND		pr.ProductTypeID IN ('1','7')
	
	INNER	JOIN Lp_common..common_product p (nolock)
	ON		acr.LegacyProductID = p.product_id
	AND		LTRIM(RTRIM(p.product_category)) = 'FIXED'

	LEFT	JOIN lp_deal_capture.dbo.deal_pricing_detail d (nolock)
	ON		acr.RateID = d.rate_id
	AND		p.product_id = d.product_id
	AND		p.IsCustom = 1   
	
	LEFT	JOIN lp_deal_capture.dbo.deal_pricing dp (nolock)
	ON		d.Deal_Pricing_ID = dp.Deal_Pricing_ID 

	WHERE	ISNULL(d.BackToBack,0) = 0

--AND 	1 = 2

	SET NOCOUNT OFF;
END	

	
