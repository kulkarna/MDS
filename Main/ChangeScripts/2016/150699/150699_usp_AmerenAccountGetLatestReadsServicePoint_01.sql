  use lp_transactions
  GO
  if object_id('usp_AmerenAccountGetLatestReadsServicePoint') is not null
   drop procedure usp_AmerenAccountGetLatestReadsServicePoint
   GO
/*******************************************************************************  
* dbo.[usp_AmerenAccountGetLatestReads]  
 * <For Getting latest set of records for each Distinct MaterNumber from AmerenAccount>  
*  
* History  
  
*******************************************************************************  
* 10/12/2015 - Srikanth Bachina   
 * Created.  
 * 04/07/2016 - Modified By Vikas Sharma 
 * 11/30/2015 - Modified by Vikas Sharma PBI -150699 
 * Descrition : Ameren Load profile Issue PBI- 113131  
*******************************************************************************  
  
exec usp_AmerenAccountGetLatestReads '0752414113'  
  
*/  
CREATE PROCEDURE [dbo].[usp_AmerenAccountGetLatestReadsServicePoint] (@Accountnumber VARCHAR(50))  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 --DECLARE @Accountnumber varchar(50)  
 --select @AccountNumber='9795164179'  
 SELECT MAX(ID) AS ID  
  ,CustomerName  
  ,MeterNumber  
  ,BillGroup  
  ,ProfileClass  
  ,ServiceClass  
  ,EffectivePLC 
  ,ServicePoint
    
 INTO #AmerenAccountDetails  
 FROM lp_transactions.dbo.AmerenAccount(NOLOCK)  
 WHERE AccountNumber = @AccountNumber  
  AND cast(created AS DATE) = (  
   SELECT MAX(cast(created AS DATE))  
   FROM lp_transactions.dbo.AmerenAccount  
   WHERE Accountnumber = @Accountnumber  
   )  
 GROUP BY CustomerName  
  ,MeterNumber  
  ,BillGroup  
  ,ProfileClass  
  ,ServiceClass  
  ,EffectivePLC
  ,ServicePoint  
 ORDER BY ID  
  
  
  
 DECLARE @MinId BIGINT = 0  
 declare @MaxId Bigint=0
  
 SELECT @MinId = MIN(id)  
 FROM #AmerenAccountDetails  
 WHERE ProfileClass <> 'LITE'  
 
  
 IF (@MinId > 0)  
 BEGIN  
  UPDATE #AmerenAccountDetails  
  SET ProfileClass = (  
    SELECT ProfileClass  
    FROM #AmerenAccountDetails  
    WHERE ID = @MinId  
    )  
  WHERE ProfileClass = 'LITE'  
 END
 
  
   
  
 SELECT ID  
  ,CustomerName  
  ,MeterNumber  
  ,BillGroup  
  ,ProfileClass  
  ,ServiceClass  
  ,EffectivePLC
  ,ServicePoint
 FROM #AmerenAccountDetails
 order by ServicePoint desc
 
  
 SET NOCOUNT OFF;  
END  
   