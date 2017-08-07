CREATE PROC usp_Chart_IdrRuleCount
AS 
BEGIN


	SELECT
		UtilityCode,
		COUNT(*) AS TotalRuleCount,
		SUM(RateClassRuleCount) AS RateClassRuleCount,
		SUM(LoadProfileRuleCount) AS LoadProfileRuleCount,
		SUM(MinUsageMWhRuleCount) AS MinUsageMWhRuleCount,
		SUM(MaxUsageMWhRuleCount) AS MaxUsageMWhRuleCount,
		SUM(IsEligibleRuleCount) AS IsEligibleRuleCount,
		SUM(IsHiaRuleCount) AS IsHiaRuleCount
	FROM
	(
	SELECT 
		UC.UtilityCode, 
		CASE WHEN RateClassId IS NULL THEN 0 ELSE 1 END AS RateClassRuleCount,
		CASE WHEN LoadProfileId IS NULL THEN 0 ELSE 1 END AS LoadProfileRuleCount,
		CASE WHEN MinUsageMWh IS NULL THEN 0 ELSE 1 END AS MinUsageMWhRuleCount,
		CASE WHEN MaxUsageMWh IS NULL THEN 0 ELSE 1 END AS MaxUsageMWhRuleCount,
		CAST(IsOnEligibleCustomerList AS INT) AS IsEligibleRuleCount,
		CAST(IsHistoricalArchiveAvailable AS INT) AS IsHiaRuleCount
	FROM 
		IdrRule (NOLOCK) IDR
		INNER JOIN UtilityCompany (NOLOCK) UC
			ON IDR.UtilityCompanyId = UC.Id
	) A
	GROUP BY A.UtilityCode
	ORDER BY A.UtilityCode
	
END
GO
