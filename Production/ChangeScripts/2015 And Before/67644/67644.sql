USE [LIBERTYPOWER]
GO
/****** OBJECT:  STOREDPROCEDURE [DBO].[USP_GETIDRANNUALUSAGE]    SCRIPT DATE: 05/26/2015 04:50:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================  
-- AUTHOR:    <VIKAS SHARMA>  
-- CREATE DATE: <05-12-2014>  
-- DESCRIPTION:  <THE USP_GETIDRANNUALUSAGE GIVES THE ANNUAL USAGE FOR THE IDR DATA  . PBI-50187
-- THE USP_GETIDRANNUALUSAGE GIVES THE ANNUAL USAGE FOR THE ACCOUNT NO
/*
 * HISTORY
 
 MODIFIED BY : VIKAS SHARMA
 DESCRIPTION  :  PBI 67644 MODIFIED FOR DUPLICATE DATA
 MODIFIED BY : VIKAS SHARMA DATED : 05/27/2015
 MODIFIED BY : VIKAS SHARMA DATED : 09/17/2015
 DESCRIPTION : PBI-69253
*/
-- EXEC [USP_GETIDRANNUALUSAGE] @ACCOUNTNO='08048076880000776226',@UTILITYCODE='JCP&L',@FROM='2010-04-02 06:51:59.733',@TO='2013-04-02 06:51:59.733'
-- EXEC [USP_GETIDRANNUALUSAGE] @ACCOUNTNO='145',@UTILITYCODE='COMED',@FROM='2012-12-05 06:51:59.733',@TO='2014-12-05 06:51:59.733'
-- EXEC [USP_GETIDRANNUALUSAGE] @ACCOUNTNO='00140060799255395',@UTILITYCODE='OHP',@FROM='2012-12-26 06:51:59.733',@TO='2014-12-26 06:51:59.733'  
-- =============================================  
ALTER PROCEDURE [DBO].[USP_GETIDRANNUALUSAGE] @ACCOUNTNO VARCHAR(50),
@UTILITYCODE VARCHAR(50),
@FROM DATETIME,
@TO DATETIME

