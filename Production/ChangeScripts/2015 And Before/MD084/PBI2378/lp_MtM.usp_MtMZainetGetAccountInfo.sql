--LUCA NEEDS TO CREATE A SYNONYM FOR vw_AccountContractRate in lp_MtM

USE LIBERTYPOWER -- IN SQL9

GO

CREATE SYNONYM [dbo].vw_accountContractRate FOR [LNKSRVTOSQLPROD].[Libertypower].[dbo].vw_accountContractRate

GO

CREATE SYNONYM [dbo].Price FOR [LNKSRVTOSQLPROD].[Libertypower].[dbo].Price

GO

CREATE SYNONYM [dbo].ProductBrand FOR [LNKSRVTOSQLPROD].[Libertypower].[dbo].ProductBrand

USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMZainetGetAccountInfo]    Script Date: 11/14/2012 12:21:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	PROCEDURE [dbo].[usp_MtMZainetGetAccountInfo]

AS

BEGIN

	TRUNCATE TABLE	MtMZainetAccountInfo
	
	-- Get the fixed product info
	SELECT	DISTINCT
			AccountContractID, p.product_id, IsCustom, RateID, d.BackToBack, RateStart, RateEnd
	INTO	#ACR
	FROM	LibertyPower..vw_AccountContractRate acr (nolock)
	
	INNER	JOIN Lp_common..common_product p (nolock)
	ON		acr.LegacyProductID = p.product_id
	AND		LTRIM(RTRIM(p.product_category)) = 'FIXED'

	LEFT	JOIN lp_deal_capture.dbo.deal_pricing_detail d (nolock)
	ON		acr.RateID = d.rate_id
	AND		p.product_id = d.product_id
	AND		p.IsCustom = 1
	
	-- Get the Multi term product info
	INSERT	INTO #ACR		
	SELECT	DISTINCT
			AccountContractID, acr.LegacyProductID as product_id, pb.IsCustom, acr.RateID, null as BackToBack, RateStart, RateEnd
	FROM	LibertyPower..vw_AccountContractRate acr (nolock)
		
	INNER	JOIN LibertyPower..Price p
	ON		p.ID = acr.PriceID
	AND		p.ProductTypeID = 7 --Multi-Term
	
	INNER	JOIN LibertyPower..ProductBrand pb
	ON		p.ProductBrandID = pb.ProductBrandID
		
	--Get the new contracts
	INSERT	INTO	MtMZainetAccountInfo	(
			AccountID,
			AccountNumber,
			AccountIdLegacy,
			ContractID,
			ContractNumber,
			AccountContractID,
			ContractDealTypeID,
			UtilityID,
			UtilityCode,
			SignedDate,
			StartDate,
			EndDate,
			ISO,
			MarketCode,
			product_id,
			RateID,
			IsCustom,
			BackToBack,
			Status,
			SubStatus,
			DateCreated
			)
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
			mk.MarketCode,
			acr.product_id, 
			acr.RateID, 
			acr.IsCustom, 
			acr.BackToBack,
			actS.Status,
			actS.SubStatus,
			c.DateCreated

	FROM	LibertyPower..Account	act (nolock)
	
	INNER	JOIN LibertyPower..AccountContract ac (nolock)
	ON		act.AccountID = ac.AccountID
	AND		(	act.CurrentContractID = ac.ContractID
			OR	act.CurrentRenewalContractID = ac.ContractID
			)
	
	INNER	JOIN  LibertyPower..Contract c (nolock)
	ON		act.CurrentContractID = c.ContractID
	
	INNER	JOIN LibertyPower..Utility u (nolock)
	ON		act.UtilityID = u.ID
	
	INNER	JOIN LibertyPower..Market mk (nolock)
	ON		u.MarketID = mk.ID
			
	INNER	JOIN #ACR acr 
	ON		ac.AccountContractID = acr.AccountContractID
	
	INNER	JOIN LibertyPower..AccountStatus actS (nolock)
	ON		actS.AccountContractID = ac.AccountContractID
END	
	

