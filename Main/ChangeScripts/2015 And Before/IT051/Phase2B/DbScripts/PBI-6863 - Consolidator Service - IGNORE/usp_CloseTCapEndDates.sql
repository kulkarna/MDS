use LibertyPower
go

--************************************************************************************************
--Author:		Abhijeet Kulkarni
--Create date: 03/01/2013
--Description:	Consolidate missing data points such as Tcap
--*************************************************************************************************


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_CloseTcapEndDates')
    BEGIN
    	DROP PROCEDURE usp_CloseTcapEndDates
    END
GO


CREATE PROCEDURE usp_CloseTcapEndDates
AS
BEGIN
	SET NOCOUNT ON;

-- CLOSE THE END DATES OF THE PREVIOS RECORD IF A NEWER RECORD EXISTS 
	-- ================================================================================================
	-- get date next record starts
	SELECT AI.ID
		, AI.AccountID 
		, NextStartDate = ( SELECT MIN(AI2.StartDate) 
							FROM  LibertyPower..AccountTcap AI2 
							WHERE AI2.StartDate > AI.StartDate 
								AND AI2.AccountID = AI.AccountID
					) 
	INTO #EndDateList
	FROM LibertyPower..AccountTcap AI (NOLOCK) 
		WHERE AI.EndDate is Null 
	GROUP BY AI.ID, AI.StartDate , AI.AccountID 
	
	-- update end date 
	UPDATE AI SET EndDate = DATEADD(DAY, -1, NextStartDate), Modified = GETDATE()
	FROM #EndDateList L
		JOIN LibertyPower..AccountTcap AI (NOLOCK) ON AI.ID = L.ID
	WHERE L.NextStartDate IS NOT NULL AND StartDate < DATEADD(DAY, -1, NextStartDate)

	SET NOCOUNT OFF;
END 
GO 