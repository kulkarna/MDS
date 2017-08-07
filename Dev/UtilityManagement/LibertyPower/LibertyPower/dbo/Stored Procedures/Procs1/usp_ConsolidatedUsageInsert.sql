
/*******************************************************************************
 * usp_ConsolidatedUsageInsert
 * Inserts usage into the usage (consolidated) table
 *
 * History
 *******************************************************************************
 * 12/30/2008 - Eduardo Patino
 * Created.
 *
 * Modified 6/8/2009 - Rick Deigsler
 * Update OE usage date
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ConsolidatedUsageInsert]
	@AccountNumber			varchar(50),
	@UtilityCode			varchar(50),
	@UsageSource			int,
	@UsageType				int,
	@FromDate				datetime		= NULL,
	@ToDate					datetime		= NULL,
	@TotalKwh				int				= NULL,
	@DaysUsed				int				= NULL,
	@MeterNumber			varchar(50)		= NULL,
	@OnPeakKwh				decimal(18,6)	= NULL,
	@OffPeakKwh				decimal(18,6)	= NULL,
	@BillingDemandKw		decimal(18,6)	= NULL,
	@MonthlyPeakDemandKw	decimal(18,6)	= NULL,
	@CurrentCharges			decimal(18,6)	= NULL,
	@transactionNumber		varchar(500)	= NULL,
	@modified				datetime		= NULL,
	@modifiedBy				varchar(50)		= NULL,
	@UserName				varchar(50)

AS
-- select top 20 * from usage (nolock)
BEGIN
    SET NOCOUNT ON;
    
	-- eliminate time component
	SET	@FromDate = CAST(DATEPART(mm, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @FromDate) AS varchar(4))
	SET	@ToDate = CAST(DATEPART(mm, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @ToDate) AS varchar(4))    

IF NOT EXISTS (
	SELECT	UtilityCode
	FROM	Usage WITH (NOLOCK)
	WHERE	AccountNumber	= @AccountNumber
		AND	UtilityCode		= @UtilityCode
		AND	FromDate		= @FromDate
		AND	ToDate			= @ToDate
		AND	TotalKwh		= @TotalKwh											-- 02/16/2009
		AND	UsageSource		= @UsageSource
		AND	UsageType		= @UsageType )

BEGIN
	INSERT INTO	Usage
				(AccountNumber, UtilityCode, FromDate, ToDate, TotalKwh, DaysUsed, MeterNumber, OnPeakKWH, TransactionNumber,
				OffPeakKWH, BillingDemandKW, MonthlyPeakDemandKW, CurrentCharges, Created, CreatedBy, UsageType, UsageSource,
				modified, modifiedBy)
	VALUES		(RTRIM(@AccountNumber), UPPER(RTRIM(@UtilityCode)), @FromDate, @ToDate, @TotalKwh, @DaysUsed, @MeterNumber, @OnPeakKwh, @transactionNumber,
				@OffPeakKwh, @BillingDemandKw, @MonthlyPeakDemandKw, @CurrentCharges, getdate(), @UserName, @UsageType, @UsageSource,
				@modified, @modifiedBy)
END

	SELECT	ID, AccountNumber, UtilityCode, FromDate, ToDate, TotalKwh, DaysUsed, MeterNumber, OnPeakKWH, TransactionNumber,
			OffPeakKWH, BillingDemandKW, MonthlyPeakDemandKW, CurrentCharges, Created, CreatedBy, UsageType, UsageSource
--	INTO	#METERREADS															-- per duggy, there are no invalids - 02/13/2009
	FROM	Usage WITH (NOLOCK)
	WHERE	AccountNumber	= @AccountNumber
		AND	UtilityCode		= @UtilityCode
		AND	FromDate		= @FromDate
		AND	ToDate			= @ToDate
		AND	TotalKwh		= @TotalKwh											-- 02/17/2009
		AND	UsageSource		= @UsageSource
		AND	UsageType		= @UsageType
	ORDER BY 3 DESC
	
	DECLARE @MaxDate		datetime,
			@AnnualUsage	bigint
	
	-- update usage date and annual usge in Offer Engine, if applicable
	SELECT	@MaxDate = MAX(ToDate)
	FROM	Usage WITH (NOLOCK)
	WHERE	AccountNumber	= @AccountNumber
	AND		UtilityCode		= @UtilityCode
	
	UPDATE	OfferEngineDB..OE_ACCOUNT
	SET		USAGE_DATE		= @MaxDate
	WHERE	ACCOUNT_NUMBER	= @AccountNumber
	AND		UTILITY			= @UtilityCode
	
	SELECT	@AnnualUsage = CAST((SUM(u.TotalKwh) * CAST(365 AS float) / CAST(SUM(DATEDIFF(dd, u.FromDate, u.ToDate)) AS float)) AS bigint)
	FROM	Usage u WITH (NOLOCK)
			INNER JOIN OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId
			INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
			INNER JOIN OfferEngineDB..OE_ACCOUNT a  WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
	WHERE	a.ACCOUNT_NUMBER	= @AccountNumber
	AND		a.UTILITY			= @UtilityCode	
	
	IF @AnnualUsage IS NOT NULL AND @AnnualUsage > 0
		BEGIN
			UPDATE	OfferEngineDB..OE_ACCOUNT
			SET		ANNUAL_USAGE	= @AnnualUsage
			WHERE	ACCOUNT_NUMBER	= @AccountNumber
			AND		UTILITY			= @UtilityCode	
		END	
	

--	DELETE FROM	#METERREADS WHERE TransactionNumber in (						-- per duggy, there are no invalids - 02/13/2009
--		SELECT	t2.TransactionNumber FROM #METERREADS t2
--		WHERE	#METERREADS.TransactionNumber = t2.TransactionNumber AND t2.usagetype = 6
--			AND #METERREADS.FromDate = t2.FromDate AND #METERREADS.ToDate = t2.ToDate)	-- per duggy - 01/07/09
--	DELETE FROM	#METERREADS WHERE usagetype IN (2, 6)							-- per duggy, there are no invalids - 02/13/2009

--	SELECT * FROM #METERREADS

	SET NOCOUNT OFF;
END
-- Copyright 2008 Liberty Power
