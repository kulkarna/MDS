/*******************************************************************************
 * usp_AccountUpdate
 * Updates account data
 *
 * History
 *******************************************************************************
 * 9/1/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountUpdate]

@p_UtilityCode			varchar(50),			
@p_account_number		varchar(50),
@p_meter_type			varchar(50)	= '',
@p_icap					decimal(18,9)	= -1,
@p_tcap					decimal(18,9)	= -1,
@p_losses				decimal(18,9)	= 0,
@p_load_shape_id		varchar(50)		= '',
@p_voltage				varchar(50)		= '',
@p_rate_class			varchar(50)		= '',
@p_zone					varchar(50)		= '',
@p_meter_number			varchar(50)		= '',
@p_BillingAccount		varchar(50)		= '',
@p_TarrifCode			varchar(50)	= '',
@p_LoadProfile			varchar(50)	= '',
@p_Grid				varchar(50)	= '',
@p_LbmpZone			varchar(50)	= ''

AS		
BEGIN
	SET NOCOUNT ON;
	DECLARE	@w_has_error	int,
			@w_utility_id	varchar(50),
			@w_id			int

	SET	@w_has_error	= 0

	SET	@p_meter_type		= LTRIM(RTRIM(UPPER(@p_meter_type)))
	SET	@p_icap				= LTRIM(RTRIM(@p_icap))
	SET	@p_tcap				= LTRIM(RTRIM(@p_tcap))
	SET	@p_losses			= LTRIM(RTRIM(@p_losses))
	SET	@p_load_shape_id	= LTRIM(RTRIM(@p_load_shape_id))
	SET	@p_voltage			= LTRIM(RTRIM(@p_voltage))
	SET	@p_rate_class		= LTRIM(RTRIM(@p_rate_class))
	SET	@p_zone				= LTRIM(RTRIM(@p_zone))
	SET	@p_meter_number		= LTRIM(RTRIM(REPLACE(@p_meter_number, '''', '')))
	SET	@p_BillingAccount	= LTRIM(RTRIM(UPPER(REPLACE(@p_BillingAccount, '''', ''))))
	SET @p_TarrifCode = LTRIM(RTRIM(UPPER(REPLACE(@p_TarrifCode, '''', ''))))
	SET @p_LoadProfile = LTRIM(RTRIM(UPPER(REPLACE(@p_LoadProfile, '''', ''))))
	SET @p_Grid = LTRIM(RTRIM(UPPER(REPLACE(@p_Grid, '''', ''))))
	SET @p_LbmpZone = LTRIM(RTRIM(UPPER(REPLACE(@p_LbmpZone, '''', ''))))


	BEGIN TRAN account_upd

	-- for DUQ, set zone to 'DUQ'
	--IF @p_UtilityCode = 'DUQ'
	--	SET	@p_zone = 'DUQ'
		
	-- bandaid for new zip to zone
	--SET	@p_zone =	CASE	WHEN @p_zone = 'HOUSTON' THEN 'HZ'
	--						WHEN @p_zone = 'SOUTH' THEN 'SZ'
	--						WHEN @p_zone = 'NORTH' THEN 'NZ'
	--						WHEN @p_zone = 'WEST' THEN 'WZ'
	--						ELSE @p_zone
	--				END	

		UPDATE	OE_ACCOUNT
		SET		ACCOUNT_NUMBER	= CASE WHEN LEN(@p_account_number) > 0							THEN @p_account_number			ELSE ACCOUNT_NUMBER	END, 
				METER_TYPE		= CASE WHEN LEN(@p_meter_type) > 0								THEN UPPER(@p_meter_type)		ELSE METER_TYPE		END, 
				ICAP			= CASE WHEN LEN(@p_icap) > 0 AND @p_icap <> -1					THEN @p_icap					ELSE ICAP			END,
				TCAP			= CASE WHEN LEN(@p_tcap) > 0 AND @p_tcap <> -1					THEN @p_tcap					ELSE TCAP			END,
				LOSSES			= CASE WHEN LEN(@p_losses) > 0 AND @p_losses <> 0				THEN @p_losses					ELSE LOSSES			END,
				LOAD_SHAPE_ID	= CASE WHEN LEN(@p_load_shape_id) > 0							THEN UPPER(@p_load_shape_id)	ELSE LOAD_SHAPE_ID	END,
				VOLTAGE			= CASE WHEN LEN(@p_voltage) > 0									THEN UPPER(@p_voltage)			ELSE VOLTAGE		END, 
				RATE_CLASS		= CASE WHEN LEN(@p_rate_class) > 0								THEN @p_rate_class				ELSE RATE_CLASS		END, 
				ZONE			= CASE WHEN LEN(@p_zone) > 0									THEN @p_zone					ELSE ZONE			END, 
				BillingAccountNumber	= CASE WHEN LEN(@p_BillingAccount) > 0					THEN @p_BillingAccount			ELSE BillingAccountNumber	END,
				TarrifCode		= CASE WHEN LEN(@p_TarrifCode) > 0								THEN @p_TarrifCode				ELSE TarrifCode	END,
				LOAD_PROFILE		= CASE WHEN LEN(@p_LoadProfile) > 0							THEN @p_LoadProfile				ELSE LOAD_PROFILE	END,
				Grid		= CASE WHEN LEN(@p_Grid) > 0										THEN @p_Grid					ELSE Grid	END,
				LbmpZone		= CASE WHEN LEN(@p_LbmpZone) > 0								THEN @p_LbmpZone				ELSE LbmpZone	END
				
		WHERE	UTILITY			= @p_UtilityCode
		AND		ACCOUNT_NUMBER	= @p_account_number
		
		SELECT	@w_id = SCOPE_IDENTITY()

		IF @@ERROR <> 0
			SET @w_has_error = 1

		UPDATE	OE_ACCOUNT_ADDRESS
		SET		ACCOUNT_NUMBER	= @p_account_number
		WHERE	OE_ACCOUNT_ID = @w_id

		IF @@ERROR <> 0
			SET @w_has_error = 1

		UPDATE	OE_ACCOUNT_METERS
		SET		ACCOUNT_NUMBER	= @p_account_number,
				METER_NUMBER	= CASE WHEN LEN(@p_meter_number) > 0 THEN @p_meter_number ELSE METER_NUMBER END
		WHERE	OE_ACCOUNT_ID = @w_id

		IF @@ERROR <> 0
			SET @w_has_error = 1

		UPDATE	OE_OFFER_ACCOUNTS
		SET		ACCOUNT_NUMBER	= @p_account_number
		WHERE	OE_ACCOUNT_ID = @w_id

		IF @@ERROR <> 0
			SET @w_has_error = 1

		UPDATE	OE_PRICING_REQUEST_ACCOUNTS
		SET		ACCOUNT_NUMBER	= @p_account_number
		WHERE	OE_ACCOUNT_ID = @w_id

		IF @@ERROR <> 0
			SET @w_has_error = 1

		IF @@ERROR <> 0
			SET @w_has_error = 1

	IF @w_has_error = 0
		BEGIN
			COMMIT TRAN account_upd
			SELECT 0
		END
	ELSE
		BEGIN
			ROLLBACK TRAN account_upd
			SELECT 1
		END

	SET NOCOUNT OFF;
END


