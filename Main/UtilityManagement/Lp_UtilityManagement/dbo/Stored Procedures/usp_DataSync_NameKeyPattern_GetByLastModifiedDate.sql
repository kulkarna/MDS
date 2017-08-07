
CREATE PROC [dbo].[usp_DataSync_NameKeyPattern_GetByLastModifiedDate]
	@BeginDate DATETIME,
	@EndDate DATETIME
AS
BEGIN

	SELECT 
		NKP.[Id]
		,UC.[UtilityIdInt] AS UtilityId
		,NKP.[NameKeyPattern]
		,NKP.[NameKeyPatternDescription]
		,NKP.[NameKeyAddLeadingZero]
		,NKP.[NameKeyTruncateLast]
		,NKP.[NameKeyRequiredForEDIRequest]
		,NKP.[Inactive]
		,NKP.[CreatedBy]
		,NKP.[CreatedDate]
		,NKP.[LastModifiedBy]
		,NKP.[LastModifiedDate]
	FROM 
		[dbo].[NameKeyPattern] (NOLOCK) NKP
		INNER JOIN [dbo].[UtilityCompany] (NOLOCK) UC
			ON NKP.UtilityCompanyId = UC.Id
	WHERE
		DATEDIFF(S, NKP.[LastModifiedDate], @BeginDate) <= 0
		AND DATEDIFF(S, NKP.[LastModifiedDate], @EndDate) > 0
		
END