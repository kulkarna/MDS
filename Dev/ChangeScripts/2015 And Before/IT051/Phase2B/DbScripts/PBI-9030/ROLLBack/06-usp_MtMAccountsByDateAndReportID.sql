USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMAccountsByDateAndReportID]    Script Date: 12/09/2013 15:58:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	PROCEDURE	[dbo].[usp_MtMAccountsByDateAndReportID]
		@SubmitDate DATETIME,
		@ReportID	INT
		
AS

BEGIN
		-- GEt the list of the latest MtM account information for all the contracts signed on "SubmitDate"
		SELECT	*
		INTO	#A
		FROM	MtMZainetAccountInfo
		WHERE	MONTH(DateCreated) = MONTH(@SubmitDate)
		AND		DAY(DateCreated) = DAY(@SubmitDate)
		AND		YEAR(DateCreated) = YEAR(@SubmitDate)
				
		SELECT	m.AccountID, 
				m.ContractID, 
				a.ContractDealTypeID, 
				a.MarketCode, 
				a.ISO,
				a.UtilityCode, 
				a.IsCustom,
				MAX(m.ID) as MtMID
		INTO	#Accounts
		FROM	MtMAccount  m (nolock)

		INNER	JOIN	#A a (nolock)
		ON		m.ContractID = a.ContractID
		AND		m.AccountID = a.AccountID
			
		INNER	JOIN LibertyPower..AccountStatus ast
		ON		a.AccountContractID = ast.AccountContractID
		
		INNER	JOIN MtMReportStatus rs
		ON		ast.Status = rs.Status
		AND		ast.SubStatus = rs.SubStatus
		AND		rs.ReportID = @ReportID



		GROUP	BY m.AccountID, m.ContractID, a.ContractDealTypeID, a.MarketCode, a.ISO, a.UtilityCode, a.IsCustom

		-- Get the total load forecasted for each account
		SELECT	a.MtMID as MtMAccountID, 
				SUM(Int1 + Int2 + Int3 + Int4 + Int5 + Int6 + Int7 + Int8 + Int9 + Int10 + Int11 + Int12 + Int13 + Int14 + Int15 + Int16 + Int17 + Int18 + Int19 + Int20 + Int21 + Int22 + Int23 + Int24 ) AS Usage
		INTO	#LOAD
		FROM	MtMDailyLoadForecast	l
		INNER	JOIN 	#Accounts a
		ON		a.MtMID = l.MtMAccountID
		GROUP	BY a.MtMID	
	
		SELECT	a.MarketCode, 
				a.ISO,
				a.UtilityCode,
				m.Zone,
				m.ContractID, 
				a.ContractDealTypeID,
				m.AccountID, 
				m.ProxiedProfile, m.ProxiedUsage, m.ProxiedZone, 
				a.IsCustom,
				m.Status,
				ISNULL(L.Usage, 0) AS Usage
		FROM	#Accounts a

		INNER	JOIN MtMAccount m (nolock)
		ON		a.MtMID = m.ID
						
		LEFT	JOIN #LOAD L (nolock)
		ON		m.ID = L.MtMAccountID

END

