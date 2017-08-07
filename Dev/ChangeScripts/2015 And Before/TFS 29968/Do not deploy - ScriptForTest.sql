--TEST SCRIPT FOR PBI 29968

--INSERTS THE DOCUMENTS ON THE NEW TABLE TO BE VALIDATED ON CHECK AND APPROVAL

/******
This will insert all the documents that exist in lp_documents..document_history for the specified
contract number into LibertyPower..TabletDocumentSubmission table
In the autoprocessing proc, once the documents step for the contract is picked up for checking, the 
code will verify if the documents match, and, if so, it will autoapprove it. If not, it will log a 
comment for every account of the contract and keep trying to approve it until it gets all the documents.
*******/

DECLARE @contractNumber VARCHAR(50)

SET @contractNumber = '' --PUT CONTRACT HERE

INSERT INTO LibertyPower..TabletDocumentSubmission
SELECT d.contract_nbr,
	   d.document_name,
	   d.document_type_id,
	   1029, --hardcoded to system's user id instead of sales agent
	   GETDATE(),
	   GETDATE()
FROM lp_documents..document_history d (NOLOCK)
WHERE d.contract_nbr = @contractNumber