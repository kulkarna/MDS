

-- =============================================
-- Author:		Jaime Forero
-- Create date: 1/25/2012
-- Description:	Returns the legacy FlowStartDate
--select * from lp_account..account
--where date_deenrollment <> date_deenrollment2
-- =============================================
CREATE  FUNCTION [dbo].ufn_GetLegacyDateDeenrollment
(
	@p_AccountStatus VARCHAR(15),
	@p_AccountSubStatus VARCHAR(15),
	@p_AccountServiceEndDate DATETIME
)

RETURNS DATETIME

AS

BEGIN
	DECLARE @w_legacy_date_deenrollment DATETIME;

	SET @w_legacy_date_deenrollment	 = 	
		CASE WHEN @p_AccountStatus in ('999998','999999','01000','03000','04000','05000')	THEN CAST('1900-01-01 00:00:00' AS DATETIME)
			 WHEN @p_AccountStatus in ('13000') AND @p_AccountSubStatus in ('70','80')		THEN CAST('1900-01-01 00:00:00' AS DATETIME)
		ELSE ISNULL(@p_AccountServiceEndDate, CAST('1900-01-01 00:00:00' AS DATETIME)) END;

	RETURN @w_legacy_date_deenrollment;
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyDateDeenrollment] TO [LIBERTYPOWER\sscott]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyDateDeenrollment] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyDateDeenrollment] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

