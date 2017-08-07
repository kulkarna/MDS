CREATE PROC usp_Chart_HistoricalUsageRequestModeParameters
AS
BEGIN

SELECT
	SUM(IsBillingAccountNumberRequired) AS IsBillingAccountNumberRequired,
	SUM(IsZipCodeRequired) AS IsZipCodeRequired,
	SUM(IsNameKeyRequired) AS IsNameKeyRequired,
	SUM(IsMdma) AS IsMdma,
	SUM(IsServiceProvider) AS IsServiceProvider
FROM
(
select 
	UC.UtilityCode, 
	CASE WHEN TSVIBANR.Value = 'Yes' THEN 1 ELSE 0 END AS IsBillingAccountNumberRequired,
	CASE WHEN TSVIZCR.Value = 'Yes' THEN 1 ELSE 0 END AS IsZipCodeRequired,
	CASE WHEN TSVINKR.Value = 'Yes' THEN 1 ELSE 0 END  AS IsNameKeyRequired,
	CASE WHEN TSVIM.Value = 'Yes' THEN 1 ELSE 0 END  AS IsMdma,
	CASE WHEN TSVISP.Value = 'Yes' THEN 1 ELSE 0 END AS IsServiceProvider
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
) A

END
GO
