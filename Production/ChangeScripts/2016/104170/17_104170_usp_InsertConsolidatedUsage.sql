USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertConsolidatedUsage]    Script Date: 02/26/2016 12:32:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*******************************************************************************  
 * usp_InsertConsolidatedUsage  
 * Inserts usage into the usage (consolidated) table  
 *  
 * History  
 *  08/08/2011 (EP) - compensating for multiple meters..  
 *  08/15/2011 (EP) - compensating for new usage type column added to EstimatedUsage  
 *  10/19/2015 Jose Munoz  
 *     Avoid unnecessary update in the table OfferEngineDB..OE_ACCOUNT.  
 *     PBI #92975  
 *******************************************************************************  
 * 12/02/2010 - Eduardo Patino  
 * Created.  
 *  
 *******************************************************************************  
 * 9/26/2014 - Rick Deigsler  
 * Changed data type for TotalKwh to bigint for temp table #staging  
 *******************************************************************************  
 */  
  
ALTER PROCEDURE [dbo].[usp_InsertConsolidatedUsage]  
 @AccountNumber   varchar(50),  
 @UtilityCode   varchar(50),  
 @UsageSource   int,  
 @UsageType    int,  
 @FromDate    datetime,  
 @ToDate     datetime,  
 @TotalKwh    int,  
 @DaysUsed    int    = NULL,  
 @MeterNumber   varchar(50)  = NULL,  
 @OnPeakKwh    decimal(15,6) = NULL,  
 @OffPeakKwh    decimal(15,6) = NULL,  
 @BillingDemandKw  decimal(15,6) = NULL,  
 @MonthlyPeakDemandKw decimal(15,6) = NULL,  
 @IntermediateKwh  decimal(15,6) = NULL,  
 @MonthlyOffPeakDemandKw decimal(15,6) = NULL,  
 @modified    datetime  = NULL,  
 @UserName    varchar(50),  
 @active     smallint,  
 @reasonCode    smallint  = NULL  
AS  
/*  
select * from reasoncode  
select * from sys.procedures where name = 'usp_InsertConsolidatedUsage'  
select top 20 * from UsageConsolidated (nolock)  
  
declare  @AccountNumber   varchar(50),  
 @UtilityCode   varchar(50),  
 @FromDate    datetime,  
 @ToDate     datetime,  
 @active     smallint,  
 @UsageType    int,  
 @TotalKwh    int,  
 @MeterNumber   varchar(50) 
 
  
set @AccountNumber = '00040621064995593'  
set @UtilityCode = 'CSP'  
s @FromDate  = cast('2014-02-25 13:51:57.113' as datetime) 
set @ToDate   = cast('2016-02-25 13:51:57.113-04-09' as datetime) 
set @active   = 1  
set @UsageType  = 2  
set @TotalKwh  = 2751  
set @MeterNumber = '224988967'																 
*/  
  
BEGIN  
    SET NOCOUNT ON;  
 declare @multipleMeter smallint  
-- select @estimate = value from usagetype where description = 'Estimated'  
  
 -- eliminate time component  
 SET @FromDate = CAST(DATEPART(mm, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @FromDate) AS varchar(4))  
 SET @ToDate = CAST(DATEPART(mm, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @ToDate) AS varchar(4))  
  
 select @multipleMeter = multipleMeters from libertypower..utility WHERE utilityCode = @UtilityCode  
 -- select @multipleMeter  
  
