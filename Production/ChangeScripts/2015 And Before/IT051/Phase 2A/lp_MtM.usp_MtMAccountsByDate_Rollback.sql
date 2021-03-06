USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMAccountsByDate]    Script Date: 03/14/2013 17:28:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	PROCEDURE	[dbo].[usp_MtMAccountsByDate]
		@SubmitDate DATETIME
		
AS

BEGIN
		SET NOCOUNT ON;
		
	
		SELECT	DISTINCT
				m.AccountID, 
				m.ContractID, 
				m.Zone,
				m.ProxiedProfile, m.ProxiedUsage, m.ProxiedZone, 
				m.Status,
				m.ID,
				a.ContractDealTypeID, 
				a.MarketCode, 
				a.ISO,
				a.UtilityCode,
				a.IsCustom	
		INTO	#MtMAccount
		FROM	MtMAccount  m (nolock)

		INNER	JOIN	MtMZainetAccountInfo a 
		ON		m.AccountID = a.AccountID
		AND		m.ContractID = a.ContractID

		WHERE	MONTH(a.DateCreated) = MONTH(@SubmitDate)
		AND		DAY(a.DateCreated) = DAY(@SubmitDate)
		AND		YEAR(a.DateCreated) = YEAR(@SubmitDate)
		
		
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
				m.Zone,
				m.ContractID, 
				m.ContractDealTypeID,
				m.AccountID, 
				m.ProxiedProfile, m.ProxiedUsage, m.ProxiedZone, 
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

