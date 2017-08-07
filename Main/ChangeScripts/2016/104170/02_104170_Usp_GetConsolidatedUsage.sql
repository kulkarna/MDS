USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetConsolidatedUsage]    Script Date: 02/09/2016 11:55:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
    
/*******************************************************************************    
 * usp_GetConsolidatedUsage    
 * retrieves usage from the consolidated usage table    
 *    
 * History    
 *    
 *******************************************************************************    
 * 11/29/2010 - Eduardo Patino    
 * Created. 
 
 * Modifed by : Vikas Sharma 05/27/2015
 * Add Capability to Add the Consolidation Process for Old Account Also. 
 * Modified by : Mudit and Vikas
 * Mudit make changes for duke overlapping and Vikas Make changes for old Account Numbers  
 *******************************************************************************    
 */    
    
ALTER PROCEDURE [dbo].[usp_GetConsolidatedUsage]
(
	@ACCOUNTNUMBER	VARCHAR(50),
	@UTILITYCODE	VARCHAR(50),
	@BEGINDATE		DATETIME,
	@ENDDATE		DATETIME
)
AS
/*
SELECT 'USAGETYPE', * FROM LIBERTYPOWER..USAGETYPE
SELECT 'USAGESOURCE', * FROM LIBERTYPOWER..USAGESOURCE
SELECT * FROM USAGECONSOLIDATED WHERE ACCOUNTNUMBER = '6703762212' AND FROMDATE >= '2008-05-01' AND TODATE <= '2011-01-01'

EXEC LIBERTYPOWER..USP_GETCONSOLIDATEDUSAGE '6143848119', 'NIMO', '01/01/2009', '01/01/2011'

DECLARE		@ACCOUNTNUMBER	VARCHAR(50),
	@UTILITYCODE	VARCHAR(50),
	@BEGINDATE		DATETIME,
	@ENDDATE		DATETIME
SET	@ACCOUNTNUMBER = '10032789430152011'
SET @UTILITYCODE = 'NIMO'
SET @BEGINDATE = '01/01/2009'
SET @ENDDATE = '01/01/2011'
*/

BEGIN
	SET NOCOUNT ON;

DECLARE	@ESTIMATE INT
SELECT	@ESTIMATE = VALUE FROM USAGETYPE WHERE DESCRIPTION = 'ESTIMATED';
--SELECT	@ESTIMATE

 --SELECT * INTO #TEMPACCOUNTS
	--		FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@ACCOUNTNUMBER)

IF(@UTILITYCODE = 'DUKE')
BEGIN
WITH OVERLAPPINGLOANS AS (
--	NOTE THAT I HAD TO CONVERT UT AND US TO INT SINCE THEY ARE DEFINED AS INTEGERS IN THE FWK
SELECT	UC.ID AS ID, UC.ACCOUNTNUMBER AS ACCOUNTNUMBER , UC.UTILITYCODE AS UTILITYCODE,
			CAST(CAST(DATEPART(MM, FROMDATE) AS VARCHAR(2)) + '/' + CAST(DATEPART(DD, FROMDATE) AS VARCHAR(2)) + '/' + CAST(DATEPART(YYYY, FROMDATE) AS VARCHAR(4)) AS DATETIME) AS FROMDATE,
			CAST(CAST(DATEPART(MM, TODATE) AS VARCHAR(2)) + '/' + CAST(DATEPART(DD, TODATE) AS VARCHAR(2)) + '/' + CAST(DATEPART(YYYY, TODATE) AS VARCHAR(4)) AS DATETIME) AS TODATE,
			TOTALKWH, DAYSUSED, CREATED, UC.CREATEDBY AS CREATEDBY, CONVERT (INT, USAGETYPE) USAGETYPE, CONVERT (INT, USAGESOURCE) USAGESOURCE, UC.ACTIVE, REASONCODE, METERNUMBER
	FROM	USAGECONSOLIDATED (NOLOCK) UC
	INNER JOIN Utility(NOLOCK) UT on  UC.UtilityCode  = UT.UtilityCode
	LEFT JOIN Account(NOLOCK) c on UC.AccountNumber = c.AccountNumber and c.utilityid = UT.id
	--LEFT OUTER JOIN ACCOUNT(NOLOCK) ON UC.ACCOUNTNUMBER = ACCOUNT.ACCOUNTNUMBER
	--LEFT OUTER JOIN METERTYPE(NOLOCK) ON ACCOUNT.METERTYPEID = METERTYPE.ID
 
	WHERE	
	--UC.ACCOUNTNUMBER  IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))
	UC.ACCOUNTNUMBER =@ACCOUNTNUMBER
		AND UC.UTILITYCODE = @UTILITYCODE
		AND FROMDATE >= @BEGINDATE
		AND TODATE <= @ENDDATE
		AND USAGETYPE <> @ESTIMATE
		AND	UC.ACTIVE = 1
	

	),
	

	 
 CTE AS( SELECT  ROW_NUMBER() OVER(PARTITION BY METERNUMBER

  ORDER BY METERNUMBER,FROMDATE) AS ROWNUMBER,* FROM OVERLAPPINGLOANS)

  --SELECT * FROM CTE

  SELECT * FROM (SELECT C1.ID,C1.ACCOUNTNUMBER , C1.UTILITYCODE,C1.FROMDATE,DATEADD(DAY,-1,C2.FROMDATE) TODATE,C1.TOTALKWH, C1.DAYSUSED, C1.CREATED, C1.CREATEDBY AS CREATEDBY, CONVERT (INT, C1.USAGETYPE) USAGETYPE, CONVERT (INT, C1.USAGESOURCE) USAGESOURCE, C1.ACTIVE, C1.REASONCODE, C1.METERNUMBER FROM CTE C1 JOIN CTE C2 ON C1.METERNUMBER = C2.METERNUMBER 
  AND C2.ROWNUMBER = C1.ROWNUMBER + 1 
  UNION SELECT ID,ACCOUNTNUMBER , UTILITYCODE,FROMDATE,TODATE,TOTALKWH, DAYSUSED, CREATED, CREATEDBY AS CREATEDBY, CONVERT (INT, USAGETYPE) USAGETYPE, CONVERT (INT, USAGESOURCE) USAGESOURCE, ACTIVE, REASONCODE, METERNUMBER FROM CTE WHERE ROWNUMBER = (SELECT MAX(ROWNUMBER) FROM CTE)) A ORDER BY A.METERNUMBER
