

-- =============================================
-- Author:		Jaime Forero
-- Create date: 1/25/2012
-- Description:	Returns the legacy lp_account..account.account_type given the current values of contract type, template, and status
-- =============================================
CREATE FUNCTION [dbo].ufn_GetLegacyContractType
(
	@p_ContractType VARCHAR(25),
	@p_ContractTemplateTypeID INT,
	@p_DealType VARCHAR(25)
)

RETURNS varchar(25)

AS

BEGIN
	DECLARE @w_legacy_contract_type	varchar(25)

	--SELECT * FROM LibertyPower..ContractType;
	--SELECT * FROM LibertyPower..ContractTemplateType;
	--SELECT * FROM LibertyPower..ContractDealType;
	
	SET @w_legacy_contract_type	 = 
		CASE WHEN UPPER(@p_ContractType) = 'VOICE'		THEN UPPER(@p_ContractType) +  CASE WHEN UPPER(@p_DealType) = 'RENEWAL' THEN ' RENEWAL'  ELSE '' END
		WHEN @p_ContractTemplateTypeID = 2	THEN 'CORPORATE'	  +	 CASE WHEN UPPER(@p_DealType) = 'RENEWAL' THEN ' RENEWAL'  ELSE '' END  -- id 2: custom template
		WHEN UPPER(@p_ContractType) = 'PAPER'		THEN UPPER(@p_ContractType) +  CASE WHEN UPPER(@p_DealType) = 'RENEWAL' THEN ' RENEWAL'  ELSE '' END
		WHEN UPPER(@p_ContractType) = 'EDI'			THEN 'POWER MOVE'
		ELSE UPPER(@p_ContractType) END;

	RETURN @w_legacy_contract_type;
END



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyContractType] TO [LIBERTYPOWER\sscott]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyContractType] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyContractType] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

