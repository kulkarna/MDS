﻿




-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_offer_component_details_ins]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)

AS

DECLARE	@w_ID								int,
		@w_MARKET_PRICES_DETAIL_ID			int,
		@w_MARKET_PRICES_DETAIL_ID_CLONE	int,
		@w_PEAK_PRICE						float,
		@w_OFF_PEAK_PRICE					float,
		@w_ATC								float,
		@w_PEAK_MWH							float,
		@w_OFF_PEAK_MWH						float,
		@w_ICAP								float,
		@w_TCAP								float,
		@w_RISK_1							float,
		@w_RISK_2							float,
		@w_RISK_3							float,
		@w_TRANSMISSION						float,
		@w_ANCILLARY_SERVICES				float,
		@w_OPERATING_RESERVE				float,
		@w_RENEWABLE_REQUIREMENTS			float,
		@w_LOSSES							float,
		@w_GREEN_FEES						float,
		@w_OTHER							float,
		@w_TOTAL_COST						float,
		@w_CONSULTANT_FEE					float,
		@w_FINANCING_FEE					float,
		@w_MARKUP							float,
		@w_FIXED_PRICE						float,
		@w_BLOCK_PRICE						float,
		@w_ADDER_PRICE						float,
		@w_CONTRIBUTION_MARGIN				float,
		@w_GROSS_MARGIN						float,
		@w_PRICE_TYPE						varchar(50),
		@w_row_count						int

SELECT	@w_MARKET_PRICES_DETAIL_ID = ID
FROM	OE_OFFER_MARKET_PRICES_DETAIL
WHERE	OFFER_ID = @p_offer_id

SELECT	@w_MARKET_PRICES_DETAIL_ID_CLONE = ID
FROM	OE_OFFER_MARKET_PRICES_DETAIL
WHERE	OFFER_ID = @p_offer_id_clone

SELECT	@w_PEAK_PRICE = PEAK_PRICE, 
		@w_OFF_PEAK_PRICE = OFF_PEAK_PRICE, @w_ATC = ATC, 
		@w_PEAK_MWH = PEAK_MWH, @w_OFF_PEAK_MWH = OFF_PEAK_MWH, @w_ICAP = ICAP, @w_TCAP = TCAP, 
		@w_RISK_1 = RISK_1, @w_RISK_2 = RISK_2, @w_RISK_3 = RISK_3, 
		@w_TRANSMISSION = TRANSMISSION, @w_ANCILLARY_SERVICES = ANCILLARY_SERVICES, 
		@w_OPERATING_RESERVE = OPERATING_RESERVE, @w_RENEWABLE_REQUIREMENTS = RENEWABLE_REQUIREMENTS, 
		@w_LOSSES = LOSSES, @w_GREEN_FEES = GREEN_FEES, 
		@w_OTHER = OTHER, @w_TOTAL_COST = TOTAL_COST, 
		@w_CONSULTANT_FEE = CONSULTANT_FEE, @w_FINANCING_FEE = FINANCING_FEE, 
		@w_MARKUP = MARKUP, @w_FIXED_PRICE = FIXED_PRICE, 
		@w_BLOCK_PRICE = BLOCK_PRICE, @w_ADDER_PRICE = ADDER_PRICE, 
		@w_CONTRIBUTION_MARGIN = CONTRIBUTION_MARGIN, @w_GROSS_MARGIN = GROSS_MARGIN, 
		@w_PRICE_TYPE = PRICE_TYPE
FROM	OE_OFFER_COMPONENT_DETAILS
WHERE	MARKET_PRICES_DETAIL_ID = @w_MARKET_PRICES_DETAIL_ID

IF @@ROWCOUNT > 0
	BEGIN
		INSERT INTO	OE_OFFER_COMPONENT_DETAILS (MARKET_PRICES_DETAIL_ID, PEAK_PRICE, OFF_PEAK_PRICE, 
					ATC, PEAK_MWH, OFF_PEAK_MWH, ICAP, TCAP, RISK_1, RISK_2, RISK_3, TRANSMISSION, 
					ANCILLARY_SERVICES, OPERATING_RESERVE, RENEWABLE_REQUIREMENTS, LOSSES, GREEN_FEES, 
					OTHER, TOTAL_COST, CONSULTANT_FEE, FINANCING_FEE, MARKUP, FIXED_PRICE, BLOCK_PRICE, 
					ADDER_PRICE, CONTRIBUTION_MARGIN, GROSS_MARGIN, PRICE_TYPE)
		VALUES		(@w_MARKET_PRICES_DETAIL_ID_CLONE, @w_PEAK_PRICE, @w_OFF_PEAK_PRICE, @w_ATC, @w_PEAK_MWH,
					@w_OFF_PEAK_MWH, @w_ICAP, @w_TCAP, @w_RISK_1, @w_RISK_2, @w_RISK_3, @w_TRANSMISSION,
					@w_ANCILLARY_SERVICES, @w_OPERATING_RESERVE, @w_RENEWABLE_REQUIREMENTS, @w_LOSSES,
					@w_GREEN_FEES, @w_OTHER, @w_TOTAL_COST, @w_CONSULTANT_FEE, @w_FINANCING_FEE, @w_MARKUP,
					@w_FIXED_PRICE, @w_BLOCK_PRICE, @w_ADDER_PRICE, @w_CONTRIBUTION_MARGIN, @w_GROSS_MARGIN,
					@w_PRICE_TYPE)
	END