IF @multipleMeter = 1 AND NOT EXISTS (  
 SELECT UtilityCode  
 FROM UsageConsolidated WITH (NOLOCK)  
 WHERE AccountNumber = @AccountNumber  
  AND UtilityCode  = @UtilityCode  
  AND FromDate  = @FromDate  
  AND ToDate   = @ToDate  
  AND Active   = @Active  
  AND MeterNumber  = @MeterNumber )  
 BEGIN  
  -- - - - - - - - - - - - - - - - - - - - - - - -   
  print '' print '* ' + lp_historical_info.dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + ' INSERT INTO UsageConsolidated [1]..'  
  -- - - - - - - - - - - - - - - - - - - - - - - -   
  INSERT INTO UsageConsolidated  
     (AccountNumber, UtilityCode, FromDate, ToDate, TotalKwh, DaysUsed, MeterNumber, OnPeakKWH, IntermediateKwh,  
      OffPeakKWH, BillingDemandKW, MonthlyPeakDemandKW, MonthlyOffPeakDemandKw, Created, CreatedBy, UsageType, UsageSource,  
      modified, Active, ReasonCode)  
  VALUES  (@AccountNumber, @UtilityCode, @FromDate, @ToDate, @TotalKwh, @DaysUsed, @MeterNumber, @OnPeakKWH, @IntermediateKwh,  
      @OffPeakKWH, @BillingDemandKW, @MonthlyPeakDemandKW, @MonthlyOffPeakDemandKw, getdate(), @UserName, @UsageType, @UsageSource,  
      @modified, @Active, @ReasonCode)  
 END  
  
IF @multipleMeter = 0 AND NOT EXISTS (  
 SELECT UtilityCode  
 FROM UsageConsolidated WITH (NOLOCK)  
 WHERE AccountNumber = @AccountNumber  
  AND UtilityCode  = @UtilityCode  
  AND FromDate  = @FromDate  
  AND Active   = @Active  
  AND ToDate   = @ToDate )  
 BEGIN  
  -- - - - - - - - - - - - - - - - - - - - - - - -   
  print '' print '* ' + lp_historical_info.dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + ' INSERT INTO UsageConsolidated [2]..'  
  -- - - - - - - - - - - - - - - - - - - - - - - -   
  INSERT INTO UsageConsolidated  
     (AccountNumber, UtilityCode, FromDate, ToDate, TotalKwh, DaysUsed, MeterNumber, OnPeakKWH, IntermediateKwh,  
      OffPeakKWH, BillingDemandKW, MonthlyPeakDemandKW, MonthlyOffPeakDemandKw, Created, CreatedBy, UsageType, UsageSource,  
      modified, Active, ReasonCode)  
  VALUES  (@AccountNumber, @UtilityCode, @FromDate, @ToDate, @TotalKwh, @DaysUsed, @MeterNumber, @OnPeakKWH, @IntermediateKwh,  
      @OffPeakKWH, @BillingDemandKW, @MonthlyPeakDemandKW, @MonthlyOffPeakDemandKw, getdate(), @UserName, @UsageType, @UsageSource,  
      @modified, @Active, @ReasonCode)  
 END  
  
IF @multipleMeter = 1  
 BEGIN  
  SELECT ID, AccountNumber, UtilityCode, FromDate, ToDate, TotalKwh, DaysUsed, Created, CreatedBy, UsageType, UsageSource, Active, ReasonCode, MeterNumber  
  FROM UsageConsolidated WITH (NOLOCK)  
  WHERE AccountNumber = @AccountNumber  
   AND UtilityCode  = @UtilityCode  
   AND FromDate  = @FromDate  
   AND ToDate   = @ToDate  
--   AND UsageType  = @UsageType  
   AND Active   = @Active  
   AND MeterNumber  = @MeterNumber  
  ORDER BY 3 DESC  
 END  
ELSE  
 BEGIN  
   
  SELECT ID, AccountNumber, UtilityCode, FromDate, ToDate, TotalKwh, DaysUsed, Created, CreatedBy, UsageType, UsageSource, Active, ReasonCode, MeterNumber  
  FROM UsageConsolidated WITH (NOLOCK)  
  WHERE AccountNumber = @AccountNumber  
   AND UtilityCode  = @UtilityCode  
   AND FromDate  = @FromDate  
   AND ToDate   = @ToDate  