AS
BEGIN

	SET NOCOUNT ON;
		DECLARE @INSMULTIPLEMETERS SMALLINT = 0
		
		SELECT * INTO #TEMPACCOUNTS
				FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@ACCOUNTNO)
     
     
	SELECT
		EA.UTILITYCODE,
		EA.ACCOUNTNUMBER,
		IUH.DATE,
		IUH.METERNUMBER,
		IUH.ID AS IDRHID,
		IUH.TIMESTAMPINSERT,

		(ISNULL(IUH.[15], 0) + ISNULL(IUH.[30], 0) + ISNULL(IUH.[45], 0) + ISNULL(IUH.[100], 0)) AS C100,

		(ISNULL(IUH.[115], 0) + ISNULL(IUH.[130], 0) + ISNULL(IUH.[145], 0) + ISNULL(IUH.[200], 0)) AS C200,

		(ISNULL(IUH.[215], 0) + ISNULL(IUH.[230], 0) + ISNULL(IUH.[245], 0) + ISNULL(IUH.[300], 0)) AS C300,

		(ISNULL(IUH.[315], 0) + ISNULL(IUH.[330], 0) + ISNULL(IUH.[345], 0) + ISNULL(IUH.[400], 0)) AS C400,

		(ISNULL(IUH.[415], 0) + ISNULL(IUH.[430], 0) + ISNULL(IUH.[445], 0) + ISNULL(IUH.[500], 0)) AS C500,

		(ISNULL(IUH.[515], 0) + ISNULL(IUH.[530], 0) + ISNULL(IUH.[545], 0) + ISNULL(IUH.[600], 0)) AS C600,

		(ISNULL(IUH.[615], 0) + ISNULL(IUH.[630], 0) + ISNULL(IUH.[645], 0) + ISNULL(IUH.[700], 0)) AS C700,

		(ISNULL(IUH.[715], 0) + ISNULL(IUH.[730], 0) + ISNULL(IUH.[745], 0) + ISNULL(IUH.[800], 0)) AS C800,

		(ISNULL(IUH.[815], 0) + ISNULL(IUH.[830], 0) + ISNULL(IUH.[845], 0) + ISNULL(IUH.[900], 0)) AS C900,

		(ISNULL(IUH.[915], 0) + ISNULL(IUH.[930], 0) + ISNULL(IUH.[945], 0) + ISNULL(IUH.[1000], 0)) AS C1000,

		(ISNULL(IUH.[1015], 0) + ISNULL(IUH.[1030], 0) + ISNULL(IUH.[1045], 0) + ISNULL(IUH.[1100], 0)) AS C1100,

		(ISNULL(IUH.[1115], 0) + ISNULL(IUH.[1130], 0) + ISNULL(IUH.[1145], 0) + ISNULL(IUH.[1200], 0)) AS C1200,

		(ISNULL(IUH.[1215], 0) + ISNULL(IUH.[1230], 0) + ISNULL(IUH.[1245], 0) + ISNULL(IUH.[1300], 0)) AS C1300,

		(ISNULL(IUH.[1315], 0) + ISNULL(IUH.[1330], 0) + ISNULL(IUH.[1345], 0) + ISNULL(IUH.[1400], 0)) AS C1400,

		(ISNULL(IUH.[1415], 0) + ISNULL(IUH.[1430], 0) + ISNULL(IUH.[1445], 0) + ISNULL(IUH.[1500], 0)) AS C1500,

		(ISNULL(IUH.[1515], 0) + ISNULL(IUH.[1530], 0) + ISNULL(IUH.[1545], 0) + ISNULL(IUH.[1600], 0)) AS C1600,

		(ISNULL(IUH.[1615], 0) + ISNULL(IUH.[1630], 0) + ISNULL(IUH.[1645], 0) + ISNULL(IUH.[1700], 0)) AS C1700,

		(ISNULL(IUH.[1715], 0) + ISNULL(IUH.[1730], 0) + ISNULL(IUH.[1745], 0) + ISNULL(IUH.[1800], 0)) AS C1800,

		(ISNULL(IUH.[1815], 0) + ISNULL(IUH.[1830], 0) + ISNULL(IUH.[1845], 0) + ISNULL(IUH.[1900], 0)) AS C1900,

		(ISNULL(IUH.[1915], 0) + ISNULL(IUH.[1930], 0) + ISNULL(IUH.[1945], 0) + ISNULL(IUH.[2000], 0)) AS C2000,

		(ISNULL(IUH.[2015], 0) + ISNULL(IUH.[2030], 0) + ISNULL(IUH.[2045], 0) + ISNULL(IUH.[2100], 0)) AS C2100,

		(ISNULL(IUH.[2115], 0) + ISNULL(IUH.[2130], 0) + ISNULL(IUH.[2145], 0) + ISNULL(IUH.[2200], 0)) AS C2200,

		(ISNULL(IUH.[2215], 0) + ISNULL(IUH.[2230], 0) + ISNULL(IUH.[2245], 0) + ISNULL(IUH.[2300], 0)) AS C2300,

		(ISNULL(IUH.[2315], 0) + ISNULL(IUH.[2330], 0) + ISNULL(IUH.[2345], 0) + ISNULL(IUH.[2359], 0) + ISNULL(IUH.[0], 0)) AS C2400 INTO #TEMPUTILITYHOURLYDATA1
				
				FROM LP_TRANSACTIONS..IDRUSAGEHORIZONTAL IUH WITH (NOLOCK)
				INNER JOIN LP_TRANSACTIONS..EDIACCOUNT EA WITH (NOLOCK)
				ON IUH.EDIACCOUNTID = EA.ID 
				INNER JOIN #TEMPACCOUNTS(NOLOCK) TTA ON TTA.ACCOUNTNO=EA.ACCOUNTNUMBER
				WHERE EA.UTILITYCODE = @UTILITYCODE  --AND IUH.TRANSACTIONSETPURPOSECODE = 52  
				AND EA.ACCOUNTNUMBER IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))
				AND IUH.UNITOFMEASUREMENT IN ('KH')
				AND IUH.[DATE] >= CONVERT(VARCHAR(10), @FROM, 101)
				AND IUH.[DATE] <= CONVERT(VARCHAR(10), @TO, 101)
				ORDER BY EA.UTILITYCODE, EA.ACCOUNTNUMBER, IUH.DATE DESC

	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY
		[DATE]
		ORDER BY
		[DATE] DESC,
		METERNUMBER DESC,
		TIMESTAMPINSERT DESC

		) AS ROW_NUM INTO #TEMPUTILITYHOURLYDATA
	FROM #TEMPUTILITYHOURLYDATA1(NOLOCK)
	
	
	/*  
	  IF WE HAVE RECORDS OF TWO ACCOUNT NUMBER 1 FOR WHICH WE HAVE RECORDS ON CURRENT DATE.2 FOR WHICH WE HAVE RECORDS EARLIER. THEN IF WE HAVE DATE CONFLICT THEN 
	  WE TAKE ONE OF THEM.
	*/

		--DELETE FROM #TEMPUTILITYHOURLYDATA WHERE ROW_NUM>1


	/*
    GIVEN A DATE, IF THERE ARE MULTIPLE RECORDS PER METER NUMBER (METER NUMBER IS DEFINED), THE RECORD WITH THE LATEST RECORD ID IS SELECTED AND ALL OTHER RECORDS ARE DISCARDED.
  
  
  */


	DELETE
		TEMPHOURLYOUTERDATA
	FROM #TEMPUTILITYHOURLYDATA TEMPHOURLYOUTERDATA
	INNER JOIN (SELECT
		MAX(IDRHID) AS IDRHID,
		
		[DATE],
		METERNUMBER
	FROM #TEMPUTILITYHOURLYDATA(NOLOCK)
	WHERE ISNULL(METERNUMBER, '') <> ''
	GROUP BY	
						[DATE],
						METERNUMBER
	HAVING COUNT(1) > 1) TEMPHOURLYINNERDATA
		
		ON TEMPHOURLYOUTERDATA.DATE = TEMPHOURLYINNERDATA.DATE
		AND TEMPHOURLYOUTERDATA.IDRHID <> TEMPHOURLYINNERDATA.IDRHID
		AND ISNULL(TEMPHOURLYOUTERDATA.METERNUMBER, '') <> ''
		AND TEMPHOURLYINNERDATA.METERNUMBER = TEMPHOURLYOUTERDATA.METERNUMBER





	/*
 
 
  
  GIVEN A DATE, IF THERE ARE MULTIPLE RECORDS WITH UNDEFINED METER NUMBER, DE-DUPE THE RECORDS WITH THE SAME 24 HOURLY DATA (HOURLY DATA IS THE SUM OF ALL INTERVALS IN THE HOUR -- SEE BELOW FOR INTERVALS IN EACH HOUR).  THAT IS, IF THERE ARE MULTIPLE RECORDS WITH THE SAME HOURLY DATA FOR EACH HOUR, THEN ONE OF THE RECORD IS SELECTED AND ALL OTHER RECORDS ARE DISCARDED.
AFTER THE RECORDS WITH UNDEFINED METER NUMBER ARE DE-DUPED, IF THERE ARE RECORDS PER METER NUMBER, DE-DUPE THE RECORD OF UNDEFINED METER NUMBER AGAINST THE RECORD OF EACH METER NUMBER FOR EACH DAY WITH THE SAME 24 HOURLY DATA.
  
  
  
  */


	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY
		[DATE]
		,C100, C200, C300, C400
	  , C500, C600, C700, C800
	  , C900, C1000, C1100, C1200
	  , C1300, C1400, C1500, C1600
	  , C1700, C1800, C1900, C2000
	  , C2100, C2200, C2300, C2400
		ORDER BY
		[DATE] DESC,
		METERNUMBER DESC,
		TIMESTAMPINSERT DESC

		) AS MULTIPLEMETERCOUNT INTO #TEMP_HOURLYRECORD
	FROM #TEMPUTILITYHOURLYDATA(NOLOCK)





	CREATE TABLE #TEMPDAILYUSAGEFROMINTERVAL (
		ID INT IDENTITY,
		ACCOUNTNUMBER VARCHAR(50),
		SUMMARIZEDATE DATETIME,
		QUANTITY DECIMAL(18, 9),
		TOTALDAYS INT,
		METERNUMBER VARCHAR(50),
	)

	INSERT INTO #TEMPDAILYUSAGEFROMINTERVAL (ACCOUNTNUMBER,
	SUMMARIZEDATE,
	QUANTITY,
	TOTALDAYS,
	METERNUMBER)
		SELECT
			@ACCOUNTNO AS ACCOUNTNUMBER,
			[DATE] AS SUMMARIZEDATE,
			SUM([C100] + C200 + C300
			+ C400 + C500 + C600
			+ C700 + C800 + C900
			+ C1000 + C1100 + C1200
			+ C1300 + C1400 + C1500
			+ C1600 + C1700 + C1800
			+ C1900 + C2000 + C2100
			+ C2200 + C2300 + C2400) AS QUANTITY,
			COUNT(1) AS TOTALDAYS,
			METERNUMBER

		FROM #TEMP_HOURLYRECORD A(NOLOCK)
		WHERE MULTIPLEMETERCOUNT <= (SELECT
			CASE WHEN MAX(MULTIPLEMETERCOUNT) > 1 THEN
						MAX(MULTIPLEMETERCOUNT) ELSE
					1
			END
		FROM #TEMP_HOURLYRECORD(NOLOCK)
		WHERE A.ACCOUNTNUMBER = ACCOUNTNUMBER
		AND A.DATE = DATE
		AND ISNULL(METERNUMBER, '') <> '')
		GROUP BY	
							[DATE],
							METERNUMBER




	-- SELECTING DATERANGE FOR MIN AND MAX  
	DECLARE
		@YEARMINDATE DATETIME
	DECLARE
		@YEARMAXDATE DATETIME

	SELECT
		@YEARMAXDATE = MAX(SUMMARIZEDATE),
		@YEARMINDATE = DATEADD(DD, -364, @YEARMAXDATE)
	FROM #TEMPDAILYUSAGEFROMINTERVAL


	DELETE
		FROM
			#TEMPDAILYUSAGEFROMINTERVAL
	WHERE SUMMARIZEDATE < @YEARMINDATE




	---   SUM OF USAGE ACCORDING TO THE METER NUMBER  


	SELECT CAST(CAST(SUM(TOTALUSAGE/TOTALDAYS) AS DECIMAL(18, 9))*365 AS INT) AS ANNUALUSAGE,
	@ACCOUNTNO AS ACCOUNTNUMBER,
    MAX(ISIDRRESULTS) AS  ISIDRRESULTS
			FROM 
				(
						 SELECT
								SUM(QUANTITY) AS TOTALUSAGE,
								SUM(TOTALDAYS) AS TOTALDAYS,
								ISNULL(METERNUMBER,'') AS METERNUMBER,
								CASE WHEN COUNT(1) > 0 THEN
											1 ELSE
										0
								END AS ISIDRRESULTS,
							@ACCOUNTNO AS  ACCOUNTNUMBER
	
							FROM #TEMPDAILYUSAGEFROMINTERVAL A(NOLOCK)
							GROUP BY	ISNULL(A.METERNUMBER,'')
				  )VW_SUMMETERNUMBER







		SELECT TOP 1 * 
		      FROM #TEMPDAILYUSAGEFROMINTERVAL(NOLOCK) ORDER BY SUMMARIZEDATE DESC



	SET NOCOUNT OFF;
END