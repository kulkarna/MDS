USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetConsolidatedUsage]    Script Date: 11/5/2015 2:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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
 * 11/05/2015 - Manoj
 * PBI: 95994: Usage consolidation issue with same account with multiple utilities
				Added join with utility table
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_GetConsolidatedUsage]
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
	SELECT	a.ID AS ID, a.AccountNumber as AccountNumber , a.UtilityCode,
			CAST(CAST(DATEPART(mm, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, FromDate) AS varchar(4)) AS datetime) AS FromDate,
			CAST(CAST(DATEPART(mm, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, ToDate) AS varchar(4)) AS datetime) AS ToDate,
			TotalKwh, DaysUsed, Created, a.CreatedBy as CreatedBy, convert (int, UsageType) UsageType, convert (int, UsageSource) UsageSource, a.Active, ReasonCode, MeterNumber
	FROM	UsageConsolidated (nolock) a
	INNER JOIN libertyPower..Utility(NOLOCK) b
	ON a.UtilityCode = b.UtilityCode
	INNER JOIN Account(NOLOCK) c on a.AccountNumber = c.AccountNumber and c.utilityid = b.id
	inner join MeterType(NOLOCK)d  on c.MeterTypeID = d.ID
	WHERE	a.accountnumber = @AccountNumber
		AND a.UtilityCode = @UtilityCode
		AND fromdate >= @BeginDate
		AND todate <= @EndDate
		AND UsageType <> @estimate
		AND	a.Active = 1
		AND d.ID <> 1
--		AND fromdate >= '2009-01-01' -- no 2008 usage
	ORDER BY fromdate DESC

	SET NOCOUNT OFF;
END

-- Copyright 2010 Liberty Power


