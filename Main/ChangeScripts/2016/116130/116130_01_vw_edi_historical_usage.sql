USE [lp_transactions]
GO

/****** Object:  View [dbo].[vw_edi_historical_usage]    Script Date: 04/21/2016 13:58:53 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_edi_historical_usage]'))
DROP VIEW [dbo].[vw_edi_historical_usage]
GO

USE [lp_transactions]
GO

/****** Object:  View [dbo].[vw_edi_historical_usage]    Script Date: 04/21/2016 13:58:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
  
  
  
/*******************************************************************************  
 * vw_edi_historical_usage  
 *  
 * History  
 * 12/07/2010 - Rick Deigsler - added MeasurementSignificanceCode = 41, 42 and 43  
 * 07/21/2011 - IT022 (EP) - added MeterNumber  
 * 07/31/2012 - 1-21819260 (EP)  
 * 10/16/2014 - Add the ID from usage tables
 * 04/21/2016 -  Remove the filters for measurement MeasurementSignificanceCode  
 *******************************************************************************  
 * 04/21/2010 - Douglas Marino  
 * Created.  
 *******************************************************************************  
 */  
  
CREATE view [dbo].[vw_edi_historical_usage]  
AS  
  
-- select * from sys.views where name = 'vw_edi_historical_usage'  
-- select top 20 * from vw_edi_historical_usage where AccountNumber in ('08010326550003207403')  
select distinct a.*  
from (  
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
 FROM  
  [lp_transactions].[dbo].[EdiAccount] a (NOLOCK) inner join  
  [lp_transactions].dbo.EdiUsage b (NOLOCK) on a.id=b.ediaccountid  
 where 1=1  
  and b.UnitOfMeasurement='kh' 
  --and 
  --b.MeasurementSignificanceCode in ('51','22','46','41','42','43')  
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
 FROM   
  [lp_transactions].[dbo].[EdiAccount] a (NOLOCK) inner join  
  [lp_transactions].[dbo].[EdiUsageDetail] b (NOLOCK) on a.id=b.ediaccountid  
 where [UnitOfMeasurement]='kh'
 -- and [MeasurementSignificanceCode] = '22'  
  --and b.TransactionSetPurposeCode=52  
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
 FROM   
  [lp_transactions].[dbo].[EdiAccount] a (NOLOCK) inner join  
  [lp_transactions].[dbo].[EdiUsageDetail] b (NOLOCK) on a.id=b.ediaccountid  
 where [UnitOfMeasurement]='kh' and ptdloop='BC' and b.TransactionSetPurposeCode='00'  
  and a.UtilityCode in ('PENELEC', 'METED')  
) a  
  
  
  
  
GO


