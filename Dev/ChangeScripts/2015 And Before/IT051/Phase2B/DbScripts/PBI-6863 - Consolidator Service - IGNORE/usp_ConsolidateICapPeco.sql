use Lp_transactions
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/************************************************************************************************
 Author:		Abhijeet Kulkarni/ Gail Mangaroo
 Create date:	03/01/2013
 Description:	Consolidate missing data points such as Icap
************************************************************************************************/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_ConsolidateICapPeco')
    BEGIN
    	DROP PROCEDURE usp_ConsolidateICapPeco
    END
GO


CREATE PROCEDURE usp_ConsolidateICapPeco
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
		, Isnull(AA.IcapBeginDate, GETDATE())
		, AA.IcapEndDate As EndDate
		, AA.Icap 
		, GETDATE()
		, 1 
		, GETDATE()
	FROM LibertyPower.dbo.Account A WITH (NOLOCK)
		INNER JOIN LibertyPower.dbo.Utility U WITH (NOLOCK) ON A.UtilityID = U.ID AND U.UtilityCode = 'Peco'
		INNER JOIN LibertyPower.dbo.AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID
		INNER JOIN LibertyPower.dbo.AccountStatus AST (nolock) on AC.AccountContractID = AST.AccountContractID 
			AND AST.Status NOT IN ('11000', '911000', '999998', '999999')
		LEFT JOIN ( SELECT AI.AccountID , StartDate = Max(Ai.StartDate) 
					FROM LibertyPower.dbo.AccountIcap  AI (NOLOCK) 
					GROUP BY AI.AccountID 
				  ) AI ON AI.AccountID = A.AccountID
		INNER JOIN Lp_Transactions.dbo.PecoAccount AA WITH (NOLOCK) ON A.AccountNumber = AA.AccountNumber 
	WHERE (AI.AccountID IS NULL OR AA.Icap > AI.StartDate ) 
		AND AA.Icap >= 0 

	SET NOCOUNT OFF;						 
END
GO
