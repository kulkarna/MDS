USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[Usp_GetIDRAnnualUsage]    Script Date: 01/12/2015 02:55:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================  
-- AUTHOR:    <Vikas Sharma>  
-- CREATE DATE: <05-12-2014>  
-- DESCRIPTION:  <The Usp_GetIDRAnnualUsage Gives the Annual Usage For the IDR Data  
-- The Usp_GetIDRAnnualUsage Gives the Annual Usage for the Account No
-- Exec Usp_GetIDRAnnualUsage @AccountNo='00140060799255395',@UtilityCode='OHP',@From='2012-12-26 06:51:59.733',@To='2014-12-26 06:51:59.733'
-- Exec Usp_GetIDRAnnualUsage @AccountNo='145',@UtilityCode='COMED',@From='2012-12-05 06:51:59.733',@To='2014-12-05 06:51:59.733'

-- =============================================  
CREATE PROCEDURE [dbo].[Usp_GetIDRAnnualUsage]
@AccountNo varchar(50),
@UtilityCode varchar(50),
@From datetime,
@To datetime

  AS
  BEGIN
  
  SET NOCOUNT ON;
    DECLARE
      @chvDynamicQuery nvarchar(max)
    DECLARE
      @chvIntervalColumnSumList varchar(max) --  This variable  stores the Columns list with + from IDRUSAGEHORIZONTAL  
    DECLARE
      @insMultipleMeters smallint = 0

    -- Firstly We Want to know all the interval Datas Columns which is total 96 in counting.  
    SELECT
      @chvIntervalColumnSumList =
      STUFF(
      (
      SELECT
        '+ isnull([' + COLUMN_NAME + '],0)'
        FROM
          LP_TRANSACTIONS..VW_IDR_HORIZONTAL_COLUMNS
      FOR xml PATH ('')
      )
      , 1, 1, '')

    -- Creating the Dynamic Query so that the Data for the Daily Basis of this Account Can be fetched  

    SET @chvDynamicQuery = 'SELECT  
       IDRHRL.EdiAccountId as AccountId,
        EAC.AccountNumber,
       [DATE] AS SummarizeDate,  
       cast(' + @chvIntervalColumnSumList + ' as decimal(18,9)) as Quantity,   
       IDRHRL.MeterNumber 
  FROM LP_TRANSACTIONS..IDRUSAGEHORIZONTAL(NOLOCK) IDRHRL  
  Inner join (select max(ID) as ID,AccountNumber from  LP_TRANSACTIONS..EdiAccount(NOLOCK)
   where AccountNumber=''' + @AccountNo + ''' and UtilityCode='''+@UtilityCode+''' 
   group by AccountNumber,UtilityCode
   ) EAC  
  on EAC.ID=IDRHRL.EdiAccountId  
  where UnitOfMeasurement=''KH''
  and IDRHRL.[Date]>=''' + CONVERT(varchar(10), @From, 101) + ''' and IDRHRL.[Date]<=''' + CONVERT(varchar(10), @To, 101) + ''''


    CREATE TABLE #TempDailyUsageFromInterval
      (
        ID int IDENTITY,
        AccountID int,
        AccountNumber varchar(50),
        SummarizeDate datetime,
        Quantity decimal(18,9),
        MeterNumber varchar(50),
      )

    INSERT
      INTO
      #TempDailyUsageFromInterval
        (
          AccountID,
          AccountNumber,
          SummarizeDate,
          Quantity,
          MeterNumber
        )

    EXEC sp_Executesql
      @chvDynamicQuery



    -- Selecting DateRange For Min and Max
    DECLARE
      @yearMinDate datetime
    DECLARE
      @yearMaxDate datetime

    SELECT
      @yearMaxDate = MAX(SummarizeDate),
      @yearMinDate = DATEADD(DD, -364, @yearMaxDate)
      FROM
        #TempDailyUsageFromInterval





    --   Delete Duplicate Data Having Same Account Number 
    --,Date,MeterNumber But Different Quantitity
    -- But the Date of One year from the Last Max Date

    DELETE
      A
      FROM
        #TempDailyUsageFromInterval A
          INNER JOIN
            #TempDailyUsageFromInterval B
              ON
                A.AccountNumber = B.AccountNumber
                AND A.MeterNumber = B.MeterNumber
                AND A.SummarizeDate = B.SummarizeDate
                AND A.Quantity <> B.Quantity
      
      
      
        DELETE
            FROM
               #TempDailyUsageFromInterval 
         WHERE
        SummarizeDate < @yearMinDate
        
        
    ---   Sum of Usage According to the Meter Number



    SELECT
      CASE
        WHEN SUM(AnnualUsage) > 0
          THEN
            CAST(SUM(AnnualUsage) AS int)
        ELSE
          -1
      END AS AnnualUsage,
      AccountNumber,
      CASE
        WHEN COUNT(1) > 0
          THEN
            1
        ELSE
          0
      END AS IsIdrResults
      FROM
        (
        SELECT
          CASE
            WHEN COUNT(1) > 0
              THEN
                CAST(SUM(Quantity) / COUNT(1) AS decimal(18,9)) * 365
            ELSE
              0
          END AS AnnualUsage,
          MeterNumber,
          AccountNumber
          FROM
            #TempDailyUsageFromInterval A
          GROUP BY
            A.MeterNumber,
            A.AccountNumber
        ) vw_SumMeterNumber
      GROUP BY
        AccountNumber
        
      SET NOCOUNT OFF;   
  END


