USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMDealsDetail]    Script Date: 09/30/2013 16:31:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the detailed information of the list of accounts processed on a submit date							*
 *  To Run:		exec usp_MtMDealsDetail	'1/3/2013'																		*
  *	Modified:	7/25: Replace DealPricingID with CustomDealID (1-155644541)												*																										*
 ************************************************************************************************************************/

ALTER PROCEDURE [dbo].[usp_MtMDealsDetail]    
  @SubmitDate DATETIME    
      
AS    
      
BEGIN    

SET NOCOUNT ON; 

  -- GEt the list of the latest MtM account information for all the contracts signed on "SubmitDate"    
SELECT DISTINCT *    
INTO #Accounts    
FROM (    
  SELECT m.AccountID, c.ContractID, c.ContractNumber as Number, c.ContractDealTypeID, ~c.IsDaily as IsCustom, MAX(m.ID) as MtMID    
  FROM MtMAccount  m (nolock)    
    
  INNER JOIN MtMZainetAccountInfo c (nolock)    
  ON  m.ContractID = c.ContractID    
      
  WHERE MONTH(c.DateCreated) = MONTH(@SubmitDate)    
  AND  DAY(c.DateCreated) = DAY(@SubmitDate)    
  AND  YEAR(c.DateCreated) = YEAR(@SubmitDate)    
    
  GROUP BY m.AccountID, c.ContractNumber, c.ContractID,  c.ContractDealTypeID, c.IsDaily    
UNION    
  -- GEt the list of the latest MtM account information for all the contracts signed on "SubmitDate"    
  SELECT m.AccountID, null as ContractID, ch.PricingRequest as Number, NULL as ContractDealTypeID, 1 as IsCustom, MAX(m.ID) as MtMID    
  FROM MtMAccount m (nolock)    
  INNER JOIN LibertyPower..Account act (nolock) ON m.AccountID = act.AccountID    
  INNER JOIN LibertyPower..Utility u (nolock) ON u.ID = act.UtilityID    
  INNER JOIN LibertyPower..Market mkt (nolock) ON u.MarketID = mkt.ID    
  INNER JOIN MtMCustomDealHeader ch (nolock) on ch.ID = m.CustomDealID   
  WHERE m.CustomDealID is not null    
  AND  MONTH(m.DateCreated) = MONTH(@SubmitDate)    
  AND  DAY(m.DateCreated) = DAY(@SubmitDate)    
  AND  YEAR(m.DateCreated) = YEAR(@SubmitDate)    
  GROUP BY m.AccountID, ch.PricingRequest  
) as ACCT     
      
  --CREATE NONCLUSTERED INDEX idx_AccountMtMID ON dbo.#Accounts (MtMID ASC)    
      
  -- Get the total load forecasted for each account     
  SELECT a.Number, a.ContractID, a.MtMID, SUM(Int1 + Int2 + Int3 + Int4 + Int5 + Int6 + Int7 + Int8 + Int9 + Int10 + Int11 + Int12 + Int13 + Int14 + Int15 + Int16 + Int17 + Int18 + Int19 + Int20 + Int21 + Int22 + Int23 + Int24 ) AS Usage    
  INTO #LOAD    
  FROM MtMDailyLoadForecast l (nolock)
  INNER JOIN  #Accounts a    
  ON  a.MtMID = l.MtMAccountID    
  GROUP BY a.Number ,a.ContractID, a.MtMID    
      
  -- Get the number of proxied accounts by contract    
  SELECT a.ContractID, a.Number, BatchNumber, QuoteNumber, COUNT(a.MtMID) as NumberOfProxiedAccounts    
  INTO #Proxied    
  FROM #Accounts a    
  INNER JOIN MtMAccount m (nolock)    
  ON  a.MtMID = m.ID    
  WHERE (  m.ProxiedProfile = 1    
    OR  m.ProxiedUsage = 1    
    OR  m.ProxiedLocation = 1    
    )    
  GROUP BY a.Number, a.ContractID, BatchNumber, QuoteNumber    
    
  -- Get the Contract numbers along with their total number accounts, proxied accounts, usage,     
  SELECT a.ContractID,    
    a.Number,     
    COUNT(DISTINCT a.MtMID) as NumberOfAccounts,    
    ISNULL(pr.NumberOfProxiedAccounts, 0) as NumberOfProxiedAccounts,    
    ISNULL(SUM(L.Usage),0) as Usage,    
    m.Status,    
    a.ContractDealTypeID,     
    a.IsCustom,    
    m.BatchNumber,    
    m.QuoteNumber        
  FROM #Accounts a    
        
  INNER JOIN MtMAccount m (nolock)    
  ON  a.MtMID = m.ID    
            
  LEFT JOIN #Load L    
  On  L.Number = a.Number    
  AND  L.MtMID = a.MtMID    
      
  LEFT JOIN #Proxied pr    
  ON  m.ContractID = pr.ContractID    
  AND  m.BatchNumber = pr.BatchNumber    
  AND  m.QuoteNumber = pr.QuoteNumber    
    
  GROUP BY a.ContractID,    
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
