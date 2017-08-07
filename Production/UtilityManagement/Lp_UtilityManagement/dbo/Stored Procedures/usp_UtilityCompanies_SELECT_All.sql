CREATE PROC usp_UtilityCompanies_SELECT_All
AS
BEGIN

	SELECT
		Id,
		UtilityCode,
		Inactive,
		CreatedBy,
		CreatedDate,
		LastModifiedBy,
		LastModifiedDate
	FROM
		dbo.UtilityCompany (NOLOCK) UC

END

GO