CREATE TABLE #Comps	(ID int IDENTITY(1,1) NOT NULL, PEAK_PRICE float, OFF_PEAK_PRICE float, ATC float, PEAK_MWH float, 
					OFF_PEAK_MWH float, ICAP float, TCAP float, RISK_1 float, RISK_2 float, RISK_3 float, TRANSMISSION float, 
					ANCILLARY_SERVICES float, OPERATING_RESERVE float, RENEWABLE_REQUIREMENTS float, LOSSES float, GREEN_FEES float, 
					OTHER float, TOTAL_COST float, CONSULTANT_FEE float, FINANCING_FEE float, MARKUP float, FIXED_PRICE float, BLOCK_PRICE float, 
					ADDER_PRICE float, CONTRIBUTION_MARGIN float, GROSS_MARGIN float, PRICE_TYPE varchar(50))

INSERT INTO #Comps
SELECT		PEAK_PRICE, OFF_PEAK_PRICE, ATC, PEAK_MWH, OFF_PEAK_MWH, ICAP, TCAP, RISK_1, RISK_2, RISK_3, 
			TRANSMISSION, ANCILLARY_SERVICES, OPERATING_RESERVE, RENEWABLE_REQUIREMENTS, LOSSES, GREEN_FEES, 
			OTHER, TOTAL_COST, CONSULTANT_FEE, FINANCING_FEE, MARKUP, FIXED_PRICE, BLOCK_PRICE, ADDER_PRICE, 
			CONTRIBUTION_MARGIN, GROSS_MARGIN, PRICE_TYPE
FROM		OE_OFFER_COMPONENT_DETAILS
WHERE		MARKET_PRICES_DETAIL_ID = @w_MARKET_PRICES_DETAIL_ID


SELECT	TOP 1 @w_ID = ID, @w_PEAK_PRICE = PEAK_PRICE, 
		@w_OFF_PEAK_PRICE = OFF_PEAK_PRICE, @w_ATC = ATC, 
		@w_PEAK_MWH = PEAK_MWH, @w_OFF_PEAK_MWH = OFF_PEAK_MWH, @w_ICAP = ICAP, @w_TCAP = TCAP, 
		@w_RISK_1 = RISK_1, @w_RISK_2 = RISK_2, @w_RISK_3 = RISK_3, 
		@w_TRANSMISSION = TRANSMISSION, @w_ANCILLARY_SERVICES = ANCILLARY_SERVICES, 
		@w_OPERATING_RESERVE = OPERATING_RESERVE, @w_RENEWABLE_REQUIREMENTS = RENEWABLE_REQUIREMENTS, 
		@w_LOSSES = LOSSES, @w_GREEN_FEES = GREEN_FEES, 
		@w_OTHER = OTHER, @w_TOTAL_COST = TOTAL_COST, 
		@w_CONSULTANT_FEE = CONSULTANT_FEE, @w_FINANCING_FEE = FINANCING_FEE, 
		@w_MARKUP = MARKUP, @w_FIXED_PRICE = FIXED_PRICE, 
		@w_BLOCK_PRICE = BLOCK_PRICE, @w_ADDER_PRICE = ADDER_PRICE, 
		@w_CONTRIBUTION_MARGIN = CONTRIBUTION_MARGIN, @w_GROSS_MARGIN = GROSS_MARGIN, 
		@w_PRICE_TYPE = PRICE_TYPE
FROM	#Comps

SET		@w_row_count = @@ROWCOUNT


WHILE	@w_row_count > 0
	BEGIN

		DELETE FROM	#Comps
		WHERE		ID = @w_ID

		SELECT	TOP 1 @w_ID = ID, @w_PEAK_PRICE = PEAK_PRICE, 
				@w_OFF_PEAK_PRICE = OFF_PEAK_PRICE, @w_ATC = ATC, 
				@w_PEAK_MWH = PEAK_MWH, @w_OFF_PEAK_MWH = OFF_PEAK_MWH, @w_ICAP = ICAP, @w_TCAP = TCAP, 
				@w_RISK_1 = RISK_1, @w_RISK_2 = RISK_2, @w_RISK_3 = RISK_3, 
				@w_TRANSMISSION = TRANSMISSION, @w_ANCILLARY_SERVICES = ANCILLARY_SERVICES, 
				@w_OPERATING_RESERVE = OPERATING_RESERVE, @w_RENEWABLE_REQUIREMENTS = RENEWABLE_REQUIREMENTS, 
				@w_LOSSES = LOSSES, @w_GREEN_FEES = GREEN_FEES, 
				@w_OTHER = OTHER, @w_TOTAL_COST = TOTAL_COST, 
				@w_CONSULTANT_FEE = CONSULTANT_FEE, @w_FINANCING_FEE = FINANCING_FEE, 
				@w_MARKUP = MARKUP, @w_FIXED_PRICE = FIXED_PRICE, 
				@w_BLOCK_PRICE = BLOCK_PRICE, @w_ADDER_PRICE = ADDER_PRICE, 
				@w_CONTRIBUTION_MARGIN = CONTRIBUTION_MARGIN, @w_GROSS_MARGIN = GROSS_MARGIN, 
				@w_PRICE_TYPE = PRICE_TYPE
		FROM	#Comps

		SET		@w_row_count = @@ROWCOUNT
	END

DROP TABLE #Comps
