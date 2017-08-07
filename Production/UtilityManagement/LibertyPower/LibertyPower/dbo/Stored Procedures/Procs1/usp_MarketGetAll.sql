
/**************************************************************************************
* Created: 4/26/2010 GW 
**************************************************************************************/
CREATE proc [dbo].[usp_MarketGetAll]      
as        
      
SELECT	m.[ID]
		,m.[MarketCode]
		,m.[RetailMktDescp]
		,m.[WholesaleMktId]
		,m.[PucCertification_number]
		,m.[DateCreated]
		,m.[Username]
		,m.[InactiveInd]
		,m.[ActiveDate]
		,m.[Chgstamp]
		,m.[TransferOwnershipEnabled]
		,w.[WholesaleMktId] AS WholesaleMarketCode
		,m.EnableTieredPricing
FROM	[LibertyPower].[dbo].[Market] m WITH (NOLOCK)
		INNER JOIN Libertypower..WholesaleMarket w WITH (NOLOCK)
		ON m.WholesaleMktId = w.ID
WHERE m.InactiveInd = 0 
  
