

CREATE PROC [dbo].[usp_DataSync_ServiceAddressZipPattern_GetByLastModifiedDate]
	@BeginDate DATETIME,
	@EndDate DATETIME
AS
BEGIN

	SELECT 
		SAZP.[Id]
		,UC.[UtilityIdInt] AS UtilityId
		,[ServiceAddressZipPattern]
		,[ServiceAddressZipPatternDescription]
		,[ServiceAddressZipAddLeadingZero]
		,[ServiceAddressZipTruncateLast]
		,[ServiceAddressZipRequiredForEDIRequest]
		,SAZP.[Inactive]
		,SAZP.[CreatedBy]
		,SAZP.[CreatedDate]
		,SAZP.[LastModifiedBy]
		,SAZP.[LastModifiedDate]
	FROM 
		[dbo].[ServiceAddressZipPattern] (NOLOCK) SAZP
		INNER JOIN [dbo].[UtilityCompany] (NOLOCK) UC
			ON SAZP.UtilityCompanyId = UC.Id
	WHERE
		DATEDIFF(S, SAZP.[LastModifiedDate], @BeginDate) <= 0
		AND DATEDIFF(S, SAZP.[LastModifiedDate], @EndDate) > 0
		
END