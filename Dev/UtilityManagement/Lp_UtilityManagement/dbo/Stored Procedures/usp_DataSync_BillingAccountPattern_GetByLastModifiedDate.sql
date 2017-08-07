CREATE PROC [dbo].[usp_DataSync_BillingAccountPattern_GetByLastModifiedDate]
	@BeginDate DATETIME,
	@EndDate DATETIME
AS
BEGIN

	SELECT 
		BAP.[Id]
		,UC.UtilityIdInt AS UtilityId
		,[BillingAccountPattern]
		,[BillingAccountPatternDescription]
		,[BillingAccountAddLeadingZero]
		,[BillingAccountTruncateLast]
		,[BillingAccountRequiredForEDIRequest]
		,BAP.[Inactive]
		,BAP.[CreatedBy]
		,BAP.[CreatedDate]
		,BAP.[LastModifiedBy]
		,BAP.[LastModifiedDate]
  FROM 
		[dbo].[BillingAccountPattern] (NOLOCK) BAP
		INNER JOIN [dbo].[UtilityCompany] (NOLOCK) UC
			ON BAP.UtilityCompanyId = UC.Id
	WHERE
		DATEDIFF(S, BAP.[LastModifiedDate], @BeginDate) <= 0
		AND DATEDIFF(S, BAP.[LastModifiedDate], @EndDate) > 0
		
END