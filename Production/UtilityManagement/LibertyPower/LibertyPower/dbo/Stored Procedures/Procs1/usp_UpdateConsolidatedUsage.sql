
/*******************************************************************************
 * usp_UpdateConsolidatedUsage
 * Update meter read record for one record
 *
 * History
 *		04/04/2012 (EP) - latest copy of production..
 *		04/05/2012 (EP) - checking whether the new invalidated record is already in the table..
 *		11/20/2012 1-38306611 - Providing permanent solution to duplicate key error message
 *******************************************************************************
 * 12/03/2010 - Eduardo Patino
 * Created.
 *
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_UpdateConsolidatedUsage]
	@ID						bigint,
	@AccountNumber			varchar(50),
	@UtilityCode			varchar(50),
	@UsageSource			int,
	@UsageType				int,
	@FromDate				datetime,
	@ToDate					datetime,
	@TotalKwh				int,
	@DaysUsed				int,
	@MeterNumber			varchar(50)		= NULL,
	@OnPeakKwh				decimal(15,6)	= NULL,
	@OffPeakKwh				decimal(15,6)	= NULL,
	@BillingDemandKw		decimal(15,6)	= NULL,
	@MonthlyPeakDemandKw	decimal(15,6)	= NULL,
	@IntermediateKwh		decimal(15,6)	= NULL,
	@MonthlyOffPeakDemandKw	decimal(15,6)	= NULL,
	@modified				datetime,
	@active					smallint,
	@reasonCode				smallint

AS
/*
select * from sys.procedures where name = 'usp_UpdateConsolidatedUsage'
select * from UsageConsolidated (nolock) where accountnumber = '627882002' order by 6 desc

declare	@ID						bigint,
	@AccountNumber			varchar(50),
	@UtilityCode			varchar(50),
	@UsageSource			int,
	@UsageType				int,
	@FromDate				datetime,
	@ToDate					datetime,
	@TotalKwh				int,
	@DaysUsed				int,
	@active					smallint,
	@reasonCode				smallint
set	@ID						= 15184631
set	@AccountNumber			= '3640252047'
set	@UtilityCode			= 'COMED'
set	@UsageSource			= 0
set	@UsageType				= 1
set	@FromDate				= '12/14/2011'
set	@ToDate					= '1/18/2012'
set	@TotalKwh				= 2683
set	@DaysUsed				= 36
set	@active					= 0
set	@reasonCode				= 10

*/

BEGIN
	SET NOCOUNT ON;

--	declare	@estimate	smallint
--	select	@estimate = value from usagetype where description = 'Estimated'

	-- eliminate time component
	SET	@FromDate = CAST(DATEPART(mm, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @FromDate) AS varchar(4))
	SET	@ToDate = CAST(DATEPART(mm, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @ToDate) AS varchar(4))    

	DECLARE	@ID2	BIGINT

	SELECT	@ID2 = ID
	FROM	UsageConsolidated (NOLOCK)
	WHERE	AccountNumber	= @AccountNumber
		AND	UtilityCode		= @UtilityCode
		AND	FromDate		= @FromDate
		AND	ToDate			= @ToDate
--		AND	TotalKwh		= @TotalKwh
		AND	UsageType		= @UsageType
		AND	UsageSource		= @UsageSource
		AND	active			= 0
