use LP_MtM
go

-- =============================================    
-- Author:  Felipe Medeiros    
-- Create date: 11/04/2013    
-- Description: Getting custom accounts with failed etp status    
-- UPDATE: Add the columns ContractID and CustomDealID
-- =============================================    
ALTER PROCEDURE usp_CPEGetCustomAccountsFailedETP    
AS    
BEGIN    
 SET NOCOUNT ON;    
    
 --Getting MtMZainetAccountInfo information    
 SELECT     
  i.AccountID,    
  i.ContractID,    
  i.AccountNumber,     
  i.ContractNumber,     
  i.UtilityCode,     
  i.StartDate as RateStartDate,     
  i.EndDate as RateEndDate,    
  i.IsDaily  as isDaily,    
  i.SubStatus,    
  i.Status as StatusZainet    
 INTO     
  #ZainetInfo    
 FROM     
  MtMZainetAccountInfo i WITH (NOLOCK)     
 WHERE     
  ISNULL(i.BackToBack,0)=0    
  AND i.ZainetEndDate >= DATEADD(D, 0, DATEDIFF(D, 0, GETDATE()))    
  AND i.IsDaily = 0    
    
 --Getting the AccountInfo     
 SELECT    
  i.*,    
  m.Zone,     
  m.LoadProfile,     
  m.ID AS MtMAccountID,    
  m.BatchNumber,    
  m.QuoteNumber,   
  m.Status as "Status" ,
  m.CustomDealID  
 INTO     
  #AccountInfo    
 FROM    
  #ZainetInfo i WITH (NOLOCK)     
  INNER JOIN MtMAccount m  WITH (NOLOCK) ON i.AccountID = m.AccountID AND i.ContractID = m.ContractID    
 WHERE    
  m.Status = 'Failed (ETP)'    
    
 --Filtering by status and WhosaleloadDates    
 SELECT     
  m.*,    
  la.MeterTypeID as MeterType    
 FROM    
  #AccountInfo m WITH (NOLOCK)    
  INNER JOIN LibertyPower..Account la WITH (NOLOCK) ON la.AccountID = m.AccountID    
  INNER JOIN MtMReportStatus rs  WITH (NOLOCK) ON m.StatusZainet=rs.Status AND m.SubStatus=rs.SubStatus AND rs.Inactive=0    
  INNER JOIN MtMDailyWholesaleLoadDates l  WITH (NOLOCK) ON m.MtMAccountID=l.MtMAccountID    
    
 DROP TABLE #ZainetInfo    
 DROP TABLE #AccountInfo    
    
 SET NOCOUNT OFF;    
END