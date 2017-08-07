Use lp_transactions
GO  
/*  
--========================================  
--Author : Jay Barreto  
--Creation Date: 5/1/2014  
--Purpose: Gets account property history data from EDI account table  
  
It uses Edi file log id to get properties from the edi account table.  
  
--==============Modifications=============  
  
5/22/2014: Added distinct key word  
03/11/2016 : Implement Condition of load profile see PBI 113131 for details
  
*/  
  
ALTER PROCEDURE [dbo].[usp_EdiAccountsByFileLogId]  
@FileLogId int,  
@AccountNumber varchar(255),  
@UtilityCode varchar(255)  
AS  
BEGIN  
SET NOCOUNT ON;  
  
SELECT distinct AccountNumber,UtilityCode, Icap, IcapEffectiveDate, Tcap, TcapEffectiveDate, ZoneCode, RateClass, LoadProfile, Voltage, EffectiveDate, BillGroup,TimeStampInsert  

into #Accounts
FROM lp_transactions..EdiAccount a WITH (NOLOCK)  
WHERE a.AccountNumber = @AccountNumber  
AND a.UtilityCode = @UtilityCode  
AND a.EdiFileLogID = @FileLogId  

declare @loadProfile varchar(100)=null
select  top 1 @loadProfile= LoadProfile from #Accounts where LoadProfile<>'LITE'
  order by TimeStampInsert desc
update #Accounts set LoadProfile= case when @loadProfile IS NULL then LoadProfile else @loadProfile end
 where LoadProfile='LITE'

SELECT distinct AccountNumber,UtilityCode, Icap, IcapEffectiveDate, Tcap, TcapEffectiveDate, ZoneCode, RateClass, LoadProfile, Voltage, EffectiveDate, BillGroup  
from #Accounts
SET NOCOUNT OFF;  
END  
  