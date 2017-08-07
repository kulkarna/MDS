


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/1/2008
-- Description:	Get average read days of offer per utility
--
-- Modified 5/8/2009 - Rick Deigsler
-- Pull from OE
-- =============================================
CREATE PROCEDURE [dbo].[usp_avg_read_days_by_offer_utility_sel]

@p_offer_id		varchar(50),
@p_utility_id	varchar(50)

AS

SET			@p_utility_id = REPLACE(@p_utility_id, '&amp;', '&')

DECLARE		@w_count				int,
			@w_avg_read_days		int,
			@w_total_read_days		int,
			@w_account_number		varchar(50),
			@w_prev_account_number	varchar(50),
			@w_from_date			datetime,
			@w_to_date				datetime

SET			@w_count				= 0
SET			@w_total_read_days		= 0

DECLARE curReadDays CURSOR FOR
	SELECT		u.AccountNumber, u.ToDate
	FROM		Libertypower..Usage u WITH (NOLOCK)
				INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId
				INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
	WHERE		o.OFFER_ID = @p_offer_id
	ORDER BY	u.AccountNumber, u.ToDate
OPEN curReadDays 
FETCH NEXT FROM curReadDays INTO @w_account_number, @w_to_date
WHILE (@@FETCH_STATUS = 0) 
	BEGIN 
		IF (@w_count > 0) AND (@w_prev_account_number = @w_account_number)
			BEGIN
				SET @w_total_read_days = @w_total_read_days + DATEDIFF(DAY, @w_from_date, @w_to_date)
			END

		SET	@w_prev_account_number	= @w_account_number
		SET	@w_from_date			= @w_to_date
		SET	@w_count				= @w_count + 1

		FETCH NEXT FROM curReadDays INTO @w_account_number, @w_to_date
	END
CLOSE curReadDays 
DEALLOCATE curReadDays

IF @w_count > 0 AND @w_total_read_days > 0
	BEGIN
		SET	 @w_avg_read_days = (@w_total_read_days / @w_count)
	END
ELSE
	SET	 @w_avg_read_days = 0

SELECT	@w_avg_read_days





