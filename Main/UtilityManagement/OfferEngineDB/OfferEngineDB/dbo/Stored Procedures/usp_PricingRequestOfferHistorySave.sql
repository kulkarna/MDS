CREATE PROCEDURE [dbo].[usp_PricingRequestOfferHistorySave]
	@PricingRequestId nvarchar(255)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @PricingRequestIdInt AS INT
	
	SELECT
		@PricingRequestIdInt = ID
	FROM
		[DBO].OE_PRICING_REQUEST (NOLOCK) PR
	WHERE
		PR.REQUEST_ID = @PricingRequestId


	INSERT INTO [DBO].[OE_PRICING_REQUEST_OFFER_HISTORY]
	(
		PRICE_REQUEST_ID,
		DATE_CREATED
	)
	VALUES
	(
		@PricingRequestIdInt,
		GETDATE()
	)
	
	SELECT 
		MAX(A.ID) 
	FROM 
		[DBO].[OE_PRICING_REQUEST_OFFER_HISTORY] (NOLOCK) A
		INNER JOIN [DBO].[OE_PRICING_REQUEST] (NOLOCK) PR
			ON A.PRICE_REQUEST_ID = PR.ID
	WHERE
		PR.REQUEST_ID = @PricingRequestId

END




SET ANSI_NULLS ON
