




CREATE PROCEDURE [dbo].[usp_AccountEtfMarketRateDataExistsForEffectiveDate]
(	@EffectiveDate datetime,
	@EffectiveDateStart datetime)
AS
BEGIN

	SET NOCOUNT ON;

	IF EXISTS(SELECT EtfMarketRateID
		FROM AccountEtfMarketRate
		WHERE [EffectiveDate] between @EffectiveDateStart and @EffectiveDate)
		SELECT 1
	ELSE
		SELECT 0
	END

	SET NOCOUNT OFF;






GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfMarketRateDataExistsForEffectiveDate';

