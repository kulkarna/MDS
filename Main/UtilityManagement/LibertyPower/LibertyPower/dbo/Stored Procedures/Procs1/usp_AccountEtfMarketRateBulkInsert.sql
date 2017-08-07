
CREATE PROCEDURE [dbo].[usp_AccountEtfMarketRateBulkInsert]
AS
BEGIN

	SET NOCOUNT ON;
	
	-- delete any records with the same effective date
	-- could occur if price generation process is re-run
	DELETE FROM AccountEtfMarketRate
	WHERE EffectiveDate IN (SELECT DISTINCT EffectiveDate FROM AccountEtfMarketRateImport)	

	INSERT INTO AccountEtfMarketRate
	SELECT dateadd(dd,0,datediff(dd,0,EffectiveDate)), 
			RetailMarket, 
			Utility, 
			Zone, 
			ServiceClass, 
			Term, 
			DropMonthIndicator, 
			Rate,
			AccountType
	 FROM AccountEtfMarketRateImport

	 -- Clear the import table
	 Exec dbo.usp_AccountEtfMarketRateImportTruncate
	

	SET NOCOUNT OFF;

END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfMarketRateBulkInsert';

