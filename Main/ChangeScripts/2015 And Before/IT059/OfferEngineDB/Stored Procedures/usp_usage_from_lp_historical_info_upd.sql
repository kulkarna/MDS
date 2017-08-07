USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_usage_from_lp_historical_info_upd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_usage_from_lp_historical_info_upd]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/5/2008
-- Description:	
--
-- Modified 5/8/2009 - Rick Deigsler
-- Pull from Offer Engine
-- Modified 9/22/2009 - Eduardo Patino (Ticket 9481)
-- =============================================
CREATE PROCEDURE [dbo].[usp_usage_from_lp_historical_info_upd]

@p_offer_id					varchar(50),
@p_utility_id				varchar(50),
@p_account_number			varchar(50)

AS
BEGIN
	SET NOCOUNT ON;
	SET		@p_utility_id		= LTRIM(RTRIM(@p_utility_id))
	SET		@p_account_number	= LTRIM(RTRIM(@p_account_number))

	DECLARE	@w_annual_usage		bigint,
			@w_total_usage		float,
			@w_total_days		float,
			@w_max_endate		datetime,
			@w_voltage			varchar(50),
			@w_364_range		datetime,
			@w_losses			decimal(18,9)

	select	top 1 @w_364_range = dateadd (day, -363, todate)
	FROM
	(
		SELECT	ToDate
		FROM	LibertyPower..UsageConsolidated u WITH (NOLOCK)
				INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
		WHERE	o.OFFER_ID			= @p_offer_id
		AND		o.ACCOUNT_NUMBER	= @p_account_number
		UNION
		SELECT	ToDate
		FROM	LibertyPower..EstimatedUsage u WITH (NOLOCK)
				INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
		WHERE	o.OFFER_ID			= @p_offer_id
		AND		o.ACCOUNT_NUMBER	= @p_account_number				
	)z
	ORDER BY todate DESC

	SELECT	@w_voltage = Voltage
	FROM	OE_ACCOUNT WITH (NOLOCK)
	WHERE	ACCOUNT_NUMBER	= @p_account_number
	AND		UTILITY		= @p_utility_id


	SELECT	@w_max_endate = MAX(z.ToDate), @w_total_usage = SUM(z.TotalKwh), @w_total_days = SUM(z.DaysUsed)
	FROM
	(
		SELECT	ToDate, TotalKwh, DaysUsed
		FROM	LibertyPower..UsageConsolidated u WITH (NOLOCK)
				INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
		WHERE	o.OFFER_ID			= @p_offer_id 
			AND	o.ACCOUNT_NUMBER	= @p_account_number
			AND	ToDate >= @w_364_range
		GROUP BY ToDate, TotalKwh, DaysUsed
		UNION
		SELECT	ToDate, TotalKwh, DaysUsed
		FROM	LibertyPower..EstimatedUsage u WITH (NOLOCK)
				INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
		WHERE	o.OFFER_ID			= @p_offer_id 
			AND	o.ACCOUNT_NUMBER	= @p_account_number
			AND	ToDate >= @w_364_range
		GROUP BY ToDate, TotalKwh, DaysUsed				
	)z

	IF @w_total_days > 0 AND @w_total_usage > 0
		SET	@w_annual_usage = CAST((CAST(@w_total_usage AS decimal(18,5)) * (CAST(365 AS decimal(18,5)) / CAST(@w_total_days AS decimal(18,5)))) AS int)
	ELSE
		SET	@w_annual_usage = 0

	-- value modifications  ----------------------
	--IF @w_voltage = '1'
	--	SET @w_voltage = CASE WHEN @p_utility_id = 'NIMO' THEN 'Secondary' ELSE 'Primary' END
	--IF @w_voltage = '2'
	--	SET @w_voltage = CASE WHEN @p_utility_id = 'NIMO' THEN 'Primary' ELSE 'Secondary' END
	--IF @w_voltage IS NULL OR LEN(@w_voltage) = 0
	--	SET @w_voltage = 'Secondary'
	----------------------------------------------

	SET	@w_annual_usage		= LTRIM(RTRIM(@w_annual_usage))
	SET	@w_voltage			= LTRIM(RTRIM(@w_voltage))

	--SELECT	@w_losses = (CASE WHEN Losses IS NULL OR LEN(Losses) = 0 THEN 0 ELSE Losses END)
	--FROM	lp_historical_info..LossesByUtilityVoltage c WITH (NOLOCK) 
	--WHERE	c.utility_id = @p_utility_id AND c.voltage = CASE WHEN @w_voltage IS NULL OR LEN(@w_voltage) = 0 THEN 'Secondary' ELSE @w_voltage END

	--INSERT INTO zErrors (RequestID, OfferID, AccountNumber, Utility, ErrorMessage, Username, [Filename], DateInsert)
	--SELECT		'NONE', @p_offer_id, @p_account_number, @p_utility_id, 'usage update - max end date', cast(@w_max_endate as varchar(50)), 'NONE', GETDATE()

	UPDATE	OE_ACCOUNT
	SET		ANNUAL_USAGE	= CASE WHEN LEN(@w_annual_usage) > 0	THEN @w_annual_usage				ELSE ANNUAL_USAGE	END, 
			--LOSSES			= CASE WHEN LEN(@w_losses) > 0			THEN @w_losses						ELSE LOSSES			END,
			USAGE_DATE		= CASE WHEN @w_max_endate IS NOT NULL	THEN @w_max_endate					ELSE USAGE_DATE		END
	WHERE	ACCOUNT_NUMBER	= @p_account_number AND UTILITY = @p_utility_id

	SET NOCOUNT OFF;
END
GO
