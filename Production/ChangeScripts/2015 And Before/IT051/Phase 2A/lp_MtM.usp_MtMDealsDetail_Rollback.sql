USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMDealsDetail]    Script Date: 03/14/2013 17:28:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [usp_MtMDealsDetail] '11/20/2012'

 ALTER PROCEDURE	[dbo].[usp_MtMDealsDetail]
		@SubmitDate DATETIME
		
AS


BEGIN
		-- GEt the list of the latest MtM account information for all the contracts signed on "SubmitDate"
		SELECT	m.AccountID, c.ContractID, c.ContractNumber as Number, c.ContractDealTypeID, c.IsCustom, MAX(m.ID) as MtMID
		INTO	#Accounts
		FROM	MtMAccount  m (nolock)

		INNER	JOIN	MtMZainetAccountInfo c (nolock)
		ON		m.ContractID = c.ContractID
		
		WHERE	MONTH(c.DateCreated) = MONTH(@SubmitDate)
		AND		DAY(c.DateCreated) = DAY(@SubmitDate)
		AND		YEAR(c.DateCreated) = YEAR(@SubmitDate)

		GROUP	BY m.AccountID, c.ContractNumber, c.ContractID,  c.ContractDealTypeID, c.IsCustom
		
		
		--CREATE NONCLUSTERED INDEX idx_AccountMtMID ON dbo.#Accounts (MtMID ASC)
		
		-- Get the total load forecasted for each account	
		SELECT	a.Number, a.ContractID, a.MtMID, SUM(Int1 + Int2 + Int3 + Int4 + Int5 + Int6 + Int7 + Int8 + Int9 + Int10 + Int11 + Int12 + Int13 + Int14 + Int15 + Int16 + Int17 + Int18 + Int19 + Int20 + Int21 + Int22 + Int23 + Int24 ) AS Usage
		INTO	#LOAD
		FROM	MtMDailyLoadForecast	l
		INNER	JOIN 	#Accounts a
		ON		a.MtMID = l.MtMAccountID
		GROUP	BY a.Number	,a.ContractID, a.MtMID
		
		-- Get the number of proxied accounts by contract
		SELECT	a.ContractID, a.Number, BatchNumber, QuoteNumber, COUNT(a.MtMID) as NumberOfProxiedAccounts
		INTO	#Proxied
		FROM	#Accounts a
		INNER	JOIN MtMAccount m (nolock)
		ON		a.MtMID = m.ID
		WHERE	(		m.ProxiedProfile = 1
				OR		m.ProxiedUsage = 1
				OR		m.ProxiedZone = 1
				)
		GROUP	BY a.Number, a.ContractID, BatchNumber, QuoteNumber

		-- Get the Contract numbers along with their total number accounts, proxied accounts, usage, 
		SELECT	a.ContractID,
				a.Number, 
				COUNT(DISTINCT a.MtMID) as NumberOfAccounts,
				ISNULL(pr.NumberOfProxiedAccounts, 0) as NumberOfProxiedAccounts,
				ISNULL(SUM(L.Usage),0) as Usage,
				m.Status,
				a.ContractDealTypeID,	
				a.IsCustom,
				m.BatchNumber,
				m.QuoteNumber				
		FROM	#Accounts a
				
		INNER	JOIN MtMAccount m (nolock)
		ON		a.MtMID = m.ID
								
		LEFT	JOIN #Load L
		On		L.Number = a.Number
		AND		L.MtMID = a.MtMID
		
		LEFT	JOIN #Proxied pr
		ON		m.ContractID = pr.ContractID
		AND		m.BatchNumber = pr.BatchNumber
		AND		m.QuoteNumber = pr.QuoteNumber

		GROUP	BY	a.ContractID,
					a.Number, 
					a.ContractDealTypeID,	
					m.Status,
					--ISNULL(L.Usage,0),
					a.IsCustom,
					ISNULL(pr.NumberOfProxiedAccounts, 0),
					m.BatchNumber,
					m.QuoteNumber
	END

