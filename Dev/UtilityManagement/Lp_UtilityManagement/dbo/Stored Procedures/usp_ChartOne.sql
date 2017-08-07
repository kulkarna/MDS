CREATE Proc [dbo].[usp_ChartOne]
AS BEGIN
select 
	uc.UtilityCode + ' ' + rmet.Name + ' ' + rmt.Name AS UtilCodeEnrolAndMode,
	rmi.UtilitysSlaIdrResponseInDays
from
	RequestModeIdr (NOLOCK) rmi
	inner join UtilityCompany (NOLOCK) uc
		on rmi.UtilityCompanyId = uc.Id
	inner join RequestModeEnrollmentType (NOLOCK) rmet 
		on rmi.RequestModeEnrollmentTypeId = rmet.Id
	inner join RequestModeType (NOLOCK) rmt
		on rmi.RequestModeTypeId = rmt.id
order by 
	uc.UtilityCode,
	rmet.Name,
	rmt.Name
END
GO
