USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMAccountsByContract]    Script Date: 07/25/2013 16:19:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the list of accounts by contraCT ID																	*
 *  To Run:		exec usp_MtMAccountsByContract	'1','',Forecasted'														*
  *	Modified:	7/25/2013																										*
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
			a.Zone,
			ISNULL(SUM(Int1 + Int2 + Int3 + Int4 + Int5 + Int6 + Int7 + Int8 + Int9 + Int10 + Int11 + Int12 + Int13 + Int14 + Int15 + Int16 + Int17 + Int18 + Int19 + Int20 + Int21 + Int22 + Int23 + Int24 ),0) AS Usage
			
	FROM	MtMAccount a (nolock)
	INNER	JOIN MtMZainetAccountInfo act (nolock)
	ON		a.AccountID = act.AccountID
	AND		a.ContractID = act.ContractID
			
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
			a.Zone
			
UNION

	SELECT	a.ContractID,
			a.AccountID,
			act.AccountNumber,
			null as AccountIdLegacy,
			mkt.MarketCode,
			u.WholeSaleMktID as ISO,
			u.UtilityCode as UtilityCode,
			a.Zone,
			ISNULL(SUM(Int1 + Int2 + Int3 + Int4 + Int5 + Int6 + Int7 + Int8 + Int9 + Int10 + Int11 + Int12 + Int13 + Int14 + Int15 + Int16 + Int17 + Int18 + Int19 + Int20 + Int21 + Int22 + Int23 + Int24 ),0) AS Usage
	FROM	MtMAccount a (nolock)
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
			a.Zone
	) AS ACCT

ORDER	BY AccountNumber
			
SET NOCOUNT OFF; 			

END



