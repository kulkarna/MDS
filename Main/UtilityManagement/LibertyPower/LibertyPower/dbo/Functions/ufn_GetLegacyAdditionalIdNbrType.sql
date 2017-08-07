

-- =============================================
-- Author:		Jaime Forero
-- Create date: 1/25/2012
-- Description:	Returns the additional id number type for legacy view
/*
select * from lp_account..account
where additional_id_nbr_type <> additional_id_nbr_type2
*/
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetLegacyAdditionalIdNbrType]
(
	@p_Duns VARCHAR(30),
	@p_EmployerId VARCHAR(30),
	@p_TaxId VARCHAR(30),
	@p_SsnEncrypted VARCHAR(512)
)
RETURNS VARCHAR(15)
AS
BEGIN
	DECLARE @w_result VARCHAR(15);

	SET @w_result = CASE WHEN LTRIM(RTRIM(@p_Duns)) <> '' THEN 'DUNSNBR' 
						 WHEN LTRIM(RTRIM(@p_EmployerId)) <> '' THEN 'EMPLID' 
						 WHEN LTRIM(RTRIM(@p_TaxId)) <> '' THEN 'TAX ID' 
							ELSE CASE WHEN @p_SsnEncrypted IS NOT NULL AND @p_SsnEncrypted != '' THEN 'SSN' 
									  ELSE 'NONE' END END;

	RETURN @w_result;
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyAdditionalIdNbrType] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetLegacyAdditionalIdNbrType] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

