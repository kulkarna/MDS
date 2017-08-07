/*******************************************************************************
 * usp_OfferForecastStartEndDatesSelect
 * Retrieve forecast start and end dates for a given offer
 *
 * History
 *******************************************************************************
 * 2/17/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferForecastStartEndDatesSelect]                                                                                     

@OfferId	varchar(50)

AS
BEGIN
    SET NOCOUNT ON;

	DECLARE		@StartDate	datetime,
				@EndDate	datetime,
				@MaxTerm	int


	SELECT		@StartDate = MIN(f.FLOW_START_DATE), @EndDate = MAX(f.FLOW_START_DATE), @MaxTerm = MAX(t.TERM)
	FROM		OE_OFFER_FLOW_DATES f WITH (NOLOCK)
				LEFT JOIN OE_TERMS_AND_PRICES t WITH (NOLOCK)
				ON f.FLOW_START_DATE_ID = t.FLOW_START_DATE_ID
	WHERE		OFFER_ID = @OfferId

	SET			@EndDate = DATEADD( dd, -1, (DATEADD(mm, @MaxTerm, @EndDate)))

	SELECT		@StartDate, @EndDate

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

