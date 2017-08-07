USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsAccountSubmissionQueue]    Script Date: 11/22/2013 09:32:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************    
 * <[usp_InsAccountSubmissionQueue]>    
 * <Insert rows at Account Submission queue table by Contract>    
 *    
 * IT 121 - Release 2    
 *******************************************************************************    
 * <9/19/2013> - <Rafael Vasques>    
 * Created.    
 *******************************************************************************    
 * <11/20/2013> - <José Muñoz>
 * Modified		: Added “top 1” in the first script because without this, 
 *				  it crashes saying that there are multiple records from the subquery.    
 *				  Required by Eric to fix problem with account status update
 *				  when the contract steps are approved
 * 
 *******************************************************************************    
 */    
ALTER procedure [dbo].[usp_InsAccountSubmissionQueue]    
@ContractId int      
as    
SET NOCOUNT ON;    
  
DECLARE @acrid int   
  
if (select ContractDealTypeid from Contract c with (nolock)  
 where c.ContractID = @ContractId) = 2  
 begin    
 if (select top 1 isnull(pb.IsMultiTerm,0) from Contract c WITH (NOLOCK)    
 inner join AccountContract ac WITH (NOLOCK) on c.ContractID = ac.ContractID    
 inner join AccountContractRate acr WITH (NOLOCK) on acr.AccountContractID = ac.AccountContractID    
 left join Price p WITH (NOLOCK) on p.ID = acr.PriceID    
 left join ProductBrand pb WITH (NOLOCK) on pb.ProductBrandID = p.ProductBrandID  
 where c.ContractID = @ContractId) = 1    
 begin    
     
  
     
     
  DECLARE csr CURSOR FAST_FORWARD FOR    
   select AccountContractrateID     
   FROM LibertyPower..AccountContract  AC WITH (NOLOCK)         
   INNER JOIN LibertyPower..Account A  WITH (NOLOCK)         
   ON AC.AccountId     = A.AccountId        
   AND AC.ContractId    = A.CurrentRenewalContractId        
   INNER JOIN LibertyPower..[Contract] C  WITH (NOLOCK)        
   ON C.ContractId     = AC.ContractId        
   INNER JOIN LibertyPower..Utility U  WITH (NOLOCK)         
   ON U.Id       = A.UtilityId        
   inner join LibertyPower..AccountContractRate acr WITH (NOLOCK) on ac.AccountContractID = acr.AccountContractID    
   LEFT JOIN Libertypower..UtilityRateLeadTime RLT WITH (NOLOCK) ON RLT.UtilityID = U.ID      
   WHERE C.ContractId    = @ContractId      
  OPEN crs    
  FETCH NEXT FROM csr INTO @acrid    
  WHILE @@FETCH_STATUS=0    
  BEGIN    
  if(ROW_NUMBER() OVER(ORDER BY @acrid)) = 1    
  begin    
   insert into  libertypower..AccountSubmissionQueue       
   select 2,3,1,dateadd(dd, -isnull(RLT.LeadTime,0), acr.RateStart),acr.RateStart,GETDATE(),AccountContractrateID     
   FROM LibertyPower..AccountContract  AC WITH (NOLOCK)         
   INNER JOIN LibertyPower..Account A  WITH (NOLOCK)         
   ON AC.AccountId     = A.AccountId        
   AND AC.ContractId    = A.CurrentRenewalContractId        
   INNER JOIN LibertyPower..[Contract] C  WITH (NOLOCK)        
   ON C.ContractId     = AC.ContractId        
   INNER JOIN LibertyPower..Utility U  WITH (NOLOCK)         
   ON U.Id       = A.UtilityId        
   inner join LibertyPower..AccountContractRate acr WITH (NOLOCK) on ac.AccountContractID = acr.AccountContractID    
   LEFT JOIN Libertypower..UtilityRateLeadTime RLT WITH (NOLOCK) ON RLT.UtilityID = U.ID      
   WHERE C.ContractId    = @ContractId         
  end    
  else    
  begin    
   insert into  libertypower..AccountSubmissionQueue       
   select 2,4,1,dateadd(dd, -isnull(RLT.LeadTime,0), acr.RateStart),acr.RateStart,GETDATE(),AccountContractrateID     
   FROM LibertyPower..AccountContract  AC WITH (NOLOCK)         
   INNER JOIN LibertyPower..Account A  WITH (NOLOCK)         
   ON AC.AccountId     = A.AccountId        
   AND AC.ContractId    = A.CurrentRenewalContractId        
   INNER JOIN LibertyPower..[Contract] C  WITH (NOLOCK)        
   ON C.ContractId     = AC.ContractId        
   INNER JOIN LibertyPower..Utility U  WITH (NOLOCK)         
   ON U.Id       = A.UtilityId        
   inner join LibertyPower..AccountContractRate acr WITH (NOLOCK) on ac.AccountContractID = acr.AccountContractID    
   LEFT JOIN Libertypower..UtilityRateLeadTime RLT WITH (NOLOCK) ON RLT.UtilityID = U.ID      
   WHERE C.ContractId    = @ContractId         
  end    
     FETCH NEXT FROM csr INTO @acrid    
    END    
    CLOSE csr    
    DEALLOCATE csr     
     
     
     
     
     
     
      
 end     
