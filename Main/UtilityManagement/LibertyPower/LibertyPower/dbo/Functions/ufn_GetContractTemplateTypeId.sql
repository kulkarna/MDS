-- =============================================
-- Author:		Jaime Forero
-- Create date: 8/19/2011
-- Description:	Get Contract Template Type based on string value, to be used for backward compatibility
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetContractTemplateTypeId]
(
	-- Add the parameters for the function here
	@p_StringContractType VARCHAR(50)
)
RETURNS INT
AS
BEGIN
	DECLARE @w_ContractTemplateID INT;
	
	-- SELECT * FROM LibertyPower.dbo.ContractTemplateType  CTT  (NOLOCK) 
	
	SELECT @w_ContractTemplateID = ContractTemplateTypeID  FROM LibertyPower.dbo.ContractTemplateType  CTT  (NOLOCK) 
				WHERE LOWER(CTT.[Type]) = CASE WHEN LOWER(LTRIM(RTRIM(@p_StringContractType))) LIKE '%corporate%' THEN 'custom' ELSE 'normal' END;
			
	-- Return the result of the function
	RETURN @w_ContractTemplateID ;

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetContractTemplateTypeId] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetContractTemplateTypeId] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

