

/*******************************************************************************
 * [usp_DailyPricingUpdateLegacyRatesJobCall]
 * Starts a SQL job that updates Legacy rates from a staging table named
 * DailyPricingUpdateLegacyRates_Stage.
 *
 * History
 *******************************************************************************
 * 01/28/2011 - Alberto Franco - Created.
 *******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricingUpdateLegacyRatesJobCall]
AS
BEGIN
	EXEC msdb.dbo.sp_start_job @job_name = N'DailyPricingUpdateLegacyRates';
	
 --EXEC msdb.dbo.sp_start_job @job_name = N'DailyPricingUpdateLegacyRates_Job1';
 --EXEC msdb.dbo.sp_start_job @job_name = N'DailyPricingUpdateLegacyRates_Job2';
 --EXEC msdb.dbo.sp_start_job @job_name = N'DailyPricingUpdateLegacyRates_Job3';
 --EXEC msdb.dbo.sp_start_job @job_name = N'DailyPricingUpdateLegacyRates_Job4';
END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingUpdateLegacyRatesJobCall';

