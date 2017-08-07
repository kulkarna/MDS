
/******************************  usp_AccountInfoAccountsSelect *********************************/
CREATE Procedure [dbo].[usp_AccountInfoAccountsSelect]
	@AccountNumber VARCHAR(100)

AS

BEGIN

SELECT	distinct a.*, m.DCZone
FROM	AccountInfoAccounts a
INNER	JOIN AccountInfoSettlement b
ON		a.STATIONCODE = b.Substation
INNER	JOIN AccountInfoZoneMapping m
ON		b.SettlementLoadZone = m.ErcotZone
WHERE	a.ESIID = @AccountNumber
			 
END

