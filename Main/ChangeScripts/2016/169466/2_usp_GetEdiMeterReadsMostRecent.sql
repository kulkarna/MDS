USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetEdiMeterReadsMostRecent]    Script Date: 2/22/2017 3:03:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----/*******************************************************************************  
---- * usp_GetEdiMeterReads  
---- * retrieves most recent usage from the transacton's database (edi)  
---- * usp_GetEdiMeterReadsMostRecent '10058073', 'BANGOR', '2014-04-20 15:30:57.000', '2016-04-20 15:30:57.000'
---- * usp_GetEdiMeterReadsMostRecent '0550099856847001572788', 'ACE', '2014-11-19 15:30:57.000', '2016-11-19 15:30:57.000' 
---- * usp_GetEdiMeterReadsMostRecent '0550100327327000169893', 'ACE', '2014-11-16 15:30:57.000', '2016-11-16 15:30:57.000' 
 --    usp_GetEdiMeterReadsMostRecent '3573126265', 'COMED', '2014-11-21 15:30:57.000', '2016-11-21 15:30:57.000'
---- *******************************************************************************  
---- * 10/20/2014 - Cathy Ghazal  
---- * Created.  
---- * 01/15/2016 -- Santosh Rao  
---- * Modified for Utiltiy PSEG  
-----* Modified By- Vikas Sharma  
-----* Dated : 02/08/2016  
-----* Modified By - Viikas Sharma  
-----* dated : 04/05/2016  
-----* Modified By - Viikas Sharma  
-----* dated : 04/21/2016  
-----* PBI-116130 (Ability to handle all the measurement significance code)
-----* PBI 135562 - 8/9/2016 - increased temp tables MeasurementSignificanceCode and TransactionSetPurposeCode fields length to 10
---- * Modified for Deleting Duplicate data from EdiUsage and EdiUsageDetail  
-----* Modified By- Vikas Sharma  
-----* Dated : 11/19/2016  
---- *******************************************************************************  
---- */  
ALTER PROCEDURE [dbo].[usp_GetEdiMeterReadsMostRecent] (
	@AccountNumber VARCHAR(50)
	,@utilityCode VARCHAR(50)
	,@BeginDate DATETIME
	,@EndDate DATETIME
	)
