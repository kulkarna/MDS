

CREATE PROC [dbo].[usp_ErcotAccountInfoAccounts_GetZoneAndZipByAccountNumber]
	@AccountNumber VARCHAR(100)
AS
BEGIN

	SET NOCOUNT ON;  

	SELECT DISTINCT
		DCZone, ZipCode, Esiid
	FROM 
		[ERCOT].[dbo].[AccountInfoAccounts] (NOLOCK) AIA
		inner join [ERCOT].[dbo].[AccountInfoSettlement] AIS (NOLOCK) 
			on AIA.STATIONCODE=AIS.Substation
		inner join [ERCOT].[dbo].[AccountInfoZoneMapping] AIZM (NOLOCK) 
			on AIS.SettlementLoadZone=AIZM.ErcotZone
	WHERE
		AIA.Esiid = @AccountNumber 

	SET NOCOUNT OFF;

END
