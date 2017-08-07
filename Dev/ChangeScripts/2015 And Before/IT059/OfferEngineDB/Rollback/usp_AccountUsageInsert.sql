USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountUsageInsert]    Script Date: 07/13/2013 14:03:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

	
/*******************************************************************************
 * usp_AccountUsageInsert
 * Insert usage for account
 *
 * History
 *******************************************************************************
 * 5/8/2009 - Rick Deigsler
 * Created.
 *
 * Modified 5/11/2010 - Rick Deigsler
 * Added voltage conversion for California utilities and rate class parameter
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_AccountUsageInsert]                                                                                     
	@AccountNumber	varchar(50),
	@UtilityCode	varchar(50),
	@FromDate		datetime,
	@ToDate			datetime,
	@TotalKwh		int,
	@DaysUsed		int,
	@MeterNumber	varchar(50),
	@MeterType		varchar(50) = '',
	@LoadProfile	varchar(50),
	@LoadShapeId	varchar(50),
	@Zone			varchar(50),
	@Voltage		varchar(50),
	@Icap			decimal(18,9),
	@Tcap			decimal(18,9),
	@Idr			varchar(50),
	@ZipCode		varchar(25),
	@UserName		varchar(50),
	@RateClass		varchar(50) = ''
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE	@AccountId		int,
			@VoltageTemp	varchar(20),
			@Today			datetime

	SELECT	@AccountId		= ID
	FROM	OE_ACCOUNT WITH (NOLOCK)
	WHERE	ACCOUNT_NUMBER	= @AccountNumber
	AND		UTILITY			= @UtilityCode	


	SET	@FromDate = CAST(DATEPART(mm, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @FromDate) AS varchar(4))
	SET	@ToDate = CAST(DATEPART(mm, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @ToDate) AS varchar(4))
	SET	@Today	= GETDATE()
	
	--Zone doesn't need to be updated as it overrides whatever zone we set when we inserted the account into the DB for the ERCOT accounts
	/*-- bandaid for new zip to zone
	SET	@Zone =	CASE	WHEN @Zone = 'HOUSTON' THEN 'HZ'
						WHEN @Zone = 'SOUTH' THEN 'SZ'
						WHEN @Zone = 'NORTH' THEN 'NZ'
						WHEN @Zone = 'WEST' THEN 'WZ'
						ELSE @Zone
				END
	*/
	-- O&R is always zone G
	IF @UtilityCode = 'O&R'
		SET	@Zone = 'G'
		
	IF @UtilityCode = 'PGE'
		BEGIN
			SET	@Zone = 'PGE'
			SET	@Voltage = CASE WHEN @Voltage = 'P' THEN 'Primary' WHEN @Voltage = 'T' THEN 'Transmission' ELSE 'Secondary' END
		END
		
	IF @UtilityCode = 'SCE'
		BEGIN
			SET	@Zone = 'SCE'
			SET	@VoltageTemp = REPLACE(@Voltage, ' V', '')
			IF ISNUMERIC(@VoltageTemp) = 1
				BEGIN
					IF CAST(@VoltageTemp AS int) < 2000
						SET	@Voltage = 'Secondary'
					IF CAST(@VoltageTemp AS int) BETWEEN 2000 AND 50000
						SET	@Voltage = 'Primary'
					IF CAST(@VoltageTemp AS int) > 50000
						SET	@Voltage = 'Sub Transmission'												
				END
		END
		
	IF @UtilityCode = 'SDGE'
		BEGIN
			SET	@Zone = 'SDGE'
			SET	@Voltage = CASE WHEN @Voltage = 'P' THEN 'Primary' WHEN @Voltage = 'T' THEN 'Transmission' WHEN @Voltage = 'Sub Trans' THEN 'Sub Transmission' ELSE 'Secondary' END
		END	
		
	IF LEN(@LoadProfile) > 0 AND LEN(@MeterType) = 0
			SET	@MeterType = CASE WHEN @LoadProfile = 'true' THEN 'IDR' ELSE 'NON-IDR' END		

	-- update account
	SET	@UtilityCode		= UPPER(@UtilityCode)
	SET	@Icap				= LTRIM(RTRIM(@Icap))
	SET	@Tcap				= LTRIM(RTRIM(@Tcap))
	SET	@LoadShapeId		= LTRIM(RTRIM(@LoadShapeId))
	SET	@Voltage			= LTRIM(RTRIM(@Voltage))
	SET	@Zone				= LTRIM(RTRIM(@Zone))
	SET	@MeterNumber		= LTRIM(RTRIM(REPLACE(@MeterNumber, '''', '')))
	SET	@RateClass			= LTRIM(RTRIM(@RateClass))
	SET	@LoadProfile		= LTRIM(RTRIM(@LoadProfile))

	UPDATE	OE_ACCOUNT
	SET		METER_TYPE		= CASE WHEN LEN(@MeterType) > 0					THEN @MeterType				ELSE METER_TYPE		END,
			ICAP			= CASE WHEN LEN(@Icap) > 0 AND @Icap <> -1		THEN @Icap					ELSE ICAP			END,
			TCAP			= CASE WHEN LEN(@Tcap) > 0 AND @Tcap <> -1		THEN @Tcap					ELSE TCAP			END,
			--LOAD_SHAPE_ID	= CASE WHEN LEN(@LoadShapeId) > 0				THEN UPPER(@LoadShapeId)	ELSE LOAD_SHAPE_ID	END,
			VOLTAGE			= CASE WHEN LEN(@Voltage) > 0					THEN UPPER(@Voltage)		ELSE VOLTAGE		END, 
			--Zone doesn't need to be updated as it overrides whatever zone we set when we inserted the account into the DB for the ERCOT accounts
			ZONE			= CASE WHEN MARKET <> 'TX' AND LEN(@Zone) > 0	THEN @Zone					ELSE ZONE			END,			
			RATE_CLASS		= CASE WHEN LEN(@RateClass) > 0					THEN @RateClass				ELSE RATE_CLASS		END,
			LOAD_PROFILE	= CASE WHEN LEN(@LoadProfile) > 0				THEN @LoadProfile			ELSE LOAD_PROFILE	END,
			NeedUsage	= 0
	WHERE	ID = @AccountId


	-- update zip
	IF EXISTS (SELECT NULL FROM OE_ACCOUNT_ADDRESS WITH (NOLOCK) WHERE OE_ACCOUNT_ID = @AccountId)
		UPDATE OE_ACCOUNT_ADDRESS SET ZIP = CASE WHEN LEN(LTRIM(RTRIM(@ZipCode))) > 0 THEN @ZipCode ELSE ZIP END WHERE OE_ACCOUNT_ID = @AccountId
	ELSE IF @AccountId IS NOT NULL
		INSERT INTO OE_ACCOUNT_ADDRESS (OE_ACCOUNT_ID, ACCOUNT_NUMBER, ZIP) VALUES (@AccountId, @AccountNumber, @ZipCode)

	-- insert usage		
	EXEC LibertyPower..usp_InsertConsolidatedUsage @AccountNumber = @AccountNumber, @UtilityCode = @UtilityCode, @UsageSource = 6, 
			@UsageType = 3, @FromDate = @FromDate, @ToDate = @ToDate, @TotalKwh = @TotalKwh, @DaysUsed = @DaysUsed, 
			@MeterNumber = @MeterNumber, @UserName = @UserName, @OnPeakKwh = NULL, @OffPeakKwh = NULL, @BillingDemandKw = NULL,
			@MonthlyPeakDemandKw = NULL, @IntermediateKwh = NULL, @MonthlyOffPeakDemandKw = NULL, @modified = @Today,
			@active = 1, @reasonCode = 4

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power


GO

