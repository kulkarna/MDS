

-- =============================================
-- Author:		Jaime Forero
-- Create date: 1/25/2012
-- Description:	Returns the legacy lp_account..account status
-- There is some translation of statuses depending on the current statuses since the renewal and account tables are now related but they should display different statuses
/*
select * from lp_account..account
where status <> status2
*/
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetLegacyAccountSubStatus]
(
	@p_CurrentAccountStatus VARCHAR(15),
	@p_CurrentAccountSubStatus VARCHAR(15)
)
RETURNS VARCHAR(15)
AS
BEGIN
	DECLARE @w_sub_status VARCHAR(15);

	SET @w_sub_status	 = 	
		CASE WHEN @p_CurrentAccountStatus			= '07000' AND @p_CurrentAccountSubStatus = '90' THEN '10' 
			 ELSE @p_CurrentAccountSubStatus END;
			 
	RETURN @w_sub_status;
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyAccountSubStatus] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyAccountSubStatus] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

