
CREATE PROCEDURE [dbo].[usp_account_renewal_account_sel]

	@p_account_number		varchar(30)

AS

SELECT 
	A.AccountIdLegacy AS account_id
FROM 
	LibertyPower.dbo.Account A WITH (NOLOCK) 
	JOIN LibertyPower.dbo.AccountContract AC	 WITH (NOLOCK) 		ON A.AccountID = AC.AccountID AND A.CurrentRenewalContractID = AC.ContractID
	JOIN LibertyPower.dbo.[Contract] C			 WITH (NOLOCK) 		ON  AC.ContractID = C.ContractID 
	JOIN LibertyPower.dbo.AccountStatus ACS		 WITH (NOLOCK) 		ON AC.AccountContractID = ACS.AccountContractID
WHERE 
	a.CurrentRenewalContractID IS NOT NULL AND a.CurrentContractID IS NOT NULL
	AND ACS.SubStatus NOT IN ('80','90') -- Renewal is not cancelled
	AND C.ContractStatusID	<> 2		 -- Renewal is not rejected
	AND A.AccountNumber = @p_account_number
