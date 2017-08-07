

CREATE PROCEDURE [dbo].[usp_SalesChannelNameWithMarketsSelect] 
AS      
BEGIN     

SELECT DISTINCT c.ChannelID, c.ChannelName, m.ID AS MarketCodeID, m.MarketCode
FROM SalesChannel c (NOLOCK) 
JOIN SalesChannelAccountType a (NOLOCK) ON c.ChannelID = a.ChannelID
JOIN Market m (NOLOCK)  ON a.MarketID = m.ID
JOIN WholesaleMarket w (NOLOCK) ON m.WholesaleMktId = w.ID
ORDER BY ChannelID

END 

