

CREATE PROCEDURE [dbo].[usp_pricing_request_account_ins] @p_pricing_request_id varchar( 50 ) ,
                                                    @p_account_number varchar( 50 ) ,
                                                    @p_retail_mkt_id varchar( 25 ) = '' ,
                                                    @p_utility_id varchar( 50 ) = '' ,
                                                    @p_meter_type varchar( 50 ) = '' ,
                                                    @p_meter_number varchar( 50 ) = '' ,
                                                    @p_voltage varchar( 50 ) = '' ,
                                                    @p_address varchar( 50 ) = '' ,
                                                    @p_suite varchar( 50 ) = '' ,
                                                    @p_city varchar( 50 ) = '' ,
                                                    @p_state varchar( 50 ) = '' ,
                                                    @p_zip varchar( 25 ) = '' ,
                                                    @p_zone varchar( 50 ) = '' ,
                                                    @p_rate_class varchar( 50 ) = '' ,
                                                    @p_icap decimal( 18 , 9 ) ,
                                                    @p_tcap decimal( 18 , 9 ) ,
                                                    @p_load_shape_id varchar( 50 ) = '' ,
                                                    @p_losses decimal( 18 , 9 ) = null ,
                                                    @p_name_key varchar( 50 ) = '' ,
                                                    @p_BillingAccount varchar( 50 ) = '' ,
                                                    @p_TarriffCode varchar( 50 ) = '' ,
                                                    @p_LoadProfile varchar( 50 ) = '' ,
                                                    @p_Grid varchar( 50 ) = '' ,
                                                    @p_LbmpZone varchar( 50 ) = ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
	   @w_oe_account_id int ,
	   @w_losses decimal( 18 , 9 ) ,
	   @w_utilityIDR bit ,
	   @w_metery_type varchar( 15 );
	SET @p_account_number = LTRIM( RTRIM( UPPER( REPLACE( @p_account_number , '''' , '' ))));
	SET @p_retail_mkt_id = LTRIM( RTRIM( UPPER( @p_retail_mkt_id )));
	SET @p_utility_id = LTRIM( RTRIM( UPPER( @p_utility_id )));
	SET @p_meter_type = LTRIM( RTRIM( UPPER( @p_meter_type )));
	SET @p_meter_number = LTRIM( RTRIM( REPLACE( @p_meter_number , '''' , '' )));
	SET @p_voltage = LTRIM( RTRIM( @p_voltage ));
	SET @p_address = LTRIM( RTRIM( @p_address ));
	SET @p_suite = LTRIM( RTRIM( @p_suite ));
	SET @p_city = LTRIM( RTRIM( @p_city ));
	SET @p_state = LTRIM( RTRIM( @p_state ));
	SET @p_zip = LTRIM( RTRIM( REPLACE( @p_zip , '''' , '' )));
	SET @p_zone = LTRIM( RTRIM( REPLACE( @p_zone , '''' , '' )));
	SET @p_rate_class = LTRIM( RTRIM( @p_rate_class ));
	SET @p_load_shape_id = LTRIM( RTRIM( @p_load_shape_id ));
	-- CKE removed stripping single quotes per ticket 1-4057025
	-- SET	@p_name_key			= LTRIM(RTRIM(REPLACE(@p_name_key, '''', '')))
	SET @p_name_key = LTRIM( RTRIM( @p_name_key ));
	SET @p_BillingAccount = LTRIM( RTRIM( UPPER( REPLACE( @p_BillingAccount , '''' , '' ))));
	SET @p_TarriffCode = LTRIM( RTRIM( UPPER( REPLACE( @p_TarriffCode , '''' , '' ))));
	SET @p_LoadProfile = LTRIM( RTRIM( UPPER( REPLACE( @p_LoadProfile , '''' , '' ))));
	SET @p_Grid = LTRIM( RTRIM( UPPER( REPLACE( @p_Grid , '''' , '' ))));
	SET @p_LbmpZone = LTRIM( RTRIM( UPPER( REPLACE( @p_LbmpZone , '''' , '' ))));

			SET @w_losses = @p_losses;
			SET @p_meter_type = @w_metery_type
	-- account data  -----------------------------------------------------------------------
	IF NOT EXISTS( SELECT NULL
					 FROM OE_ACCOUNT WITH ( NOLOCK )
					 WHERE ACCOUNT_NUMBER
						 = @p_account_number
					   AND UTILITY
						 = @p_utility_id )
		BEGIN
			INSERT INTO OE_ACCOUNT( ACCOUNT_NUMBER ,
									ACCOUNT_ID ,
									MARKET ,
									UTILITY ,
									METER_TYPE ,
									RATE_CLASS ,
									VOLTAGE ,
									ZONE ,
									VAL_COMMENT ,
									TCAP ,
									ICAP ,
									LOSSES ,
									ANNUAL_USAGE ,
									LOAD_SHAPE_ID ,
									NAME_KEY ,
									BillingAccountNumber ,
									NeedUsage ,
									TarrifCode ,
									LOAD_PROFILE ,
									Grid ,
									LbmpZone )
			VALUES( @p_account_number ,
					NULL ,
					@p_retail_mkt_id ,
					@p_utility_id ,
					@p_meter_type ,
					@p_rate_class ,
					@p_voltage,
					@p_zone ,
					NULL ,
					@p_tcap ,
					@p_icap ,
					@w_losses ,
					0 ,
					@p_load_shape_id ,
					CASE
					WHEN @p_name_key IS NULL
					  OR LEN( @p_name_key )
					   = 0 THEN ''
						ELSE UPPER( @p_name_key )
					END ,
					CASE
					WHEN @p_BillingAccount IS NULL
					  OR LEN( @p_BillingAccount )
					   = 0 THEN ''
						ELSE @p_BillingAccount
					END ,
					1 ,
					@p_TarriffCode ,
					@p_LoadProfile ,
					@p_Grid ,
					@p_LbmpZone );
			SET @w_oe_account_id = SCOPE_IDENTITY( );
		END;
	ELSE
		BEGIN
			UPDATE OE_ACCOUNT
			SET MARKET = CASE
						 WHEN LEN( @p_retail_mkt_id )
							> 0 THEN @p_retail_mkt_id
							 ELSE MARKET
						 END ,
				UTILITY = CASE
						  WHEN LEN( @p_utility_id )
							 > 0 THEN @p_utility_id
							  ELSE UTILITY
						  END ,
				METER_TYPE = CASE
							 WHEN LEN( @p_meter_type )
								> 0 THEN UPPER( @p_meter_type )
								 ELSE METER_TYPE
							 END ,
				VOLTAGE = CASE
						  WHEN LEN( @p_voltage )
							 > 0 THEN @p_voltage
							  ELSE VOLTAGE
						  END ,
				ZONE = CASE
						WHEN  LEN( @p_zone ) > 0 THEN @p_zone
						   ELSE ZONE
					   END ,
				RATE_CLASS = CASE
							 WHEN LEN( @p_rate_class )
								> 0 THEN @p_rate_class
								 ELSE RATE_CLASS
							 END ,
				ICAP = CASE
					   WHEN LEN( @p_icap ) > 0
						AND @p_icap <> -1 THEN @p_icap
						   ELSE ICAP
					   END ,
				TCAP = CASE
					   WHEN LEN( @p_tcap ) > 0
						AND @p_tcap <> -1 THEN @p_tcap
						   ELSE TCAP
					   END ,
				LOSSES = @p_losses,
				LOAD_SHAPE_ID = CASE
								WHEN LEN( @p_load_shape_id )
								   > 0 THEN @p_load_shape_id
									ELSE LOAD_SHAPE_ID
								END ,
				NAME_KEY = CASE
						   WHEN LEN( @p_name_key )
							  > 0 THEN UPPER( @p_name_key )
							   ELSE NAME_KEY
						   END ,
				BillingAccountNumber = CASE
									   WHEN LEN( @p_BillingAccount )
										  > 0 THEN @p_BillingAccount
										   ELSE BillingAccountNumber
									   END ,
				NeedUsage = 1 ,
				TarrifCode = CASE
							 WHEN LEN( @p_TarriffCode )
								> 0 THEN @p_TarriffCode
								 ELSE TarrifCode
							 END ,
				LOAD_PROFILE = CASE
							   WHEN LEN( @p_LoadProfile )
								  > 0 THEN @p_LoadProfile
								   ELSE LOAD_PROFILE
							   END ,
				Grid = CASE
					   WHEN LEN( @p_Grid ) > 0 THEN @p_Grid
						   ELSE Grid
					   END ,
				LbmpZone = CASE
						   WHEN LEN( @p_LbmpZone )
							  > 0 THEN @p_LbmpZone
							   ELSE LbmpZone
						   END
			  WHERE ACCOUNT_NUMBER
				  = @p_account_number
				AND UTILITY
				  = @p_utility_id;
			SELECT @w_oe_account_id = ID
			  FROM OE_ACCOUNT WITH ( NOLOCK )
			  WHERE ACCOUNT_NUMBER
				  = @p_account_number
				AND UTILITY
				  = @p_utility_id;
		END;
	-- account meter (if applicable)  --------------------------------------------------------
	IF LEN( RTRIM( LTRIM( @p_meter_number )))
	 > 0
	AND @w_oe_account_id IS NOT NULL
	AND NOT EXISTS( SELECT NULL
					  FROM OE_ACCOUNT_METERS WITH ( NOLOCK )
					  WHERE ACCOUNT_NUMBER
						  = @p_account_number
						AND OE_ACCOUNT_ID
						  = @w_oe_account_id )
		BEGIN
			INSERT INTO OE_ACCOUNT_METERS( OE_ACCOUNT_ID ,
										   ACCOUNT_NUMBER ,
										   METER_NUMBER )
			VALUES( @w_oe_account_id ,
					@p_account_number ,
					@p_meter_number );
		END;
	ELSE
		BEGIN
			UPDATE OE_ACCOUNT_METERS
			SET METER_NUMBER = CASE
							   WHEN LEN( @p_meter_number )
								  > 0 THEN @p_meter_number
								   ELSE METER_NUMBER
							   END
			  WHERE OE_ACCOUNT_ID
				  = @w_oe_account_id;
		END;
	-- address data  -----------------------------------------------------------------------
	IF @w_oe_account_id IS NOT NULL
	AND NOT EXISTS( SELECT NULL
					  FROM OE_ACCOUNT_ADDRESS WITH ( NOLOCK )
					  WHERE OE_ACCOUNT_ID
						  = @w_oe_account_id )
		BEGIN
			INSERT INTO OE_ACCOUNT_ADDRESS( OE_ACCOUNT_ID ,
											ACCOUNT_NUMBER ,
											ADDRESS ,
											SUITE ,
											CITY ,
											STATE ,
											ZIP )
			VALUES( @w_oe_account_id ,
					@p_account_number ,
					@p_address ,
					@p_suite ,
					@p_city ,
					@p_state ,
					@p_zip );
		END;
	ELSE
		BEGIN
			UPDATE OE_ACCOUNT_ADDRESS
			SET ADDRESS = CASE
						  WHEN LEN( @p_address )
							 > 0 THEN @p_address
							  ELSE ADDRESS
						  END ,
				SUITE = CASE
						WHEN LEN( @p_suite )
						   > 0 THEN @p_suite
							ELSE SUITE
						END ,
				CITY = CASE
					   WHEN LEN( @p_city ) > 0 THEN @p_city
						   ELSE CITY
					   END ,
				STATE = CASE
						WHEN LEN( @p_state )
						   > 0 THEN @p_state
							ELSE STATE
						END ,
				ZIP = CASE
					  WHEN LEN( @p_zip ) > 0 THEN @p_zip
						  ELSE ZIP
					  END
			  WHERE OE_ACCOUNT_ID
				  = @w_oe_account_id;
		END;
	-- account for pricing request  ---------------------------------------------------------
	IF @w_oe_account_id IS NOT NULL
	AND NOT EXISTS( SELECT NULL
					  FROM OE_PRICING_REQUEST_ACCOUNTS WITH ( NOLOCK )
					  WHERE PRICING_REQUEST_ID
						  = @p_pricing_request_id
						AND ACCOUNT_NUMBER
						  = @p_account_number )
		BEGIN
			INSERT INTO OE_PRICING_REQUEST_ACCOUNTS( OE_ACCOUNT_ID ,
													 PRICING_REQUEST_ID ,
													 ACCOUNT_ID ,
													 ACCOUNT_NUMBER )
			VALUES( @w_oe_account_id ,
					@p_pricing_request_id ,
					NULL ,
					@p_account_number );
		END;
	UPDATE OE_PRICING_REQUEST
	SET TOTAL_NUMBER_OF_ACCOUNTS = ( SELECT COUNT( ACCOUNT_NUMBER )
									   FROM OE_PRICING_REQUEST_ACCOUNTS
									   WHERE PRICING_REQUEST_ID
										   = @p_pricing_request_id )
	  WHERE REQUEST_ID
		  = @p_pricing_request_id;
	
	SET NOCOUNT OFF;
END


