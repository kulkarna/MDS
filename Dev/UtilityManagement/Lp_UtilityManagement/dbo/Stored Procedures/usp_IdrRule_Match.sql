CREATE PROC usp_IdrRule_Match
	@UtilityIdInt int,
	@RateClassValue NVARCHAR(255),
	@LoadProfileValue NVARCHAR(255),
	@Hia BIT,
	@IsEligibleFromUsage BIT,
	@Usage int
AS
BEGIN

--DECLARE @RateClassValue NVARCHAR(255)
--DECLARE @LoadProfileValue NVARCHAR(255)
--DECLARE @Hia BIT
--DECLARE @IsEligibleFromUsage BIT
--DECLARE @Usage int

--SET @RateClassValue = 'Aaa 111'
--SET @LoadProfileValue = 'r'
--SET @Hia = 0
--SET @IsEligibleFromUsage = 1
--SET @Usage = 1234

	
SELECT 
	CASE WHEN COUNT(IDR.Id) > 0 THEN 1 ELSE 0 END AS Match
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
			@RateClassValue IS NOT NULL AND RC.RateClassCode IS NOT NULL AND @RateClassValue = RC.RateClassCode
		)
	)
	AND
	(
		LP.LoadProfileCode IS NULL 
		OR
		(
			@LoadProfileValue IS NOT NULL AND LP.LoadProfileCode IS NOT NULL AND @LoadProfileValue = LP.LoadProfileCode
		)
	)
	AND
	(
		IDR.IsOnEligibleCustomerList = 0
		OR 
		(
			IDR.IsOnEligibleCustomerList = 1
			AND
			@IsEligibleFromUsage = 1
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

END