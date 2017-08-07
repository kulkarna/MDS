
CREATE PROC [dbo].[usp_SynchronizationTables_GetByLastModifiedDate]
	@LastModifiedDate DATETIME

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
		,[BillingAccountPattern]
		,[BillingAccountPatternDescription]
		,[BillingAccountAddLeadingZero]
		,[BillingAccountTruncateLast]
		,[BillingAccountRequiredForEDIRequest]
		,[MeterNumberPattern]
		,[MeterNumberPatternDescription]
		,[MeterNumberAddLeadingZero]
		,[MeterNumberTruncateLast]
		,[MeterNumberRequiredForEdiRequest]
		,NKP.[NameKeyPattern]
		,NKP.[NameKeyPatternDescription]
		,NKP.[NameKeyAddLeadingZero]
		,NKP.[NameKeyTruncateLast]
		,NKP.[NameKeyRequiredForEDIRequest]
		,SAP.[ServiceAccountPattern]
		,SAP.[ServiceAccountPatternDescription]
		,SAP.[ServiceAccountAddLeadingZero]
		,SAP.[ServiceAccountTruncateLast]
		,SAP.[ServiceAccountRequiredForEDIRequest]
		,[ServiceAddressZipPattern]
		,[ServiceAddressZipPatternDescription]
		,[ServiceAddressZipAddLeadingZero]
		,[ServiceAddressZipTruncateLast]
		,[ServiceAddressZipRequiredForEDIRequest]
		,SP.[StrataPattern]
		,SP.[StrataPatternDescription]
		,SP.[StrataAddLeadingZero]
		,SP.[StrataTruncateLast]
		,SP.[StrataRequiredForEdiRequest]
		,[ICapNextRefresh]
		,[ICapEffectiveDate]
		,[TCapNextRefresh]
		,[TCapEffectiveDate]
		,RMI.RequestCostAccount AS IdrRequestCostPerAccount
		,RMHU.UtilitysSlaHistoricalUsageResponseInDays 
		,RMHU.LibertyPowersSlaFollowUpHistoricalUsageResponseInDays
		,RMIC.UtilitysSlaIcapResponseInDays
		,RMIC.LibertyPowersSlaFollowUpIcapResponseInDays
		,RMI.UtilitysSlaIdrResponseInDays
		,RMI.LibertyPowersSlaFollowUpIdrResponseInDays
		,(SELECT MAX(LastModifiedDate) FROM 
			(
				SELECT BAP.LastModifiedDate UNION
				SELECT MNP.LastModifiedDate UNION
				SELECT NKP.LastModifiedDate UNION
				SELECT SAP.LastModifiedDate UNION
				SELECT SAZP.LastModifiedDate UNION
				SELECT SP.LastModifiedDate UNION
				SELECT ICTCR.LastModifiedDate UNION
				SELECT RMI.LastModifiedDate UNION
				SELECT RMHU.LastModifiedDate UNION
				SELECT RMIC.LastModifiedDate
			) A
		)	AS LastModifiedDate			
  FROM 
		UtilityCompany (NOLOCK) UC
		LEFT OUTER JOIN [dbo].[BillingAccountPattern] (NOLOCK) BAP
			ON BAP.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN [dbo].[MeterNumberPattern] (NOLOCK) MNP
			ON MNP.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN [dbo].[NameKeyPattern] (NOLOCK) NKP 
			ON NKP.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN [dbo].[ServiceAccountPattern] (NOLOCK) SAP
			ON SAP.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN [dbo].[ServiceAddressZipPattern] (NOLOCK) SAZP
			ON SAZP.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN [dbo].[StrataPattern] (NOLOCK) SP
			ON SP.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN [dbo].[ICapTCapRefresh] (NOLOCK) ICTCR
			ON ICTCR.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN [dbo].[RequestModeIdr] (NOLOCK) RMI
			ON RMI.UtilityCompanyId = UC.Id
			AND RMI.RequestModeEnrollmentTypeId = @RequestModeEnrollmentTypeId
		LEFT OUTER JOIN [dbo].[RequestModeHistoricalUsage] (NOLOCK) RMHU
			ON UC.Id = RMHU.UtilityCompanyId
			AND RMHU.RequestModeEnrollmentTypeId = @RequestModeEnrollmentTypeId
		LEFT OUTER JOIN [dbo].[RequestModeIcap] (NOLOCK) RMIC
			ON UC.Id = RMIC.UtilityCompanyId
			AND RMIC.RequestModeEnrollmentTypeId = @RequestModeEnrollmentTypeId
		LEFT OUTER JOIN [dbo].[Market] (NOLOCK) M
			ON UC.MarketId = M.Id
		LEFT OUTER JOIN [dbo].ISO (NOLOCK) I
			ON UC.IsoId = I.Id
		LEFT OUTER JOIN [dbo].[TriStateValuePendingActiveInactive] (NOLOCK) TSV
			ON UC.UtilityStatusId = TSV.Id
	WHERE
		DATEDIFF(S, BAP.[LastModifiedDate], @LastModifiedDate) <= 0
		OR DATEDIFF(S, MNP.[LastModifiedDate], @LastModifiedDate) <= 0
		OR DATEDIFF(S, NKP.[LastModifiedDate], @LastModifiedDate) <= 0
		OR DATEDIFF(S, SAP.[LastModifiedDate], @LastModifiedDate) <= 0
		OR DATEDIFF(S, SAZP.[LastModifiedDate], @LastModifiedDate) <= 0
		OR DATEDIFF(S, SP.[LastModifiedDate], @LastModifiedDate) <= 0
		OR DATEDIFF(S, ICTCR.[LastModifiedDate], @LastModifiedDate) <= 0
		OR DATEDIFF(S, RMI.[LastModifiedDate], @LastModifiedDate) <= 0
		OR (DATEDIFF(S, RMHU.[LastModifiedDate], @LastModifiedDate) <= 0
		OR DATEDIFF(S, RMIC.[LastModifiedDate], @LastModifiedDate) <= 0
		)
	ORDER BY
		UC.UtilityCode
				
END