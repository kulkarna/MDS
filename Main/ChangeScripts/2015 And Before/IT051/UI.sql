USE Libertypower
GO

  /*********************************************************************************************************/
 /**************************************      usp_MtMDealsSummary  ****************************************/
/*********************************************************************************************************/

--exec usp_MtMAccountsByDate '1/17/2011' 
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		get the summary data of the deals signed on a specific date						*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE	PROCEDURE	usp_MtMAccountsByDate
		@SubmitDate DATETIME
		
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
 /**************************************      usp_MtMDealsDetail   ****************************************/
/*********************************************************************************************************/

--exec usp_MtMDealsDetail '1/17/2011' 
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		get the detailed data of the deals signed on a specific date					*
 *	Modified:																					*
 ********************************************************************************************** */
 ALTER PROCEDURE	usp_MtMDealsDetail
		@SubmitDate DATETIME
		
AS

BEGIN
		-- GEt the list of the latest MtM account information for all the contracts signed on "SubmitDate"
		SELECT	m.AccountID, c.ContractID, c.Number, c.ContractDealTypeID, MAX(m.ID) as MtMID
		INTO	#Accounts
		FROM	MtMAccount  m (nolock)

		INNER	JOIN	Contract c (nolock)
		ON		m.ContractID = c.ContractID
		
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
 /**************************************      usp_MtMViewLogs   *******************************************/
/*********************************************************************************************************/
--exec usp_MtMViewLogs 'd4895d0b-bc4e-4b81-85d5-462e0fabc47c', 'DealCapture-2010006908JD'
GO
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		view logs for a batch/quote number												*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_MtMViewLogs (
		@BatchNumber AS VARCHAR(50),
		@QuoteNumber AS VARCHAR(50)
)

AS

BEGIN

	SELECT	DISTINCT
			ID, Description, Type, DateCreated
	FROM	MtMTracking (nolock)
	WHERE	(QuoteNumber = @QuoteNumber
	AND		BatchNumber = @BatchNumber)
	OR		(Description like '%' + @BatchNumber + '%' + @QuoteNumber + '%')
	ORDER	BY ID

END

GO


  /*********************************************************************************************************/
 /**************************************      usp_MtMAccountsCountByDate   ********************************/
/*********************************************************************************************************/
--exec usp_MtMAccountsCountByDate '12/10/2010'
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		GEt the list of the latest MtM account information for all the contracts		*
					signed on "SubmitDate"														*
 *	Modified:																					*
 ********************************************************************************************** */

--exec usp_MtMAccountsCountByDate '1/17/2011'
CREATE PROCEDURE	usp_MtMAccountsCountByDate
		@SubmitDate DATETIME
		
AS

BEGIN
		--DECLARE	@SubmitDate AS DATETIME
		--SET		@SubmitDate = '12/10/2010'
		
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

  /*********************************************************************************************************/
 /**************************************      usp_MtMAccountsByContract  **********************************/
/*********************************************************************************************************/

--exec usp_MtMAccountsByContract '2269', '8e4cbb8c-382e-4baa-97c6-40d4dce93f67'
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	1/5/2012																		*
 *	Descp:		get the list of accounts by contract and batch number  						    *
 *	Modified:																					*
 ********************************************************************************************** */
 CREATE	PROCEDURE	usp_MtMAccountsByContract
		@ContractID INT,
		@BatchNumber VARCHAR(50)
		
AS

BEGIN

	 SELECT	a.ContractID,
			a.AccountID,
			act.AccountNumber,
			act.AccountIdLegacy,
			mk.MarketCode, 
			u.WholeSaleMktID AS ISO,
			u.UtilityCode, 
			a.Zone,
			ISNULL(SUM(Int1 + Int2 + Int3 + Int4 + Int5 + Int6 + Int7 + Int8 + Int9 + Int10 + Int11 + Int12 + Int13 + Int14 + Int15 + Int16 + Int17 + Int18 + Int19 + Int20 + Int21 + Int22 + Int23 + Int24 ),0) AS Usage
			
	FROM	MtMAccount a
	INNER	JOIN Account act
	ON		a.AccountID = act.AccountID

	INNER	JOIN	Contract c (nolock)
	ON		a.ContractID = c.ContractID
			
	INNER	JOIN Utility u (nolock)
	ON		act.UtilityID = u.ID
			
	INNER	JOIN Market mk (nolock)
	ON		u.MarketID = mk.ID

	LEFT	JOIN MtMDailyLoadForecast	l
	ON		a.ID = l.MtMAccountID

	WHERE	a.BatchNumber = @BatchNumber
	AND		a.ContractID = @ContractID

	GROUP	BY
			a.ContractID,
			a.AccountID,
			act.AccountNumber,
			act.AccountIdLegacy,
			mk.MarketCode, 
			u.WholeSaleMktID,
			u.UtilityCode, 
			a.Zone
END



GO