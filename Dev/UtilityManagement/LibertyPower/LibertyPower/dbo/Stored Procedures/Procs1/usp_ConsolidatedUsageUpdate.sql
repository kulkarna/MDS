
/*******************************************************************************
 * usp_ConsolidatedUsageUpdate
 * Update meter read record for one record
 *
 *******************************************************************************
 * 01/30/2009 - Eduardo Patino
 * Created.
 *
 * Modified 6/8/2009 - Rick Deigsler
 * Update OE usage date 
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ConsolidatedUsageUpdate]
	@ID						bigint,
	@AccountNumber			varchar(50),
	@UtilityCode			varchar(50),
	@UsageSource			int,
	@UsageType				int,
	@FromDate				datetime,
	@ToDate					datetime,
	@TotalKwh				int,
	@DaysUsed				int,
	@MeterNumber			varchar(50),
	@OnPeakKwh				decimal(12,6),
	@OffPeakKwh				decimal(12,6),
	@BillingDemandKw		decimal(12,6),
	@MonthlyPeakDemandKw	decimal(12,6),
	@CurrentCharges			decimal(12,6),
	@transactionNumber		varchar(500),
	@modified				datetime,
	@modifiedBy				varchar(50)

AS
BEGIN
    SET NOCOUNT ON;
    
	-- eliminate time component
	SET	@FromDate = CAST(DATEPART(mm, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @FromDate) AS varchar(4))
	SET	@ToDate = CAST(DATEPART(mm, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @ToDate) AS varchar(4))    

	UPDATE	Usage
	SET		AccountNumber = @AccountNumber,
			UtilityCode = @UtilityCode,
			FromDate = @FromDate,
			ToDate = @ToDate,
			TotalKwh = @TotalKwh,
			DaysUsed = @DaysUsed,
			MeterNumber = @MeterNumber,
			OnPeakKWH = @OnPeakKwh,
			OffPeakKWH = @OffPeakKwh,
			TransactionNumber = @transactionNumber,
			BillingDemandKW = @BillingDemandKw,
			MonthlyPeakDemandKW = @MonthlyPeakDemandKw,
			CurrentCharges = @CurrentCharges,
			UsageType = @UsageType,
			UsageSource = @UsageSource,
			Modified = @Modified,
			ModifiedBy = @ModifiedBy
	WHERE	ID = @ID

	SELECT	ID, AccountNumber, UtilityCode, FromDate, ToDate, TotalKwh, DaysUsed, MeterNumber, OnPeakKWH, TransactionNumber,
			OffPeakKWH, BillingDemandKW, MonthlyPeakDemandKW, CurrentCharges, Created, CreatedBy, UsageType, UsageSource
	FROM	Usage WITH (NOLOCK)
	WHERE	ID = @ID
	
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

	SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power
