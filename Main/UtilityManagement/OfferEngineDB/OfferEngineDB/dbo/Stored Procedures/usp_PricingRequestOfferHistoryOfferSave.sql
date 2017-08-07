CREATE PROCEDURE [dbo].[usp_PricingRequestOfferHistoryOfferSave]
	@PricingRequestOfferHistoryId INT,
	@OfferId NVARCHAR(255)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @OfferIdInt AS INT
	
	SELECT
		@OfferIdInt = ID
	FROM
		[DBO].OE_OFFER (NOLOCK) O
	WHERE
		O.OFFER_ID = @OfferId

	INSERT INTO [DBO].[OE_PRICING_REQUEST_OFFER_HISTORY_OFFER]
	(
		[OFFER_ID],
		[PRICING_REQUEST_OFFER_HISTORY_ID],
		[DATE_CREATED]
	)
	VALUES
	(
		@OfferIdInt,
		@PricingRequestOfferHistoryId,
		GETDATE()
	)

END