-- =============================================
-- Author:		Jaime Forero
-- Create date: 8/19/2011
-- Description:	Get Contract Type based on string value, to be used for backward compatibility
-- =============================================
CREATE FUNCTION ufn_GetContractTypeId
(
	-- Add the parameters for the function here
	@p_StringContractType VARCHAR(50)
)
RETURNS INT
AS
BEGIN
	DECLARE @w_ContractTypeID INT;
	SELECT @w_ContractTypeID = CT.ContractTypeID FROM LibertyPower.dbo.ContractType CT (NOLOCK) 
			 WHERE LOWER(CT.[Type]) = CASE WHEN LOWER(LTRIM(RTRIM(@p_StringContractType))) LIKE '%voice%' THEN 'voice' ELSE 'paper' END;
			
	-- Return the result of the function
	RETURN @w_ContractTypeID;

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetContractTypeId] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetContractTypeId] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

