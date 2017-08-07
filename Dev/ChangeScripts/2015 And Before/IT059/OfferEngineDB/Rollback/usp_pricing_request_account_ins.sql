USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_pricing_request_account_ins]    Script Date: 07/13/2013 14:03:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[usp_pricing_request_account_ins] 

@p_pricing_request_id	varchar(50),			
@p_account_number		varchar(50),
@p_retail_mkt_id		varchar(25)		= '',
@p_utility_id			varchar(50)		= '',
@p_meter_type			varchar(50)		= '',
@p_meter_number			varchar(50)		= '',
@p_voltage				varchar(50)		= '',
@p_address				varchar(50)		= '',
@p_suite				varchar(50)		= '',
@p_city					varchar(50)		= '',
@p_state				varchar(50)		= '',
@p_zip					varchar(25)		= '',
@p_zone					varchar(50)		= '',
@p_rate_class			varchar(50)		= '',
@p_icap					decimal(18,9),
@p_tcap					decimal(18,9),
@p_load_shape_id		varchar(50)		= '',
@p_losses				decimal(18,9),
@p_name_key				varchar(50)		= '',
@p_BillingAccount		varchar(50)		= '',
@p_TarriffCode			varchar(50)	= '',
@p_LoadProfile			varchar(50)	= '',
@p_Grid				varchar(50)	= '',
@p_LbmpZone			varchar(50)	= ''

AS
DECLARE	@w_oe_account_id	int,
		@w_losses			decimal(18,9),
		@w_utilityIDR		bit,
		@w_metery_type		varchar(15)

