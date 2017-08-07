
/*******************************************************************************
 * usp_UpdateAccount
 * Updates account data
 *
 * History
 *******************************************************************************
 * 6/9/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UpdateAccount]
	@p_account_number		varchar(50),
	@p_utility_id			varchar(50),
	@p_meter_type			varchar(50)		= '',
	@p_icap					decimal(18,9)	= -1,
	@p_tcap					decimal(18,9)	= -1,
	@p_losses				decimal(18,9)	= 0,
	@p_load_shape_id		varchar(50)		= '',
	@p_voltage				varchar(50)		= '',
	@p_rate_class			varchar(50)		= '',
	@p_zone					varchar(50)		= '',
	@p_meter_number			varchar(50)		= '',
	@p_BillingAccount		varchar(50)		= '',
	@p_TarrifCode			varchar(50)		= '',
	@p_LoadProfile			varchar(50)		= '',
	@p_Grid					varchar(50)		= '',
	@p_LbmpZone				varchar(50)		= '',
	@p_rate_code			varchar(50)		= ''
AS
BEGIN
    SET NOCOUNT ON;
    
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
	SET @p_rate_code = LTRIM(RTRIM(UPPER(REPLACE(@p_rate_code, '''', ''))))

	UPDATE	OE_ACCOUNT
	SET		METER_TYPE		= CASE WHEN LEN(@p_meter_type) > 0								THEN UPPER(@p_meter_type)		ELSE METER_TYPE		END, 
			ICAP			= CASE WHEN LEN(@p_icap) > 0 AND @p_icap <> -1					THEN @p_icap					ELSE ICAP			END,
			TCAP			= CASE WHEN LEN(@p_tcap) > 0 AND @p_tcap <> -1					THEN @p_tcap					ELSE TCAP			END,
			LOSSES			= CASE WHEN LEN(@p_losses) > 0 AND @p_losses <> 0				THEN @p_losses					ELSE LOSSES			END,
			LOAD_SHAPE_ID	= CASE WHEN LEN(@p_load_shape_id) > 0							THEN UPPER(@p_load_shape_id)	ELSE LOAD_SHAPE_ID	END,
			VOLTAGE			= CASE WHEN LEN(@p_voltage) > 0									THEN UPPER(@p_voltage)			ELSE VOLTAGE		END, 
			RATE_CLASS		= CASE WHEN LEN(@p_rate_class) > 0								THEN @p_rate_class				ELSE RATE_CLASS		END, 
			ZONE			= CASE WHEN LEN(@p_zone) > 0									THEN @p_zone					ELSE ZONE			END, 
			BillingAccountNumber	= CASE WHEN LEN(@p_BillingAccount) > 0					THEN @p_BillingAccount			ELSE BillingAccountNumber	END,
			TarrifCode		= CASE WHEN LEN(@p_TarrifCode) > 0								THEN @p_TarrifCode				ELSE TarrifCode	END,
			LOAD_PROFILE	= CASE WHEN LEN(@p_LoadProfile) > 0								THEN @p_LoadProfile				ELSE LOAD_PROFILE	END,
			Grid			= CASE WHEN LEN(@p_Grid) > 0									THEN @p_Grid					ELSE Grid	END,
			LbmpZone		= CASE WHEN LEN(@p_LbmpZone) > 0								THEN @p_LbmpZone				ELSE LbmpZone	END,
			RATE_CODE		= CASE WHEN LEN(@p_rate_code) > 0								THEN @p_rate_code				ELSE RATE_CODE	END	
	WHERE	ACCOUNT_NUMBER	= @p_account_number	
	AND		UTILITY			= @p_utility_id

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


