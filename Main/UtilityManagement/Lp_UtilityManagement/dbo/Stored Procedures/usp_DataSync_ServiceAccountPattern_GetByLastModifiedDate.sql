
CREATE PROC [dbo].[usp_DataSync_ServiceAccountPattern_GetByLastModifiedDate]
	@BeginDate DATETIME,
	@EndDate DATETIME
AS
BEGIN

	SELECT 
		SAP.[Id]
		,UC.[UtilityIdInt] AS UtilityId
		,SAP.[ServiceAccountPattern]
		,SAP.[ServiceAccountPatternDescription]
		,SAP.[ServiceAccountAddLeadingZero]
		,SAP.[ServiceAccountTruncateLast]
		,SAP.[ServiceAccountRequiredForEDIRequest]
		,SAP.[Inactive]
		,SAP.[CreatedBy]
		,SAP.[CreatedDate]
		,SAP.[LastModifiedBy]
		,SAP.[LastModifiedDate]
	FROM 
		[dbo].[ServiceAccountPattern] (NOLOCK) SAP
		INNER JOIN [UtilityCompany] (NOLOCK) UC
			ON SAP.UtilityCompanyId = UC.Id
	WHERE
		DATEDIFF(S, SAP.[LastModifiedDate], @BeginDate) <= 0
		AND DATEDIFF(S, SAP.[LastModifiedDate], @EndDate) > 0
		
END