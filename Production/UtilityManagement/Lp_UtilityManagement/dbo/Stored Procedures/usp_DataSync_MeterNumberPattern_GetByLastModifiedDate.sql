
CREATE PROC [dbo].[usp_DataSync_MeterNumberPattern_GetByLastModifiedDate]
	@BeginDate DATETIME,
	@EndDate DATETIME
AS
BEGIN

	SELECT 
		MNP.[Id]
		,UC.UtilityIdInt AS UtilityId
		,[MeterNumberPattern]
		,[MeterNumberPatternDescription]
		,[MeterNumberAddLeadingZero]
		,[MeterNumberTruncateLast]
		,[MeterNumberRequiredForEdiRequest]
		,MNP.[Inactive]
		,MNP.[CreatedBy]
		,MNP.[CreatedDate]
		,MNP.[LastModifiedBy]
		,MNP.[LastModifiedDate]
	FROM 
		[dbo].[MeterNumberPattern] (NOLOCK) MNP
		INNER JOIN [dbo].[UtilityCompany] (NOLOCK) UC
			ON MNP.UtilityCompanyId = UC.Id
	WHERE
		DATEDIFF(S, MNP.[LastModifiedDate], @BeginDate) <= 0
		AND DATEDIFF(S, MNP.[LastModifiedDate], @EndDate) > 0
		
END