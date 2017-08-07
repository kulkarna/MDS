CREATE PROC [dbo].[usp_IdrRule_IndexSelect]
	@UtilityCompanyId UNIQUEIDENTIFIER,
	@RequestModeEnrollmentTypeEnum INT
AS
BEGIN

	SELECT 
		IR.Id IdrRuleId,
		RMI.Id RequestModeIdrId,
		RMET.Name RequestModeEnrollmentTypeName,
		RMT.Name RequestModeTypeName,
		RC.RateClassCode,
		LP.LoadProfileCode,
		TC.TariffCodeCode,
		IR.MinUsageMWh,
		IR.MaxUsageMWh,
		IR.IsOnEligibleCustomerList,
		IR.IsHistoricalArchiveAvailable,
		IR.Inactive,
		IR.CreatedBy,
		IR.CreatedDate,
		IR.LastModifiedBy,
		IR.LastModifiedDate 
	FROM 
		dbo.IdrRule (NOLOCK) IR
		LEFT OUTER JOIN RequestModeIdr (NOLOCK) RMI
			ON IR.RequestModeIdrId = RMI.Id
		LEFT OUTER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
			ON RMI.RequestModeEnrollmentTypeId = RMET.Id
		LEFT OUTER JOIN RequestModeType (NOLOCK) RMT
			ON RMI.RequestModeTypeId = RMT.Id
		LEFT OUTER JOIN dbo.RateClass (NOLOCK) RC
			ON IR.RateClassId = RC.Id
		LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LP
			ON IR.LoadProfileId = LP.Id
		LEFT OUTER JOIN dbo.TariffCode (NOLOCK) TC
			ON IR.TariffCodeId = TC.Id
	WHERE	
		IR.UtilityCompanyId = @UtilityCompanyId
		AND RMET.EnumValue = @RequestModeEnrollmentTypeEnum
		
END