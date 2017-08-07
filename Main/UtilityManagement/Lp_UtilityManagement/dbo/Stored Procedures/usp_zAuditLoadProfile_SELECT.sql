
CREATE PROC [dbo].[usp_zAuditLoadProfile_SELECT]
AS
BEGIN

	SELECT 
		ALP.Id,
		ALP.IdPrevious,
		UC.Id AS UtilityCompanyId,
		UCPrev.Id AS UtilityCompanyIdPrevious,
		UC.UtilityCode,
		UCPrev.UtilityCode UtilityCodePrevious,
		ALP.LoadProfileCode,
		ALP.LoadProfileCodePrevious,
		ALP.[Description],
		ALP.[DescriptionPrevious],
		ALP.AccountTypeId,
		ALP.AccountTypeIdPrevious,
		AT.Name AS AccountTypeName,
		ATPrev.Name AS AccountTypeNamePrevious,
		ALP.LpStandardLoadProfileId,
		ALP.LpStandardLoadProfileIdPrevious,
		LSLP.LpStandardLoadProfileCode,
		LSLPPrev.LpStandardLoadProfileCode AS LpStandardLoadProfileCodePrevious,
		ALP.Inactive,
		ALP.InactivePrevious,
		ALP.CreatedBy,
		ALP.CreatedByPrevious,
		ALP.CreatedDate,
		ALP.CreatedDatePrevious,
		ALP.LastModifiedBy,
		ALP.LastModifiedByPrevious,
		ALP.LastModifiedDate,
		ALP.LastModifiedDatePrevious,
		REPLACE(ALP.SYS_CHANGE_COLUMNS, ',', ', ') AS SYS_CHANGE_COLUMNS,
		ALP.SYS_CHANGE_CREATION_VERSION,
		ALP.SYS_CHANGE_OPERATION,
		ALP.SYS_CHANGE_VERSION
	FROM 
		dbo.zAuditLoadProfile (NOLOCK) ALP
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC 
			ON ALP.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UCPrev 
			ON ALP.UtilityCompanyIdPrevious = UCPrev.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) AT
			ON ALP.AccountTypeId = AT.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) ATPrev
			ON ALP.AccountTypeIdPrevious = ATPrev.Id
		LEFT OUTER JOIN dbo.LpStandardLoadProfile (NOLOCK) LSLP
			ON ALP.LpStandardLoadProfileId = LSLP.Id
		LEFT OUTER JOIN dbo.LpStandardLoadProfile (NOLOCK) LSLPPrev
			ON ALP.LpStandardLoadProfileIdPrevious = LSLPPrev.Id

END


GO