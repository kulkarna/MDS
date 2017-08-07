USE [lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_document_letter_data_renewal_sel]    Script Date: 05/30/2012 17:06:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Created By: Gail Mangaroo
-- Created: 4/15/2008
-- Gather data for renewal letters
-- ==============================================
-- Modified 3/9/2009
-- get account data from account table as well as account_renewal table
-- ==============================================
-- Modified: 4/30/2009 GM
-- Sorted by Market
-- =============================================
-- Modified: 3/4/2010 GM
-- Added Utility to sort 
-- =============================================
-- Modified: 07/17/2011 Ryan Russon
-- Minor overhaul --now ignoring template mapping to Product and Market since Template is matched (by multiple contract attributes) later
-- =============================================
-- Modified: 02/01/2012 Ryan Russon
-- Major emergency overhaul to fix performance problems after Account data schema change --also eliminated returned fields that aren't being used in doc mgmt webservice
-- =============================================
-- Modified: 05/30/2012 Ryan Russon
-- Re-added AccountType to data (removed with Account table restructing)
-- =============================================
ALTER PROCEDURE [dbo].[usp_document_letter_data_renewal_sel] 
(
	@sample_row_size	int = -1
)

AS 

BEGIN 

	IF @sample_row_size > 0
		SET ROWCOUNT @sample_row_size

	SELECT
		A.AccountIdLegacy							AS account_id,  
		A.AccountNumber								AS account_number,
		A.AccountNumber								AS AccountNumber,
		AT.AccountType								AS AccountType,
		''											AS reason_code,
		C.Number									AS contract_nbr,  
		C.Number									AS ContractNumber,
		1											AS by_contract,
		M.MarketCode								AS retail_mkt_id

	FROM LibertyPower..Account								A WITH (NOLOCK)
	JOIN LibertyPower..AccountType							AT WITH (NOLOCK)
		ON AT.ID = A.AccountTypeID
	JOIN LibertyPower..AccountContract						AC WITH (NOLOCK)
		ON (A.AccountID = AC.AccountID		AND		A.CurrentRenewalContractID = AC.ContractID)
	JOIN LibertyPower..[Contract]							C WITH (NOLOCK)
		ON AC.ContractID = C.ContractID
	JOIN lp_enrollment..check_account						ca WITH (NOLOCK)
		ON (C.Number = ca.contract_nbr	OR	A.AccountIdLegacy = ca.account_id)
	JOIN LibertyPower..AccountStatus						ACS WITH (NOLOCK)
		ON AC.AccountContractID = ACS.AccountContractID  
	JOIN LibertyPower..Market								M WITH (NOLOCK)
		ON A.RetailMktID = M.ID
	LEFT JOIN lp_account..enrollment_status_substatus_vw	v WITH (NOLOCK)
		ON (ACS.[status] = v.[status]		AND		ACS.SubStatus = v.sub_status)

	WHERE ca.check_Type = 'LETTER' 
	AND ca.Approval_Status = 'PENDING'
	AND ca.check_request_id  = 'RENEWAL' 
	AND ( v.flow_status in('Pending', 'Pending Active', 'Pending Approval', 'Active')		OR v.flow_status IS NULL ) 
	AND ltrim(rtrim(isnull(ca.account_id, ''))) = ''

	ORDER BY retail_mkt_id
END


GO
