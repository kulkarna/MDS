
/*******************************************************************************
 * usp_ForecastMonthlyUsageDetailInsert
 * Insert forecast usage header record
 *
 * History
 *
 * 12/07/2010 - refactored TransactionNumber out of the Usage class since it's
 *		an Ista field (obsolete) + is not being saved in this table - IT022
 *
 *******************************************************************************
 * 04/01/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_ForecastMonthlyUsageDetailInsert]
	@MonthlyUsageId			int,
	@AccountNumber			varchar(50),
	@UtilityCode			varchar(50),
	@UsageSource			int,
	@UsageType				int,
	@FromDate				datetime,
	@ToDate					datetime,
	@TotalKwh				int,
	@DaysUsed				int,
	@Created				datetime		= NULL,
	@CreatedBy				varchar(50)		= NULL,
	@Modified				datetime		= NULL,
	@ModifiedBy				varchar(50)		= NULL,
	@MeterNumber			varchar(50)		= NULL,
	@OnPeakKwh				decimal(20,6)	= NULL,
	@OffPeakKwh				decimal(20,6)	= NULL,
	@BillingDemandKw		decimal(20,6)	= NULL,
	@MonthlyPeakDemandKw	decimal(20,6)	= NULL,
	@CurrentCharges			decimal(20,6)	= NULL,
	@Comments				varchar(1000)	= NULL,
--	@TransactionNumber		varchar(500)	= NULL,
	@TdspCharges			decimal(20,6)	= NULL,
	@UsageId				int,
	@IsConsolidated			tinyint
AS

BEGIN
-- select distinct TransactionNumber from ForecastMonthlyUsageDetail (nolock)
    SET NOCOUNT ON;

	INSERT INTO ForecastMonthlyUsageDetail (MonthlyUsageId, UtilityCode, AccountNumber,
				UsageType, UsageSource, FromDate, ToDate, TotalKwh, DaysUsed, Created,
				CreatedBy, Modified, ModifiedBy, MeterNumber, OnPeakKWh, OffPeakKWh,
				BillingDemandKW, MonthlyPeakDemandKW, CurrentCharges, Comments,
				TdspCharges, UsageId, IsConsolidated)
	VALUES		(@MonthlyUsageId, @UtilityCode, @AccountNumber, @UsageType, @UsageSource,
				@FromDate, @ToDate, @TotalKwh, @DaysUsed, @Created, @CreatedBy, @Modified,
				@ModifiedBy, @MeterNumber, @OnPeakKwh, @OffPeakKwh, @BillingDemandKw, @MonthlyPeakDemandKw,
				@CurrentCharges, @Comments, @TdspCharges, @UsageId, @IsConsolidated)

	SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power

