
/*******************************************************************************
 * usp_GetAccountUsage
 * retrieves usage from the usage table
 *
 * History
 * 12/23/2008 - added begin/end date parameters per code review meeting
 * 01/30/2009 - added InvalidCancel parameter in order to retrieve invalid and canceled
 *			records (for merge functionality)
 * 02/23/2009 - since we're filling "external" gaps (i.e. gaps where usage is less than 1
 *			 year) we'll probably end up with a bunch of small (invalid) estimated usage
 * 03/05/2010 - ticket 14032 - added @UtilityCode
 * 05/04/2011 - IT022 - added @estimate
 *******************************************************************************
 * 12/05/2008 - Eduardo Patino (fcm)
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_GetAccountUsage]
(
	@AccountNumber	varchar(50),
	@UtilityCode	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime,
	@InvalidCancel	varchar(1) = '0'
--	@Source			varchar(40)
)
AS
/*
select * from usage where accountnumber = '696041102211111' and fromdate >= '2007-05-01' and todate <= '2008-05-01'
select * from usage where accountnumber = '696041102211111' and todate >= '2007-05-01' and todate <= '2008-05-01'

exec libertypower..usp_GetAccountUsage '10032789405389768', 'AEPCE', '1/1/05', '1/1/09', '0'

declare		@AccountNumber	varchar(50),
	@GoBackOne		varchar(10),
	@Source			varchar(20)
set	@AccountNumber = '10032789430152011'
set @GoBackOne = 'false'
set @Source = 'Ista'
*/

BEGIN
	SET NOCOUNT ON;

declare	@estimate int
select	@estimate = value from usagetype where description = 'Estimated'

IF @InvalidCancel = '0'
  BEGIN
--		SELECT * FROM usage ORDER BY fromdate DESC
	SELECT	ID, AccountNumber, UtilityCode,
			CAST(CAST(DATEPART(mm, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, FromDate) AS varchar(4)) AS datetime) AS FromDate,
			CAST(CAST(DATEPART(mm, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, ToDate) AS varchar(4)) AS datetime) AS ToDate,
			TotalKwh, DaysUsed, MeterNumber, OnPeakKWH, TransactionNumber,
			OffPeakKWH, BillingDemandKW, MonthlyPeakDemandKW, CurrentCharges, Created, CreatedBy, UsageType, UsageSource
	INTO	#METERREADS
	FROM	usage (nolock)
	WHERE	accountnumber = @AccountNumber
		AND UtilityCode = @UtilityCode
		AND todate >= @BeginDate
		AND todate <= @EndDate
		AND UsageType <> @estimate
		AND fromdate >= '2009-01-01' -- no 2008 usage													
--		AND usagetype <> 2	-- Invalid											-- per duggy, there are no cancels - 02/16/2009
--		AND fromdate >= (select dateadd(MM, -13, max(fromdate)) from usage (nolock) where accountnumber = @AccountNumber)
	ORDER BY fromdate DESC

	DELETE FROM	#METERREADS WHERE TransactionNumber in (						-- 01/07/2009
		SELECT	t2.TransactionNumber FROM #METERREADS t2
		WHERE	#METERREADS.TransactionNumber = t2.TransactionNumber --AND t2.usagetype = 6
			AND #METERREADS.FromDate = t2.FromDate AND #METERREADS.ToDate = t2.ToDate)	-- per duggy - 01/07/09
	DELETE FROM	#METERREADS WHERE usagetype IN (0)								-- Invalid, Canceled

	SELECT * FROM #METERREADS
	ORDER BY FromDate DESC
  END
ELSE
  BEGIN
	SELECT	ID, AccountNumber, UtilityCode,
			CAST(CAST(DATEPART(mm, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, FromDate) AS varchar(4)) AS datetime) AS FromDate,
			CAST(CAST(DATEPART(mm, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, ToDate) AS varchar(4)) AS datetime) AS ToDate,
			TotalKwh, DaysUsed, MeterNumber, OnPeakKWH, TransactionNumber,
			OffPeakKWH, BillingDemandKW, MonthlyPeakDemandKW, CurrentCharges, Created, CreatedBy, UsageType, UsageSource
	INTO	#METERREADS2
	FROM	usage (nolock)
	WHERE	accountnumber = @AccountNumber
		AND UtilityCode = @UtilityCode
		AND todate >= @BeginDate
		AND todate <= @EndDate
		AND UsageType <> @estimate
		AND fromdate >= '2009-01-01' -- no 2008 usage													
	ORDER BY fromdate DESC

	SELECT * FROM #METERREADS2
	ORDER BY FromDate DESC
  END

	SET NOCOUNT OFF;
END
-- Copyright 2008 Liberty Power

