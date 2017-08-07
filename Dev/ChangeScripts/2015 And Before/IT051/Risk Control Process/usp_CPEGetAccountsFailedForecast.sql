USE [lp_MtM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 11/04/2013
-- Description:	Get all daily accounts with Failed (forecast) status
-- =============================================
CREATE PROCEDURE usp_CPEGetDailyAccountsFailedForecast  
AS  
BEGIN 

	SET NOCOUNT ON;
	 
	SELECT i.AccountNumber,   
		i.ContractNumber,   
		i.UtilityCode,   
		m.AccountID,  
		m.ID AS MtMAccountID,  
		m.BatchNumber,  
		m.QuoteNumber,  
		i.StartDate as RateStartDate,   
		i.EndDate as RateEndDate,   
		la.MeterTypeID as MeterType,  
		m.LoadProfile,
		m.Zone,
		m.Status as "Status",  
		i.IsDaily  as isDaily  
	from MtMZainetAccountInfo i with (nolock)  
		inner join MtMAccount m with (nolock) on i.AccountID=m.AccountID and i.ContractID=m.ContractID  
		inner join LibertyPower..Account la with (nolock) on la.AccountID = m.AccountID  
		inner join MtMReportStatus rs with (nolock) on i.Status=rs.Status and i.SubStatus=rs.SubStatus ANd rs.Inactive=0  
	where isnull(i.BackToBack,0)=0  
		and  i.ZainetEndDate >= DATEADD(D, 0, DATEDIFF(D, 0, GETDATE()))  
		--and  i.IsDaily = 1  
		And  m.Status = 'Failed (Forecasting)'  
	order by i.IsDaily, m.MeterReadCount,m.AccountID 

	SET NOCOUNT OFF;
END  