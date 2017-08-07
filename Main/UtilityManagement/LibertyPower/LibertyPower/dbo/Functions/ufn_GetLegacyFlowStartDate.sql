

-- =============================================
-- Author:		Jaime Forero
-- Create date: 1/25/2012
-- Description:	Returns the legacy FlowStartDate
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetLegacyFlowStartDate]
(
	@p_AccountStatus VARCHAR(15),
	@p_AccountSubStatus VARCHAR(15),
	@p_AccountServiceStartDate DATETIME
)

RETURNS DATETIME

AS

BEGIN
	DECLARE @w_legacy_flow_start_date DATETIME;

	--SELECT * FROM LibertyPower..ContractType;
	--SELECT * FROM LibertyPower..ContractTemplateType;
	--SELECT * FROM LibertyPower..ContractDealType;
	
	SET @w_legacy_flow_start_date	 = 	
			CASE WHEN @p_AccountStatus in ('999998','999999','01000','03000','04000','05000') AND @p_AccountSubStatus not in ('30') 
			THEN CAST('1900-01-01 00:00:00' AS DATETIME)
			ELSE ISNULL(@p_AccountServiceStartDate, CAST('1900-01-01 00:00:00' AS DATETIME)) END;

	RETURN @w_legacy_flow_start_date;
END



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyFlowStartDate] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyFlowStartDate] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

