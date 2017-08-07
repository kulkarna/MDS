

/*******************************************************************************
 * usp_GetConsolidatedUsage
 * retrieves usage from the consolidated usage table
 *
 * History
 *
 *******************************************************************************
 * 11/29/2010 - Eduardo Patino
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_GetConsolidatedUsage]
(
	@AccountNumber	varchar(50),
	@UtilityCode	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime
)
AS
/*
select 'UsageType', * from libertypower..usagetype
select 'UsageSource', * from libertypower..usagesource
select * from usageconsolidated where accountnumber = '6703762212' and fromdate >= '2008-05-01' and todate <= '2011-01-01'

exec libertypower..usp_GetConsolidatedUsage '6143848119', 'NIMO', '01/01/2009', '01/01/2011'

declare		@AccountNumber	varchar(50),
	@UtilityCode	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime
set	@AccountNumber = '10032789430152011'
set @UtilityCode = 'NIMO'
set @BeginDate = '01/01/2009'
set @EndDate = '01/01/2011'
*/

BEGIN
	SET NOCOUNT ON;

declare	@estimate int
select	@estimate = value from usagetype where description = 'Estimated'
--select	@estimate

--	note that i had to convert UT and US to int since they are defined as INTegers in the FWK
	SELECT	ID, AccountNumber, UtilityCode,
			CAST(CAST(DATEPART(mm, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, FromDate) AS varchar(4)) AS datetime) AS FromDate,
			CAST(CAST(DATEPART(mm, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, ToDate) AS varchar(4)) AS datetime) AS ToDate,
			TotalKwh, DaysUsed, Created, CreatedBy, convert (int, UsageType) UsageType, convert (int, UsageSource) UsageSource, Active, ReasonCode, MeterNumber
	FROM	UsageConsolidated (nolock)
	WHERE	accountnumber = @AccountNumber
		AND UtilityCode = @UtilityCode
		AND fromdate >= @BeginDate
		AND todate <= @EndDate
		AND UsageType <> @estimate
		AND	Active = 1
--		AND fromdate >= '2009-01-01' -- no 2008 usage
	ORDER BY fromdate DESC

	SET NOCOUNT OFF;
END

-- Copyright 2010 Liberty Power