AS
BEGIN
	SET NOCOUNT ON;

	/* For Testing Start   
         
              if object_id('tempdb..#usage') is not null  
                     drop table #usage  
            
              if object_id('tempdb..#usage2') is not null  
                     drop table #usage2  
            
              if object_id('tempdb..#M') is not null  
                     drop table #M  
            
              if object_id('tempdb..#ONE') is not null  
                     drop table #ONE  
            
              if object_id('tempdb..#U') is not null  
                     drop table #U  
                   
              if object_id('tempdb..#Unique') is not null  
                     drop table #Unique  
  
              if object_id('tempdb..#TEMPACCOUNTS') is not null  
                     drop table #TEMPACCOUNTS  
  
                     --Declare @AccountNumber     varchar(50)  
                     --Declare @utilityCode varchar(50)  
                    -- Declare @BeginDate         datetime  
                   --  Declare @EndDate           datetime  
  
                     SET @AccountNumber='PE000011446799641477'  
                     SET @utilityCode ='PSEG'  
                     --SET @BeginDate='2015-11-19 00:00:00.000'  
                     --SET @EndDate='2015-12-21 00:00:00.000'  
                     SET @BeginDate='2009-11-18 00:00:00.000'  
                     SET @EndDate='2009-12-18 00:00:00.000'  
         
        For Testing End */
	DECLARE @multipleMeters SMALLINT

	SELECT @multipleMeters = multipleMeters
	FROM libertyPower..Utility
	WHERE UtilityCode = @utilityCode

	SELECT *
	INTO #TEMPACCOUNTS
	FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@accountnumber)

	CREATE TABLE #usage (
		UsageID BIGINT
		,AccountNumber VARCHAR(30)
		,UtilityCode VARCHAR(20)
		,BeginDate DATETIME
		,EndDate DATETIME
		,Quantity INT
		,MeasurementSignificanceCode VARCHAR(10)
		,MeterNumber VARCHAR(50)
		,TransactionSetPurposeCode VARCHAR(10)
		,BaseSource  varchar(20)
		)

	CREATE TABLE #usage2 (
		UsageID BIGINT
		,AccountNumber VARCHAR(30)
		,UtilityCode VARCHAR(20)
		,BeginDate DATETIME
		,EndDate DATETIME
		,Quantity INT
		,MeasurementSignificanceCode VARCHAR(10)
		,MeterNumber VARCHAR(50)
		,TransactionSetPurposeCode VARCHAR(10)
		,BaseSource  varchar(20)
		)

	INSERT INTO #usage
	SELECT DISTINCT UsageID
		,AccountNumber
		,UtilityCode
		,BeginDate
		,EndDate
		,abs(Quantity)
		,MeasurementSignificanceCode
		,MeterNumber
		,TransactionSetPurposeCode
		,BaseSource
	--FROM [vw_edi_historical_usage_New](NOLOCK) t1
	FROM ufn_GetEdiAccountUsage(@AccountNumber, @utilityCode, @BeginDate, @EndDate) t1
	WHERE accountnumber IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND @utilityCode NOT IN (
			'AMEREN'
			,'PSEG'
			)
		AND utilityCode = @utilityCode
		AND TransactionSetPurposeCode IN (
			'52'
			,'00'
			,'01'
			)
			
			
	-- and MeasurementSignificanceCode in ('51', '22', '46')  
	
	UNION
	
	/*Start Modification*/
	SELECT DISTINCT UsageID
		,AccountNumber
		,UtilityCode
		,BeginDate
		,EndDate
		,abs(Quantity)
		,MeasurementSignificanceCode
		,MeterNumber
		,TransactionSetPurposeCode
		,BaseSource
	--FROM [vw_edi_historical_usage_New] t1(NOLOCK)
	FROM ufn_GetEdiAccountUsage(@AccountNumber, @utilityCode, @BeginDate, @EndDate) t1 
	WHERE accountnumber IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND @utilityCode = 'PSEG'
		AND utilityCode = @utilityCode
		AND TransactionSetPurposeCode IN (
			'52'
			,'00'
			,'01'
			)
		AND MeasurementSignificanceCode IN (
			'51'
			,'22'
			,'46'
			)
		AND NOT EXISTS (
			SELECT 1
			--FROM [vw_edi_historical_usage_New] t2(NOLOCK)
			FROM ufn_GetEdiAccountUsage(@AccountNumber, @utilityCode, @BeginDate, @EndDate) t2
			WHERE t2.accountnumber = t1.AccountNumber --IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))   
				AND t2.TransactionSetPurposeCode IN (
					'52'
					,'00'
					,'01'
					)
				AND t2.MeasurementSignificanceCode IN (
					'41'
					,'42'
					,'43'
					)
				AND t1.BeginDate = t2.BeginDate
				AND t1.EndDate = t2.EndDate
			)
	/*End Modification*/
	
	UNION
	
	SELECT DISTINCT b.ID AS UsageID
		,a.AccountNumber
		,a.UtilityCode
		,b.BeginDate
		,b.EndDate
		,abs(b.Quantity)
		,MeasurementSignificanceCode
		,b.MeterNumber
		,b.TransactionSetPurposeCode
		,'t2'BaseSource
	FROM EdiAccount a(NOLOCK)
	INNER JOIN EdiUsageDetail b(NOLOCK) ON a.id = b.ediaccountid
	WHERE accountnumber IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND UnitOfMeasurement = 'kh'
		AND b.MeterNumber <> ''
		AND @utilityCode = 'AMEREN'
		AND TransactionSetPurposeCode IN (
			'52'
			,'00'
			,'01'
			)
		AND MeasurementSignificanceCode IN (
			'51'
			,''
			)
		
			

	-- ERCOT Re-Bills  
	INSERT INTO #usage
	SELECT DISTINCT UsageID
		,AccountNumber
		,UtilityCode
		,BeginDate
		,EndDate
		,abs(Quantity)
		,MeasurementSignificanceCode
		,MeterNumber
		,TransactionSetPurposeCode
		,BaseSource
	--FROM [vw_edi_historical_usage_New](NOLOCK)
	FROM ufn_GetEdiAccountUsage(@AccountNumber, @utilityCode, @BeginDate, @EndDate)
	WHERE accountnumber IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND @utilityCode IN (
			SELECT DISTINCT t3.utilitycode
			FROM libertypower..utility t3
			WHERE WholeSaleMktID = 'ERCOT'
			)
		AND utilityCode = @utilityCode
		AND TransactionSetPurposeCode IN ('05')
		AND MeasurementSignificanceCode IN ('51')
		
		---  Added By : Vikas Sharma
			--- To Remove ENTRIEs of Data comes from Ediusage and ediusagedetails both
			--- PBI : 151999
						
			delete UG2 from #usage UG 	
		     inner join #usage UG2 on ug.begindate=ug2.begindate and ug.EndDate=ug2.EndDate
		  where UG.BaseSource='t1' and UG2.BaseSource='t2'
	

	IF @@ROWCOUNT > 0
	BEGIN
		DELETE
		FROM #usage
		WHERE AccountNumber IN (
				SELECT DISTINCT t1.AccountNumber
				FROM #usage t1
				WHERE t1.BeginDate = #usage.BeginDate
					AND t1.EndDate = #usage.EndDate
					AND t1.TransactionSetPurposeCode = '05'
				)
			AND TransactionSetPurposeCode = '00'

		UPDATE #usage
		SET TransactionSetPurposeCode = '00'
		WHERE TransactionSetPurposeCode = '05'
	END

	INSERT INTO #usage
	SELECT DISTINCT UsageID
		,AccountNumber
		,UtilityCode
		,BeginDate
		,EndDate
		,abs(Quantity)
		,MeasurementSignificanceCode
		,MeterNumber
		,TransactionSetPurposeCode
		,BaseSource
	--FROM [vw_edi_historical_usage_New] t1(NOLOCK)
	FROM ufn_GetEdiAccountUsage(@AccountNumber, @utilityCode, @BeginDate, @EndDate) t1
	WHERE accountnumber IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND @utilityCode = 'PSEG'
		AND utilityCode = @utilityCode
		AND accountnumber NOT IN (
			SELECT DISTINCT t2.accountnumber
			FROM #usage t2
			WHERE t1.accountnumber = t2.accountnumber
				AND t1.BeginDate = t2.BeginDate
				AND t1.EndDate = t2.EndDate
			)
		AND TransactionSetPurposeCode IN ('00')
		AND MeasurementSignificanceCode IN (
			'51'
			,'22'
			,'46'
			)

	INSERT INTO #usage
	SELECT DISTINCT UsageID
		,AccountNumber
		,UtilityCode
		,BeginDate
		,EndDate
		,abs(Quantity)
		,MeasurementSignificanceCode
		,MeterNumber
		,TransactionSetPurposeCode
		,BaseSource
	--FROM [vw_edi_historical_usage_New](NOLOCK) t1
	FROM ufn_GetEdiAccountUsage(@AccountNumber, @utilityCode, @BeginDate, @EndDate) t1
	WHERE accountnumber IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND @utilityCode <> 'AMEREN'
		AND accountnumber NOT IN (
			SELECT DISTINCT t2.accountnumber
			FROM #usage t2
			WHERE t1.accountnumber = t2.accountnumber
				AND t1.BeginDate = t2.BeginDate
				AND t1.EndDate = t2.EndDate
			)
		AND utilityCode = @utilityCode
		AND TransactionSetPurposeCode IN (
			'52'
			,'00'
			,'01'
			)
	--and MeasurementSignificanceCode in ('41','42','43')  
	
	UNION
	
	SELECT DISTINCT b.ID AS UsageID
		,a.AccountNumber
		,a.UtilityCode
		,b.BeginDate
		,b.EndDate
		,abs(b.Quantity)
		,MeasurementSignificanceCode
		,b.MeterNumber
		,b.TransactionSetPurposeCode
		,'t2' BaseSource
	FROM EdiAccount a(NOLOCK)
	INNER JOIN EdiUsageDetail b(NOLOCK) ON a.id = b.ediaccountid
	WHERE accountnumber IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND accountnumber NOT IN (
			SELECT DISTINCT t2.accountnumber
			FROM #usage t2
			WHERE a.accountnumber = t2.accountnumber
				AND b.BeginDate = t2.BeginDate
				AND b.EndDate = t2.EndDate
			)
		AND UnitOfMeasurement = 'kh'
		AND b.MeterNumber <> ''
		AND @utilityCode = 'AMEREN'
		AND TransactionSetPurposeCode IN (
			'52'
			,'00'
			,'01'
			)
		AND MeasurementSignificanceCode IN (
			'41'
			,'42'
			,'43'
			)

	--Select @multipleMeters;  
	/*
  Added for PBI 116130 for all utilities except PSEG and AMEREN if we have measurementsignificance Code=51
  then we will take this record other wise we wil sum up all the other utilites record.
  */
	SELECT *
	INTO #usage1
	FROM #usage
	WHERE MeasurementSignificanceCode = '51'

	INSERT INTO #usage1
	SELECT t1.*
	FROM #usage t1
	WHERE NOT EXISTS (
			SELECT 1
			FROM #usage1 t2
			WHERE t1.AccountNumber = t2.AccountNumber
				AND t1.BeginDate = t2.BeginDate
				AND t1.EndDate = t2.EndDate
			)
	ORDER BY t1.BeginDate DESC

	IF @multipleMeters = 0
	BEGIN
		-- print '@multipleMeters=0 IF'  
		INSERT INTO #usage2
		SELECT DISTINCT MAx(UsageID) AS UsageID
			,@AccountNumber AS AccountNumber
			,UtilityCode
			,BeginDate
			,EndDate
			,Quantity
			,MeasurementSignificanceCode
			,max(MeterNumber) MeterNumber
			,TransactionSetPurposeCode
			,max(BaseSource) as BaseSource
		FROM #usage1
		WHERE beginDate >= @BeginDate
			AND endDate <= @EndDate
		GROUP BY
			--AccountNumber,  
			UtilityCode
			,Quantity
			,BeginDate
			,EndDate
			,MeasurementSignificanceCode
			,TransactionSetPurposeCode
	END

	IF @multipleMeters = 1
	BEGIN
		--print '@multipleMeters=1 IF'  
		SELECT UsageID
			,ROW_NUMBER() OVER (
				PARTITION BY UtilityCode
				,BeginDate
				,EndDate
				,Quantity ORDER BY TransactionSetPurposeCode ASC
				) AS Row_NUM
			,UtilityCode
			,BeginDate
			,EndDate
			,Quantity
			,'' MeasurementSignificanceCode
			,MeterNumber
			,MeterNumber AS previousvalue
			,TransactionSetPurposeCode
		INTO #M14
		FROM #usage1(NOLOCK)

		--update A set  a.MeterNumber=B.meternumber  
		--from #M14  A   
		--inner join (select * from #M14(NOLOCK) where Row_NUM=2 )B   
		--on A.BeginDate=b.BeginDate and   
		--a.EndDate=b.EndDate and a.Quantity=b.Quantity  
		--and a.MeterNumber=''  
		UPDATE b
		SET b.previousvalue = a.previousvalue
		FROM #M14 A
		LEFT JOIN #M14 B ON A.BeginDate = b.BeginDate
			AND a.EndDate = b.EndDate
			AND a.Quantity = b.Quantity
		WHERE a.Row_NUM <> b.Row_NUM
			AND a.Row_NUM < b.Row_NUM

		DELETE
		FROM #M14
		WHERE ROW_NUM > 2
			AND previousvalue = ''

		SELECT MAX(UsageID) AS UsageID
			,@AccountNumber AS AccountNumber
			,UtilityCode
			,BeginDate
			,EndDate
			,Sum(Quantity) AS Quantity
			,'' MeasurementSignificanceCode
			,MeterNumber
			,TransactionSetPurposeCode
		INTO #M
		FROM #M14
		WHERE beginDate >= @BeginDate
			AND endDate <= @EndDate
		GROUP BY
			--AccountNumber,  
			UtilityCode
			,BeginDate
			,EndDate
			,MeterNumber
			,TransactionSetPurposeCode
		ORDER BY 4
			,7

		SELECT MAX(UsageID) AS UsageID
			,BeginDate
			,EndDate
			,Quantity
			,TransactionSetPurposeCode
		INTO #ONE
		FROM #M
		GROUP BY BeginDate
			,EndDate
			,Quantity
			,TransactionSetPurposeCode

		SELECT DISTINCT m.*
		FROM #M m
		INNER JOIN #ONE o ON m.UsageID = o.UsageID
		--  FROM   #M m    
		--INNER  JOIN #ONE o    
		--ON            m.UsageID=o.UsageID    
		--inner join #usage UT on m.UsageID=ut.UsageID  
		--and m.BeginDate=ut.BeginDate and m.EndDate=m.EndDate  
		--and ut.TransactionSetPurposeCode=m.TransactionSetPurposeCode  
		--and ut.MeasurementSignificanceCode=m.MeasurementSignificanceCode  
		--and ut.MeterNumber=m.MeterNumber  
		--and ut.Quantity=m.Quantity  
		--and ut.UtilityCode=m.UtilityCode   
		ORDER BY 4
			,7
	END
	ELSE
	BEGIN
		--print '@multipleMeters=1 Else'  
		SELECT MAX(UsageID) AS UsageID
			,@AccountNumber AS AccountNumber
			,UtilityCode
			,BeginDate
			,EndDate
			,Sum(Quantity) AS Quantity
			,'' MeasurementSignificanceCode
			,max(MeterNumber) MeterNumber
			,TransactionSetPurposeCode
		INTO #U
		FROM #usage2
		WHERE beginDate >= @BeginDate
			AND endDate <= @EndDate
		GROUP BY
			--AccountNumber,  
			UtilityCode
			,BeginDate
			,EndDate
			,TransactionSetPurposeCode
		ORDER BY 4
			,7

		SELECT MAX(UsageID) AS UsageID
			,BeginDate
			,EndDate
			,Quantity
			,TransactionSetPurposeCode
		INTO #Unique
		FROM #U
		GROUP BY BeginDate
			,EndDate
			,Quantity
			,TransactionSetPurposeCode

		SELECT DISTINCT m.*
		FROM #U m
		INNER JOIN #Unique o ON m.UsageID = o.UsageID
		-- FROM   #U m    
		--INNER  JOIN #Unique o    
		--ON            m.UsageID=o.UsageID   
		--inner join #usage UT on m.UsageID=ut.UsageID  
		--and m.BeginDate=ut.BeginDate and m.EndDate=m.EndDate  
		--and ut.TransactionSetPurposeCode=m.TransactionSetPurposeCode  
		--and ut.MeasurementSignificanceCode=m.MeasurementSignificanceCode  
		--and ut.MeterNumber=m.MeterNumber  
		--and ut.Quantity=m.Quantity  
		--and ut.UtilityCode=m.UtilityCode   
		ORDER BY 4
			,7
	END

	SET NOCOUNT OFF;
END

