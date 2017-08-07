use Libertypower
go

/*******************************************************************************
 * <[usp_AccountSubmissionStatusUpdateRejected]>
 * <Chaning the status of the table accountsubmissionqueue to one of the rejected status.>
 *
* IT 121 - Release 4
 *******************************************************************************      
 * <11/5/2013> - <Diogo Lima>  
 * Added capatibility to handle new deals.      
 *******************************************************************************      
 *
 * IT 121 - Release 2
 *******************************************************************************
 * <9/19/2013> - <Rafael Vasques>
 * Created.
 *******************************************************************************
 */
alter procedure usp_AccountSubmissionStatusUpdateRejected
@accountId varchar(50),
@AccountContractStatus int,
@ReasonRejected int = null,
@EdiType int
as
SET NOCOUNT ON

if(@EdiType = 1 or @EdiType = 2) 
begin 
			update ac set ac.AccountContractStatusID = @AccountContractStatus ,  AccountContractStatusReasonID = @ReasonRejected
			FROM LibertyPower..AccountContract  AC WITH (NOLOCK)     
			INNER JOIN LibertyPower..Account A  WITH (NOLOCK)     
			ON AC.AccountId     = A.AccountId    
			AND AC.ContractId    = A.CurrentContractId    
			INNER JOIN LibertyPower..[Contract] C  WITH (NOLOCK)    
			ON C.ContractId     = AC.ContractId    
			INNER JOIN LibertyPower..Utility U  WITH (NOLOCK)     
			ON U.Id       = A.UtilityId    
			WHERE a.AccountIdLegacy = @accountId  			
end
else
begin
			update ac set ac.AccountContractStatusID = @AccountContractStatus ,  AccountContractStatusReasonID = @ReasonRejected
			FROM LibertyPower..AccountContract  AC WITH (NOLOCK)     
			INNER JOIN LibertyPower..Account A  WITH (NOLOCK)     
			ON AC.AccountId     = A.AccountId    
			AND AC.ContractId    = A.CurrentRenewalContractId    
			INNER JOIN LibertyPower..[Contract] C  WITH (NOLOCK)    
			ON C.ContractId     = AC.ContractId    
			INNER JOIN LibertyPower..Utility U  WITH (NOLOCK)     
			ON U.Id       = A.UtilityId    
			WHERE a.AccountIdLegacy = @accountId  
end			
SET NOCOUNT OFF;	




