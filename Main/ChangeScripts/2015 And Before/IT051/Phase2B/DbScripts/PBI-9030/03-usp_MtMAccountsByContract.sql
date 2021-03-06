USE [lp_MtM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the list of accounts by contraCT ID																	*
 *  To Run:		exec usp_MtMAccountsByContract	'1','','Forecasted'														*
  *	Modified:																											*
 ************************************************************************************************************************/

 ALTER	PROCEDURE	[dbo].[usp_MtMAccountsByContract]
		@ContractID INT,
		@BatchNumber VARCHAR(50),
		@Status VARCHAR (50)
		
AS

BEGIN

SET NOCOUNT ON; 

SELECT * FROM
(
	 SELECT	a.ContractID,
			a.AccountID,
			act.AccountNumber,
			act.AccountIdLegacy,
			act.MarketCode, 
			act.ISO,
			act.UtilityCode, 
			d.Value AS Location,
			ISNULL(SUM(Int1 + Int2 + Int3 + Int4 + Int5 + Int6 + Int7 + Int8 + Int9 + Int10 + Int11 + Int12 + Int13 + Int14 + Int15 + Int16 + Int17 + Int18 + Int19 + Int20 + Int21 + Int22 + Int23 + Int24 ),0) AS Usage
			
	FROM	MtMAccount a (nolock)
	INNER	JOIN MtMZainetAccountInfo act (nolock)
	ON		a.AccountID = act.AccountID
	AND		a.ContractID = act.ContractID
	
	INNER	JOIN LibertyPower..PropertyInternalRef d  (nolock)
	ON		a.SettlementLocationRefID = d.ID
			
	LEFT	JOIN MtMDailyLoadForecast	l (nolock)
	ON		a.ID = l.MtMAccountID

	WHERE	a.CustomDealID is null
	AND		a.BatchNumber = @BatchNumber
	AND		a.ContractID = @ContractID
	AND		a.Status = @Status

	GROUP	BY
			a.ContractID,
			a.AccountID,
			act.AccountNumber,
			act.AccountIdLegacy,
			act.MarketCode, 
			act.ISO,
			act.UtilityCode, 
			d.Value
			
UNION

	SELECT	a.ContractID,
			a.AccountID,
			act.AccountNumber,
			null as AccountIdLegacy,
			mkt.MarketCode,
			u.WholeSaleMktID as ISO,
			u.UtilityCode as UtilityCode,
			d.Value AS Location,
			ISNULL(SUM(Int1 + Int2 + Int3 + Int4 + Int5 + Int6 + Int7 + Int8 + Int9 + Int10 + Int11 + Int12 + Int13 + Int14 + Int15 + Int16 + Int17 + Int18 + Int19 + Int20 + Int21 + Int22 + Int23 + Int24 ),0) AS Usage
	FROM	MtMAccount a (nolock)
	INNER	JOIN LibertyPower..PropertyInternalRef d  (nolock)
	ON		a.SettlementLocationRefID = d.ID
		
	INNER	JOIN LibertyPower..Account act (nolock) ON a.AccountID = act.AccountID
	INNER	JOIN LibertyPower..Utility u (nolock) ON u.ID = act.UtilityID
	INNER	JOIN LibertyPower..Market mkt (nolock) ON u.MarketID = mkt.ID
	LEFT	JOIN MtMDailyLoadForecast l (nolock) ON a.ID = l.MtMAccountID
	
	WHERE	a.CustomDealID is not null
	AND		a.BatchNumber = @BatchNumber AND a.ContractID = @ContractID
	AND		a.Status = @Status
	GROUP	BY
			a.ContractID,
			a.AccountID,
			act.AccountNumber,
			mkt.MarketCode,
			u.WholeSaleMktID,
			u.UtilityCode,
			d.Value
	) AS ACCT

ORDER	BY AccountNumber
			
SET NOCOUNT OFF; 			

END



