CREATE PROC usp_IdrRule_GuaranteedFactorNotMet
	@RateClassCode AS NVARCHAR(255),
	@LoadProfileCode AS NVARCHAR(255),
	@Eligibility AS BIT,
	@Hia AS BIT,
	@UtilityIdInt AS INT,
	@Usage AS INT
AS
BEGIN

	DECLARE @GuaranteedFactorNotMet INT
	DECLARE @TotalRuleCount INT
	DECLARE @BusinessFactorNotMet INT
	DECLARE @MatchCount INT
	DECLARE @InsufficientInfoCount INT

	DECLARE @GuaranteedFactorNotMetTable TABLE
	(
		IdrId NVARCHAR(90)
	)

	DECLARE @TotalRuleCountTable TABLE
	(
		IdrId NVARCHAR(90)
	)

	SELECT DISTINCT
		IDR.Id,
		RC.RateClassCode,
		LP.LoadProfileCode,
		IDR.IsOnEligibleCustomerList,
		IDR.IsHistoricalArchiveAvailable,
		IDR.MinUsageMWh,
		IDR.MaxUsageMWh,
		*
	FROM 
		dbo.IdrRule (NOLOCK) IDR
		LEFT OUTER JOIN dbo.RateClass (NOLOCK) RC
			ON IDR.RateClassId = RC.Id
		LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LP
			ON IDR.LoadProfileId = LP.Id
		inner join dbo.UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
	WHERE
		UC.UtilityIdInt = @UtilityIdInt	

	SELECT 
		@MatchCount = COUNT(IDR.ID)
	FROM 
		dbo.IdrRule (NOLOCK) IDR
		LEFT OUTER JOIN dbo.RateClass (NOLOCK) RC
			ON IDR.RateClassId = RC.Id
		LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LP
			ON IDR.LoadProfileId = LP.Id
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
	WHERE
		UC.UtilityIdInt = @UtilityIdInt
		AND
		(
			RC.RateClassCode IS NULL
			OR
			(
				@RateClassCode IS NOT NULL AND RC.RateClassCode IS NOT NULL AND @RateClassCode = RC.RateClassCode
			)
		)
		AND
		(
			LP.LoadProfileCode IS NULL 
			OR
			(
				@LoadProfileCode IS NOT NULL AND LP.LoadProfileCode IS NOT NULL AND @LoadProfileCode = LP.LoadProfileCode
			)
		)
		AND
		(
			IDR.IsOnEligibleCustomerList = 0
			OR 
			(
				IDR.IsOnEligibleCustomerList = 1
				AND
				@Eligibility = 1
			)
		)
		AND
		(
			IDR.IsHistoricalArchiveAvailable = @Hia
		)
		AND 
		(
			(IDR.MaxUsageMWh IS NULL OR (IDR.MaxUsageMWh IS NOT NULL AND @Usage IS NOT NULL AND IDR.MaxUsageMWh >= @Usage))
			AND
			(IDR.MinUsageMWh IS NULL OR (IDR.MinUsageMWh IS NOT NULL AND @Usage IS NOT NULL AND IDR.MinUsageMWh <= @Usage))
		)
		
----------------------------------------------------------------------

	SELECT 
		@InsufficientInfoCount = COUNT(DISTINCT IDR.ID)
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
		AND @RateClassCode IS NOT NULL
		AND RC.RateClassCode <> @RateClassCode
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
		AND @LoadProfileCode IS NOT NULL
		AND LC.LoadProfileCode <> @LoadProfileCode
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
		(((@RateClassCode IS NULL OR RTRIM(LTRIM(@RateClassCode)) = '') AND RC.RateClassCode IS NULL) OR RC.RateClassCode IS NULL OR RC.RateClassCode = @RateClassCode)
		AND (((@LoadProfileCode IS NULL OR RTRIM(LTRIM(@LoadProfileCode)) = '') AND LP.LoadProfileCode IS NULL) OR LP.LoadProfileCode IS NULL OR LP.LoadProfileCode = @LoadProfileCode)
		AND UC.UtilityIdInt = @UtilityIdInt
		AND ((@Usage IS NULL AND IDR.MinUsageMWh IS NULL) OR IDR.MinUsageMWh IS NULL OR IDR.MinUsageMWh <= @Usage)
		AND ((IDR.MaxUsageMWh IS NULL AND @Usage IS NULL) OR IDR.MaxUsageMWh IS NULL OR IDR.MaxUsageMWh >= @Usage)
		AND ((@Hia IS NULL AND IDR.IsHistoricalArchiveAvailable IS NULL) OR IDR.IsHistoricalArchiveAvailable = @Hia)
	)

