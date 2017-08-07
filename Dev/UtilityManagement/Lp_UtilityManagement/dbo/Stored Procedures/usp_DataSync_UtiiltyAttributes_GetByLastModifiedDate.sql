

CREATE PROC [dbo].[usp_DataSync_UtiiltyAttributes_GetByLastModifiedDate]
	@BeginDate DATETIME,
	@EndDate DATETIME
AS
BEGIN

	--DECLARE @LastModifiedDate DATETIME
	--SET @LastModifiedDate = '1/1/2013'

	DECLARE @RequestModeEnrollmentTypeId AS UNIQUEIDENTIFIER
	SELECT
		@RequestModeEnrollmentTypeId = ID
	FROM
		dbo.RequestModeEnrollmentType (NOLOCK) RMET
	WHERE
		EnumValue = 0

	SELECT 
		UC.UtilityIdInt AS UtilityId
		,UC.UtilityCode 
		,UC.[FullName] 
		,I.NAME AS IsoName
		,M.Market
		,UC.[PrimaryDunsNumber] 
		,UC.[LpEntityId] 
		,UC.[SalesForceId] 
		,TSV.[Value] 
		,UC.LastModifiedDate
  FROM 
		UtilityCompany (NOLOCK) UC
		LEFT OUTER JOIN [dbo].[Market] (NOLOCK) M
			ON UC.MarketId = M.Id
		LEFT OUTER JOIN [dbo].ISO (NOLOCK) I
			ON UC.IsoId = I.Id
		LEFT OUTER JOIN [dbo].[TriStateValuePendingActiveInactive] (NOLOCK) TSV
			ON UC.UtilityStatusId = TSV.Id
	WHERE
		DATEDIFF(S, UC.[LastModifiedDate], @BeginDate) <= 0
		AND DATEDIFF(S, UC.[LastModifiedDate], @EndDate) > 0
	ORDER BY
		UC.UtilityCode
				
END