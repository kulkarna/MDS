USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_EdiAccountInsert]    Script Date: 07/30/2015 04:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_EdiAccountInsert
 * Insert account from EDI file
 *
 * History
 * 06/25/2010 - added extra 814 columns - Eduardo Patino
 * 08/30/2010 - added code to retrieve default zones for utilities that don't
 *		have zones (i.e. to update OE) - Eduardo Patino
 * 09/20/2010 - concatenate rate class and load profile for PECO (SD 18359)
 * 09/21/2010 - ordered parameters alphabetically + added meter number (ticket
 *		18280) - Eduardo Patino
 *
 * 11/15/2010 - Rick Deigsler
 *		SD 19685 - Update NSTAR utility code in OE to match EDI file
 *
 * 12/23/2010 - Rick Deigsler
 *		SD 19762 - Added load shape id and account type
 * 08/08/2011 -	Eduardo Patino - per D, removed SD 19685 code + if @LoadShapeId
 *		== null then i'm grabbing the value from the @LoadProfile variable
 * 12/30/2011 - ? - commented out update to LOAD_SHAPE_ID (in OE) + changed @@IDENTITY for SCOPE_IDENTITY()
 * 04/03/2012 - Eduardo - IT098 transposed IDR table..
 * 04/24/2012 - Eduardo - 1-13500958; per Eric, apply same rule accross all utilities..
 * 01/23/2013 - 1-55574161; alleghany sends billed and historical meters with 1 day difference
 *		(which causes 'UC_UniqueValuesIndex'..)
 * 09/03/2013 - bug in determining last account id
 * 09/12/2013 - adding new parameters..
 *
 * 1/10/2014 - Rick Deigsler
 * Added parameters @IcapEffectiveDate and @TcapEffectiveDate
 *
 * 5/1/2014  -  Gail M
 * TFS 39112: Avoid issue with UC_UniqueValuesIndex  when usage already exists.
 
 * 06-16-2015 - Vikas Sharma
 * TFS 69730 : Add Ability to Add DaysInArrear
 
 * 07-30-2015 - Vikas Sharma
 * TFS 28613 : Adding TransactionCreatedDate
 *******************************************************************************
 * 3/25/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_EdiAccountInsert]
	@AccountNumber			varchar(50),
	@AccountStatus			varchar(50) = '',
	@AnuualUsage			int,
	@BillCalculation		varchar(50) = '',
	@BillGroup				varchar(15),
	@BillingAccountNumber	varchar(50),
	@BillingType			varchar(50) = '',
	@ContactName			varchar(50) = '',
	@CustomerName			varchar(100) = '',
	@DunsNumber				varchar(50),
	@EdiFileLogID			int,
	@EmailAddress			varchar(50) = '',
	@EspAccountNumber		varchar(50) = '',
	@Fax					varchar(50) = '',
	@HomePhone				varchar(50) = '',
	@Icap					decimal(12,6),
	@LoadProfile			varchar(50),
	@LossFactor				decimal(12,6),
	@MeterMultiplier		smallint,
	@MeterNumber			varchar(50) = '',
	@MeterType				varchar(50) = '',
	@NetMeterType			varchar(50) = '',
	@MonthsToComputeKwh		smallint,
	@NameKey				varchar(50),
	@PreviousAccountNumber	varchar(50),
	@ProductAltType			varchar(10) = '',
	@ProductType			varchar(10) = '',
	@RateClass				varchar(50),
	@RetailMarketCode		varchar(50),
	@ServicePeriodEnd		datetime,
	@ServicePeriodStart		datetime,
	@effectiveDate			datetime,
	@ServiceType			varchar(10) = '',
	@ServiceDeliveryPoint	varchar(50) = '',
	@Tcap					decimal(12,6),
	@Telephone				varchar(50) = '',
	@TransactionType		varchar(10) = '',
	@UtilityCode			varchar(50),
	@Voltage				varchar(45) = '',
	@WorkPhone				varchar(50) = '',
	@ZoneCode				varchar(50) = '',
	@LoadShapeId			varchar(50) = '',
	@AccountType			varchar(50) = '',
	@IcapEffectiveDate		datetime	= NULL,
	@TcapEffectiveDate		datetime	= NULL,
	@DaysInArrears           int        = NULL,
	@TransactionCreationDate datetime	= NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE	@ID			int,
			@PreviousID	int

	IF @UtilityCode = 'PECO' AND LEN(@RateClass) > 0 AND LEN(@LoadProfile) > 0 -- concatenate rate class and load profile for PECO (SD 18359)
		SET	@LoadProfile = @RateClass + '-' + @LoadProfile

	-- select * from sys.procedures where name = 'usp_EdiAccountInsert'
	-- select top 100 * from ediaccount
	IF @PreviousAccountNumber <> ''
		SELECT @PreviousID = MAX(ID) FROM EdiAccount WITH (NOLOCK) WHERE @PreviousAccountNumber = AccountNumber AND @UtilityCode = UtilityCode

	SELECT @PreviousID = MAX(ID) FROM EdiAccount WITH (NOLOCK) WHERE @AccountNumber = AccountNumber AND @UtilityCode = UtilityCode

	INSERT INTO	EdiAccount (EdiFileLogID, AccountNumber, BillingAccountNumber, EspAccountNumber, CustomerName, DunsNumber,
							Icap, NameKey, PreviousAccountNumber, RateClass, LoadProfile, BillGroup,
							RetailMarketCode, Tcap, UtilityCode, ZoneCode, TimeStampInsert,
							AccountStatus, BillingType, BillCalculation, ServicePeriodStart,
							ServicePeriodEnd, AnuualUsage, MonthsToComputeKwh, MeterType, MeterMultiplier,
							TransactionType, ServiceType, ProductType, ProductAltType, ContactName,
							Telephone, HomePhone, WorkPhone, Fax, EmailAddress, MeterNumber, ServiceDeliveryPoint,
							LossFactor, Voltage, LoadShapeId, AccountType, EffectiveDate, NetMeterType,
							IcapEffectiveDate, TcapEffectiveDate,DaysInArrears,TransactionCreationDate )
	VALUES					(@EdiFileLogID, @AccountNumber, @BillingAccountNumber, @EspAccountNumber, @CustomerName, @DunsNumber,
							@Icap, @NameKey, @PreviousAccountNumber, @RateClass, @LoadProfile,
							@BillGroup, @RetailMarketCode, @Tcap, @UtilityCode, @ZoneCode, GETDATE(),
							@AccountStatus, @BillingType, @BillCalculation, @ServicePeriodStart,
							@ServicePeriodEnd, @AnuualUsage, @MonthsToComputeKwh, @MeterType, @MeterMultiplier,
							@TransactionType, @ServiceType, @ProductType, @ProductAltType, @ContactName,
							@Telephone, @HomePhone, @WorkPhone, @Fax, @EmailAddress, @MeterNumber, @ServiceDeliveryPoint,
							@LossFactor, @Voltage, @LoadShapeId, @AccountType, @effectiveDate, @NetMeterType,
							@IcapEffectiveDate, @TcapEffectiveDate,@DaysInArrears,@TransactionCreationDate )

	SET	@ID	= SCOPE_IDENTITY()

	DECLARE	@ZONE	VARCHAR(20)

	SELECT	@ZONE	= def.zone
		FROM	lp_common..common_utility t2 (NOLOCK) INNER JOIN
				lp_common..zone def (NOLOCK) on t2.utility_id = def.utility_id
		WHERE	has_zones = 0
			AND	t2.utility_id = @UtilityCode

	IF @ZONE IS NOT NULL
		SET @ZoneCode = @ZONE

	-- update foreign key in usage table
	IF @PreviousID IS NOT NULL
		BEGIN
			UPDATE	EdiUsage
			SET		EdiAccountID	= @ID
			WHERE	EdiAccountID	= @PreviousID

			UPDATE	EdiUsageDetail
			SET		EdiAccountID	= @ID
			WHERE	EdiAccountID	= @PreviousID

			UPDATE	IdrUsageHorizontal
			SET		EdiAccountID	= @ID
			WHERE	EdiAccountID	= @PreviousID
		END

	IF @PreviousAccountNumber <> '' AND	@UtilityCode <> 'ALLEGMD'
		BEGIN
			UPDATE	U
			SET		AccountNumber = @AccountNumber,
					Modified = getdate(),
					ReasonCode = 16
			FROM libertypower..UsageConsolidated U
			WHERE	AccountNumber = @PreviousAccountNumber
				AND	UtilityCode = @UtilityCode
				-- Bug ID 39112 - Avoid Unique Key Error - GM
				AND NOT EXISTS ( SELECT ID 
									FROM libertypower..UsageConsolidated (nolock)
									WHERE UtilityCode = U.UtilityCode
										AND AccountNumber = @AccountNumber 
										AND FromDate = U.FromDate
										AND ToDate = U.ToDate
										AND MeterNumber = U.MeterNumber 
										AND Active = U.Active
								)
	
		END

