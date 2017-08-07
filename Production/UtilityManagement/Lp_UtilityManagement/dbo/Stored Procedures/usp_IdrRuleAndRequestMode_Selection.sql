
CREATE PROC [dbo].[usp_IdrRuleAndRequestMode_Selection]
	@RateClassCode AS NVARCHAR(250),
	@LoadProfileCode AS NVARCHAR(250),
	@UtilityIdInt INT,
	@AnnualUsage INT
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
		LEFT OUTER JOIN dbo.RequestModeType (NOLOCK) RM
			ON IDR.RequestModeTypeId = RM.Id
	WHERE
		(@RateClassCode IS NULL OR RTRIM(LTRIM(@RateClassCode)) = '' OR RC.RateClassCode = @RateClassCode)
		AND (@LoadProfileCode IS NULL OR RTRIM(LTRIM(@LoadProfileCode)) = '' OR LP.LoadProfileCode = @LoadProfileCode)
		AND UC.UtilityIdInt = @UtilityIdInt
		AND (IDR.MinUsageMWh IS NULL OR @AnnualUsage IS NULL OR IDR.MinUsageMWh <= @AnnualUsage)
		AND (IDR.MaxUsageMWh IS NULL OR @AnnualUsage IS NULL OR IDR.MaxUsageMWh >= @AnnualUsage)
		
END
GO

