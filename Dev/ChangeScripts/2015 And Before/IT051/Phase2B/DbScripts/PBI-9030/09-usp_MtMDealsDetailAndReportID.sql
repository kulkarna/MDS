USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMDealsDetailAndReportID]    Script Date: 09/30/2013 16:33:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE	[dbo].[usp_MtMDealsDetailAndReportID]
		@SubmitDate DATETIME,
		@ReportID INT
		
AS


BEGIN
	
	SET NOCOUNT ON;

		-- GEt the list of the latest MtM account information for all the contracts signed on "SubmitDate"
		SELECT	*
		INTO	#A
		FROM	MtMZainetAccountInfo WITH (NOLOCK)
		WHERE	MONTH(DateCreated) = MONTH(@SubmitDate)
		AND		DAY(DateCreated) = DAY(@SubmitDate)
		AND		YEAR(DateCreated) = YEAR(@SubmitDate)


		SELECT	m.AccountID, a.ContractID, a.ContractNumber as Number, a.ContractDealTypeID, ~a.IsDaily as IsCustom, MAX(m.ID) as MtMID
		INTO	#Accounts
		FROM	MtMAccount  m (nolock)

		INNER	JOIN	#A a (nolock)
		ON		m.ContractID = a.ContractID
		AND		m.AccountID = a.AccountID
		
		INNER	JOIN LibertyPower..AccountStatus ast WITH (NOLOCK)
		ON		a.AccountContractID = ast.AccountContractID
		
		INNER	JOIN MtMReportStatus rs WITH (NOLOCK)
		ON		ast.Status = rs.Status
		AND		ast.SubStatus = rs.SubStatus
		AND		rs.ReportID = @ReportID

		GROUP	BY m.AccountID, a.ContractNumber, a.ContractID,  a.ContractDealTypeID, ~a.IsDaily
		
		-- Get the total load forecasted for each account
		SELECT	a.Number, a.ContractID, a.MtMID, SUM(Int1 + Int2 + Int3 + Int4 + Int5 + Int6 + Int7 + Int8 + Int9 + Int10 + Int11 + Int12 + Int13 + Int14 + Int15 + Int16 + Int17 + Int18 + Int19 + Int20 + Int21 + Int22 + Int23 + Int24 ) AS Usage
		INTO	#LOAD
		FROM	MtMDailyLoadForecast	l  WITH (NOLOCK)
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
				OR		m.ProxiedLocation = 1
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
		ON		a.Number = pr.Number
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

	SET NOCOUNT OFF;
END

