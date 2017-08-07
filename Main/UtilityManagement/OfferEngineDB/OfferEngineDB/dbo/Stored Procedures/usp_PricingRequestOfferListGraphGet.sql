CREATE PROCEDURE [dbo].[usp_PricingRequestOfferListGraphGet]
    @PricingRequestId VARCHAR(50)
AS
    SELECT
    			(SELECT  
    				@PricingRequestId AS PricingRequestId,
					O.OFFER_ID AS OfferId,
					'' AS SuffixId,
					( SELECT  A.ACCOUNT_NUMBER AS AccountNumber, ISNULL(A.USAGE_DATE, '01/01/1753') AS LastUsageDate
							  FROM [dbo].[OE_OFFER_ACCOUNTS] OA INNER JOIN dbo.OE_ACCOUNT A ON OA.OE_ACCOUNT_ID = A.ID
							  WHERE OA.OFFER_ID = O.OFFER_ID
							FOR XML PATH('OfferAccount'), TYPE
					) 
					Accounts ,
					( SELECT    fd.FLOW_START_DATE AS FlowStartDate ,
										[TERM] AS Term ,
										[PRICE] AS Price
							  FROM      [dbo].[OE_TERMS_AND_PRICES] AS tp
										INNER JOIN dbo.OE_OFFER_FLOW_DATES AS fd ON tp.FLOW_START_DATE_ID = fd.FLOW_START_DATE_ID
							  WHERE fd.OFFER_ID = O.OFFER_ID
							FOR XML PATH('OfferTerm'), TYPE
					) 
					Terms ,
					Product ,
					STATUS AS [Status]
				FROM    dbo.OE_OFFER AS O INNER JOIN dbo.OE_PRICING_REQUEST_OFFER PRO 
				ON O.OFFER_ID = PRO.OFFER_ID
				WHERE PRO.REQUEST_ID = @PricingRequestId
				FOR     XML PATH('Offer'), TYPE
				) Offers
    FOR  XML PATH('OfferList')

