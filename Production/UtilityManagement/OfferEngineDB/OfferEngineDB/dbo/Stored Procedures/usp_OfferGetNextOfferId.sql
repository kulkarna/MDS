CREATE PROC usp_OfferGetNextOfferId
AS
BEGIN

SELECT 
	'OF-' + REPLACE(STR(
		ISNULL((
			SELECT 
				CAST(substring(offer_id,4,6) AS INT) 
			FROM 
				dbo.OE_OFFER (NOLOCK) 
			WHERE 
				DATE_CREATED = 
				(
					SELECT 
						MAX(DATE_CREATED) 
					FROM 
						OE_OFFER (NOLOCK) 
					WHERE 
						OFFER_ID LIKE 'of%'
				)
		),0) + 1, 6, 0), ' ', '0') + '-1'

END