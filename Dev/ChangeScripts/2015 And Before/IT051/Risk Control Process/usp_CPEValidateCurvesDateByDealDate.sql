USE [lp_MtM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 10/28/2013
-- Description:	Procedure to validate all curves by deal date, test if there is most effective date for them
-- =============================================
CREATE PROCEDURE usp_CPEValidateCurvesDateByDealDate
(
	@MtMAccountID AS INT
) AS 
BEGIN
	
	SET NOCOUNT ON;

	SELECT	DISTINCT
			m.ID as MtMAccountID, m.AccountID, m.ContractID, m.SettlementLocationRefID
	INTO	#M
	FROM	MtMAccount m (nolock)
	WHERE	m.ID = @MtMAccountID
	
	SELECT	DISTINCT
			m.MtMAccountID, a.product_id, a.IsCustom, a.RateID,
			a.ISO, m.SettlementLocationRefID, DATEADD(D, 0, DATEDIFF(D, 0, a.SignedDate)) as DealDate, a.StartDate, a.EndDate
	INTO	#Accounts
	FROM	#M m (nolock)
	INNER	JOIN MtMZainetAccountInfo a (nolock)
	ON		m.AccountID = a.AccountID
	AND		m.ContractID = a.ContractID
	WHERE	a.IsDaily = 1
	
	CREATE CLUSTERED INDEX idx_Accounts_ID ON #Accounts (MtMAccountID)
	CREATE NONCLUSTERED INDEX idx_Accounts_IZ ON #Accounts (ISO,SettlementLocationRefID)
	CREATE NONCLUSTERED INDEX idx_Accounts_D ON #Accounts (StartDate,EndDate)
	
	-- Get the ISO, SettlementLocationRefIDs and deal dates in question for non custom accounts with flow start date in the future 
	SELECT	DISTINCT
			m.ISO, m.SettlementLocationRefID, m.DealDate
	INTO	#AccountData
	FROM	#Accounts m (nolock)
	
	(SELECT 'EnergyCurveCounter' as CounterType, COUNT(*) as "Counter"
	 FROM 
		#AccountData t1 (nolock)
		INNER JOIN MtMEnergyCurvesMostRecentEffectiveDate t3 (nolock) 
			ON t1.DealDate = t3.EffectiveDate)			
	UNION
	(SELECT 'SupplierPremiumCounter' as CounterType, COUNT(*) as "Counter"
	 FROM 
		#AccountData t1 (nolock) 
		INNER JOIN MtMSupplierPremiumsMostRecentEffectiveDate t3 (nolock) 
			ON t1.DealDate <= t3.EffectiveDate)			
	UNION
	(SELECT 'ShapingCounter' as CounterType, COUNT(*) as "Counter"
	 FROM 
		#AccountData t1 (nolock)
		INNER JOIN MtMShapingMostRecentEffectiveDate t3 (nolock) 
			ON t1.DealDate <= t3.EffectiveDate)			
	UNION
	(SELECT 'IntradayCounter' as CounterType, COUNT(*) as "Counter"
	 FROM 
		#AccountData t1 (nolock)
		INNER JOIN MtMIntradayMostRecentEffectiveDate t3 (nolock) 
			ON t1.DealDate <= t3.EffectiveDate)	
			
	SET NOCOUNT OFF;		
END
GO