--   AND UsageType  = @UsageType
   and TotalKwh=@TotalKwh
   
     
   AND Active   = @Active  
  ORDER BY 3 DESC  
 END  
  
 DECLARE @MaxDate  datetime,  
   @AnnualUsage bigint  
  
 -- update usage date and annual usge in Offer Engine, if applicable  
 SELECT @MaxDate = MAX(ToDate)  
 FROM UsageConsolidated WITH (NOLOCK)  
 WHERE AccountNumber = @AccountNumber  
  AND UtilityCode  = @UtilityCode  
  
 /* PBI #92975 old code commented before 10/19/2015  
 UPDATE OfferEngineDB..OE_ACCOUNT  
 SET  USAGE_DATE  = @MaxDate  
 WHERE ACCOUNT_NUMBER = @AccountNumber    
  AND UTILITY   = @UtilityCode
 */  
  
 CREATE TABLE #staging (TotalKwh bigint, FromDate datetime, ToDate datetime)  
 insert into #staging  
 SELECT u.TotalKwh, u.FromDate, u.ToDate  
 FROM UsageConsolidated u WITH (NOLOCK)  
   INNER JOIN OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType -- <-- TODO: ask rick to point to the new table - 12/03/2010  
   INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]  
   INNER JOIN OfferEngineDB..OE_ACCOUNT a  WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER  
 WHERE a.ACCOUNT_NUMBER = @AccountNumber  
  AND a.UTILITY   = @UtilityCode  
 UNION  
 SELECT u.TotalKwh, u.FromDate, u.ToDate  
 FROM EstimatedUsage u WITH (NOLOCK)  
   INNER JOIN OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType -- <-- TODO: ask rick to point to the new table - 12/03/2010  
   INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]  
   INNER JOIN OfferEngineDB..OE_ACCOUNT a  WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER  
 WHERE a.ACCOUNT_NUMBER = @AccountNumber  
  AND a.UTILITY   = @UtilityCode  
--  AND m.UsageType   = @estimate  
  
 SELECT @AnnualUsage = CAST((SUM(TotalKwh) * CAST(365 AS float) /   
   CASE WHEN CAST(SUM(DATEDIFF(dd, FromDate, ToDate)) AS float) = 0 THEN 1 ELSE CAST(SUM(DATEDIFF(dd, FromDate, ToDate)) AS float) END) AS bigint)  
 FROM #staging  
  
  
 /* PBI #92975 Begin 10/19/2015*/  
 IF EXISTS ( SELECT NULL FROM OfferEngineDB..OE_ACCOUNT A WITH (NOLOCK)  
    WHERE A.ACCOUNT_NUMBER = @AccountNumber   
    AND A.UTILITY   = @UtilityCode  
    AND ((ANNUAL_USAGE  <> @AnnualUsage)  
      OR (USAGE_DATE  <> @MaxDate)))  
 BEGIN  
  UPDATE OfferEngineDB..OE_ACCOUNT  
  SET  USAGE_DATE  = @MaxDate  
   ,ANNUAL_USAGE  = CASE WHEN @AnnualUsage IS NOT NULL AND @AnnualUsage > 0 THEN @AnnualUsage ELSE ANNUAL_USAGE END  
  WHERE ACCOUNT_NUMBER = @AccountNumber  
   AND UTILITY   = @UtilityCode  
 END  
 /* PBI #92975 End 10/19/2015*/  
  
 /* PBI #92975 old code commented before 10/19/2015  
 IF @AnnualUsage IS NOT NULL AND @AnnualUsage > 0  
  BEGIN  
   UPDATE OfferEngineDB..OE_ACCOUNT  
   SET  ANNUAL_USAGE = @AnnualUsage  
   WHERE ACCOUNT_NUMBER = @AccountNumber  
    AND UTILITY   = @UtilityCode  
  END  
 */  
  
 SET NOCOUNT OFF;  
END  
-- Copyright 2010 Liberty Power