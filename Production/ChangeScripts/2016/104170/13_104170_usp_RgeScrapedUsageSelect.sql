USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_RgeScrapedUsageSelect]    Script Date: 02/09/2016 12:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
/*******************************************************************************  
 * usp_RgeScrapedUsageSelect  
 * Selects usage from the peco scraped table  
 *  
 * History  
 *04-03-2014: add created  
 * 06-02-2011 - added meter number (from account table)..  
 * Modifed by : Vikas Sharma 05/27/2015  
 * Add Capability to Add the Consolidation Process for Old Account Also.  
 *******************************************************************************  
 * 02-03-2011 - Eduardo Patino  
 * Created.  
 *******************************************************************************  
 */  
  
ALTER PROCEDURE [dbo].[usp_RgeScrapedUsageSelect] (  
 @AccountNumber varchar(50),  
 @BeginDate  datetime,  
 @EndDate  datetime )  
AS  
/*  
select * from RgeAccount (nolock) where accountnumber = 'R01000057083990' order by 1 desc  
select * from RgeUsage (nolock) where kwh <> 0  
usp_RgeScrapedUsageSelect 'R01000051132280', '2008-4-2', '2016-4-2'  
*/  
BEGIN  
 SET NOCOUNT ON;  
   
   SELECT * INTO #TEMPACCOUNTS  
    FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@AccountNumber)  
  
 SELECT DISTINCT t1.Id, t1.AccountNumber, BeginDate, EndDate, ReadType, Kw, KwOn, KwOff,  
   Kwh = (case when Kwh = 0 then KwhOn + KwhOff + KwhMid else Kwh end),  
   KwhOn, KwhOff, KwhMid, Rkvah, Total, TotalTax, Days, MeterNumber, t1.Created
   ,ROW_NUMBER() OVER (
				PARTITION BY BeginDate
				,EndDate
				,(case when Kwh = 0 then KwhOn + KwhOff + KwhMid else Kwh end)
				,Days
				,MeterNumber
			 order by MeterNumber desc
				) AS Row_Num  
   into #RgeUsageTemp
 FROM RgeUsage (nolock) t1 inner join RgeAccount (nolock) t2 on t1.accountnumber = t2.accountnumber  
 WHERE t2.ACCOUNTNUMBER IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
  AND BeginDate >= @BeginDate  
  AND EndDate <= @EndDate  
  AND t2.id in (SELECT max(t3.id) FROM RgeAccount (nolock) t3 WHERE t3.accountnumber = t2.accountnumber)  
 
 delete from #RgeUsageTemp where Row_Num>1
 
 SELECT DISTINCT Id, AccountNumber, BeginDate, EndDate, ReadType, Kw, KwOn, KwOff,  
   Kwh ,  
   KwhOn, KwhOff, KwhMid, Rkvah, Total, TotalTax, Days, MeterNumber, Created
   from  #RgeUsageTemp
    ORDER BY 3 DESC, 4  
  
 SET NOCOUNT OFF;  
END  
-- Copyright 2011 Liberty Power  
  