
CREATE PROC [dbo].[usp_DataSync_ICapTCapRefresh_GetByLastModifiedDate]
	@BeginDate DATETIME,
	@EndDate DATETIME
AS
BEGIN

	SELECT 
		ICTCR.[Id],
		UC.UtilityIdInt AS UtilityId,
		[ICapNextRefresh],
		[ICapEffectiveDate],
		[TCapNextRefresh],
		[TCapEffectiveDate],
		ICTCR.[Inactive],
		ICTCR.[CreatedBy],
		ICTCR.[CreatedDate],
		ICTCR.[LastModifiedBy],
		ICTCR.[LastModifiedDate]
	FROM 
		[dbo].[ICapTCapRefresh] (NOLOCK) ICTCR
		INNER JOIN [dbo].[UtilityCompany] (NOLOCK) UC
			ON ICTCR.UtilityCompanyId = UC.Id
	WHERE
		DATEDIFF(S, ICTCR.[LastModifiedDate], @BeginDate) <= 0
		AND DATEDIFF(S, ICTCR.[LastModifiedDate], @EndDate) > 0
		
END