----------------------------------------------------------------------		
		
		
		
		INSERT INTO @GuaranteedFactorNotMetTable
		SELECT 
			IDR.Id
		FROM
			dbo.IdrRule (NOLOCK) IDR
			INNER JOIN dbo.UtilityCompany (NOLOCK) UC
				ON IDR.UtilityCompanyId = UC.Id
			LEFT OUTER JOIN dbo.RateClass (NOLOCK) RC
				ON IDR.RateClassId = RC.Id
			LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LP
				ON IDR.LoadProfileId = LP.Id
		WHERE
			UC.UtilityIdInt = @UtilityIdInt
			AND
			(
				(RC.RateClassCode IS NOT NULL AND @RateClassCode IS NOT NULL AND RC.RateClassCode <> @RateClassCode)
				OR
				(LP.LoadProfileCode IS NOT NULL AND @LoadProfileCode IS NOT NULL AND LP.LoadProfileCode <> @LoadProfileCode)
				OR
				(IDR.IsOnEligibleCustomerList = 1 AND @Eligibility = 0)
				OR
				(IDR.IsHistoricalArchiveAvailable <> @Hia)
			)
	
	INSERT INTO @TotalRuleCountTable
	SELECT 
		IDR.Id
	FROM
		dbo.IdrRule (NOLOCK) IDR
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.RateClass (NOLOCK) RC
			ON IDR.RateClassId = RC.Id
		LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LP
			ON IDR.LoadProfileId = LP.Id
	WHERE
		UC.UtilityIdInt = @UtilityIdInt

	--SELECT 
	--	@GuaranteedFactorNotMet = COUNT(IdrId)
	--FROM
	--	@GuaranteedFactorNotMetTable
	SELECT 
		@GuaranteedFactorNotMet = COUNT(IDR.Id)
	FROM
		dbo.IdrRule (NOLOCK) IDR
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.RateClass (NOLOCK) RC
			ON IDR.RateClassId = RC.Id
		LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LP
			ON IDR.LoadProfileId = LP.Id
	WHERE
		UC.UtilityIdInt = @UtilityIdInt
		AND
		(
			(RC.RateClassCode IS NOT NULL AND @RateClassCode IS NOT NULL AND RC.RateClassCode <> @RateClassCode)
			OR
			(LP.LoadProfileCode IS NOT NULL AND @LoadProfileCode IS NOT NULL AND LP.LoadProfileCode <> @LoadProfileCode)
			OR
			(IDR.IsOnEligibleCustomerList = 1 AND @Eligibility = 0)
			OR
			(IDR.IsHistoricalArchiveAvailable <> @Hia)
		)

	--SELECT 
	--	@TotalRuleCount = COUNT(IdrId)
	--FROM
	--	@TotalRuleCountTable
	SELECT 
		@TotalRuleCount = COUNT(IDR.Id)
	FROM
		dbo.IdrRule (NOLOCK) IDR
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.RateClass (NOLOCK) RC
			ON IDR.RateClassId = RC.Id
		LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LP
			ON IDR.LoadProfileId = LP.Id
	WHERE
		UC.UtilityIdInt = @UtilityIdInt

	SELECT
		@BusinessFactorNotMet = COUNT(IDR.Id)
	FROM
		dbo.IdrRule (NOLOCK) IDR
	WHERE
		IDR.Id IN
		(
			SELECT
				IdrId
			FROM
				@TotalRuleCountTable TRCT
			WHERE
				TRCT.IdrId NOT IN (SELECT IdrId FROM @GuaranteedFactorNotMetTable)
		)
		AND 
		(
			(
				@Usage IS NULL AND (IDR.MinUsageMWh IS NOT NULL AND IDR.MaxUsageMWh IS NOT NULL)
			)
			OR
			(
				@Usage IS NOT NULL AND 
				(
					(
						IDR.MinUsageMWh IS NOT NULL 
						AND @Usage < IDR.MinUsageMWh
					)
					OR
					(
						IDR.MaxUsageMWh IS NOT NULL 
						AND @Usage > IDR.MaxUsageMWh
					)
				)
			)
		)

	SELECT @RateClassCode RateClassCode, @LoadProfileCode LoadProfileCode, @Eligibility Eligibility, @Hia Hia, @UtilityIdInt UtilityIdInt, @Usage Usage

	SELECT @MatchCount MatchCount, @InsufficientInfoCount InsufficientInfoCount, @TotalRuleCount TotalRuleCount, @GuaranteedFactorNotMet GuaranteedFactorNotMet, @BusinessFactorNotMet BusinessFactorNotMet

	SELECT
		CASE WHEN @MatchCount > 0 THEN 1 ELSE 0 END AS Match
		
	SELECT
		CASE WHEN @MatchCount = 0 AND @InsufficientInfoCount > 0 THEN 1 ELSE 0 END AS InsufficientInfo

	SELECT
		CASE WHEN @MatchCount > 0 OR @TotalRuleCount > @GuaranteedFactorNotMet THEN 0 ELSE 1 END AS GuaranteedFactorNotMet

	SELECT
		CASE WHEN @MatchCount = 0 AND @InsufficientInfoCount = 0 AND @BusinessFactorNotMet > 0 THEN 1 ELSE 0 END AS BusinessFactorNotMet

		
END