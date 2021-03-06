USE Libertypower
GO

  /*********************************************************************************************************/
 /**************************************      usp_MtMAccountsByDateAndReportID  ***************************/
/*********************************************************************************************************/

--exec usp_MtMAccountsByDateAndReportID '1/17/2011' , 1
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		get the summary data of the deals signed on a specific date	for a report ID		*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE	PROCEDURE	usp_MtMAccountsByDateAndReportID
		@SubmitDate DATETIME,
		@ReportID	INT
		
AS

BEGIN
		-- GEt the list of the latest MtM account information for all the contracts signed on "SubmitDate"
		SELECT	m.AccountID, 
				m.ContractID, 
				c.ContractDealTypeID, 
				mk.MarketCode, 
				u.WholeSaleMktID AS ISO,
				u.UtilityCode, 
				MAX(m.ID) as MtMID
		INTO	#Accounts
		FROM	MtMAccount  m (nolock)

		INNER	JOIN	Contract c (nolock)
		ON		m.ContractID = c.ContractID

		INNER	JOIN Account act (nolock)
		ON		m.AccountID = act.AccountID
		
		INNER	JOIN Utility u (nolock)
		ON		act.UtilityID = u.ID
		
		INNER	JOIN Market mk (nolock)
		ON		u.MarketID = mk.ID
		
		INNER	JOIN AccountContract ac
		ON		m.AccountID = ac.AccountID
		AND		m.ContractID = ac.ContractID
		
		INNER	JOIN AccountStatus ast
		ON		ac.AccountContractID = ast.AccountContractID
		
		INNER	JOIN MtMReportStatus rs
		ON		ast.Status = rs.Status
		AND		ast.SubStatus = rs.SubStatus
		AND		rs.ReportID = @ReportID

		WHERE	MONTH(c.SignedDate) = MONTH(@SubmitDate)
		AND		DAY(c.SignedDate) = DAY(@SubmitDate)
		AND		YEAR(c.SignedDate) = YEAR(@SubmitDate)

		GROUP	BY m.AccountID, m.ContractID, c.ContractDealTypeID, mk.MarketCode, u.WholeSaleMktID, u.UtilityCode

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
				p.IsCustom,
				m.Status,
				ISNULL(L.Usage, 0) AS Usage
		FROM	#Accounts a

		INNER	JOIN MtMAccount m (nolock)
		ON		a.MtMID = m.ID
		
		INNER	JOIN AccountContract ac (nolock)
		ON		m.AccountID = ac.AccountID
		AND		m.ContractID = ac.ContractID

		INNER	JOIN AccountContractRate acr (nolock)
		ON		ac.AccountContractID = acr.AccountContractID
		AND		acr.IsContractedRate = 1

		INNER	JOIN Lp_common..common_product p (nolock)
		ON		acr.LegacyProductID = p.product_id
				
		LEFT	JOIN #LOAD L (nolock)
		ON		m.ID = L.MtMAccountID

END

GO

  /*********************************************************************************************************/
 /*********************************  usp_MtMDealsDetailAndReportID   **************************************/
/*********************************************************************************************************/

--exec usp_MtMDealsDetailAndReportID '1/17/2011' , 1
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		get the detailed data of the deals signed on a specific date and ReportID		*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE	usp_MtMDealsDetailAndReportID
		@SubmitDate DATETIME,
		@ReportID INT
		
AS

