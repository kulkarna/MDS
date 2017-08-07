
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/13/2008
-- Description:	Gets status of required components
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_accounts_status_sel]

@p_price_request_id		varchar(50),
@p_offer_id				varchar(50)

AS

DECLARE	@w_account_number		varchar(50),
		@w_utility				varchar(50),
		@w_has_usage			tinyint,
		@w_has_zone				tinyint,
		@w_has_load_shape_id	tinyint,
		@w_has_hourly_load		tinyint,
		@w_has_rate_class		tinyint,
		@w_has_stratum			tinyint,
		@w_has_offer_file		tinyint,
		@w_has_load_file		tinyint


CREATE TABLE #AccountStatus (account_number varchar(50), utility_id varchar(50), has_usage tinyint, has_zone tinyint, has_load_shape_id tinyint,  
							has_hourly_load tinyint, has_rate_class tinyint, has_stratum tinyint, has_offer_file tinyint, has_load_file tinyint)

-- pricing files (2) --------------------------------------------------------
--IF EXISTS (	SELECT	NULL
--			FROM	OE_OFFER_PRICE_FILES WITH (NOLOCK)
--			WHERE	REQUEST_ID	= @p_price_request_id
--			AND		OFFER_ID	= @p_offer_id
--			AND		FILE_TYPE	= 'txt' )
	SET		@w_has_offer_file = 1
--ELSE
--	SET		@w_has_offer_file = 0

--IF EXISTS (	SELECT	NULL
--			FROM	OE_OFFER_PRICE_FILES WITH (NOLOCK)
--			WHERE	REQUEST_ID	= @p_price_request_id
--			AND		OFFER_ID	= @p_offer_id
--			AND		FILE_TYPE	= 'csv' )
	SET		@w_has_load_file = 1
--ELSE
--	SET		@w_has_load_file = 0
------------------------------------------------------------------------------

DECLARE curStatus CURSOR FOR
	SELECT	a.ACCOUNT_NUMBER, a.UTILITY
	FROM	OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
	WHERE	b.OFFER_ID = @p_offer_id
OPEN curStatus 
FETCH NEXT FROM curStatus INTO @w_account_number, @w_utility
WHILE (@@FETCH_STATUS = 0) 
	BEGIN 
		SET	@w_has_usage			= 0
		SET	@w_has_zone				= 0
		SET	@w_has_load_shape_id	= 0
		SET	@w_has_hourly_load		= 0
		SET	@w_has_rate_class		= 0
		SET	@w_has_stratum			= 0	
		
		-- usage  --------------------------------------------------------
		IF ((	SELECT	COUNT(u.[ID])
				FROM	LibertyPower..Usage u WITH (NOLOCK)
						INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId
						INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
				WHERE	o.OFFER_ID			= @p_offer_id 
				AND		o.ACCOUNT_NUMBER	= @w_account_number ) > 0)
			SET		@w_has_usage = 1
		ELSE
			SET		@w_has_usage = 0

		-- zone  ---------------------------------------------------------
		IF ((	SELECT	COUNT(a.[ID])
				FROM	dbo.OE_ACCOUNT a WITH (NOLOCK)
						INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON a.ACCOUNT_NUMBER = o.ACCOUNT_NUMBER
				WHERE	o.OFFER_ID			= @p_offer_id 
				AND		o.ACCOUNT_NUMBER	= @w_account_number
				AND		(a.Zone IS NULL OR LEN(RTRIM(LTRIM(a.Zone))) = 0)) = 0 )
			SET		@w_has_zone = 1
		ELSE
			SET		@w_has_zone = 0

		-- hourly load  --------------------------------------------------
		SET		@w_has_hourly_load = 1

		SELECT	@w_has_zone				= CASE WHEN ZONE IS NULL OR LEN(ZONE) = 0 THEN 0 ELSE 1 END,
				@w_has_load_shape_id	= CASE WHEN LOAD_SHAPE_ID IS NULL OR LEN(LOAD_SHAPE_ID) = 0 THEN 0 ELSE 1 END, 
				@w_has_rate_class		= CASE WHEN RATE_CLASS IS NULL OR LEN(RATE_CLASS) = 0 THEN 0 ELSE 1 END, 
				@w_has_stratum			= CASE WHEN STRATUM_VARIABLE IS NULL OR LEN(STRATUM_VARIABLE) = 0 THEN 0 ELSE 1 END
				FROM	dbo.OE_ACCOUNT a WITH (NOLOCK)
						INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON a.ACCOUNT_NUMBER = o.ACCOUNT_NUMBER
				WHERE	o.OFFER_ID			= @p_offer_id 
				AND		o.ACCOUNT_NUMBER	= @w_account_number
				AND		a.UTILITY			= @w_utility


		INSERT INTO	#AccountStatus
		SELECT		@w_account_number, LTRIM(RTRIM(@w_utility)), 
					CASE WHEN @w_has_usage IS NULL THEN 0 ELSE @w_has_usage END, 
					CASE WHEN @w_has_zone IS NULL THEN 0 ELSE @w_has_zone END, 
					CASE WHEN @w_has_load_shape_id IS NULL THEN 0 ELSE @w_has_load_shape_id END, 
					CASE WHEN @w_has_hourly_load IS NULL THEN 0 ELSE @w_has_hourly_load END, 
					CASE WHEN @w_has_rate_class IS NULL THEN 0 ELSE @w_has_rate_class END, 
					CASE WHEN @w_has_stratum IS NULL THEN 0 ELSE @w_has_stratum END,
					CASE WHEN @w_has_offer_file IS NULL THEN 0 ELSE @w_has_offer_file END, 
					CASE WHEN @w_has_load_file IS NULL THEN 0 ELSE @w_has_load_file END

		FETCH NEXT FROM curStatus INTO @w_account_number, @w_utility
	END
CLOSE curStatus 
DEALLOCATE curStatus

SELECT		*
FROM		#AccountStatus

DROP TABLE	#AccountStatus








