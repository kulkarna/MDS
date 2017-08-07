
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/11/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_component_details_ins_upd]

@p_market_prices_detail_id			int			= 0,
@p_peak_price						float		= 0,
@p_off_peak_price					float		= 0,
@p_atc								float		= 0,
@p_peak_mwh							float		= 0,
@p_off_peak_mwh						float		= 0,
@p_icap								float		= 0,
@p_tcap								float		= 0,
@p_risk_1							float		= 0,
@p_risk_2							float		= 0,
@p_risk_3							float		= 0,
@p_transmission						float		= 0,
@p_ancillary_services				float		= 0,
@p_operating_reserve				float		= 0,
@p_renewable_requirements			float		= 0,
@p_losses							float		= 0,
@p_green_fees						float		= 0,
@p_other							float		= 0,
@p_total_cost						float		= 0,
@p_consultant_fee					float		= 0,
@p_financing_fee					float		= 0,
@p_markup							float		= 0,
@p_fixed_price						float		= 0,
@p_block_price						float		= 0,
@p_adder_price						float		= 0,
@p_contribution_margin				float		= 0,
@p_gross_margin						float		= 0,
@p_price_type						varchar(50)	= 'matPrice'

AS


IF NOT EXISTS (	SELECT	NULL
				FROM	OE_OFFER_COMPONENT_DETAILS WITH (NOLOCK)
				WHERE	MARKET_PRICES_DETAIL_ID = @p_market_prices_detail_id
				AND		PRICE_TYPE				=  @p_price_type)
	BEGIN
		INSERT INTO	OE_OFFER_COMPONENT_DETAILS
				   (MARKET_PRICES_DETAIL_ID, PEAK_PRICE, OFF_PEAK_PRICE, ATC, PEAK_MWH, OFF_PEAK_MWH, 
					ICAP, TCAP, RISK_1, RISK_2, RISK_3, TRANSMISSION, ANCILLARY_SERVICES, OPERATING_RESERVE, 
					RENEWABLE_REQUIREMENTS, LOSSES, GREEN_FEES, OTHER, TOTAL_COST, CONSULTANT_FEE, FINANCING_FEE, 
					MARKUP, FIXED_PRICE, BLOCK_PRICE, ADDER_PRICE, CONTRIBUTION_MARGIN, GROSS_MARGIN, PRICE_TYPE)
		VALUES		(@p_market_prices_detail_id, @p_peak_price, @p_off_peak_price, @p_atc, @p_peak_mwh, @p_off_peak_mwh, 
					@p_icap, @p_tcap, @p_risk_1, @p_risk_2, @p_risk_3, @p_transmission, @p_ancillary_services, 
					@p_operating_reserve, @p_renewable_requirements, @p_losses, @p_green_fees, @p_other, 
					@p_total_cost, @p_consultant_fee, @p_financing_fee, @p_markup, @p_fixed_price, 
					@p_block_price, @p_adder_price, @p_contribution_margin, @p_gross_margin, @p_price_type)
	END
ELSE
	BEGIN
		UPDATE	OE_OFFER_COMPONENT_DETAILS
		SET		PEAK_PRICE				= @p_peak_price, 
				OFF_PEAK_PRICE			= @p_off_peak_price, 
				ATC						= @p_atc, 
				PEAK_MWH				= @p_peak_mwh,
				OFF_PEAK_MWH			= @p_off_peak_mwh,
				ICAP					= @p_icap,
				TCAP					= @p_tcap,
				RISK_1					= @p_risk_1,
				RISK_2					= @p_risk_2,
				RISK_3					= @p_risk_3,
				TRANSMISSION			= @p_transmission,
				ANCILLARY_SERVICES		= @p_ancillary_services,
				OPERATING_RESERVE		= @p_operating_reserve,
				RENEWABLE_REQUIREMENTS	= @p_renewable_requirements,
				LOSSES					= @p_losses,
				GREEN_FEES				= @p_green_fees,
				OTHER					= @p_other,
				TOTAL_COST				= @p_total_cost,
				CONSULTANT_FEE			= @p_consultant_fee,
				FINANCING_FEE			= @p_financing_fee,
				MARKUP					= @p_markup,
				FIXED_PRICE				= @p_fixed_price,
				BLOCK_PRICE				= @p_block_price,
				ADDER_PRICE				= @p_adder_price,
				CONTRIBUTION_MARGIN		= @p_contribution_margin,
				GROSS_MARGIN			= @p_gross_margin
		WHERE	MARKET_PRICES_DETAIL_ID	= @p_market_prices_detail_id
		AND		PRICE_TYPE				= @p_price_type
	END




