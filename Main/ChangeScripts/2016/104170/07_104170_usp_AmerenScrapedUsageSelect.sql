USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_AmerenScrapedUsageSelect]    Script Date: 02/09/2016 12:00:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_AmerenScrapedUsageSelect] (
	@AccountNumber VARCHAR(50)
	,@BeginDate DATETIME
	,@EndDate DATETIME
	,@MeterNumber VARCHAR(50) = ''
	)
AS
/*  
select * from AmerenAccount order by 2, 6  
usp_AmerenScrapedUsageSelect '0005002917',  '2008-11-16', '2016-01-16' -- Lighting  
*/
BEGIN
	SET NOCOUNT ON;

	SELECT *
	INTO #TEMPACCOUNTS
	FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@AccountNumber)

	IF @MeterNumber <> ''
	BEGIN
		SELECT DISTINCT t2.Id
			,AccountId
			,BeginDate
			,EndDate
			,Days
			,TotalKwh
			,OnPeakKwh
			,OffPeakKwh
			,OnPeakDemandKw
			,OffPeakDemandKw
			,PeakReactivePowerKvar
			,AccountNumber
			,MeterNumber
			,t2.Created
			,ROW_NUMBER() OVER (
				PARTITION BY BeginDate
				,EndDate
				,Days
				,TotalKwh
				,MeterNumber ORDER BY MeterNumber DESC
				) AS Row_Num
		INTO #tempUsageIf
		FROM AmerenAccount(NOLOCK) t1
		INNER JOIN AmerenUsage(NOLOCK) t2 ON AccountId = t1.Id
		WHERE ACCOUNTNUMBER IN (
				SELECT ACCOUNTNO AS ACCOUNTNUMBER
				FROM #TEMPACCOUNTS(NOLOCK)
				)
			AND MeterNumber = @MeterNumber
			AND BeginDate >= @BeginDate
			AND EndDate <= @EndDate
		ORDER BY 3 DESC
			,4

		DELETE
		FROM #tempUsageIf
		WHERE Row_Num >1

		SELECT Id
			,AccountId
			,BeginDate
			,EndDate
			,Days
			,TotalKwh
			,OnPeakKwh
			,OffPeakKwh
			,OnPeakDemandKw
			,OffPeakDemandKw
			,PeakReactivePowerKvar
			,AccountNumber
			,MeterNumber
			,Created
		FROM #tempUsageIf
	END
	ELSE
	BEGIN
		SELECT DISTINCT t2.Id
			,AccountId
			,BeginDate
			,EndDate
			,Days
			,TotalKwh
			,OnPeakKwh
			,OffPeakKwh
			,OnPeakDemandKw
			,OffPeakDemandKw
			,PeakReactivePowerKvar
			,AccountNumber
			,MeterNumber
			,t2.Created
			,ROW_NUMBER() OVER (
				PARTITION BY BeginDate
				,EndDate
				,Days
				,TotalKwh
				,MeterNumber ORDER BY MeterNumber DESC
				) AS Row_Num
		INTO #tempUsageElse
		FROM AmerenAccount(NOLOCK) t1
		INNER JOIN AmerenUsage(NOLOCK) t2 ON AccountId = t1.Id
		WHERE ACCOUNTNUMBER IN (
				SELECT ACCOUNTNO AS ACCOUNTNUMBER
				FROM #TEMPACCOUNTS(NOLOCK)
				)
			AND BeginDate >= @BeginDate
			AND EndDate <= @EndDate
		ORDER BY 2
			,3 DESC
			,4

		DELETE A
		FROM #tempUsageElse A
		WHERE Row_Num >1

		SELECT Id
			,AccountId
			,BeginDate
			,EndDate
			,Days
			,TotalKwh
			,OnPeakKwh
			,OffPeakKwh
			,OnPeakDemandKw
			,OffPeakDemandKw
			,PeakReactivePowerKvar
			,AccountNumber
			,MeterNumber
			,Created
		FROM #tempUsageElse
	END

	SET NOCOUNT OFF;
END
