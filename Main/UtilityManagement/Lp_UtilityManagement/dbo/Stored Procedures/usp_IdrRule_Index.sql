CREATE PROC usp_IdrRule_Index
AS
BEGIN

SELECT
	IDR.Id,
	UC.Id AS UtilityCompanyId,
	UC.UtilityCode,
	UC.UtilityIdInt,
	RMET.Id AS RequestModeEnrollmentTypeId,
	RMET.Name AS RequestModeEnrollmentTypeName,
	RMT.Id AS RequestModeTypeId,
	RMT.Name AS RequestModeTypeName,
	RC.Id AS RateClassId,
	RC.RateClassCode AS RateClassCode,
	RC.RateClassId AS RateClassRateClassId,
	LP.Id AS LoadProfileId,
	LP.LoadProfileCode AS LoadProfileCode,
	LP.LoadProfileId AS LoadProfileLoadProfileId,
	IDR.MaxUsageMWh,
	IDR.MinUsageMWh,
	IDR.IsHistoricalArchiveAvailable,
	IDR.IsOnEligibleCustomerList,
	IDR.Inactive,
	IDR.CreatedBy,
	IDR.CreatedDate,
	IDR.LastModifiedBy,
	IDR.LastModifiedDate
FROM
	dbo.IdrRule (NOLOCK) IDR
	INNER JOIN dbo.UtilityCompany (NOLOCK) UC
		ON IDR.UtilityCompanyId = UC.Id
	INNER JOIN dbo.RequestModeIdr (NOLOCK) RMI
		ON UC.Id = RMI.UtilityCompanyId
	INNER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
		ON RMI.RequestModeEnrollmentTypeId = RMET.Id
			AND RMET.EnumValue = 0
	INNER JOIN dbo.RequestModeType (NOLOCK) RMT
		ON RMI.RequestModeTypeId = RMT.Id
	LEFT OUTER JOIN RateClass (NOLOCK) RC
		ON IDR.RateClassId = RC.Id
	LEFT OUTER JOIN LoadProfile (NOLOCK) LP
		ON IDR.LoadProfileId = LP.Id

END