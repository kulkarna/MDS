
CREATE PROC [dbo].[usp_zAuditRequestModeHistoricalUsage_SELECT]
AS
BEGIN

	SELECT 
		ZARMHU.Id,
		ZARMHU.IdPrevious,
		UC.Id AS UtilityCompanyId,
		UCPrev.Id AS UtilityCompanyIdPrevious,
		UC.UtilityCode,
		UCPrev.UtilityCode UtilityCodePrevious,
		RMET.Id AS RequestModeEnrollmentTypeId,
		RMETPrev.Id AS RequestModeEnrollmentTypeIdPrevious,
		RMET.Name AS RequestModeEnrollmentType,
		RMETPrev.Name AS RequestModeEnrollmentTypePrevious,
		RMT.Id AS RequestModeTypeId,
		RMTPrev.Id AS RequestModeTypeIdPrevious,
		RMT.Name AS RequestModeType,
		RMTPrev.Name AS RequestModeTypePrevious,
		ZARMHU.AddressForPreEnrollment,
		ZARMHU.AddressForPreEnrollmentPrevious,
		ZARMHU.EmailTemplate,
		ZARMHU.EmailTemplatePrevious,
		ZARMHU.Instructions,
		ZARMHU.InstructionsPrevious,
		ZARMHU.UtilitysSlaHistoricalUsageResponseInDays,
		ZARMHU.UtilitysSlaHistoricalUsageResponseInDaysPrevious,
		ZARMHU.LibertyPowersSlaFollowUpHistoricalUsageResponseInDays,
		ZARMHU.LibertyPowersSlaFollowUpHistoricalUsageResponseInDaysPrevious,
		ZARMHU.IsLoaRequired,
		ZARMHU.IsLoaRequiredPrevious,
		ZARMHU.Inactive,
		ZARMHU.InactivePrevious,
		ZARMHU.CreatedBy,
		ZARMHU.CreatedByPrevious,
		ZARMHU.CreatedDate,
		ZARMHU.CreatedDatePrevious,
		ZARMHU.LastModifiedBy,
		ZARMHU.LastModifiedByPrevious,
		ZARMHU.LastModifiedDate,
		ZARMHU.LastModifiedDatePrevious,
		REPLACE(ZARMHU.SYS_CHANGE_COLUMNS, ',', ', ') AS SYS_CHANGE_COLUMNS,
		ZARMHU.SYS_CHANGE_CREATION_VERSION,
		ZARMHU.SYS_CHANGE_OPERATION,
		ZARMHU.SYS_CHANGE_VERSION
	FROM 
		dbo.zAuditRequestModeHistoricalUsage (NOLOCK) ZARMHU
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC 
			ON ZARMHU.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UCPrev 
			ON ZARMHU.UtilityCompanyIdPrevious = UCPrev.Id
		LEFT OUTER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
			ON ZARMHU.RequestModeEnrollmentTypeId = RMET.Id
		LEFT OUTER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMETPrev
			ON ZARMHU.RequestModeEnrollmentTypeIdPrevious = RMETPrev.Id
		LEFT OUTER JOIN dbo.RequestModeType (NOLOCK) RMT
			ON ZARMHU.RequestModeTypeId = RMT.Id
		LEFT OUTER JOIN dbo.RequestModeType (NOLOCK) RMTPrev
			ON ZARMHU.RequestModeTypeIdPrevious = RMTPrev.Id

END