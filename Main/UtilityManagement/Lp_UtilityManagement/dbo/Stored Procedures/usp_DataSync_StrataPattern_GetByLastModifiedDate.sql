
CREATE PROC [dbo].[usp_DataSync_StrataPattern_GetByLastModifiedDate]
	@BeginDate DATETIME,
	@EndDate DATETIME
AS
BEGIN

	SELECT 
		SP.[Id]
		,UC.UtilityIdInt UtilityId
		,SP.[StrataPattern]
		,SP.[StrataPatternDescription]
		,SP.[StrataAddLeadingZero]
		,SP.[StrataTruncateLast]
		,SP.[StrataRequiredForEdiRequest]
		,SP.[Inactive]
		,SP.[CreatedBy]
		,SP.[CreatedDate]
		,SP.[LastModifiedBy]
		,SP.[LastModifiedDate]
	FROM 
		[dbo].[StrataPattern] (NOLOCK) SP
		INNER JOIN [dbo].[UtilityCompany] (NOLOCK) UC
			ON SP.UtilityCompanyId = UC.Id
	WHERE
		DATEDIFF(S, SP.[LastModifiedDate], @BeginDate) <= 0
		AND DATEDIFF(S, SP.[LastModifiedDate], @EndDate) > 0

END