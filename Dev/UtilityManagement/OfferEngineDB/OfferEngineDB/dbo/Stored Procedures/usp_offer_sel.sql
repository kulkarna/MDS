﻿-- =============================================
-- Author:		Rick Deigsler
-- Create date: 9/2/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_sel]

@p_offer_id		varchar(50)

AS

SELECT	ID, HENRY_HUB_DAILY, LOOSES_INCLUDED, RENEWABLES_VALUE, PEAK_UNIT, 
		ANCILLARY_SERVICES_OPERATING_RESERVE_INCLUDED, PEAK_VALUE, PRODUCT, 
		HENRY_HUB_MONTHLY, LOSSES, POWER_INDEX, ANCILLARY_SERVICES_INCLUDED, 
		RENEWABLES_INCLUDED, CONSULTANTS_FEE_VALUE, OFF_PEAK_UNIT, CAPACITY, 
		CONSULTANTS_FEE_INCLUDED, BAND_WITH_INCLUDED, OFF_PEAK_VALUE, BAND_WITH_VALUE, 
		BLOCK_SIZE, VALUE_24_7, UNIT_24_7, GAS_INDEX_INCUDED, OTHERS_INCLUDED, 
		OFFER_ID, NETWORK_TRANSMISSION_INCLUDED, OTHERS_VALUE, DATE_CREATED, IS_REFRESH 
FROM	OE_OFFER
WHERE	OFFER_ID = @p_offer_id