/*	
	-- SD 19685 - Update NSTAR utility code in OE to match EDI file
	IF @UtilityCode LIKE '%NSTAR%'
		BEGIN
			UPDATE	OfferEngineDB..OE_ACCOUNT
			SET		UTILITY			= @UtilityCode
			WHERE	ACCOUNT_NUMBER	= @AccountNumber
		END
*/
	-- select top 40 * from OfferEngineDB..OE_ACCOUNT
	-- select top 40 * from lp_transactions..EdiAccount order by 1 desc

	-- update account data in Offer Engine
	UPDATE	OfferEngineDB..OE_ACCOUNT
	SET		ICAP			= CASE WHEN @Icap IS NULL OR @Icap = -1						THEN ICAP			ELSE @Icap			END,
			TCAP			= CASE WHEN @Tcap IS NULL OR @Tcap = -1						THEN TCAP			ELSE @Tcap			END,
			ZONE			= CASE WHEN @ZoneCode IS NULL OR LEN(@ZoneCode) = 0			THEN ZONE			ELSE @ZoneCode		END,
			RATE_CLASS		= CASE WHEN @RateClass IS NULL OR LEN(@RateClass) = 0		THEN RATE_CLASS		ELSE @RateClass		END,
			LOAD_PROFILE	= CASE WHEN @LoadProfile IS NULL OR LEN(@LoadProfile) = 0	THEN LOAD_PROFILE	ELSE @LoadProfile	END,
			--LOAD_SHAPE_ID	= CASE WHEN @LoadShapeId IS NULL OR LEN(@LoadShapeId) = 0	THEN @LoadProfile	ELSE @LoadShapeId	END,
			BILL_GROUP		= CASE WHEN @BillGroup IS NULL OR LEN(@BillGroup) = 0		THEN BILL_GROUP		ELSE @BillGroup		END,
			VOLTAGE			= CASE WHEN @Voltage IS NULL OR LEN(@Voltage) = 0			THEN VOLTAGE		ELSE @Voltage		END,
			ANNUAL_USAGE	= CASE WHEN @AnuualUsage IS NULL OR @AnuualUsage = -1		THEN ANNUAL_USAGE	ELSE @AnuualUsage	END,
			NAME_KEY		= CASE WHEN @NameKey IS NULL OR LEN(@NameKey) = 0			THEN NAME_KEY		ELSE @NameKey		END
	WHERE	ACCOUNT_NUMBER	= @AccountNumber
		AND	UTILITY			= @UtilityCode

	SELECT ID = @ID

	SET NOCOUNT OFF;
END

-- Copyright 2010 Liberty Power

