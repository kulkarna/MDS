
/*******************************************************************************
 * usp_InsertConsolidatedUsage
 * Inserts usage into the usage (consolidated) table
 *
 * History
 *		08/08/2011 (EP) - compensating for multiple meters..
 *		08/15/2011 (EP) - compensating for new usage type column added to EstimatedUsage
 *******************************************************************************
 * 12/02/2010 - Eduardo Patino
 * Created.
 *
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_InsertConsolidatedUsage]
	@AccountNumber			varchar(50),
	@UtilityCode			varchar(50),
	@UsageSource			int,
	@UsageType				int,
	@FromDate				datetime,
	@ToDate					datetime,
	@TotalKwh				int,
	@DaysUsed				int				= NULL,
	@MeterNumber			varchar(50)		= NULL,
	@OnPeakKwh				decimal(15,6)	= NULL,
	@OffPeakKwh				decimal(15,6)	= NULL,
	@BillingDemandKw		decimal(15,6)	= NULL,
	@MonthlyPeakDemandKw	decimal(15,6)	= NULL,
	@IntermediateKwh		decimal(15,6)	= NULL,
	@MonthlyOffPeakDemandKw	decimal(15,6)	= NULL,
	@modified				datetime		= NULL,
	@UserName				varchar(50),
	@active					smallint,
	@reasonCode				smallint		= NULL
AS
/*
select * from reasoncode
select * from sys.procedures where name = 'usp_InsertConsolidatedUsage'
select top 20 * from UsageConsolidated (nolock)

declare		@AccountNumber			varchar(50),
	@UtilityCode			varchar(50),
	@FromDate				datetime,
	@ToDate					datetime,
	@active					smallint,
	@UsageType				int,
	@TotalKwh				int,
	@MeterNumber			varchar(50)

set	@AccountNumber	= '4646383257'
set	@UtilityCode	= 'BGE'
set	@FromDate		= '2010-03-05'
set	@ToDate			= '2010-04-09'
set	@active			= 1
set	@UsageType		= 5
set	@TotalKwh		= 13600
set	@MeterNumber	= 'G000011476'
*/

BEGIN
    SET NOCOUNT ON;
	declare	@multipleMeter	smallint
--	select	@estimate = value from usagetype where description = 'Estimated'

	-- eliminate time component
	SET	@FromDate = CAST(DATEPART(mm, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @FromDate) AS varchar(4))
	SET	@ToDate = CAST(DATEPART(mm, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @ToDate) AS varchar(4))

	select @multipleMeter = multipleMeters from libertypower..utility WHERE utilityCode = @UtilityCode
	-- select @multipleMeter

IF @multipleMeter = 1 AND NOT EXISTS (
	SELECT	UtilityCode
	FROM	UsageConsolidated WITH (NOLOCK)
	WHERE	AccountNumber	= @AccountNumber
		AND	UtilityCode		= @UtilityCode
		AND	FromDate		= @FromDate
		AND	ToDate			= @ToDate
		AND	Active			= @Active
		AND	MeterNumber		= @MeterNumber )
	BEGIN
		-- - - - - - - - - - - - - - - - - - - - - - - - 
		print '' print '* ' + lp_historical_info.dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + ' INSERT INTO	UsageConsolidated [1]..'
		-- - - - - - - - - - - - - - - - - - - - - - - - 
		INSERT INTO	UsageConsolidated
					(AccountNumber, UtilityCode, FromDate, ToDate, TotalKwh, DaysUsed, MeterNumber, OnPeakKWH, IntermediateKwh,
					 OffPeakKWH, BillingDemandKW, MonthlyPeakDemandKW, MonthlyOffPeakDemandKw, Created, CreatedBy, UsageType, UsageSource,
					 modified, Active, ReasonCode)
		VALUES		(@AccountNumber, @UtilityCode, @FromDate, @ToDate, @TotalKwh, @DaysUsed, @MeterNumber, @OnPeakKWH, @IntermediateKwh,
					 @OffPeakKWH, @BillingDemandKW, @MonthlyPeakDemandKW, @MonthlyOffPeakDemandKw, getdate(), @UserName, @UsageType, @UsageSource,
					 @modified, @Active, @ReasonCode)
	END

IF @multipleMeter = 0 AND NOT EXISTS (
	SELECT	UtilityCode
	FROM	UsageConsolidated WITH (NOLOCK)
	WHERE	AccountNumber	= @AccountNumber
		AND	UtilityCode		= @UtilityCode
		AND	FromDate		= @FromDate
		AND	Active			= @Active
		AND	ToDate			= @ToDate )
	BEGIN
		-- - - - - - - - - - - - - - - - - - - - - - - - 
		print '' print '* ' + lp_historical_info.dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + ' INSERT INTO	UsageConsolidated [2]..'
		-- - - - - - - - - - - - - - - - - - - - - - - - 
		INSERT INTO	UsageConsolidated
					(AccountNumber, UtilityCode, FromDate, ToDate, TotalKwh, DaysUsed, MeterNumber, OnPeakKWH, IntermediateKwh,
					 OffPeakKWH, BillingDemandKW, MonthlyPeakDemandKW, MonthlyOffPeakDemandKw, Created, CreatedBy, UsageType, UsageSource,
					 modified, Active, ReasonCode)
		VALUES		(@AccountNumber, @UtilityCode, @FromDate, @ToDate, @TotalKwh, @DaysUsed, @MeterNumber, @OnPeakKWH, @IntermediateKwh,
					 @OffPeakKWH, @BillingDemandKW, @MonthlyPeakDemandKW, @MonthlyOffPeakDemandKw, getdate(), @UserName, @UsageType, @UsageSource,
					 @modified, @Active, @ReasonCode)
	END

IF @multipleMeter = 1
	BEGIN
		SELECT	ID, AccountNumber, UtilityCode, FromDate, ToDate, TotalKwh, DaysUsed, Created, CreatedBy, UsageType, UsageSource, Active, ReasonCode, MeterNumber
		FROM	UsageConsolidated WITH (NOLOCK)
		WHERE	AccountNumber	= @AccountNumber
			AND	UtilityCode		= @UtilityCode
			AND	FromDate		= @FromDate
			AND	ToDate			= @ToDate
--			AND	UsageType		= @UsageType
			AND	Active			= @Active
			AND	MeterNumber		= @MeterNumber
		ORDER BY 3 DESC
	END
ELSE
	BEGIN
		SELECT	ID, AccountNumber, UtilityCode, FromDate, ToDate, TotalKwh, DaysUsed, Created, CreatedBy, UsageType, UsageSource, Active, ReasonCode, MeterNumber
		FROM	UsageConsolidated WITH (NOLOCK)
		WHERE	AccountNumber	= @AccountNumber
			AND	UtilityCode		= @UtilityCode
			AND	FromDate		= @FromDate
			AND	ToDate			= @ToDate
--			AND	UsageType		= @UsageType
			AND	Active			= @Active
		ORDER BY 3 DESC
	END

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
			INNER JOIN OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType	-- <-- TODO: ask rick to point to the new table - 12/03/2010
			INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
			INNER JOIN OfferEngineDB..OE_ACCOUNT a  WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
	WHERE	a.ACCOUNT_NUMBER	= @AccountNumber
		AND	a.UTILITY			= @UtilityCode
	UNION
	SELECT	u.TotalKwh, u.FromDate, u.ToDate
	FROM	EstimatedUsage u WITH (NOLOCK)
			INNER JOIN OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType	-- <-- TODO: ask rick to point to the new table - 12/03/2010
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

