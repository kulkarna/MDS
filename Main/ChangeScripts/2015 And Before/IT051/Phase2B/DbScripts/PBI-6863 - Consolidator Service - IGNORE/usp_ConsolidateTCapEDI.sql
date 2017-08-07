use LibertyPower
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/************************************************************************************************
 Author:		Gail Mangaroo
 Create date: 03/14/2013
 Description:	Update missing Load Profiles
************************************************************************************************/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_ConsolidateTCapEDI')
    BEGIN
    	DROP PROCEDURE usp_ConsolidateTCapEDI
    END
GO


CREATE PROCEDURE usp_ConsolidateTCapEDI
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Questions/Issues !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	-- Lp_transactions..ediProxyQuery to be replaced by results of query from Douglas (EDIQuery) 
	-- Verify that join with LibertyPower..Utility takes care of the correct id of the ISO returned by the EDIQuery 
	-- Which DB should these SPs reside in ...
	
	DECLARE @DataSourceIDForScraper int
	SELECT @DataSourceIDForScraper = ID from LibertyPower.dbo.DataSource with (nolock) where [Source] = 'EDI' 
	
	-- INSERT VALUES WHERE THERE IS NO ENRTY IN THE ICAP TABLE OR A NEWER STARTDATE EXISTS
	-- ======================================================================================
	--INSERT INTO LibertyPower.dbo.AccountTCap (AccountID, DataSourceID, StartDate, EndDate, TCapValue, Created, UserID, Modified)	
	--SELECT DISTINCT A.AccountID 
	--	, @DataSourceIDForScraper 
	--	, StartDate = case when isnull(EsiidStartDate , '1/1/1900') = '1/1/1900' then SpecialReadSwitchDate else EsiidStartDate end  
	--	, EndDate = null
	--	, e.TransmissionObligation
	--	, GETDATE()
	--	, 1 
	--	, GETDATE()
		
	--FROM Lp_transactions..ediProxyQuery e 
	--	JOIN LibertyPower..Account a on a.AccountNumber = e.AccountNumber 
	--	Left Join ( SELECT AccountID , Max(StartDate) as StartDate 
	--				FROM LibertyPower..AccountTCap 
	--				GROUP BY AccountID 
	--			  ) ai on ai.accountId = a.accountID and 
	--WHERE ( ai.AccountID IS NULL OR StartDate > ai.StartDate ) 
	--	AND isnull( e.TransmissionObligation , 0 ) > 0


	--OR 
	
	SELECT DISTINCT A.AccountID 
		, @DataSourceIDForScraper 
		, StartDate = case when isnull(EsiidStartDate , '1/1/1900') = '1/1/1900' then SpecialReadSwitchDate else EsiidStartDate end  
		, EndDate = null
		, e.TransmissionObligation
		, GETDATE()
		, 1 
		, GETDATE()
		
	FROM Lp_transactions..ediProxyQuery e (NOLOCK) 
		JOIN LibertyPower..Account a (NOLOCK) on a.AccountNumber = e.AccountNumber 
		LEFT JOIN LibertyPower..AccountTCap  at (NOLOCK) ON at.AccountID = a.AccountID 
			AND DATEADD(DAY,0,DATEDIFF(DAY,0, at.StartDate)) = DATEADD(DAY,0,DATEDIFF(DAY,0, StartDate))
	WHERE at.AccountID IS NULL 
		AND isnull( e.TransmissionObligation , 0 ) > 0

	SET NOCOUNT OFF;
END 
GO	

--select distinct CapacityObligation from Lp_transactions..ediProxyQuery
-- delete libertypower..accountIcap 