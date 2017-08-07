
CREATE PROC [dbo].[usp_IdrRule_InsufficientInfo]
	@UtilityIdInt int,
	@RateClass NVARCHAR(250),
	@LoadProfile NVARCHAR(250),
	@Usage INT,
	@Eligibility BIT,
	@Hia BIT
AS
BEGIN

	SELECT 
		COUNT(DISTINCT IDR.ID)
	FROM
		dbo.IdrRule (NOLOCK) IDR
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
	WHERE
		UC.UtilityIdInt = @UtilityIdInt
		AND IDR.ID NOT IN
	(
	SELECT DISTINCT
		IDR.ID
	FROM 
		dbo.IdrRule (NOLOCK) IDR
		LEFT OUTER JOIN dbo.RateClass (NOLOCK) RC
			ON IDR.RateClassId = RC.Id
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
			AND UC.UtilityIdInt = @UtilityIdInt
	WHERE
		RC.RateClassCode IS NOT NULL 
		AND @RateClass IS NOT NULL
		AND RC.RateClassCode <> @RateClass
	UNION	
	SELECT DISTINCT
		IDR.ID
	FROM 
		dbo.IdrRule (NOLOCK) IDR
		LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LC
			ON IDR.LoadProfileId = LC.Id
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
			AND UC.UtilityIdInt = @UtilityIdInt
	WHERE
		LC.LoadProfileCode IS NOT NULL 
		AND @LoadProfile IS NOT NULL
		AND LC.LoadProfileCode <> @LoadProfile
	UNION	
	SELECT DISTINCT
		IDR.ID
	FROM 
		dbo.IdrRule (NOLOCK) IDR
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
			AND UC.UtilityIdInt = @UtilityIdInt
	WHERE
		IDR.MinUsageMWh IS NOT NULL
		AND @Usage IS NOT NULL
		AND IDR.MinUsageMWh > @Usage
	UNION
	SELECT DISTINCT
		IDR.ID
	FROM 
		dbo.IdrRule (NOLOCK) IDR
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
			AND UC.UtilityIdInt = @UtilityIdInt
	WHERE
		IDR.MaxUsageMWh IS NOT NULL
		AND @Usage IS NOT NULL
		AND IDR.MaxUsageMWh < @Usage
	UNION
	SELECT DISTINCT
		IDR.ID
	FROM 
		dbo.IdrRule (NOLOCK) IDR
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
			AND UC.UtilityIdInt = @UtilityIdInt
	WHERE
		IDR.IsOnEligibleCustomerList IS NOT NULL
		AND @Eligibility IS NOT NULL
		AND IDR.IsOnEligibleCustomerList <> @Eligibility
	UNION
	SELECT DISTINCT
		IDR.ID
	FROM 
		dbo.IdrRule (NOLOCK) IDR
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
			AND UC.UtilityIdInt = @UtilityIdInt
	WHERE
		IDR.IsHistoricalArchiveAvailable IS NOT NULL
		AND @Hia IS NOT NULL
		AND IDR.IsHistoricalArchiveAvailable <> @Hia

	UNION

	SELECT DISTINCT
		IDR.[Id]
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
		(((@RateClass IS NULL OR RTRIM(LTRIM(@RateClass)) = '') AND RC.RateClassCode IS NULL) OR RC.RateClassCode IS NULL OR RC.RateClassCode = @RateClass)
		AND (((@LoadProfile IS NULL OR RTRIM(LTRIM(@LoadProfile)) = '') AND LP.LoadProfileCode IS NULL) OR LP.LoadProfileCode IS NULL OR LP.LoadProfileCode = @LoadProfile)
		AND UC.UtilityIdInt = @UtilityIdInt
		AND ((@Usage IS NULL AND IDR.MinUsageMWh IS NULL) OR IDR.MinUsageMWh IS NULL OR IDR.MinUsageMWh <= @Usage)
		AND ((IDR.MaxUsageMWh IS NULL AND @Usage IS NULL) OR IDR.MaxUsageMWh IS NULL OR IDR.MaxUsageMWh >= @Usage)
		AND ((@Hia IS NULL AND IDR.IsHistoricalArchiveAvailable IS NULL) OR IDR.IsHistoricalArchiveAvailable = @Hia)
	)
END