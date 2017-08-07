USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetConsolidatedUsage]    Script Date: 06/21/2016 09:25:42 ******/
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
 * Manoj:-01/26/2016- Merged the changes from PBI-97212.  
 * Vikas : 04/05/2016 - Revert IUM Changes PBI - 114034 
 * Vikas : 20160621 - Due to Rerver of IUM Changes Account Change Logic Changed so We need this deployment. 
 *******************************************************************************      
 */
ALTER PROCEDURE [dbo].[usp_GetConsolidatedUsage] (
	@ACCOUNTNUMBER VARCHAR(50)
	,@UTILITYCODE VARCHAR(50)
	,@BEGINDATE DATETIME
	,@ENDDATE DATETIME
	)
AS
/*  
SELECT 'USAGETYPE', * FROM LIBERTYPOWER..USAGETYPE  
SELECT 'USAGESOURCE', * FROM LIBERTYPOWER..USAGESOURCE  
SELECT * FROM USAGECONSOLIDATED WHERE ACCOUNTNUMBER = '6703762212' AND FROMDATE >= '2008-05-01' AND TODATE <= '2011-01-01'  
  
EXEC LIBERTYPOWER..USP_GETCONSOLIDATEDUSAGE '6143848119', 'NIMO', '01/01/2009', '01/01/2011'  
  
DECLARE  @ACCOUNTNUMBER VARCHAR(50),  
 @UTILITYCODE VARCHAR(50),  
 @BEGINDATE  DATETIME,  
 @ENDDATE  DATETIME  
SET @ACCOUNTNUMBER = '10032789430152011'  
SET @UTILITYCODE = 'NIMO'  
SET @BEGINDATE = '01/01/2009'  
SET @ENDDATE = '01/01/2011'  
*/
BEGIN
	SET NOCOUNT ON;

	DECLARE @ESTIMATE INT

	SELECT @ESTIMATE = VALUE
	FROM USAGETYPE
	WHERE DESCRIPTION = 'ESTIMATED';

	--SELECT @ESTIMATE  
	--SELECT *  
	--INTO #TEMPACCOUNTS  
	--FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@ACCOUNTNUMBER)  
	SELECT UC.ID AS ID
		,UC.ACCOUNTNUMBER AS ACCOUNTNUMBER
		,UC.UTILITYCODE AS UTILITYCODE
		,CAST(CAST(DATEPART(MM, FROMDATE) AS VARCHAR(2)) + '/' + CAST(DATEPART(DD, FROMDATE) AS VARCHAR(2)) + '/' + CAST(DATEPART(YYYY, FROMDATE) AS VARCHAR(4)) AS DATETIME) AS FROMDATE
		,CAST(CAST(DATEPART(MM, TODATE) AS VARCHAR(2)) + '/' + CAST(DATEPART(DD, TODATE) AS VARCHAR(2)) + '/' + CAST(DATEPART(YYYY, TODATE) AS VARCHAR(4)) AS DATETIME) AS TODATE
		,TOTALKWH
		,DAYSUSED
		,CREATED
		,UC.CREATEDBY AS CREATEDBY
		,CONVERT(INT, USAGETYPE) USAGETYPE
		,CONVERT(INT, USAGESOURCE) USAGESOURCE
		,UC.ACTIVE
		,REASONCODE
		,METERNUMBER
	FROM USAGECONSOLIDATED(NOLOCK) UC
	INNER JOIN Utility(NOLOCK) UT ON UC.UtilityCode = UT.UtilityCode
	LEFT JOIN Account(NOLOCK) c ON UC.AccountNumber = c.AccountNumber
		AND c.utilityid = UT.id
	--LEFT OUTER JOIN ACCOUNT(NOLOCK) ON UC.ACCOUNTNUMBER = ACCOUNT.ACCOUNTNUMBER  
	--LEFT OUTER JOIN METERTYPE(NOLOCK) ON ACCOUNT.METERTYPEID = METERTYPE.ID  
	WHERE
		--UC.ACCOUNTNUMBER  IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))
		UC.ACCOUNTNUMBER = @ACCOUNTNUMBER
		AND UC.UTILITYCODE = @UTILITYCODE
		AND FROMDATE >= @BEGINDATE
		AND TODATE <= @ENDDATE
		AND USAGETYPE <> @ESTIMATE
		AND UC.ACTIVE = 1
	--AND METERTYPE.ID <> 1
	--		AND FROMDATE >= '2009-01-01' -- NO 2008 USAGE
	ORDER BY FROMDATE DESC

	SET NOCOUNT OFF;
END
	-- COPYRIGHT 2010 LIBERTY POWER  
	-- Copyright 2010 Liberty Power    
