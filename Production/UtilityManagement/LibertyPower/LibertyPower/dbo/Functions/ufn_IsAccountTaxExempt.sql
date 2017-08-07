-- =============================================
-- Author:		Al Tafur
-- Create date: 10/29/2012
-- Description:	Returns an int if the TaxExempt flag is for a given contract
-- =============================================
-- Modified: Isabelle Tamanini
-- Date:     11/27/2012
-- OriginalTaxDesignation check removed
-- SR1-40503982
-- =============================================
CREATE FUNCTION [dbo].[ufn_IsAccountTaxExempt] 
(
	@pContractId int
)
RETURNS int
AS
BEGIN

	DECLARE @IsTaxExempt INT
	
	SET  @IsTaxExempt = 0
		
	SELECT	@IsTaxExempt = a.taxstatusid 
	FROM	libertypower..account a (nolock)
	JOIN		libertypower..accountdetail ad (nolock)				on a.accountid = ad.accountid
	JOIN		libertypower..accountcontract ac (nolock)			on a.accountid = ac.accountid and a.currentcontractid = ac.contractid
	JOIN		libertypower..accountstatus [as] (nolock)			on ac.accountcontractid = [as].accountcontractid
	left join lp_documents..document_history dh (nolock)		on a.accountidlegacy = dh.account_id
	WHERE 
	(
	  --ad.OriginalTaxDesignation = 1
	  --OR
	  dh.document_type_id = 9  -- TAX EXEMPT DOCUMENT TYPE
	  OR
	  a.taxstatusid = 1 -- TAX EXEMPT FLAG FROM DEAL CAPTURE
	)
    AND a.currentcontractid = @pContractId

	RETURN @IsTaxExempt

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_IsAccountTaxExempt] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_IsAccountTaxExempt] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

