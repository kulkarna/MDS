CREATE PROC [dbo].[usp_IdrRuleAndRequestMode_SelectByParamWithTariffCode]
	@RateClassCode AS NVARCHAR(250),
	@LoadProfileCode AS NVARCHAR(250),
	@TariffCodeCode AS NVARCHAR(250),
	@UtilityIdInt INT,
	@AnnualUsage INT,
	@EnrollmentType INT,
	@Hia BIT
AS
BEGIN

	SELECT 
		IDR.[Id],
		LP.LoadProfileCode,
		RC.RateClassCode,
		TC.TariffCodeCode,
		IDR.[MinUsageMWh],
		IDR.[MaxUsageMWh],
		IDR.[RateClassId] AS RateClassIdGuid,
		IDR.[LoadProfileId] AS LoadProfileIdGuid,
		IDR.[IsOnEligibleCustomerList],
		IDR.[IsHistoricalArchiveAvailable],
		IDR.[Inactive],
		IDR.[CreatedBy],
		IDR.[CreatedDate],
		IDR.[LastModifiedBy],
		IDR.[LastModifiedDate],
		UC.Id AS UtilityCompanyId,
		UC.UtilityCode,
		UC.UtilityIdInt,
		LP.LoadProfileId,
		RC.RateClassId,
		RMI.Id AS RequestModeIdrId,
		RMI.RequestModeTypeId,
		RMI.RequestModeEnrollmentTypeId,
		RMI.AddressForPreEnrollment,
		RMI.EmailTemplate,
		RMI.Instructions,
		RMI.UtilitysSlaIdrResponseInDays,
		RMI.LibertyPowersSlaFollowUpIdrResponseInDays,
		RMI.IsLoaRequired,
		RMI.RequestCostAccount,
		RM.Name AS RequestModeTypeName
	FROM
		dbo.IdrRule (NOLOCK) IDR
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.RateClass (NOLOCK) RC
			ON IDR.RateClassId = RC.Id
		LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LP
			ON IDR.LoadProfileId = LP.Id
		LEFT OUTER JOIN dbo.TariffCode (NOLOCK) TC
			ON IDR.TariffCodeId = TC.Id
		INNER JOIN dbo.RequestModeIdr (NOLOCK) RMI
			ON UC.Id = RMI.UtilityCompanyId
		INNER JOIN dbo.RequestModeEnrollmentType (NOLOCK) REMT
			ON RMI.RequestModeEnrollmentTypeId = REMT.Id
		LEFT OUTER JOIN dbo.RequestModeType (NOLOCK) RM
			ON RMI.RequestModeTypeId = RM.Id
	WHERE
		UC.UtilityIdInt = @UtilityIdInt
		AND (@EnrollmentType IS NOT NULL AND REMT.EnumValue = @EnrollmentType)
		AND 
		(
			(
				(((@RateClassCode IS NULL OR RTRIM(LTRIM(@RateClassCode)) = '') AND RC.RateClassCode IS NULL) OR RC.RateClassCode IS NULL OR RC.RateClassCode = @RateClassCode)
				AND (((@LoadProfileCode IS NULL OR RTRIM(LTRIM(@LoadProfileCode)) = '') AND LP.LoadProfileCode IS NULL) OR LP.LoadProfileCode IS NULL OR LP.LoadProfileCode = @LoadProfileCode)
				AND (((@TariffCodeCode IS NULL OR RTRIM(LTRIM(@TariffCodeCode)) = '') AND TC.TariffCodeCode IS NULL) OR TC.TariffCodeCode IS NULL OR TC.TariffCodeCode = @TariffCodeCode)
				AND ((@AnnualUsage IS NULL AND IDR.MinUsageMWh IS NULL) OR IDR.MinUsageMWh IS NULL OR IDR.MinUsageMWh <= @AnnualUsage)
				AND ((IDR.MaxUsageMWh IS NULL AND @AnnualUsage IS NULL) OR IDR.MaxUsageMWh IS NULL OR IDR.MaxUsageMWh >= @AnnualUsage)
				AND (@EnrollmentType IS NOT NULL AND REMT.EnumValue = @EnrollmentType)
				AND ((@Hia IS NULL AND IDR.IsHistoricalArchiveAvailable IS NULL) OR IDR.IsHistoricalArchiveAvailable = 0 OR IDR.IsHistoricalArchiveAvailable = @Hia)
			)
			OR
			RMI.AlwaysRequest = 1
		)

END