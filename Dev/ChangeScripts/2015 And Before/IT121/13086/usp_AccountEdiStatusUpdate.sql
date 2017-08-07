use libertypower
go
/*******************************************************************************
 * <[usp_AccountSubmissionStatusUpdate]>
 * <Update records at the table accountsubmissionqueue changing the status>
 *
 * IT 121 - Release 2
 *******************************************************************************
 * <9/19/2013> - <Rafael Vasques>
 * Created.
 *******************************************************************************
 */
create procedure usp_AccountSubmissionStatusUpdate
@accountId varchar(50),
@EdiType int,
@EdiStatus int
as
SET NOCOUNT ON;


			if(@EdiType = 1)
  begin
  update asq set EdiStatus = @EdiStatus   
   FROM LibertyPower..AccountContract  AC WITH (NOLOCK)       
   INNER JOIN LibertyPower..Account A  WITH (NOLOCK)       
   ON AC.AccountId     = A.AccountId      
   AND AC.ContractId    = A.CurrentContractId      
   INNER JOIN LibertyPower..[Contract] C  WITH (NOLOCK)      
   ON C.ContractId     = AC.ContractId      
   INNER JOIN LibertyPower..Utility U  WITH (NOLOCK)       
   ON U.Id       = A.UtilityId      
   inner join LibertyPower..AccountContractRate acr with(nolock) on ac.AccountContractID = acr.AccountContractID     
   inner join libertypower..accountsubmissionqueue asq on acr.AccountContractRateid = asq.AccountContractRateid  
   WHERE a.AccountIdLegacy = @accountId    
   and asq.type = @EdiType  
  end
  else
  begin
   update asq set EdiStatus = @EdiStatus   
   FROM LibertyPower..AccountContract  AC WITH (NOLOCK)       
   INNER JOIN LibertyPower..Account A  WITH (NOLOCK)       
   ON AC.AccountId     = A.AccountId      
   AND AC.ContractId    = A.CurrentRenewalContractId      
   INNER JOIN LibertyPower..[Contract] C  WITH (NOLOCK)      
   ON C.ContractId     = AC.ContractId      
   INNER JOIN LibertyPower..Utility U  WITH (NOLOCK)       
   ON U.Id       = A.UtilityId      
   inner join LibertyPower..AccountContractRate acr with(nolock) on ac.AccountContractID = acr.AccountContractID     
   inner join libertypower..accountsubmissionqueue asq on acr.AccountContractRateid = asq.AccountContractRateid  
   WHERE a.AccountIdLegacy = @accountId    
   and asq.type = @EdiType  
SET NOCOUNT OFF;