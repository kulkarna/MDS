
/********************************************  usp_PricingRequestSelect ********************************************/

/*******************************************************************************
 * <usp_PricingRequestSelect>
 * <Get the list of pricing requests>
 *
 * History
 *******************************************************************************
 * <11/24/2011> - <CGHAZAL>
 * Created.
 *******************************************************************************
 */

CREATE	PROCEDURE	usp_PricingRequestSelect 

AS

BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	REQUEST_ID
	FROM	OfferEngineDB..OE_PRICING_REQUEST (NOLOCK)
	ORDER	BY REQUEST_ID
	
	SET NOCOUNT OFF;
	
END


