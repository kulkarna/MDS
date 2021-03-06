USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[Usp_GetAnnualUsage]    Script Date: 6/7/2016 9:32:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*      
-- =============================================      
-- AUTHOR:  VIKAS SHARMA      
-- CREATE DATE: 10-13-2015      
-- DESCRIPTION:  USED TO CALCULATE ANNUAL USAGE      
-- MODIFIED BY : VIKAS SHARMA AND SANTOSH KUMAR RAO      
-- DESCRIPTION : PBI 104170 (88315) FOR METER NUMBER OVERLAPPING AS DISCUSSED WITH JOHN PANG      
-- MODIFIED DATE : 01/29/2016      
-- ============================================= 
-- PBI-112989
-- Modified By Vikas Sharma
-- Modified Date : 04/26/2016
-- If overlap meter reads and values are the same, then treat as same meter, else treat as separate meters    
       
      
*/
ALTER PROCEDURE [dbo].[Usp_GetAnnualUsage] @LISTUSAGELIST
AS
DBO.USAGELIST READONLY AS

BEGIN


       
       /*   STORE THE DATA IN FORMATED TABLE */
       SELECT ID
              ,ACCOUNTNUMBER
              ,UTILITYCODE
              ,USAGESOURCE
              ,BEGINDATE
              ,ENDDATE
              ,CASE 
                     WHEN [DAYS] > 1
                           THEN [DAYS] - 1
                     ELSE 0
                     END DAYS
              ,TOTALKWH AS QUANTITY
              ,ISNULL(METERNUMBER, '') AS METERNUMBER
       INTO #TEMPUSAGE
       FROM @LISTUSAGELIST
       WHERE ISACTIVE = 1

       UPDATE #TEMPUSAGE
       SET METERNUMBER = '#'
       WHERE ISNULL(METERNUMBER, '') = ''

       /*
PBI-112989
Modified By Vikas Sharma
If overlap meter reads and values are the same, then treat as same meter, else treat as separate meters 
 
 */
       UPDATE T1
       SET t1.METERNUMBER = t2.MeterNumber
       FROM #TEMPUSAGE T1
              ,#TEMPUSAGE T2
       WHERE T1.BEGINDATE >= T2.BEGINDATE
              AND T1.BEGINDATE < T2.ENDDATE
              AND (
                     T1.METERNUMBER <> T2.METERNUMBER
                     AND T1.ID <> T2.ID
                     )
              AND t1.QUANTITY = t2.QUANTITY

       /*
During the UsageConsolidation/AnnualUsage Calculation  Process,
if  the above situation  happens(Overlapping meter reads with Different values)    we need  to  log those  account and Meter read entries  into a  New   Logging table,  with  the   Meter Read information.      This should not  stop the Consolidation  process, but  all  we  need is   to log those  Accounts for further manual Evaluation by the users. 
*/
       SELECT DISTINCT t1.*
       INTO #tempLog
       FROM #TEMPUSAGE T1
              ,#TEMPUSAGE T2
       WHERE T1.BEGINDATE >= T2.BEGINDATE
              AND T1.BEGINDATE < T2.ENDDATE
              AND (
                     T1.METERNUMBER <> T2.METERNUMBER
                     AND T1.ID <> T2.ID
                     )
              AND t1.QUANTITY <> t2.QUANTITY

       UPDATE #tempLog
       SET METERNUMBER = ''
       WHERE METERNUMBER = '#'

       INSERT INTO libertypower..OverlapUsageLog
       SELECT t1.*
       FROM @LISTUSAGELIST T1
       INNER JOIN #tempLog(NOLOCK) t2 ON t1.beginDate = t2.begindate
              AND t1.enddate = t2.enddate
              AND isnull(t1.meterNumber, '#') = isnull(t2.MeterNumber, '#')
              AND NOT EXISTS (
                     SELECT 1
                     FROM libertypower..OverlapUsageLog(NOLOCK) t3
                     WHERE t1.accountnumber = t3.accountnumber
                           AND t1.begindate = t3.begindate
                           AND t1.enddate = t3.enddate
                           AND t1.meternumber = t3.meternumber
                     )

       -------------------------End Section For PBI 112989-----------------------------------------
       /*  FIND OUT THE COMBINATIONS TO ANALYSE THE OVERLAPPING  */
       SELECT DISTINCT ISNULL(METERNUMBER, '') AS METERNUMBER
       INTO #TOTALMETERALIAS
       FROM #TEMPUSAGE(NOLOCK) B

       SELECT ROW_NUMBER() OVER (
                     ORDER BY METERNUMBER ASC
                     ) AS METERROWNUM
              ,*
       INTO #TOTALMETER
       FROM #TOTALMETERALIAS(NOLOCK)

       SELECT DISTINCT T1.METERNUMBER AS SOURCEMETERNUMBER
              ,T2.METERNUMBER AS DESTMETERNUMBER
       INTO #TMPNOTEXIST
       FROM #TEMPUSAGE(NOLOCK) T1
              ,#TEMPUSAGE(NOLOCK) T2
       WHERE T1.BEGINDATE >= T2.BEGINDATE
              AND T1.BEGINDATE < T2.ENDDATE
              AND (
                     T1.METERNUMBER <> T2.METERNUMBER
                     --AND T1.BEGINDATE <> T2.BEGINDATE      
                     ----AND T1.ENDDATE <> T2.ENDDATE      
                     --AND T1.QUANTITY <> T2.QUANTITY      
                     --AND T1.[DAYS] <> T2.[DAYS]    
                     AND T1.ID <> T2.ID
                     )
       ORDER BY T1.METERNUMBER ASC

       SELECT ROW_NUMBER() OVER (
                     ORDER BY SOURCEMETERNUMBER
                     ) AS ROWNUM
              ,ROW_NUMBER() OVER (
                     PARTITION BY SOURCEMETERNUMBER
                     ,DESTMETERNUMBER ORDER BY SOURCEMETERNUMBER
                     ) AS ROWNUM2
              ,*
       INTO #TMPNOTEXISTALIAS
       FROM #TMPNOTEXIST(NOLOCK) A

       /*  IN THE CURRENT SCNERIO IF WE ARE GETTING THE SAME METER DETAILS TWICE LIKE M1 CANT COME WITH M2       
      AND AGAIN WE FOUND M2 CAN'T COME WITH M1 . SO WE HAVE TO REMOVE THOSE ROWS. ALSO WE ARE RREMOVING THE DUPLICATE ROWS.      
       
  */
       DELETE B
       FROM #TMPNOTEXISTALIAS A
       LEFT OUTER JOIN #TMPNOTEXISTALIAS B ON A.DESTMETERNUMBER = B.SOURCEMETERNUMBER
       WHERE (
                     A.SOURCEMETERNUMBER = B.DESTMETERNUMBER
                     AND A.ROWNUM < B.ROWNUM
                     )
              OR A.ROWNUM2 > 1

       CREATE TABLE #TMPUSAGEOUTERRESULT (
              SNO INT IDENTITY(1, 1)
              ,METERNUMBER INT
              ,LOOKUPMETER VARCHAR(50)
              ,SOURCEMETERNUMBER VARCHAR(50)
              ,DESTINATIONMETERNUMBER VARCHAR(50)
              ,RANKINGNUMBER INT DEFAULT(1)
              )

       INSERT INTO #TMPUSAGEOUTERRESULT (
              METERNUMBER
              ,LOOKUPMETER
              ,SOURCEMETERNUMBER
              ,DESTINATIONMETERNUMBER
              )
       SELECT TM.METERROWNUM
              ,TM.METERNUMBER
              ,TEA.SOURCEMETERNUMBER
              ,TEA.DESTMETERNUMBER
       FROM #TOTALMETER(NOLOCK) TM
       LEFT JOIN #TMPNOTEXISTALIAS(NOLOCK) TEA ON TM.METERNUMBER = TEA.SOURCEMETERNUMBER

       DECLARE @MINRECORDCOUNT INT
       DECLARE @MAXRECORDCOUNT INT
       DECLARE @INNERMINCOUNT INT
       DECLARE @INNERMAXCOUNT INT
       DECLARE @MAXRANKCOUNT INT
       DECLARE @RANKINGNUMBER INT
       DECLARE @SERIALNUM INT
       DECLARE @SOURCEMETER VARCHAR(50)
       DECLARE @DESTINATIONMETER VARCHAR(50)
       DECLARE @DESTINATIONRANKINGNUM INT
       DECLARE @DESTINATIONSNO INT

       SELECT @MAXRECORDCOUNT = COUNT(DISTINCT LOOKUPMETER)
       FROM #TMPUSAGEOUTERRESULT

       SET @MINRECORDCOUNT = 1

       WHILE @MINRECORDCOUNT <= @MAXRECORDCOUNT
       BEGIN
              SET @INNERMINCOUNT = 1;
              SET @INNERMAXCOUNT = 0;
              SET @MAXRANKCOUNT = 0;
              SET @RANKINGNUMBER = 0;
              SET @SERIALNUM = 0;
              SET @SOURCEMETER = NULL;
              SET @DESTINATIONMETER = NULL;
              SET @DESTINATIONRANKINGNUM = 0;
              SET @DESTINATIONSNO = 0

              IF OBJECT_ID('TEMPDB..#TMPTBLINNER') IS NOT NULL
              BEGIN
                     DROP TABLE #TMPTBLINNER
              END

              CREATE TABLE #TMPTBLINNER (
                     SNO INT IDENTITY(1, 1)
                     ,TESTREULTSNO INT
                     ,METERNUMBER INT
                     ,LOOKUPMETER VARCHAR(50)
                     ,SOURCEMETERNUMBER VARCHAR(50)
                     ,DESTINATIONMETERNUMBER VARCHAR(50)
                     ,RANKINGNUMBER INT
                     )

              INSERT INTO #TMPTBLINNER (
                     TESTREULTSNO
                     ,METERNUMBER
                     ,LOOKUPMETER
                     ,SOURCEMETERNUMBER
                     ,DESTINATIONMETERNUMBER
                     ,RANKINGNUMBER
                     )
              SELECT SNO
                     ,METERNUMBER
                     ,LOOKUPMETER
                     ,SOURCEMETERNUMBER
                     ,DESTINATIONMETERNUMBER
                     ,RANKINGNUMBER
              FROM #TMPUSAGEOUTERRESULT
              WHERE RANKINGNUMBER >= @MINRECORDCOUNT

              SELECT @INNERMAXCOUNT = MAX(SNO)
              FROM #TMPTBLINNER

              WHILE (@INNERMINCOUNT <= @INNERMAXCOUNT)
              BEGIN
                     SELECT @RANKINGNUMBER = ISNULL(RANKINGNUMBER, 999)
                           ,@SOURCEMETER = SOURCEMETERNUMBER
                           ,@DESTINATIONMETER = DESTINATIONMETERNUMBER
                     FROM #TMPTBLINNER
                     WHERE SNO = @INNERMINCOUNT

                     SELECT @MAXRANKCOUNT = MAX(RANKINGNUMBER)
                     FROM #TMPTBLINNER(NOLOCK)
                     WHERE SNO = @INNERMINCOUNT

                     SELECT TOP 1 @DESTINATIONRANKINGNUM = ISNULL(RANKINGNUMBER, 999)
                           ,@DESTINATIONSNO = TESTREULTSNO
                     FROM #TMPTBLINNER(NOLOCK)
                     WHERE LOOKUPMETER = @DESTINATIONMETER
                     ORDER BY TESTREULTSNO

                     IF (
                                  @DESTINATIONRANKINGNUM = @RANKINGNUMBER
                                  AND @RANKINGNUMBER <> 999
                                  AND @DESTINATIONRANKINGNUM <> 999
                                  )
                     BEGIN
                           UPDATE T1
                           SET RANKINGNUMBER = @MAXRANKCOUNT + 1
                           FROM #TMPTBLINNER T1
                           WHERE LOOKUPMETER = CASE 
                                         WHEN @INNERMINCOUNT <= @DESTINATIONSNO
                                                THEN @DESTINATIONMETER
                                         ELSE @SOURCEMETER
                                         END;
                     END

                     SET @INNERMINCOUNT = @INNERMINCOUNT + 1;
              END

              UPDATE T2
              SET T2.RANKINGNUMBER = T3.RANKINGNUMBER
              FROM #TMPUSAGEOUTERRESULT T2
              INNER JOIN #TMPTBLINNER T3 ON T2.SNO = T3.TESTREULTSNO;

              SET @MINRECORDCOUNT = @MINRECORDCOUNT + 1;
       END

       SELECT DISTINCT LOOKUPMETER AS METERNUMBER
              ,RANKINGNUMBER AS RANKALIAS
       INTO #ANNUALUSAGERECORDS
       FROM #TMPUSAGEOUTERRESULT(NOLOCK)

       UPDATE A
       SET A.METERNUMBER = B.RANKALIAS
       FROM #TEMPUSAGE A
       INNER JOIN #ANNUALUSAGERECORDS B ON A.METERNUMBER = B.METERNUMBER

       SELECT SUM(ANNUALUSAGE) AS ANNUALUSAGE
       FROM (
              SELECT CAST(SUM(QUANTITY) AS FLOAT) / (SUM(DAYS) + 1) * 365 AS ANNUALUSAGE
              FROM #TEMPUSAGE
              GROUP BY ISNULL(METERNUMBER, '')
              ) VW_SUMMETERNUMBER

       SET NOCOUNT OFF;
END