-- select accountnumber, 'inserted from usp_UpdateConsolidatedUsage', ID, UtilityCode, AccountNumber, UsageType, UsageSource, FromDate, ToDate, TotalKwh, DaysUsed, Created, CreatedBy, getdate() Modified, Active, ReasonCode, MeterNumber from UsageConsolidated where id = @ID

	IF @ID2 IS NOT NULL AND @active = 0		-- record already exists
	  BEGIN
		insert into Workspace..UsageCleanup select accountnumber, 'inserted from usp_UpdateConsolidatedUsage', ID, UtilityCode, AccountNumber, UsageType, UsageSource, FromDate, ToDate, TotalKwh, DaysUsed, Created, CreatedBy, getdate() Modified, Active, ReasonCode, MeterNumber from UsageConsolidated (NOLOCK) where id = @ID
		DELETE FROM UsageConsolidated WHERE ID = @ID
		SET @ID = @ID2
	  END
	ELSE
	  BEGIN
		UPDATE	UsageConsolidated
		SET		AccountNumber	= @AccountNumber,
				UtilityCode		= @UtilityCode,
				FromDate		= @FromDate,
				ToDate			= @ToDate,
				TotalKwh		= @TotalKwh,
				DaysUsed		= @DaysUsed,
				MeterNumber		= @MeterNumber,
				OnPeakKWH		= @OnPeakKwh,
				OffPeakKWH		= @OffPeakKwh,
				IntermediateKwh = @IntermediateKwh,
				BillingDemandKW	= @BillingDemandKw,
				MonthlyPeakDemandKW	= @MonthlyPeakDemandKw,
				MonthlyOffPeakDemandKw	= @MonthlyOffPeakDemandKw,
				UsageType		= @UsageType,
				UsageSource		= @UsageSource,
				Modified		= @Modified,
				active			= @active,
				reasonCode		= @reasonCode
		WHERE	ID				= @ID
	  END

	UPDATE	OfferUsageMapping
	SET		UsageType		= @UsageType
	WHERE	UsageId			= @ID

	SELECT	ID, AccountNumber, UtilityCode, UsageType, UsageSource, FromDate, ToDate, TotalKwh, DaysUsed, MeterNumber, OnPeakKWH, IntermediateKwh,
			OffPeakKWH, BillingDemandKW, MonthlyPeakDemandKW, MonthlyOffPeakDemandKw, Created, CreatedBy, Active, ReasonCode
	FROM	UsageConsolidated WITH (NOLOCK)
	WHERE	ID = @ID

	DECLARE @MaxDate		datetime,
			@AnnualUsage	bigint

	-- update usage date and annual usge in Offer Engine, if applicable
	SELECT	@MaxDate = MAX(ToDate)
	FROM	UsageConsolidated WITH (NOLOCK)
	WHERE	AccountNumber	= @AccountNumber
		AND	UtilityCode		= @UtilityCode

	UPDATE	OfferEngineDB..OE_ACCOUNT
	SET		USAGE_DATE		= @MaxDate
	WHERE	ACCOUNT_NUMBER	= @AccountNumber
		AND	UTILITY			= @UtilityCode	

	CREATE	TABLE #staging (TotalKwh int, FromDate datetime, ToDate datetime)
	insert into #staging
	SELECT	u.TotalKwh, u.FromDate, u.ToDate
	FROM	UsageConsolidated u WITH (NOLOCK)
			INNER JOIN OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
			INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
			INNER JOIN OfferEngineDB..OE_ACCOUNT a  WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
	WHERE	a.ACCOUNT_NUMBER	= @AccountNumber
		AND	a.UTILITY			= @UtilityCode	
	UNION
	SELECT	u.TotalKwh, u.FromDate, u.ToDate
	FROM	EstimatedUsage u WITH (NOLOCK)
			INNER JOIN OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
			INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
			INNER JOIN OfferEngineDB..OE_ACCOUNT a  WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
	WHERE	a.ACCOUNT_NUMBER	= @AccountNumber
		AND	a.UTILITY			= @UtilityCode
--		AND	m.UsageType			= @estimate

	SELECT	@AnnualUsage = CAST((SUM(TotalKwh) * CAST(365 AS float) / 
			CASE WHEN CAST(SUM(DATEDIFF(dd, FromDate, ToDate)) AS float) = 0 THEN 1 ELSE CAST(SUM(DATEDIFF(dd, FromDate, ToDate)) AS float) END) AS bigint)
	FROM	#staging

	IF @AnnualUsage IS NOT NULL AND @AnnualUsage > 0
		BEGIN
			UPDATE	OfferEngineDB..OE_ACCOUNT
			SET		ANNUAL_USAGE	= @AnnualUsage
			WHERE	ACCOUNT_NUMBER	= @AccountNumber
				AND	UTILITY			= @UtilityCode	
		END

	SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

