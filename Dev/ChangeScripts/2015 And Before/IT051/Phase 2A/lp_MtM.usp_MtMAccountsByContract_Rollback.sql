USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMAccountsByContract]    Script Date: 03/14/2013 17:28:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER	PROCEDURE	[dbo].[usp_MtMAccountsByContract]
		@ContractID INT,
		@BatchNumber VARCHAR(50),
		@Status VARCHAR (50)
		
AS

BEGIN

	 SELECT	a.ContractID,
			a.AccountID,
			act.AccountNumber,
			act.AccountIdLegacy,
			act.MarketCode, 
			act.ISO,
			act.UtilityCode, 
			a.Zone,
			ISNULL(SUM(Int1 + Int2 + Int3 + Int4 + Int5 + Int6 + Int7 + Int8 + Int9 + Int10 + Int11 + Int12 + Int13 + Int14 + Int15 + Int16 + Int17 + Int18 + Int19 + Int20 + Int21 + Int22 + Int23 + Int24 ),0) AS Usage
			
	FROM	MtMAccount a
	INNER	JOIN MtMZainetAccountInfo act
	ON		a.AccountID = act.AccountID
	AND		a.ContractID = act.ContractID
			
	LEFT	JOIN MtMDailyLoadForecast	l
	ON		a.ID = l.MtMAccountID

	WHERE	a.BatchNumber = @BatchNumber
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
END



