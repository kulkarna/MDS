/*******************************************************************************
 * usp_MarketsSelect
 * Gets all market records
 *
 * History
 *******************************************************************************
 * 2/6/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_MarketsSelect]

AS
BEGIN
    SET NOCOUNT ON;

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

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
