USE [lp_transactions]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetEdiAccountUsage]    Script Date: 2/22/2017 2:59:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Abhi Kulkarni/Manoj Thanath
-- Create date: 02/22/2017
-- Description:	This table value function will be invoked by the usp_GetEdiMeterReadsMostRecent instead of the view vw_edi_historical_usage_new
-- =============================================

CREATE  FUNCTION [dbo].[ufn_GetEdiAccountUsage] 
(
	@AccountNumber VARCHAR(50)
	,@utilityCode VARCHAR(50)
	,@BeginDate DATETIME
	,@EndDate DATETIME
)
RETURNS  @UsageData TABLE 
(
	-- Add the column definitions for the TABLE variable here
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
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	insert into @UsageData (AccountNumber, UtilityCode, BeginDate, EndDate, Quantity, MeasurementSignificanceCode, TransactionSetPurposeCode, MeterNumber, UsageID, BaseSource)
	(
	 SELECT distinct  
	  --a.EdiFileLogID  
	  a.AccountNumber  
	  ,a.UtilityCode  
	  ,b.BeginDate  
	  ,b.EndDate  
	  ,b.Quantity  
	  ,b.MeasurementSignificanceCode  
	  ,b.TransactionSetPurposeCode  
	  ,b.MeterNumber  
	  ,b.ID as UsageID
	  ,'t1'   as BaseSource
	 FROM  
	  [lp_transactions].[dbo].[EdiAccount] a (NOLOCK) inner join  
	  [lp_transactions].dbo.EdiUsage b (NOLOCK) on a.id=b.ediaccountid 
  
	 where 1=1 
	  and b.UnitOfMeasurement='kh' 
	  and a.AccountNumber = @AccountNumber
	  and a.UtilityCode = @utilityCode
	  and b.BeginDate >= @BeginDate
	  and b.EndDate <= @EndDate

	 UNION  
	 SELECT distinct  
	  --a.EdiFileLogID  
	  a.AccountNumber  
	  ,a.UtilityCode  
	  ,b.BeginDate  
	  ,b.EndDate  
	  ,b.Quantity  
	  ,b.MeasurementSignificanceCode  
	  ,b.TransactionSetPurposeCode  
	  ,b.MeterNumber  
	  ,b.ID as UsageID  
	  ,'t2'   as BaseSource
	 FROM   
	  [lp_transactions].[dbo].[EdiAccount] a (NOLOCK) inner join  
	  [lp_transactions].[dbo].[EdiUsageDetail] b (NOLOCK) on a.id=b.ediaccountid  
	 where [UnitOfMeasurement]='kh'
	 -- and [MeasurementSignificanceCode] = '22'  
	  --and b.TransactionSetPurposeCode=52  
	   and a.AccountNumber = @AccountNumber
	  and a.UtilityCode = @utilityCode
	  and b.BeginDate >= @BeginDate
	  and b.EndDate <= @EndDate

	 UNION  
	 SELECT distinct  
	  --a.EdiFileLogID  
	  a.AccountNumber  
	  ,a.UtilityCode  
	  ,b.BeginDate  
	  ,b.EndDate  
	  ,b.Quantity  
	  ,b.MeasurementSignificanceCode  
	  ,b.TransactionSetPurposeCode  
	  ,b.MeterNumber  
	  ,b.ID as UsageID 
	  ,'t2'   as BaseSource 
	 FROM   
	  [lp_transactions].[dbo].[EdiAccount] a (NOLOCK) inner join  
	  [lp_transactions].[dbo].[EdiUsageDetail] b (NOLOCK) on a.id=b.ediaccountid  
	 where [UnitOfMeasurement]='kh' and ptdloop='BC' and b.TransactionSetPurposeCode='00'  
	  and a.UtilityCode in ('PENELEC', 'METED')  
	   and a.AccountNumber = @AccountNumber
	  and a.UtilityCode = @utilityCode
	  and b.BeginDate >= @BeginDate
	  and b.EndDate <= @EndDate

   )
	
	RETURN; 
END


GO


