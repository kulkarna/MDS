use Lp_transactions
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************************************************************************************************
--Author:		Abhijeet Kulkarni
--Create date: 03/01/2013
--Description:	Consolidate missing data points such as Icap
--*************************************************************************************************
-- Modified: Gail Managaroo
-- Modified Date: 3/12/2013
-- ************************************************************************************************

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_ConsolidateICapCOMED')
    BEGIN
    	DROP PROCEDURE usp_ConsolidateICapCOMED
    END
GO


CREATE PROCEDURE usp_ConsolidateICapCOMED
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DataSourceIDForScraper int
	SELECT @DataSourceIDForScraper = ID from LibertyPower.dbo.DataSource with (nolock) where [Source] = 'Scraper' 
	
	-- INSERT VALUES WHERE THERE IS NO ENRTY IN THE ICAP TABLE OR A NEWER STARTDATE EXISTS
	-- ======================================================================================
	INSERT INTO LibertyPower.dbo.AccountIcap (AccountID, DataSourceID, StartDate, EndDate, ICapValue, Created, UserID, Modified)	
	SELECT DISTINCT A.AccountID 
		, @DataSourceIDForScraper 
		, AA.CapacityPLC1StartDate 
		, AA.CapacityPLC1EndDate  -- Can substitute this value with null if desired
		, AA.CapacityPLC1Value
		, GETDATE()
		, 1 
		, GETDATE()
	FROM LibertyPower.dbo.Account A WITH (NOLOCK)
		INNER JOIN LibertyPower.dbo.Utility U WITH (NOLOCK) ON A.UtilityID = U.ID AND U.UtilityCode = 'COMED'
		INNER JOIN LibertyPower.dbo.AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID
		INNER JOIN LibertyPower.dbo.AccountStatus AST (nolock) on AC.AccountContractID = AST.AccountContractID 
			AND AST.Status NOT IN ('11000', '911000', '999998', '999999')
		LEFT JOIN ( SELECT AI.AccountID , StartDate = Max(Ai.StartDate) 
					FROM LibertyPower.dbo.AccountIcap  AI (NOLOCK) 
					GROUP BY AI.AccountID 
				  ) AI ON AI.AccountID = A.AccountID
		LEFT JOIN Lp_Transactions.dbo.COMEDAccount AA WITH (NOLOCK) ON A.AccountNumber = AA.AccountNumber 
	WHERE (AI.AccountID IS NULL OR AA.CapacityPLC1StartDate > AI.StartDate ) 
		AND AA.CapacityPLC1Value >= 0 
			
	UNION 
	
	SELECT DISTINCT A.AccountID 
		, @DataSourceIDForScraper
		, AA.CapacityPLC2StartDate 
		, AA.CapacityPLC2EndDate  -- Can substitute this value with null if desired
		, AA.CapacityPLC2Value
		, GETDATE()
		, 1 
		, GETDATE()
	FROM LibertyPower.dbo.Account A WITH (NOLOCK)
		INNER JOIN LibertyPower.dbo.Utility U WITH (NOLOCK) ON A.UtilityID = U.ID AND U.UtilityCode = 'COMED'
		INNER JOIN LibertyPower.dbo.AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID
		INNER JOIN LibertyPower.dbo.AccountStatus AST (nolock) on AC.AccountContractID = AST.AccountContractID 
			AND AST.Status NOT IN ('11000', '911000', '999998', '999999')
		LEFT JOIN ( SELECT AI.AccountID , StartDate = Max(Ai.StartDate) 
					FROM LibertyPower.dbo.AccountIcap  AI (NOLOCK) 
					GROUP BY AI.AccountID 
				  ) AI ON AI.AccountID = A.AccountID
		LEFT JOIN Lp_Transactions.dbo.COMEDAccount AA WITH (NOLOCK) ON A.AccountNumber = AA.AccountNumber 
	WHERE (AI.AccountID IS NULL OR AA.CapacityPLC2StartDate > AI.StartDate )
		AND AA.CapacityPLC2Value >= 0 

	SET NOCOUNT OFF;			 
END
GO