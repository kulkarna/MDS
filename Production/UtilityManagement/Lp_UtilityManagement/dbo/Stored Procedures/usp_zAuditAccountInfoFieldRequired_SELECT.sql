
CREATE PROC [dbo].[usp_zAuditAccountInfoFieldRequired_SELECT]
AS
BEGIN

	SELECT 
		AAIFR.Id,
		AAIFR.IdPrevious,
		UC.Id AS UtilityCompanyId,
		UCPrev.Id AS UtilityCompanyIdPrevious,
		UC.UtilityCode,
		UCPrev.UtilityCode UtilityCodePrevious,
		AIF.Id AccountInfoFieldId,
		AIFPrev.Id AccountInfoFieldIdPrevious,
		AIF.NameUserFriendly,
		AIFPrev.NameUserFriendly AS NameUserFriendlyPrevious,
		AIF.NameMachineUnfriendly,
		AIFPrev.NameMachineUnfriendly AS NameMachineUnfriendlyPrevious,
		AIF.[Description],
		AIFPrev.[Description] AS DescriptionPrevious,
		AAIFR.IsRequired,
		AAIFR.IsRequiredPrevious,
		AAIFR.Inactive,
		AAIFR.InactivePrevious,
		AAIFR.CreatedBy,
		AAIFR.CreatedByPrevious,
		AAIFR.CreatedDate,
		AAIFR.CreatedDatePrevious,
		AAIFR.LastModifiedBy,
		AAIFR.LastModifiedByPrevious,
		AAIFR.LastModifiedDate,
		AAIFR.LastModifiedDatePrevious,
		REPLACE(AAIFR.SYS_CHANGE_COLUMNS, ',', ', ') AS SYS_CHANGE_COLUMNS,
		AAIFR.SYS_CHANGE_CREATION_VERSION,
		AAIFR.SYS_CHANGE_OPERATION,
		AAIFR.SYS_CHANGE_VERSION
	FROM 
		dbo.zAuditAccountInfoFieldRequired (NOLOCK) AAIFR
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC 
			ON AAIFR.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UCPrev 
			ON AAIFR.UtilityCompanyIdPrevious = UCPrev.Id
		LEFT OUTER JOIN dbo.AccountInfoField (NOLOCK) AIF
			ON AAIFR.AccountInfoFieldId = AIF.Id
		LEFT OUTER JOIN dbo.AccountInfoField (NOLOCK) AIFPrev
			ON AAIFR.AccountInfoFieldIdPrevious = AIFPrev.Id
END