SET	@p_account_number	= LTRIM(RTRIM(UPPER(REPLACE(@p_account_number, '''', ''))))
SET	@p_retail_mkt_id	= LTRIM(RTRIM(UPPER(@p_retail_mkt_id)))
SET	@p_utility_id		= LTRIM(RTRIM(UPPER(@p_utility_id)))
SET	@p_meter_type		= LTRIM(RTRIM(UPPER(@p_meter_type)))
SET	@p_meter_number		= LTRIM(RTRIM(REPLACE(@p_meter_number, '''', '')))
SET	@p_voltage			= LTRIM(RTRIM(@p_voltage))
SET	@p_address			= LTRIM(RTRIM(@p_address))
SET	@p_suite			= LTRIM(RTRIM(@p_suite))
SET	@p_city				= LTRIM(RTRIM(@p_city))
SET	@p_state			= LTRIM(RTRIM(@p_state))
SET	@p_zip				= LTRIM(RTRIM(REPLACE(@p_zip, '''', '')))
SET	@p_zone				= LTRIM(RTRIM(REPLACE(@p_zone, '''', '')))
SET	@p_rate_class		= LTRIM(RTRIM(@p_rate_class))
SET	@p_load_shape_id	= LTRIM(RTRIM(@p_load_shape_id))

-- CKE removed stripping single quotes per ticket 1-4057025
-- SET	@p_name_key			= LTRIM(RTRIM(REPLACE(@p_name_key, '''', '')))
SET	@p_name_key			= LTRIM(RTRIM(@p_name_key))

SET	@p_BillingAccount	= LTRIM(RTRIM(UPPER(REPLACE(@p_BillingAccount, '''', ''))))
SET @p_TarriffCode = LTRIM(RTRIM(UPPER(REPLACE(@p_TarriffCode, '''', ''))))
SET @p_LoadProfile = LTRIM(RTRIM(UPPER(REPLACE(@p_LoadProfile, '''', ''))))
SET @p_Grid = LTRIM(RTRIM(UPPER(REPLACE(@p_Grid, '''', ''))))
SET @p_LbmpZone = LTRIM(RTRIM(UPPER(REPLACE(@p_LbmpZone, '''', ''))))

-- bandaid for new zip to zone
SET	@p_zone =	CASE	WHEN @p_zone = 'HOUSTON' THEN 'HZ'
						WHEN @p_zone = 'SOUTH' THEN 'SZ'
						WHEN @p_zone = 'NORTH' THEN 'NZ'
						WHEN @p_zone = 'WEST' THEN 'WZ'
						ELSE @p_zone
				END


IF @p_icap IS NULL OR LEN(@p_icap) = 0 OR @p_icap = -1
	BEGIN
		IF @p_retail_mkt_id = 'TX' OR @p_retail_mkt_id = 'CA'
			SET	@p_icap = 0
		ELSE
			SET	@p_icap = -1
	END
	
IF @p_tcap IS NULL OR LEN(@p_tcap) = 0 OR @p_tcap = -1
	BEGIN
		IF @p_retail_mkt_id = 'TX' OR @p_retail_mkt_id = 'CA'
			SET	@p_tcap = 0
		ELSE
			SET	@p_tcap = -1
	END	

-- for DUQ, set zone to 'DUQ'
IF @p_utility_id = 'DUQ'
	SET	@p_zone = 'DUQ'

IF @p_losses = 0
	BEGIN
		SELECT	@w_losses = (CASE WHEN Losses IS NULL OR LEN(Losses) = 0 THEN 0 ELSE Losses END)
		FROM	lp_historical_info..LossesByUtilityVoltage c WITH (NOLOCK) 
		WHERE	c.utility_id = @p_utility_id AND c.voltage = CASE WHEN @p_voltage IS NULL OR LEN(@p_voltage) = 0 THEN 'Secondary' ELSE @p_voltage END
	END
ELSE
	BEGIN
		SET	@w_losses = @p_losses
	END

-- Get the meter type: if the utiltiy is IDR EDI and the account number exists in the IDR acocunts table, then meter type should be IDR
SELECT	@w_utilityIDR=u.isIDR_EDI_Capable
FROM	LibertyPower..Utility u
WHERE	u.UtilityCode = @p_utility_id

SELECT	@w_metery_type = 'IDR'
FROM	LibertyPower..IDRAccounts a
WHERE	@w_utilityIDR = 1
AND		a.AccountNumber = @p_account_number
AND		a.UtilityID = 'IDR_' + @p_utility_id

IF (@w_metery_type!= '')
	SET @p_meter_type = @w_metery_type
	
-- Get the Zone
IF	(@p_retail_mkt_id = 'TX')
BEGIN
	SET	@p_zone = (SELECT	/*a.ESIID, a.StationCode, */top 1 m.OEZone
							FROM	ERCOT..AccountInfoAccounts a
							INNER	JOIN ERCOT..AccountInfoSettlement s
							ON		a.StationCode = s.SubStation
							INNER	JOIN ERCOT..AccountInfoZoneMapping m
							ON		s.SettlementLoadZone = m.ErcotZone
							WHERE	a.ESIID = 	@p_account_number)	
							
	if (@p_zone is null)
		SET	@p_zone = ''					
END
	
-- account data  -----------------------------------------------------------------------
IF NOT EXISTS (	SELECT	NULL
				FROM	OE_ACCOUNT WITH (NOLOCK)
				WHERE	ACCOUNT_NUMBER = @p_account_number AND UTILITY = @p_utility_id )
	BEGIN
		INSERT INTO	OE_ACCOUNT (ACCOUNT_NUMBER, ACCOUNT_ID, MARKET, UTILITY, METER_TYPE, 
					RATE_CLASS, VOLTAGE, ZONE, VAL_COMMENT, TCAP, ICAP, LOSSES, ANNUAL_USAGE, 
					LOAD_SHAPE_ID, NAME_KEY, BillingAccountNumber, NeedUsage, TarrifCode, LOAD_PROFILE, Grid, LbmpZone)
		VALUES		(@p_account_number, NULL, @p_retail_mkt_id, @p_utility_id, CASE WHEN LEN(@p_meter_type) > 0 THEN UPPER(@p_meter_type) ELSE 'NON-IDR' END, 
					@p_rate_class, CASE WHEN @p_voltage IS NULL OR LEN(@p_voltage) = 0 THEN 'Secondary' ELSE @p_voltage END, 
					@p_zone, NULL, @p_tcap, @p_icap, @w_losses, 0, 
					@p_load_shape_id, CASE WHEN @p_name_key IS NULL OR LEN(@p_name_key) = 0 THEN '' ELSE UPPER(@p_name_key) END,
					CASE WHEN @p_BillingAccount IS NULL OR LEN(@p_BillingAccount) = 0 THEN '' ELSE @p_BillingAccount END, 1,
					@p_TarriffCode,
					@p_LoadProfile,
					@p_Grid,
					@p_LbmpZone) 


		SET	@w_oe_account_id = SCOPE_IDENTITY()
	END
ELSE
	BEGIN
		UPDATE	OE_ACCOUNT
		SET		MARKET			= CASE WHEN LEN(@p_retail_mkt_id) > 0				THEN @p_retail_mkt_id		ELSE MARKET			END, 
				UTILITY			= CASE WHEN LEN(@p_utility_id) > 0					THEN @p_utility_id			ELSE UTILITY		END, 
				METER_TYPE		= CASE WHEN LEN(@p_meter_type) > 0					THEN UPPER(@p_meter_type)	ELSE METER_TYPE		END,
				VOLTAGE			= CASE WHEN LEN(@p_voltage) > 0						THEN @p_voltage				ELSE VOLTAGE		END,
				ZONE			= CASE	WHEN	@p_retail_mkt_id = 'TX'				THEN @p_zone
										WHEN	@p_retail_mkt_id <> 'TX' AND LEN(@p_zone) > 0 THEN @p_zone
										ELSE	ZONE
										END,
				RATE_CLASS		= CASE WHEN LEN(@p_rate_class) > 0					THEN @p_rate_class			ELSE RATE_CLASS		END, 
				ICAP			= CASE WHEN LEN(@p_icap) > 0 AND @p_icap <> -1		THEN @p_icap				ELSE ICAP			END,
				TCAP			= CASE WHEN LEN(@p_tcap) > 0 AND @p_tcap <> -1		THEN @p_tcap				ELSE TCAP			END,
				LOSSES			= CASE WHEN LEN(@w_losses) > 0 AND @p_losses <> 0	THEN @w_losses				ELSE LOSSES			END,
				LOAD_SHAPE_ID	= CASE WHEN LEN(@p_load_shape_id) > 0				THEN @p_load_shape_id		ELSE LOAD_SHAPE_ID	END, 
				NAME_KEY		= CASE WHEN LEN(@p_name_key) > 0					THEN UPPER(@p_name_key)		ELSE NAME_KEY		END,
				BillingAccountNumber	= CASE WHEN LEN(@p_BillingAccount) > 0		THEN @p_BillingAccount		ELSE BillingAccountNumber	END,
				NeedUsage		= 1,
				TarrifCode		= CASE WHEN LEN(@p_TarriffCode) > 0								THEN @p_TarriffCode				ELSE TarrifCode	END,
				LOAD_PROFILE		= CASE WHEN LEN(@p_LoadProfile) > 0							THEN @p_LoadProfile				ELSE LOAD_PROFILE	END,
				Grid		= CASE WHEN LEN(@p_Grid) > 0										THEN @p_Grid					ELSE Grid	END,
				LbmpZone		= CASE WHEN LEN(@p_LbmpZone) > 0								THEN @p_LbmpZone				ELSE LbmpZone	END
				

		WHERE	ACCOUNT_NUMBER	= @p_account_number
		AND		UTILITY			= @p_utility_id 

		SELECT	@w_oe_account_id = ID
		FROM	OE_ACCOUNT WITH (NOLOCK)
		WHERE	ACCOUNT_NUMBER	= @p_account_number
		AND		UTILITY			= @p_utility_id 
	END

-- account meter (if applicable)  --------------------------------------------------------
IF LEN(RTRIM(LTRIM(@p_meter_number))) > 0
AND @w_oe_account_id IS NOT NULL
AND NOT EXISTS (	SELECT	NULL
					FROM	OE_ACCOUNT_METERS WITH (NOLOCK)
					WHERE	ACCOUNT_NUMBER	= @p_account_number
					AND		OE_ACCOUNT_ID	= @w_oe_account_id )
	BEGIN
		INSERT INTO	OE_ACCOUNT_METERS (OE_ACCOUNT_ID, ACCOUNT_NUMBER, METER_NUMBER)
		VALUES		(@w_oe_account_id, @p_account_number, @p_meter_number)
	END
ELSE
	BEGIN
		UPDATE	OE_ACCOUNT_METERS
		SET		METER_NUMBER	= CASE WHEN LEN(@p_meter_number) > 0 THEN @p_meter_number ELSE METER_NUMBER END
		WHERE	OE_ACCOUNT_ID	= @w_oe_account_id
	END


-- address data  -----------------------------------------------------------------------
IF @w_oe_account_id IS NOT NULL
AND NOT EXISTS (	SELECT	NULL
					FROM	OE_ACCOUNT_ADDRESS WITH (NOLOCK)
					WHERE	OE_ACCOUNT_ID = @w_oe_account_id )
	BEGIN
		INSERT INTO	OE_ACCOUNT_ADDRESS (OE_ACCOUNT_ID, ACCOUNT_NUMBER, ADDRESS, SUITE, CITY, STATE, ZIP)
		VALUES		(@w_oe_account_id, @p_account_number, @p_address, @p_suite, @p_city, @p_state, @p_zip)
	END
ELSE
	BEGIN
		UPDATE	OE_ACCOUNT_ADDRESS
		SET		ADDRESS			= CASE WHEN LEN(@p_address) > 0	THEN @p_address		ELSE ADDRESS	END, 
				SUITE			= CASE WHEN LEN(@p_suite) > 0	THEN @p_suite		ELSE SUITE		END, 
				CITY			= CASE WHEN LEN(@p_city) > 0	THEN @p_city		ELSE CITY		END, 
				STATE			= CASE WHEN LEN(@p_state) > 0	THEN @p_state		ELSE STATE		END, 
				ZIP				= CASE WHEN LEN(@p_zip) > 0		THEN @p_zip			ELSE ZIP		END
		WHERE	OE_ACCOUNT_ID	= @w_oe_account_id
	END

-- account for pricing request  ---------------------------------------------------------
IF @w_oe_account_id IS NOT NULL
AND NOT EXISTS (	SELECT	NULL
					FROM	OE_PRICING_REQUEST_ACCOUNTS WITH (NOLOCK)
					WHERE	PRICING_REQUEST_ID	= @p_pricing_request_id
					AND		ACCOUNT_NUMBER		= @p_account_number )
	BEGIN
		INSERT INTO	OE_PRICING_REQUEST_ACCOUNTS (OE_ACCOUNT_ID, PRICING_REQUEST_ID, ACCOUNT_ID, ACCOUNT_NUMBER)
		VALUES		(@w_oe_account_id, @p_pricing_request_id, NULL, @p_account_number)
	END

UPDATE	OE_PRICING_REQUEST
SET		TOTAL_NUMBER_OF_ACCOUNTS	= (SELECT COUNT(ACCOUNT_NUMBER) FROM OE_PRICING_REQUEST_ACCOUNTS WHERE PRICING_REQUEST_ID = @p_pricing_request_id)
WHERE	REQUEST_ID					= @p_pricing_request_id

-- historical_info update, if exists
/*  10/5/2010
	Rick Deigsler
	commented out, obsolete
UPDATE	lp_historical_info..ProspectAccounts
SET		ICAP			= CASE WHEN LEN(@p_icap) > 0 AND @p_icap <> -1	THEN @p_icap			ELSE ICAP			END, 
		TCAP			= CASE WHEN LEN(@p_tcap) > 0 AND @p_tcap <> -1	THEN @p_tcap			ELSE TCAP			END, 
		Voltage			= CASE WHEN LEN(@p_voltage) > 0					THEN @p_voltage			ELSE Voltage		END, 
		Zone			= CASE WHEN LEN(@p_zone) > 0					THEN @p_zone			ELSE Zone			END,
		LoadShapeID		= CASE WHEN LEN(@p_load_shape_id) > 0			THEN @p_load_shape_id	ELSE LoadShapeID	END,
		RateClass		= CASE WHEN LEN(@p_rate_class) > 0				THEN @p_rate_class		ELSE RateClass		END, 
		IDR				= CASE WHEN @p_meter_type = 'IDR'				THEN 'true'				ELSE 'false'		END
WHERE	AccountNumber	= @p_account_number
AND		[Deal ID] LIKE '%OF-%'
*/



GO

