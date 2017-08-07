CREATE	PROCEDURE	[dbo].[usp_UtilityMarketTypeList] 
AS
BEGIN
	SELECT ID, MarketCode, RetailMktDescp 
	FROM [libertypower].[dbo].[Market]
END