else    
 begin    
 insert into  libertypower..AccountSubmissionQueue       
  select 2,3,1,dateadd(dd, -isnull(RLT.LeadTime,0), acr.RateStart),acr.RateStart,GETDATE(),AccountContractrateID     
  FROM LibertyPower..AccountContract  AC WITH (NOLOCK)         
  INNER JOIN LibertyPower..Account A  WITH (NOLOCK)         
  ON AC.AccountId     = A.AccountId        
  AND AC.ContractId    = A.CurrentRenewalContractId        
  INNER JOIN LibertyPower..[Contract] C  WITH (NOLOCK)        
  ON C.ContractId     = AC.ContractId        
  INNER JOIN LibertyPower..Utility U  WITH (NOLOCK)         
  ON U.Id       = A.UtilityId        
  inner join LibertyPower..AccountContractRate acr WITH (NOLOCK) on ac.AccountContractID = acr.AccountContractID    
  LEFT JOIN Libertypower..UtilityRateLeadTime RLT WITH (NOLOCK) ON RLT.UtilityID = U.ID      
  WHERE C.ContractId    = @ContractId         
 end    
   end  
     
     
   else  
   begin  
   if (select isnull(pb.IsMultiTerm,0) from Contract c WITH (NOLOCK)    
 inner join AccountContract ac WITH (NOLOCK) on c.ContractID = ac.ContractID    
 inner join AccountContractRate acr WITH (NOLOCK) on acr.AccountContractID = ac.AccountContractID    
 left join Price p WITH (NOLOCK) on p.ID = acr.PriceID    
 left join ProductBrand pb WITH (NOLOCK) on pb.ProductBrandID = p.ProductBrandID  
 where c.ContractID = @ContractId) = 1    
 begin    
     
    
     
     
  DECLARE csr CURSOR FAST_FORWARD FOR    
   select AccountContractrateID     
   FROM LibertyPower..AccountContract  AC WITH (NOLOCK)         
   INNER JOIN LibertyPower..Account A  WITH (NOLOCK)         
   ON AC.AccountId     = A.AccountId        
   AND AC.ContractId    = A.CurrentContractId        
   INNER JOIN LibertyPower..[Contract] C  WITH (NOLOCK)        
   ON C.ContractId     = AC.ContractId        
   INNER JOIN LibertyPower..Utility U  WITH (NOLOCK)         
   ON U.Id       = A.UtilityId        
   inner join LibertyPower..AccountContractRate acr WITH (NOLOCK) on ac.AccountContractID = acr.AccountContractID    
   LEFT JOIN Libertypower..UtilityRateLeadTime RLT WITH (NOLOCK) ON RLT.UtilityID = U.ID      
   WHERE C.ContractId    = @ContractId      
  OPEN crs    
  FETCH NEXT FROM csr INTO @acrid    
  WHILE @@FETCH_STATUS=0    
  BEGIN    
  if(ROW_NUMBER() OVER(ORDER BY @acrid)) = 1    
  begin    
   insert into  libertypower..AccountSubmissionQueue       
   select 1,1,1,dateadd(dd, -isnull(RLT.LeadTime,0), acr.RateStart),acr.RateStart,GETDATE(),AccountContractrateID     
   FROM LibertyPower..AccountContract  AC WITH (NOLOCK)         
   INNER JOIN LibertyPower..Account A  WITH (NOLOCK)         
   ON AC.AccountId     = A.AccountId        
   AND AC.ContractId    = A.CurrentContractId        
   INNER JOIN LibertyPower..[Contract] C  WITH (NOLOCK)        
   ON C.ContractId     = AC.ContractId        
   INNER JOIN LibertyPower..Utility U  WITH (NOLOCK)         
   ON U.Id       = A.UtilityId        
   inner join LibertyPower..AccountContractRate acr WITH (NOLOCK) on ac.AccountContractID = acr.AccountContractID    
   LEFT JOIN Libertypower..UtilityRateLeadTime RLT WITH (NOLOCK) ON RLT.UtilityID = U.ID      
   WHERE C.ContractId    = @ContractId         
  end    
  else    
  begin    
   insert into  libertypower..AccountSubmissionQueue       
   select 1,4,1,dateadd(dd, -isnull(RLT.LeadTime,0), acr.RateStart),acr.RateStart,GETDATE(),AccountContractrateID     
   FROM LibertyPower..AccountContract  AC WITH (NOLOCK)         
   INNER JOIN LibertyPower..Account A  WITH (NOLOCK)         
   ON AC.AccountId     = A.AccountId        
   AND AC.ContractId    = A.CurrentContractId        
   INNER JOIN LibertyPower..[Contract] C  WITH (NOLOCK)        
   ON C.ContractId     = AC.ContractId        
   INNER JOIN LibertyPower..Utility U  WITH (NOLOCK)         
   ON U.Id       = A.UtilityId        
   inner join LibertyPower..AccountContractRate acr WITH (NOLOCK) on ac.AccountContractID = acr.AccountContractID    
   LEFT JOIN Libertypower..UtilityRateLeadTime RLT WITH (NOLOCK) ON RLT.UtilityID = U.ID      
   WHERE C.ContractId    = @ContractId         
  end    
     FETCH NEXT FROM csr INTO @acrid    
    END    
    CLOSE csr    
    DEALLOCATE csr     
     
     
     
     
     
     
      
 end     
else    
 begin    
  insert into  libertypower..AccountSubmissionQueue       
  select 1,1,1,dateadd(dd, -isnull(RLT.LeadTime,0), acr.RateStart),acr.RateStart,GETDATE(),AccountContractrateID     
  FROM LibertyPower..AccountContract  AC WITH (NOLOCK)         
  INNER JOIN LibertyPower..Account A  WITH (NOLOCK)         
  ON AC.AccountId     = A.AccountId        
  AND AC.ContractId    = A.CurrentContractId        
  INNER JOIN LibertyPower..[Contract] C  WITH (NOLOCK)        
  ON C.ContractId     = AC.ContractId        
  INNER JOIN LibertyPower..Utility U  WITH (NOLOCK)         
  ON U.Id       = A.UtilityId        
  inner join LibertyPower..AccountContractRate acr WITH (NOLOCK) on ac.AccountContractID = acr.AccountContractID    
  LEFT JOIN Libertypower..UtilityRateLeadTime RLT WITH (NOLOCK) ON RLT.UtilityID = U.ID      
  WHERE C.ContractId    = @ContractId         
 end    
     
     
   end  
 SET NOCOUNT OFF;    
     