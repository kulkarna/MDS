
CREATE PROC [dbo].[usp_IdrRuleAndRequestMode_SelectByParams]
	@RateClassCode AS NVARCHAR(250),
	@LoadProfileCode AS NVARCHAR(250),
	@UtilityIdInt INT,
	@AnnualUsage INT,
	@EnrollmentType NVARCHAR(250),
	@Hia BIT
AS
BEGIN

	SELECT 
		IDR.[Id],
		IDR.[RateClassId] AS RateClassIdGuid,
		IDR.[LoadProfileId] AS LoadProfileIdGuid,
		IDR.[MinUsageMWh],
		IDR.[MaxUsageMWh],
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
		LP.LoadProfileCode,
		RC.RateClassCode,
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
		INNER JOIN dbo.RequestModeIdr (NOLOCK) RMI
			ON UC.Id = RMI.UtilityCompanyId
				AND IDR.RequestModeTypeId = RMI.RequestModeTypeId
		INNER JOIN dbo.RequestModeEnrollmentType (NOLOCK) REMT
			ON RMI.RequestModeEnrollmentTypeId = REMT.Id
		LEFT OUTER JOIN dbo.RequestModeType (NOLOCK) RM
			ON IDR.RequestModeTypeId = RM.Id
	WHERE
		(((@RateClassCode IS NULL OR RTRIM(LTRIM(@RateClassCode)) = '') AND RC.RateClassCode IS NULL) OR RC.RateClassCode IS NULL OR RC.RateClassCode = @RateClassCode)
		AND (((@LoadProfileCode IS NULL OR RTRIM(LTRIM(@LoadProfileCode)) = '') AND LP.LoadProfileCode IS NULL) OR LP.LoadProfileCode IS NULL OR LP.LoadProfileCode = @LoadProfileCode)
		AND UC.UtilityIdInt = @UtilityIdInt
		AND ((@AnnualUsage IS NULL AND IDR.MinUsageMWh IS NULL) OR IDR.MinUsageMWh IS NULL OR IDR.MinUsageMWh <= @AnnualUsage)
		AND ((IDR.MaxUsageMWh IS NULL AND @AnnualUsage IS NULL) OR IDR.MaxUsageMWh IS NULL OR IDR.MaxUsageMWh >= @AnnualUsage)
		AND (@EnrollmentType IS NOT NULL AND REMT.Name = @EnrollmentType)
		AND ((@Hia IS NULL AND IDR.IsHistoricalArchiveAvailable IS NULL) OR IDR.IsHistoricalArchiveAvailable = @Hia)


END