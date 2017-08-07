USE [lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_document_letter_data_welcome_sel]    Script Date: 11/28/2012 13:59:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- MODIFICATION NECESSARY FOR PROD   
-- reason code from check account   
-- =============================================  
-- Created By: Gail Mangaroo  
-- Created: 4/15/2008  
-- Gather data for welcome letters  
-- =============================================  
-- Modified: 4/19/2009 GM  
-- Sorted by Market  
-- =============================================  
-- Modified 3/4/2010 GM  
-- Added Utility to sort   
-- =============================================  
-- Modified 07/20/2011 Ryan Russon  
-- Minor overhaul --now ignoring template mapping to Product and Market since Template is matched (by multiple contract attributes) later  
-- =============================================  
-- Modified 03/09/2012 Ryan Russon  
-- Changed ORDER BY to also sort by AccountType 
-- =============================================  
-- Modified 09/10/2012 Eric Hernandez/Ryan Russon
-- Cut Gordian knot of unnecessary joins, subqueries, and unused fields
-- =============================================  
-- Modified: 11/29/2012 Ryan Russon
-- Using new Task system (not lp_account..check_account) and removed old inefficient views
-- =============================================
ALTER PROCEDURE [dbo].[usp_document_letter_data_welcome_sel] (
      @sample_row_size  int = -1  
)

AS   

BEGIN   

	IF @sample_row_size > 0  
		SET ROWCOUNT @sample_row_size  

	----	Document Autogeneration code uses: "ContractNumber", "Reason_Code", "by_contract", "AccountType", "account_id"
	SELECT
		replace(AT.AccountType, 'RES', 'RESIDENTIAL')	AS AccountType
		, C.Number										AS ContractNumber
		, ''											AS reason_code
		, 1												AS by_contract
		, ACCT.AccountIdLegacy							AS account_id
	FROM [LibertyPower]..[Account]			ACCT WITH (NOLOCK)
	JOIN [LibertyPower]..[AccountType]		AT WITH (NOLOCK)		ON ACCT.AccountTypeID = AT.ID
	JOIN [LibertyPower]..[Contract]			C WITH (NOLOCK)			ON ACCT.CurrentContractID = C.ContractID
	JOIN [LibertyPower]..[wiptask_vw]		WIP WITH (NOLOCK)		ON C.Number = WIP.NUMBER
--	JOIN [lp_enrollment]..[check_account]	ch WITH (NOLOCK)		ON c.Number = ch.contract_nbr		--old table

	WHERE WIP.TaskName = 'Letter'
	AND WIP.StatusName = 'PENDING'
--	AND ( v.flow_status in('Pending', 'Pending Active', 'Pending Approval', 'Active')		OR v.flow_status IS NULL ) 
	AND C.ContractDealTypeId = 1	--			1=New, 2=Renewal, 3=Conversion

	ORDER BY ACCT.AccountTypeID, ACCT.RetailMktID, ACCT.UtilityID	--, acct.Product???  Can't find Product in new tables

END  
  



GO


-----------------------------------------------------------------------------


USE [lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_document_letter_data_renewal_sel]    Script Date: 11/28/2012 14:08:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--exec usp_document_letter_data_renewal_sel

-- =============================================
-- Created By: Gail Mangaroo
-- Created: 4/15/2008
-- Gather data for renewal letters
-- =============================================
-- Modified 3/9/2009
-- get account data from account table as well as account_renewal table
-- =============================================
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
-- Modified: 11/29/2012 Ryan Russon
-- Using new Task system (not lp_account..check_account) and removed old inefficient views
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
		''											AS reason_code,
		C.Number									AS contract_nbr,  
		C.Number									AS ContractNumber,
		1											AS by_contract,
		M.MarketCode								AS retail_mkt_id

	FROM LibertyPower..Account								A WITH (NOLOCK)   
	JOIN LibertyPower..AccountContract						AC WITH (NOLOCK)
		ON (A.AccountID = AC.AccountID		AND		A.CurrentRenewalContractID = AC.ContractID)
	JOIN LibertyPower..[Contract]							C WITH (NOLOCK)
		ON AC.ContractID = C.ContractID
	JOIN LibertyPower..wiptask_vw							WIP WITH (NOLOCK)
		ON C.Number = WIP.NUMBER
	--JOIN lp_enrollment..check_account						ca WITH (NOLOCK)		--old table
	--	ON (C.Number = ca.contract_nbr	OR	A.AccountIdLegacy = ca.account_id)
	JOIN LibertyPower..AccountStatus						ACS WITH (NOLOCK)
		ON AC.AccountContractID = ACS.AccountContractID  
	JOIN LibertyPower..Market								M WITH (NOLOCK)
		ON A.RetailMktID = M.ID
	LEFT JOIN lp_account..enrollment_status_substatus_vw	v WITH (NOLOCK)
		ON (ACS.[status] = v.[status]		AND		ACS.SubStatus = v.sub_status)

	--WHERE ca.check_Type = 'LETTER' 
	--AND ca.Approval_Status = 'PENDING'
	--AND ca.check_request_id  = 'RENEWAL' 
	--AND ( v.flow_status in('Pending', 'Pending Active', 'Pending Approval', 'Active')		OR v.flow_status IS NULL ) 
	--AND ltrim(rtrim(isnull(ca.account_id, ''))) = ''
	WHERE WIP.TaskName = 'Letter'
	AND WIP.StatusName = 'PENDING'
	AND ( v.flow_status in('Pending', 'Pending Active', 'Pending Approval', 'Active')		OR v.flow_status IS NULL ) 
	AND c.ContractDealTypeId = 2	--Renewal			1=New, 2=Renewal, 3=Conversion

	ORDER BY m.MarketCode
END




GO


