
CREATE PROC [dbo].[usp_zAuditServiceClass_SELECT]
AS
BEGIN
	SELECT 
		AMT.Id,
		AMT.IdPrevious,
		UC.Id AS UtilityCompanyId,
		UCPrev.Id AS UtilityCompanyIdPrevious,
		UC.UtilityCode,
		UCPrev.UtilityCode UtilityCodePrevious,
		AMT.ServiceClassCode,
		AMT.ServiceClassCodePrevious,
		AMT.[Description],
		AMT.[DescriptionPrevious],
		AMT.AccountTypeId,
		AMT.AccountTypeIdPrevious,
		AT.Name AS AccountTypeName,
		ATPrev.Name AS AccountTypeNamePrevious,
		AMT.LpStandardServiceClass,
		AMT.LpStandardServiceClassPrevious,
		AMT.Inactive,
		AMT.InactivePrevious,
		AMT.CreatedBy,
		AMT.CreatedByPrevious,
		AMT.CreatedDate,
		AMT.CreatedDatePrevious,
		AMT.LastModifiedBy,
		AMT.LastModifiedByPrevious,
		AMT.LastModifiedDate,
		AMT.LastModifiedDatePrevious,
		REPLACE(AMT.SYS_CHANGE_COLUMNS, ',', ', ') AS SYS_CHANGE_COLUMNS,
		AMT.SYS_CHANGE_CREATION_VERSION,
		AMT.SYS_CHANGE_OPERATION,
		AMT.SYS_CHANGE_VERSION
	FROM 
		dbo.zAuditServiceClass (NOLOCK) AMT
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC 
			ON AMT.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UCPrev 
			ON AMT.UtilityCompanyIdPrevious = UCPrev.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) AT
			ON AMT.AccountTypeId = AT.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) ATPrev
			ON AMT.AccountTypeIdPrevious = ATPrev.Id
END


GO