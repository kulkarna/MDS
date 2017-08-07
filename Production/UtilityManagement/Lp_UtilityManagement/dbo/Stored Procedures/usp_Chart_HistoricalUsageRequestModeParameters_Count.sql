CREATE PROC [dbo].[usp_Chart_HistoricalUsageRequestModeParameters_Count]
AS
BEGIN

SELECT
	UtilityCode,
	SUM(IsBillingAccountNumberRequired) + SUM(IsZipCodeRequired) + SUM(IsNameKeyRequired) + SUM(IsMdma) + SUM(IsServiceProvider) +
	SUM(IsMeterInstallerId) + SUM(IsMeterReaderId) + SUM(IsMeterOwnerId) + SUM(IsSchedulingCoordinatorId) + SUM(HasReferenceNumberId) + SUM(HasCustomerNumberId) + SUM(HasPodIdNumberId) + SUM(HasMeterTypeId) + SUM(IsMeterNumberRequiredId)
	AS RequiredFieldCount
FROM
(
select 
	UC.UtilityCode, 
	CASE WHEN TSVIBANR.Value = 'Yes' THEN 1 ELSE 0 END AS IsBillingAccountNumberRequired,
	CASE WHEN TSVIZCR.Value = 'Yes' THEN 1 ELSE 0 END AS IsZipCodeRequired,
	CASE WHEN TSVINKR.Value = 'Yes' THEN 1 ELSE 0 END  AS IsNameKeyRequired,
	CASE WHEN TSVIM.Value = 'Yes' THEN 1 ELSE 0 END  AS IsMdma,
	CASE WHEN TSVISP.Value = 'Yes' THEN 1 ELSE 0 END AS IsServiceProvider,
	CASE WHEN TSVIMI.Value = 'Yes' THEN 1 ELSE 0 END AS IsMeterInstallerId,
	CASE WHEN TSVIMR.Value = 'Yes' THEN 1 ELSE 0 END AS IsMeterReaderId,
	CASE WHEN TSVIMO.Value = 'Yes' THEN 1 ELSE 0 END AS IsMeterOwnerId,
	CASE WHEN TSVISC.Value = 'Yes' THEN 1 ELSE 0 END AS IsSchedulingCoordinatorId,
	CASE WHEN TSVHRN.Value = 'Yes' THEN 1 ELSE 0 END AS HasReferenceNumberId,
	CASE WHEN TSVHCN.Value = 'Yes' THEN 1 ELSE 0 END AS HasCustomerNumberId,
	CASE WHEN TSVHPIN.Value = 'Yes' THEN 1 ELSE 0 END AS HasPodIdNumberId,
	CASE WHEN TSVHMT.Value = 'Yes' THEN 1 ELSE 0 END AS HasMeterTypeId,
	CASE WHEN TSVIMNR.Value = 'Yes' THEN 1 ELSE 0 END AS IsMeterNumberRequiredId
from 
	dbo.RequestModeHistoricalUsageParameter (NOLOCK) RMHUP
	INNER JOIN dbo.UtilityCompany (NOLOCK) UC 
		ON RMHUP.UtilityCompanyId = UC.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVIBANR
		ON RMHUP.IsBillingAccountNumberRequiredId = TSVIBANR.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVIZCR
		ON RMHUP.IsZipCodeRequiredId = TSVIZCR.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVINKR
		ON RMHUP.IsNameKeyRequiredId = TSVINKR.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVIM
		ON RMHUP.IsMdmaId = TSVIM.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVISP
		ON RMHUP.IsServiceProviderId = TSVISP.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVIMI
		ON RMHUP.IsMeterInstallerId = TSVIMI.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVIMR
		ON RMHUP.IsMeterReaderId = TSVIMR.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVIMO
		ON RMHUP.IsMeterOwnerId = TSVIMO.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVISC
		ON RMHUP.IsSchedulingCoordinatorId = TSVISC.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVHRN
		ON RMHUP.HasReferenceNumberId = TSVHRN.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVHCN
		ON RMHUP.HasCustomerNumberId = TSVHCN.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVHPIN
		ON RMHUP.HasPodIdNumberId = TSVHPIN.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVHMT
		ON RMHUP.HasMeterTypeId = TSVHMT.Id
	INNER JOIN dbo.TriStateValue (NOLOCK) TSVIMNR
		ON RMHUP.IsMeterNumberRequiredId = TSVIMNR.Id
) A
GROUP BY UtilityCode
ORDER BY SUM(IsBillingAccountNumberRequired) + SUM(IsZipCodeRequired) + SUM(IsNameKeyRequired) + SUM(IsMdma) + SUM(IsServiceProvider) +
	SUM(IsMeterInstallerId) + SUM(IsMeterReaderId) + SUM(IsMeterOwnerId) + SUM(IsSchedulingCoordinatorId) + SUM(HasReferenceNumberId) + SUM(HasCustomerNumberId) + SUM(HasPodIdNumberId) + SUM(HasMeterTypeId) + SUM(IsMeterNumberRequiredId) DESC

END