use LibertyPower
GO

--************************************************************************************************
--Author:		Abhijeet Kulkarni
--Create date: 03/01/2013
--Description:	Remove duplicate records from the Tcap table
--*************************************************************************************************


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_RemoveDuplicateTcap')
    BEGIN
    	DROP PROCEDURE usp_RemoveDuplicateTcap
    END
GO

CREATE PROCEDURE usp_RemoveDuplicateTcap
AS
BEGIN
	SET NOCOUNT ON;	
	
	/* Delete Duplicate records */
	 WITH CTE (AccountID, StartDate, DuplicateCount)
	 AS
	 (
		 SELECT AccountID, convert(date, StartDate)as StartDate
		 , ROW_NUMBER() OVER(PARTITION BY AccountID, convert(date, StartDate) ORDER BY AccountID) as DuplicateCount
		 FROM LibertyPower.dbo.AccountTcap (NOLOCK)
	 )
	 DELETE
	 FROM CTE
	 WHERE DuplicateCount > 1	

	 SET NOCOUNT OFF;
END
GO