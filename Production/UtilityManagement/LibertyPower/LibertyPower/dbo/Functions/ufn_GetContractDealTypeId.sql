-- =============================================
-- Author:		Jaime Forero
-- Create date: 8/19/2011
-- Description:	Get Contract Type based on string value, to be used for backward compatibility
-- =============================================
CREATE FUNCTION ufn_GetContractDealTypeId
(
	-- Add the parameters for the function here
	@p_StringContractType VARCHAR(50)
)
RETURNS INT
AS
BEGIN
	DECLARE @w_ContractDealTypeID INT;
	
	SELECT @w_ContractDealTypeID = CDT.ContractDealTypeID FROM LibertyPower.dbo.ContractDealType CDT (NOLOCK) 
				WHERE LOWER(CDT.[DealType]) = CASE WHEN LOWER(LTRIM(RTRIM(@p_StringContractType))) LIKE '%renewal%' THEN 'renewal' ELSE 'new' END; 
					
	-- Return the result of the function
	RETURN @w_ContractDealTypeID ;

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetContractDealTypeId] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetContractDealTypeId] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

