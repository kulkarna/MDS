USE [lp_MtM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE	[dbo].[usp_MtMAccountsCountByDateAndReportID]
		@SubmitDate DATETIME,
		@ReportID	INT
		
AS

-- exec usp_MtMAccountsCountByDateAndReportID '7/8/2012', '1'

BEGIN

	SET NOCOUNT ON;

	-- GEt the list of the latest MtM account information for all the contracts signed on "SubmitDate"
		SELECT	*
		INTO	#A
		FROM	MtMZainetAccountInfo WITH (NOLOCK)
		WHERE	MONTH(DateCreated) = MONTH(@SubmitDate)
		AND		DAY(DateCreated) = DAY(@SubmitDate)
		AND		YEAR(DateCreated) = YEAR(@SubmitDate)
		
		SELECT	m.AccountID, 
				m.ContractID, 
				a.ContractDealTypeID, 
				a.MarketCode, 
				a.ISO,
				a.UtilityCode, 
				~a.IsDaily as IsCustom,
				MAX(m.ID) as MtMID
		INTO	#Accounts
		FROM	MtMAccount  m (nolock)

		INNER	JOIN	#A a (nolock)
		ON		m.ContractID = a.ContractID
		AND		m.AccountID = a.AccountID
		
		INNER	JOIN LibertyPower..AccountStatus ast (nolock)
		ON		a.AccountContractID = ast.AccountContractID
		
		INNER	JOIN MtMReportStatus rs (nolock)
		ON		ast.Status = rs.Status
		AND		ast.SubStatus = rs.SubStatus
		AND		rs.ReportID = @ReportID

		GROUP	BY m.AccountID, m.ContractID, a.ContractDealTypeID, a.MarketCode, a.ISO, a.UtilityCode, a.IsDaily
		
		SELECT	a.MarketCode, a.ISO, a.UtilityCode, d.Value as Location,
				m.ProxiedProfile, m.ProxiedUsage, m.ProxiedLocation, a.ContractDealTypeID, a.IsCustom,
				Proxied =	CASE	WHEN m.ProxiedProfile = 1 OR m.ProxiedUsage = 1 OR  m.ProxiedLocation = 1 
										THEN '1' 
										ELSE '0' 
									END,
				Failed = CASE	WHEN m.Status like '%Failed%' THEN	1 ELSE 0 END,
				COUNT(Distinct m.ContractID) DealCount, COUNT(Distinct m.AccountID)AccountCount
		INTO	#A1
		FROM	#Accounts a	

		INNER	JOIN MtMAccount m (nolock)
		ON		a.MtMID = m.ID
		
		INNER	JOIN LibertyPower..PropertyInternalRef d (nolock)
		ON		m.SettlementLocationRefID = d.ID
		
		GROUP	BY 
				a.MarketCode, a.ISO ,a.UtilityCode, d.Value, a.ContractDealTypeID, a.IsCustom,
				m.ProxiedProfile, m.ProxiedUsage, m.ProxiedLocation,
				CASE	WHEN m.Status like '%Failed%' THEN	1 ELSE 0 END
				
				
		SELECT	MarketCode, ISO, UtilityCode, Location, ContractDealTypeID, IsCustom, Failed, 
				MAX(ProxiedDealCount) ProxiedDealCount, 
				MAX(DealCount) DealCount, 
				MAX(ProxiedAccountCount) ProxiedAccountCount, 
				MAX(AccountCount) AccountCount,
				MAX(ProxiedLocationAccountCount) ProxieLocationAccountCount,
				MAX(ProxiedProfileAccountCount) ProxiedProfileAccountCount,
				MAX(ProxiedUsageAccountCount) ProxiedUsageAccountCount
				
		FROM	(
				SELECT	MarketCode, ISO, UtilityCode, Location, ContractDealTypeID, IsCustom, Failed, 
						SUM(DealCount) as ProxiedDealCount, 0 as DealCount, 
						SUM(AccountCount) as ProxiedAccountCount, 0 as AccountCount,
						0 as ProxiedLocationAccountCount, 0 as ProxiedProfileAccountCount, 0 as ProxiedUsageAccountCount
						
				FROM	#A1
				WHERE	Proxied = 1
				GROUP	BY MarketCode, ISO, UtilityCode, Location, ContractDealTypeID, IsCustom, Failed
				
				UNION 
				
				SELECT	MarketCode, ISO, UtilityCode, Location, ContractDealTypeID, IsCustom, Failed, 
						0 as ProxiedDealCount, SUM(DealCount) as DealCount, 
						0 as ProxiedAccountCount, SUM(AccountCount) as AccountCount,
						0 as ProxiedLocationAccountCount, 0 as ProxiedProfileAccountCount, 0 as ProxiedUsageAccountCount
				FROM	#A1
				WHERE	Proxied = 0
				GROUP	BY MarketCode, ISO, UtilityCode, Location, ContractDealTypeID, IsCustom, Failed
				
				UNION 
				
				SELECT	MarketCode, ISO, UtilityCode, Location, ContractDealTypeID, IsCustom, Failed, 
						0 as ProxiedDealCount, 0 as DealCount, 
						0 as ProxiedAccountCount, 0 as AccountCount,
						SUM(AccountCount) as ProxiedLocationAccountCount, 0 as ProxiedProfileAccountCount, 0 as ProxiedUsageAccountCount
				FROM	#A1
				WHERE	ProxiedLocation = 1
				GROUP	BY MarketCode, ISO, UtilityCode, Location, ContractDealTypeID, IsCustom, Failed
				
				UNION 
				
				SELECT	MarketCode, ISO, UtilityCode, Location, ContractDealTypeID, IsCustom, Failed, 
						0 as ProxiedDealCount, 0 as DealCount, 
						0 as ProxiedAccountCount, 0 as AccountCount,
						0 as ProxiedLocationAccountCount, SUM(AccountCount) as ProxiedProfileAccountCount, 0 as ProxiedUsageAccountCount
				FROM	#A1
				WHERE	ProxiedProfile = 1
				GROUP	BY MarketCode, ISO, UtilityCode, Location, ContractDealTypeID, IsCustom, Failed
						
				UNION 
				
				SELECT	MarketCode, ISO, UtilityCode, Location, ContractDealTypeID, IsCustom, Failed, 
						0 as ProxiedDealCount, 0 as DealCount, 
						0 as ProxiedAccountCount, 0 as AccountCount,
						0 as ProxiedLocationAccountCount, 0 as ProxiedProfileAccountCount, SUM(AccountCount) as ProxiedUsageAccountCount
				FROM	#A1
				WHERE	ProxiedUsage = 1
				GROUP	BY MarketCode, ISO, UtilityCode, Location, ContractDealTypeID, IsCustom, Failed		
				
								)T
		GROUP	BY MarketCode, ISO, UtilityCode, Location, ContractDealTypeID, IsCustom, Failed

	SET NOCOUNT OFF;
END
