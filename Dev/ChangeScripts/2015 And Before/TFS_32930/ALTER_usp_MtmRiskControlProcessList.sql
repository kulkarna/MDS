use LP_MtM
go

-- =============================================  
-- Author:  Felipe Medeiros  
-- Create date: 10/31/2013  
-- Description: Return all accounts' failures 
-- UPDATE: Add the columns ContractID and CustomDealID 
-- =============================================  
ALTER PROCEDURE usp_MtmRiskControlProcessList  
AS  
BEGIN  
   
 SET NOCOUNT ON;  
  
 select p.*, r.Description as ReasonDesc, i.ISO, a.ContractID, a.CustomDealID
 from MtmRiskControlProcess p (nolock)  
 join MtMRiskControlReasons r (nolock) on (p.ReasonID = r.Id)  
 join MtMAccount a (nolock) on (p.MtMAccountID = a.ID)  
 join MtMZainetAccountInfo i (nolock) on (p.AccountID = i.AccountID and a.ContractID = i.ContractID)  
   
 SET NOCOUNT OFF;  
END  