END
ELSE
 BEGIN
 
  
 
 
SELECT	UC.ID AS ID, UC.ACCOUNTNUMBER AS ACCOUNTNUMBER , UC.UTILITYCODE AS UTILITYCODE,
			CAST(CAST(DATEPART(MM, FROMDATE) AS VARCHAR(2)) + '/' + CAST(DATEPART(DD, FROMDATE) AS VARCHAR(2)) + '/' + CAST(DATEPART(YYYY, FROMDATE) AS VARCHAR(4)) AS DATETIME) AS FROMDATE,
			CAST(CAST(DATEPART(MM, TODATE) AS VARCHAR(2)) + '/' + CAST(DATEPART(DD, TODATE) AS VARCHAR(2)) + '/' + CAST(DATEPART(YYYY, TODATE) AS VARCHAR(4)) AS DATETIME) AS TODATE,
			TOTALKWH, DAYSUSED, CREATED, UC.CREATEDBY AS CREATEDBY, CONVERT (INT, USAGETYPE) USAGETYPE, CONVERT (INT, USAGESOURCE) USAGESOURCE, UC.ACTIVE, REASONCODE, METERNUMBER
	FROM	USAGECONSOLIDATED (NOLOCK) UC
	INNER JOIN Utility(NOLOCK) UT on  UC.UtilityCode  = UT.UtilityCode
	LEFT JOIN Account(NOLOCK) c on UC.AccountNumber = c.AccountNumber and c.utilityid = UT.id
	--LEFT OUTER JOIN ACCOUNT(NOLOCK) ON UC.ACCOUNTNUMBER = ACCOUNT.ACCOUNTNUMBER
	--LEFT OUTER JOIN METERTYPE(NOLOCK) ON ACCOUNT.METERTYPEID = METERTYPE.ID
	   
	WHERE	
	--UC.ACCOUNTNUMBER  IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))
	UC.ACCOUNTNUMBER =@ACCOUNTNUMBER
		AND UC.UTILITYCODE = @UTILITYCODE
		AND FROMDATE >= @BEGINDATE
		AND TODATE <= @ENDDATE
		AND USAGETYPE <> @ESTIMATE
		AND	UC.ACTIVE = 1
		--AND METERTYPE.ID <> 1
--		AND FROMDATE >= '2009-01-01' -- NO 2008 USAGE
	ORDER BY FROMDATE DESC
END
SET NOCOUNT OFF;
	END

-- COPYRIGHT 2010 LIBERTY POWER
    
-- Copyright 2010 Liberty Power  

