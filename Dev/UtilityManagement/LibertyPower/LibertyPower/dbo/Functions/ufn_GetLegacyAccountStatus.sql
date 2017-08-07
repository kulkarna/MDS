

-- =============================================
-- Author:		Jaime Forero
-- Create date: 1/25/2012
-- Description:	Returns the legacy lp_account..account status
-- There is some translation of statuses depending on the current statuses since the renewal and account tables are now related but they should display different statuses
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetLegacyAccountStatus]
(
	@p_CurrentAccountStatus VARCHAR(15),
	@p_CurrentAccountSubStatus VARCHAR(15)
)
RETURNS VARCHAR(15)
AS
BEGIN
	DECLARE @w_status VARCHAR(15);

	SET @w_status	 = 	
		CASE WHEN @p_CurrentAccountStatus			= '07000' AND @p_CurrentAccountSubStatus = '90' THEN '999999' 
			 WHEN @p_CurrentAccountStatus			= '07000' AND @p_CurrentAccountSubStatus = '10' THEN '07000' -- wasas 05000
			 ELSE @p_CurrentAccountStatus END;
		
	RETURN @w_status;
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyAccountStatus] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyAccountStatus] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

