/*******************************************************************************
 * usp_OfferFlowStartDatesTermsSelect
 * Retrieve flow start dates and terms for a given offer
 *
 * History
 *******************************************************************************
 * 12/22/2008 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferFlowStartDatesTermsSelect]                                                                                     

@OfferId	varchar(50)

AS
BEGIN
    SET NOCOUNT ON;

		SELECT		f.FLOW_START_DATE, t.TERM
		FROM		OE_OFFER_FLOW_DATES f WITH (NOLOCK)
					LEFT JOIN OE_TERMS_AND_PRICES t WITH (NOLOCK)
					ON f.FLOW_START_DATE_ID = t.FLOW_START_DATE_ID
		WHERE		OFFER_ID = @OfferId
		GROUP BY	f.FLOW_START_DATE, t.TERM

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2008 Liberty Power

