USE [lp_MtM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the list of accounts processed on a submit date														*
 *  To Run:		exec usp_MtMAccountsByDate	'1/3/2013'																	*
  *	Modified:																											*
 ************************************************************************************************************************/

ALTER	PROCEDURE	[dbo].[usp_MtMAccountsByDate]
		@SubmitDate DATETIME
		
AS

BEGIN
		SET NOCOUNT ON;
		
SELECT	DISTINCT *
INTO	#MtMAccount
FROM	(	
		SELECT	DISTINCT
				m.AccountID, 
				m.ContractID, 
				d.Value AS Location,
				m.ProxiedProfile, m.ProxiedUsage, m.ProxiedLocation, 
				m.Status,
				m.ID,
				a.ContractDealTypeID, 
				a.MarketCode, 
				a.ISO,
				a.UtilityCode,
				a.IsCustom	
		FROM	MtMAccount  m (nolock)

		INNER	JOIN	MtMZainetAccountInfo a   (nolock)
		ON		m.AccountID = a.AccountID
		AND		m.ContractID = a.ContractID
		
		INNER	JOIN LibertyPower..PropertyInternalRef d (nolock)
		ON		m.SettlementLocationRefID = d.ID

		WHERE	m.CustomDealID is null
		AND		MONTH(a.DateCreated) = MONTH(@SubmitDate)
		AND		DAY(a.DateCreated) = DAY(@SubmitDate)
		AND		YEAR(a.DateCreated) = YEAR(@SubmitDate)

UNION
	SELECT	DISTINCT
			m.AccountID,
			m.ContractID,
			d.Value AS Location,
			m.ProxiedProfile, m.ProxiedUsage, m.ProxiedLocation,
			m.Status,
			m.ID,
			null as ContractDealTypeID,
			mkt.MarketCode as MarketCode,
			u.WholeSaleMktID as ISO,
			u.UtilityCode as UtilityCode,
			1 as IsCustom
	FROM	MtMAccount m (nolock)
	INNER	JOIN LibertyPower..Account act (nolock) ON m.AccountID = act.AccountID
	INNER	JOIN LibertyPower..Utility u (nolock) ON u.ID = act.UtilityID
	INNER	JOIN LibertyPower..Market mkt (nolock) ON u.MarketID = mkt.ID
	INNER	JOIN LibertyPower..PropertyInternalRef d (nolock)
	ON		m.SettlementLocationRefID = d.ID
			
	WHERE	m.CustomDealID is not null
	AND		MONTH(m.DateCreated) = MONTH(@SubmitDate)
	AND		DAY(m.DateCreated) = DAY(@SubmitDate)
	AND		YEAR(m.DateCreated) = YEAR(@SubmitDate)
) AS ACCT		
		
		CREATE NONCLUSTERED INDEX idx_mACID ON dbo.#MtMAccount (AccountID,ContractID ASC)

		SELECT	m.AccountID, 
				m.ContractID, 
				MAX(m.ID) as MtMID
		INTO	#Max
		FROM	#MtMAccount  m (nolock)

		GROUP	BY m.AccountID, 
				m.ContractID
				
		CREATE NONCLUSTERED INDEX idx_mxMtMID ON dbo.#Max (MtMID ASC)		
		
		-- Get the total load forecasted for each account
		SELECT	l.MtMAccountID, 
				SUM(Int1 + Int2 + Int3 + Int4 + Int5 + Int6 + Int7 + Int8 + Int9 + Int10 + Int11 + Int12 + Int13 + Int14 + Int15 + Int16 + Int17 + Int18 + Int19 + Int20 + Int21 + Int22 + Int23 + Int24 ) AS Usage
		INTO	#LOAD
		FROM	MtMDailyLoadForecast	l (nolock)
		INNER	JOIN 	#Max a
		ON		a.MtMID = l.MtMAccountID
		GROUP	BY l.MtMAccountID
	
		SELECT	m.MarketCode, 
				m.ISO,
				m.UtilityCode,
				m.Location,
				m.ContractID, 
				m.ContractDealTypeID,
				m.AccountID, 
				m.ProxiedProfile, m.ProxiedUsage, m.ProxiedLocation, 
				m.IsCustom,
				m.Status,
				ISNULL(L.Usage, 0) AS Usage
		FROM	#Max a

		INNER	JOIN #MtMAccount m (nolock)
		ON		a.MtMID = m.ID
		
		LEFT	JOIN #LOAD L (nolock)
		ON		m.ID = L.MtMAccountID
		
		SET NOCOUNT OFF;
END

