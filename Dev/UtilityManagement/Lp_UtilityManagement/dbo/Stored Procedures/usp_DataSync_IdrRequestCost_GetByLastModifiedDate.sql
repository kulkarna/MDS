
CREATE PROC [dbo].[usp_DataSync_IdrRequestCost_GetByLastModifiedDate]
	@BeginDate DATETIME,
	@EndDate DATETIME
AS
BEGIN

	SELECT 
		RMI.[Id],
		UC.UtilityIdInt AS UtilityId,
		RMI.RequestCostAccount AS IdrRequestCostPerAccount,
		RMI.[Inactive],
		RMI.[CreatedBy],
		RMI.[CreatedDate],
		RMI.[LastModifiedBy],
		RMI.[LastModifiedDate]
	FROM 
		[dbo].[RequestModeIdr] (NOLOCK) RMI
		INNER JOIN [dbo].[UtilityCompany] (NOLOCK) UC
			ON RMI.UtilityCompanyId = UC.Id
		INNER JOIN [dbo].[RequestModeEnrollmentType] (NOLOCK) RMET
			ON RMI.RequestModeEnrollmentTypeId = RMET.Id
				AND RMET.EnumValue = 0
	WHERE
		DATEDIFF(S, RMI.[LastModifiedDate], @BeginDate) <= 0
		AND DATEDIFF(S, RMI.[LastModifiedDate], @EndDate) > 0
		
END