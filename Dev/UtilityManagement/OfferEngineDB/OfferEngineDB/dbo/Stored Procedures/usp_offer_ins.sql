


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/26/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_ins]

@p_pricing_request_id			varchar(50),
@p_offer_id						varchar(50),
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
@p_is_refresh					tinyint

AS

DECLARE		@w_has_error		int
SET			@w_has_error		= 0

BEGIN TRAN	offer
	INSERT INTO	OE_OFFER (OFFER_ID, PRODUCT, POWER_INDEX, BLOCK_SIZE, PEAK_VALUE, PEAK_UNIT, 
				OFF_PEAK_VALUE, OFF_PEAK_UNIT, VALUE_24_7, UNIT_24_7, HENRY_HUB_DAILY, HENRY_HUB_MONTHLY, 
				LOOSES_INCLUDED, ANCILLARY_SERVICES_INCLUDED, ANCILLARY_SERVICES_OPERATING_RESERVE_INCLUDED, 
				CAPACITY, NETWORK_TRANSMISSION_INCLUDED, RENEWABLES_INCLUDED, BAND_WITH_INCLUDED, 
				GAS_INDEX_INCUDED, CONSULTANTS_FEE_INCLUDED, OTHERS_INCLUDED, RENEWABLES_VALUE, 
				BAND_WITH_VALUE, CONSULTANTS_FEE_VALUE, OTHERS_VALUE, LOSSES, STATUS, IS_REFRESH)
	VALUES		(@p_offer_id, @p_product, @p_power_index, @p_block_size, @p_peak_value, @p_peak_unit,
				@p_off_peak_value, @p_off_peak_unit, @p_value_24_7, @p_unit_24_7, @p_henry_hub_daily,
				@p_henry_hub_monthly, @p_losses_included, @p_anc_svcs_included, @p_anc_svcs_op_res_included,
				@p_capacity, @p_network_trans_included, @p_renewables_included, @p_band_width_included,
				@p_gas_index_included, @p_consultants_fees_included, @p_others_included, @p_renewables_value,
				@p_band_width_value, @p_consultants_fee_value, @p_others_value, @p_losses, @p_status, @p_is_refresh)

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
		SET @w_has_error = 1

	INSERT INTO	OE_PRICING_REQUEST_OFFER (REQUEST_ID, OFFER_ID)
	VALUES		(@p_pricing_request_id, @p_offer_id)

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
		SET @w_has_error = 1

IF @w_has_error = 0
	BEGIN
		COMMIT TRAN offer
		SELECT 0
	END
ELSE
	BEGIN
		ROLLBACK TRAN offer
		SELECT 1
	END







