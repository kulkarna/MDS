



CREATE PROCEDURE [dbo].[usp_offer_create_or_update]
@p_accounts dbo.tvp_ocou_accounts READONLY,
@terms_prices_flow_dates dbo.tvp_ocou_terms_prices_flow_dates READONLY,
@p_pricing_request_id			varchar(50),
@p_offer_id						varchar(50)     = NULL OUTPUT,
@p_product						varchar(50)		= NULL,
@p_power_index					varchar(10)		= NULL,
@p_block_size					varchar(50)		= NULL,
@p_peak_value					decimal(16,2)	= NULL,
@p_peak_unit					varchar(2)		= NULL,
@p_off_peak_value				decimal(16,2)	= NULL,
@p_off_peak_unit				varchar(2)		= NULL,
@p_value_24_7					decimal(16,2)	= NULL,
@p_unit_24_7					varchar(2)		= NULL,
@p_henry_hub_daily				int				= NULL,
@p_henry_hub_monthly			int				= NULL,
@p_losses_included				varchar(50)		= NULL,
@p_anc_svcs_included			varchar(50)		= NULL,
@p_anc_svcs_op_res_included		varchar(50)		= NULL,
@p_capacity						varchar(50)		= NULL,
@p_network_trans_included		varchar(50)		= NULL,
@p_renewables_included			varchar(50)		= NULL,
@p_band_width_included			varchar(50)		= NULL,
@p_gas_index_included			varchar(50)		= NULL,
@p_consultants_fees_included	varchar(50)		= NULL,
@p_others_included				varchar(50)		= NULL,
@p_renewables_value				decimal(16,2)	= NULL,
@p_band_width_value				decimal(16,2)	= NULL,
@p_consultants_fee_value		decimal(16,2)	= NULL,
@p_others_value					varchar(50)		= NULL,
@p_losses						decimal(18,0)	= NULL,
@p_status						varchar(50)		= NULL,
@p_is_refresh					tinyint = 0,
@p_use_int_tran					BIT = 1,
@p_offer_id_suffix				varchar(50)		= NULL


AS
SET NOCOUNT ON;

DECLARE @Debug BIT = 1;
DECLARE @Accounts TABLE (
	[Count] [int] IDENTITY(1,1) NOT NULL,
	[ID] [int] NOT NULL,
	[ACCOUNT_NUMBER] [varchar](50) NULL,
	[MARKET] [varchar](25) NULL,
	[UTILITY] [varchar](50) NULL
);

INSERT  INTO @Accounts
        ( ID ,
          ACCOUNT_NUMBER ,
          MARKET ,
          UTILITY 
        )
        SELECT  oea.ID ,
                oea.ACCOUNT_NUMBER ,
                oea.MARKET ,
                oea.UTILITY
        FROM    dbo.OE_ACCOUNT oea
                INNER JOIN @p_accounts a ON a.AccountNumber = oea.ACCOUNT_NUMBER ;
                
IF @Debug = 1 SELECT * FROM @Accounts;
             
             
SET @p_offer_id = dbo.NullIfEmptyOrWhiteSpaceVarchar(@p_offer_id);

BEGIN TRY
	IF @p_use_int_tran = 1 BEGIN TRAN
		IF(@p_offer_id IS NOT NULL)
			EXEC [dbo].[usp_offer_del] @p_pricing_request_id, @p_offer_id;
	
		IF(@p_offer_id IS NULL) BEGIN
			EXEC [dbo].[usp_generate_id] 'OFFER_ID', @p_offer_id OUTPUT;
			
			IF NOT (dbo.IsNullEmptyOrWhiteSpaceVarchar(@p_offer_id_suffix) = 1)
				SET @p_offer_id = @p_offer_id + '-' + @p_offer_id_suffix;
		END
			

		IF @Debug = 1 SELECT @p_offer_id;

		--offer
		EXEC dbo.usp_offer_ins 
			@p_pricing_request_id,
		    @p_offer_id,
		    @p_product,
		    @p_power_index,
		    @p_block_size,
		    @p_peak_value,
		    @p_peak_unit,
		    @p_off_peak_value,
		    @p_off_peak_unit,
		    @p_value_24_7,
		    @p_unit_24_7,
		    @p_henry_hub_daily,
		    @p_henry_hub_monthly,
		    @p_losses_included,
		    @p_anc_svcs_included,
		    @p_anc_svcs_op_res_included,
		    @p_capacity,
		    @p_network_trans_included,
		    @p_renewables_included,
		    @p_band_width_included,
		    @p_gas_index_included,
		    @p_consultants_fees_included,
		    @p_others_included,
		    @p_renewables_value,
		    @p_band_width_value,
		    @p_consultants_fee_value,
		    @p_others_value,
		    @p_losses,
		    @p_status,
		    @p_is_refresh;
		
		--markets
		INSERT OE_OFFER_MARKETS (OFFER_ID, MARKET) SELECT DISTINCT @p_offer_id, a.MARKET FROM @Accounts a;
	
		--utilities
		INSERT OE_OFFER_UTILITIES (OFFER_ID, UTILITY) SELECT DISTINCT @p_offer_id, a.UTILITY FROM @Accounts a;
		
		--accounts
		DECLARE
			@account_count INT = (SELECT MAX([Count]) FROM @Accounts),
			@p_account_id  varchar(50),
			@p_account_number  varchar(50),
			@p_utility_id varchar(50),
			@current_account INT = 1;
			
		WHILE @current_account <= @account_count 
		BEGIN
			SELECT  @p_account_number = la.ACCOUNT_NUMBER,
					@p_account_id = la.ID,
					@p_utility_id = la.UTILITY
			FROM    @Accounts la
					INNER JOIN dbo.OE_PRICING_REQUEST_ACCOUNTS a ON a.PRICING_REQUEST_ID = @p_pricing_request_id
																  AND la.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
																  AND a.IS_ACTIVE = 1
			WHERE   la.[Count] = @current_account;
				
			EXEC [dbo].[usp_offer_account_ins] 
				@p_pricing_request_id, 
				@p_offer_id,
				@p_account_id, 
				@p_account_number;
					
				--accounts update usage--may be slow
			EXEC [dbo].[usp_usage_from_lp_historical_info_upd] 
				@p_offer_id,
				@p_utility_id, 
				@p_account_number;

			SET @current_account = @current_account + 1;
		END
		
		--terms prices and flow dates
		EXEC [dbo].[usp_offer_add_terms_prices_flow_dates] 
		   @terms_prices_flow_dates
		  ,@p_offer_id
		  ,@p_use_int_tran = 0
		  ,@p_debug = 0

    IF @p_use_int_tran = 1 COMMIT TRAN
END TRY
BEGIN CATCH
	IF @p_use_int_tran = 1 ROLLBACK TRAN
	DECLARE 
		@ErrorMessage NVARCHAR(4000),
		@ErrorSeverity INT,
		@ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();
           
    RAISERROR (@ErrorMessage,
               @ErrorSeverity,
               @ErrorState );
END CATCH




