USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMAccountsCountByDate]    Script Date: 03/14/2013 17:28:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE	[dbo].[usp_MtMAccountsCountByDate]
		@SubmitDate DATETIME
		
AS


BEGIN
		--DECLARE	@SubmitDate AS DATETIME
		--SET		@SubmitDate = '12/10/2010'
		
		-- GEt the list of the latest MtM account information for all the contracts signed on "SubmitDate"
	-- GEt the list of the latest MtM account information for all the contracts signed on "SubmitDate"
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

		INNER	JOIN	MtMZainetAccountInfo a (nolock)
		ON		m.ContractID = a.ContractID
		AND		m.AccountID = a.AccountID
		
		WHERE	MONTH(a.DateCreated) = MONTH(@SubmitDate)
		AND		DAY(a.DateCreated) = DAY(@SubmitDate)
		AND		YEAR(a.DateCreated) = YEAR(@SubmitDate)

		GROUP	BY m.AccountID, m.ContractID, a.ContractDealTypeID, a.MarketCode, a.ISO, a.UtilityCode, a.IsCustom
		
		SELECT	a.MarketCode, a.ISO, a.UtilityCode, m.Zone,
				m.ProxiedProfile, m.ProxiedUsage, m.ProxiedZone, a.ContractDealTypeID, a.IsCustom,
				Proxied =	CASE	WHEN m.ProxiedProfile = 1 OR m.ProxiedUsage = 1 OR  m.ProxiedZone = 1 
										THEN '1' 
										ELSE '0' 
									END,
				Failed = CASE	WHEN m.Status like '%Failed%' THEN	1 ELSE 0 END,
				COUNT(Distinct m.ContractID) DealCount, COUNT(Distinct m.AccountID)AccountCount
		INTO	#A1
		FROM	#Accounts a	

		INNER	JOIN MtMAccount m (nolock)
		ON		a.MtMID = m.ID
		
		GROUP	BY 
				a.MarketCode, a.ISO ,a.UtilityCode, m.Zone, a.ContractDealTypeID, a.IsCustom,
				m.ProxiedProfile, m.ProxiedUsage, m.ProxiedZone,
				CASE	WHEN m.Status like '%Failed%' THEN	1 ELSE 0 END
				
				
		SELECT	MarketCode, ISO, UtilityCode, Zone, ContractDealTypeID, IsCustom, Failed, 
				MAX(ProxiedDealCount) ProxiedDealCount, 
				MAX(DealCount) DealCount, 
				MAX(ProxiedAccountCount) ProxiedAccountCount, 
				MAX(AccountCount) AccountCount,
				MAX(ProxiedZoneAccountCount) ProxiedZoneAccountCount,
				MAX(ProxiedProfileAccountCount) ProxiedProfileAccountCount,
				MAX(ProxiedUsageAccountCount) ProxiedUsageAccountCount
				
		FROM	(
				SELECT	MarketCode, ISO, UtilityCode, Zone, ContractDealTypeID, IsCustom, Failed, 
						SUM(DealCount) as ProxiedDealCount, 0 as DealCount, 
						SUM(AccountCount) as ProxiedAccountCount, 0 as AccountCount,
						0 as ProxiedZoneAccountCount, 0 as ProxiedProfileAccountCount, 0 as ProxiedUsageAccountCount
						
				FROM	#A1
				WHERE	Proxied = 1
				GROUP	BY MarketCode, ISO, UtilityCode, Zone, ContractDealTypeID, IsCustom, Failed
				
				UNION 
				
				SELECT	MarketCode, ISO, UtilityCode, Zone, ContractDealTypeID, IsCustom, Failed, 
						0 as ProxiedDealCount, SUM(DealCount) as DealCount, 
						0 as ProxiedAccountCount, SUM(AccountCount) as AccountCount,
						0 as ProxiedZoneAccountCount, 0 as ProxiedProfileAccountCount, 0 as ProxiedUsageAccountCount
				FROM	#A1
				WHERE	Proxied = 0
				GROUP	BY MarketCode, ISO, UtilityCode, Zone, ContractDealTypeID, IsCustom, Failed
				
				UNION 
				
				SELECT	MarketCode, ISO, UtilityCode, Zone, ContractDealTypeID, IsCustom, Failed, 
						0 as ProxiedDealCount, 0 as DealCount, 
						0 as ProxiedAccountCount, 0 as AccountCount,
						SUM(AccountCount) as ProxiedZoneAccountCount, 0 as ProxiedProfileAccountCount, 0 as ProxiedUsageAccountCount
				FROM	#A1
				WHERE	ProxiedZone = 1
				GROUP	BY MarketCode, ISO, UtilityCode, Zone, ContractDealTypeID, IsCustom, Failed
				
				UNION 
				
				SELECT	MarketCode, ISO, UtilityCode, Zone, ContractDealTypeID, IsCustom, Failed, 
						0 as ProxiedDealCount, 0 as DealCount, 
						0 as ProxiedAccountCount, 0 as AccountCount,
						0 as ProxiedZoneAccountCount, SUM(AccountCount) as ProxiedProfileAccountCount, 0 as ProxiedUsageAccountCount
				FROM	#A1
				WHERE	ProxiedProfile = 1
				GROUP	BY MarketCode, ISO, UtilityCode, Zone, ContractDealTypeID, IsCustom, Failed
						
				UNION 
				
				SELECT	MarketCode, ISO, UtilityCode, Zone, ContractDealTypeID, IsCustom, Failed, 
						0 as ProxiedDealCount, 0 as DealCount, 
						0 as ProxiedAccountCount, 0 as AccountCount,
						0 as ProxiedZoneAccountCount, 0 as ProxiedProfileAccountCount, SUM(AccountCount) as ProxiedUsageAccountCount
				FROM	#A1
				WHERE	ProxiedUsage = 1
				GROUP	BY MarketCode, ISO, UtilityCode, Zone, ContractDealTypeID, IsCustom, Failed		
				
								)T
		GROUP	BY MarketCode, ISO, UtilityCode, Zone, ContractDealTypeID, IsCustom, Failed
END		



