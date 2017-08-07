

-- =============================================
-- Author:		Jaime Forero
-- Create date: 1/25/2012
-- Description:	Returns the legacy lp_account..account.account_type given the current values of contract type, template, and status
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetLegacyContractTypeByID]
(
	@p_ContractTypeID INT,
	@p_ContractTemplateTypeID INT,
	@p_DealTypeID INT
)

RETURNS varchar(25)

AS

BEGIN
	DECLARE @w_legacy_contract_type	VARCHAR(25)
	
	IF @p_ContractTypeID = 3 -- EDI
	BEGIN
		SET @w_legacy_contract_type = 'POWER MOVE'
	END
	ELSE
	BEGIN
		IF @p_ContractTypeID = 1
			SET @w_legacy_contract_type = 'VOICE'
		IF @p_ContractTypeID = 2
			SET @w_legacy_contract_type = 'PAPER'
		IF @p_ContractTemplateTypeID = 2
			SET @w_legacy_contract_type = 'CORPORATE'

		IF @p_DealTypeID = 2 -- Renewal
			SET @w_legacy_contract_type = @w_legacy_contract_type + ' RENEWAL'
	END	

	RETURN @w_legacy_contract_type;
END


/*
select * from ContractType
1	VOICE
2	PAPER
3	EDI
4	ONLINE

select * from ContractTemplateType
1	Normal
2	Custom
3	Modified

SELECT * FROM LibertyPower..ContractDealType;
1	New
2	Renewal
3	Conversion
*/


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyContractTypeByID] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyContractTypeByID] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

