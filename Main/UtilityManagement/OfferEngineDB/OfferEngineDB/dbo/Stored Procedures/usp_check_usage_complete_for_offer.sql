
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/5/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_check_usage_complete_for_offer]

@p_offer_id		varchar(50)

AS

DECLARE	@w_count1			int,
		@w_count2			int,
		@w_count3			int		


-- if usage is missing, set offer status to open
SELECT	@w_count1 = COUNT(DISTINCT ACCOUNT_NUMBER)
FROM	dbo.OE_ACCOUNT a WITH (NOLOCK)
INNER JOIN
(
	SELECT	DISTINCT u.AccountNumber
	FROM	Libertypower..UsageConsolidated u WITH (NOLOCK)
			INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId AND u.UsageType = m.UsageType
			INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
	WHERE	o.OFFER_ID = @p_offer_id
	UNION
	SELECT	DISTINCT u.AccountNumber
	FROM	Libertypower..EstimatedUsage u WITH (NOLOCK)
			INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId AND m.UsageType = u.UsageType
			INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
	WHERE	o.OFFER_ID = @p_offer_id 
)z ON a.ACCOUNT_NUMBER = z.AccountNumber

SELECT		@w_count2 = COUNT(DISTINCT a.ACCOUNT_NUMBER)
FROM		OE_OFFER_ACCOUNTS o WITH (NOLOCK)
			INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
WHERE		o.OFFER_ID	= @p_offer_id

SELECT		@w_count3 = COUNT(DISTINCT a.ACCOUNT_NUMBER)
FROM		OE_OFFER_ACCOUNTS o WITH (NOLOCK)
			INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
WHERE		o.OFFER_ID	= @p_offer_id
AND			a.NeedUsage	= 1

IF EXISTS		(	SELECT		NULL
					FROM		OfferUsageStatus WITH (NOLOCK)
					WHERE		OfferId = @p_offer_id
					AND			HasErrors = 1
				)
OR ((@w_count1 <> @w_count2) OR (@w_count1 = 0) OR (@w_count3 > 0))
	SELECT 1
ELSE
	SELECT 0
	