BEGIN
		-- GEt the list of the latest MtM account information for all the contracts signed on "SubmitDate"
		SELECT	m.AccountID, c.ContractID, c.Number, c.ContractDealTypeID, MAX(m.ID) as MtMID
		INTO	#Accounts
		FROM	MtMAccount  m (nolock)

		INNER	JOIN	Contract c (nolock)
		ON		m.ContractID = c.ContractID
		
		INNER	JOIN AccountContract ac
		ON		m.AccountID = ac.AccountID
		AND		m.ContractID = ac.ContractID
		
		INNER	JOIN AccountStatus ast
		ON		ac.AccountContractID = ast.AccountContractID
		
		INNER	JOIN MtMReportStatus rs
		ON		ast.Status = rs.Status
		AND		ast.SubStatus = rs.SubStatus
		AND		rs.ReportID = @ReportID
		
		WHERE	MONTH(c.SignedDate) = MONTH(@SubmitDate)
		AND		DAY(c.SignedDate) = DAY(@SubmitDate)
		AND		YEAR(c.SignedDate) = YEAR(@SubmitDate)

		GROUP	BY m.AccountID, c.Number, c.ContractID,  c.ContractDealTypeID
		
		-- Get the total load forecasted for each account
		SELECT	a.Number, a.ContractID, SUM(Int1 + Int2 + Int3 + Int4 + Int5 + Int6 + Int7 + Int8 + Int9 + Int10 + Int11 + Int12 + Int13 + Int14 + Int15 + Int16 + Int17 + Int18 + Int19 + Int20 + Int21 + Int22 + Int23 + Int24 ) AS Usage
		INTO	#LOAD
		FROM	MtMDailyLoadForecast	l
		INNER	JOIN 	#Accounts a
		ON		a.MtMID = l.MtMAccountID
		GROUP	BY a.Number	,a.ContractID
		
		-- Get the number of proxied accounts by contract
		SELECT	a.ContractID, a.Number, COUNT(a.MtMID) as NumberOfProxiedAccounts
		INTO	#Proxied
		FROM	#Accounts a
		INNER	JOIN MtMAccount m (nolock)
		ON		a.MtMID = m.ID
		WHERE	(		m.ProxiedProfile = 1
				OR		m.ProxiedUsage = 1
				OR		m.ProxiedZone = 1
				)
		GROUP	BY a.Number, a.ContractID

		-- Get the Contract numbers along with their total number accounts, proxied accounts, usage, 
		SELECT	a.ContractID,
				a.Number, 
				COUNT(DISTINCT a.MtMID) as NumberOfAccounts,
				ISNULL(pr.NumberOfProxiedAccounts, 0) as NumberOfProxiedAccounts,
				ISNULL(L.Usage,0) as Usage,
				m.Status,
				a.ContractDealTypeID,	
				p.IsCustom,
				MIN(m.BatchNumber) as BatchNumber,
				MIN(m.QuoteNumber) as QuoteNumber				
		FROM	#Accounts a
				
		INNER	JOIN MtMAccount m (nolock)
		ON		a.MtMID = m.ID
				
		INNER	JOIN AccountContract ac (nolock)
		ON		m.AccountID = ac.AccountID
		AND		m.ContractID = ac.ContractID

		INNER	JOIN AccountContractRate acr (nolock)
		ON		ac.AccountContractID = acr.AccountContractID
		AND		acr.IsContractedRate = 1

		INNER	JOIN Lp_common..common_product p (nolock)
		ON		acr.LegacyProductID = p.product_id
				
		LEFT	JOIN #Load L
		On		L.Number = a.Number
		
		LEFT	JOIN #Proxied pr
		ON		a.Number = pr.Number

		GROUP	BY	a.ContractID,
					a.Number, 
					a.ContractDealTypeID,	
					m.Status,
					ISNULL(L.Usage,0),
					p.IsCustom,
					ISNULL(pr.NumberOfProxiedAccounts, 0)
END

GO

  /*********************************************************************************************************/
 /**************************************      usp_MtMAccountsCountByDateAndReportID  **********************/
/*********************************************************************************************************/

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		GEt the list of the latest MtM account information for all the contracts		*
					signed on "SubmitDate" and ReportID											*
 *	Modified:																					*
 ********************************************************************************************** */

--exec usp_MtMAccountsCountByDateAndReportID '1/17/2011', 1
CREATE PROCEDURE	usp_MtMAccountsCountByDateAndReportID
		@SubmitDate DATETIME,
		@ReportID	INT
		
AS

BEGIN
	-- GEt the list of the latest MtM account information for all the contracts signed on "SubmitDate"
	-- GEt the list of the latest MtM account information for all the contracts signed on "SubmitDate"
		SELECT	m.AccountID, 
				m.ContractID, 
				c.ContractDealTypeID, 
				mk.MarketCode, 
				u.WholeSaleMktID AS ISO,
				u.UtilityCode, 
				MAX(m.ID) as MtMID
		INTO	#Accounts
		FROM	MtMAccount  m (nolock)

		INNER	JOIN	Contract c (nolock)
		ON		m.ContractID = c.ContractID

		INNER	JOIN Account act (nolock)
		ON		m.AccountID = act.AccountID
		
		INNER	JOIN Utility u (nolock)
		ON		act.UtilityID = u.ID
		
		INNER	JOIN Market mk (nolock)
		ON		u.MarketID = mk.ID

		INNER	JOIN AccountContract ac
		ON		m.AccountID = ac.AccountID
		AND		m.ContractID = ac.ContractID
		
		INNER	JOIN AccountStatus ast
		ON		ac.AccountContractID = ast.AccountContractID
		
		INNER	JOIN MtMReportStatus rs
		ON		ast.Status = rs.Status
		AND		ast.SubStatus = rs.SubStatus
		AND		rs.ReportID = @ReportID

		WHERE	MONTH(c.SignedDate) = MONTH(@SubmitDate)
		AND		DAY(c.SignedDate) = DAY(@SubmitDate)
		AND		YEAR(c.SignedDate) = YEAR(@SubmitDate)

		GROUP	BY m.AccountID, m.ContractID, c.ContractDealTypeID, mk.MarketCode, u.WholeSaleMktID, u.UtilityCode
		
		SELECT	a.MarketCode, a.ISO, a.UtilityCode, m.Zone,
				m.ProxiedProfile, m.ProxiedUsage, m.ProxiedZone, a.ContractDealTypeID, p.IsCustom,
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
		
		INNER	JOIN AccountContract ac (nolock)
		ON		m.AccountID = ac.AccountID
		AND		m.ContractID = ac.ContractID

		INNER	JOIN AccountContractRate acr (nolock)
		ON		ac.AccountContractID = acr.AccountContractID
		AND		acr.IsContractedRate = 1

		INNER	JOIN Lp_common..common_product p (nolock)
		ON		acr.LegacyProductID = p.product_id
		
		GROUP	BY 
				a.MarketCode, a.ISO ,a.UtilityCode, m.Zone, a.ContractDealTypeID, p.IsCustom,
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



GO

