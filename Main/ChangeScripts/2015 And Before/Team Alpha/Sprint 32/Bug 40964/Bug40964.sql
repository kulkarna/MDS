USE [Lp_common]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductRateSelect]    Script Date: 05/28/2014 08:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * usp_ProductRateSelect
 * Select product rate data for specified product id and rate id
 *
 * History
 *******************************************************************************
 * 4/29/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 9/9/2010 - Eric Hernandez
 * Ticket 17543
 * Added @DealDate so that we can pull rates from previous days.
 *******************************************************************************
  * 5/28/2014 - Sara Lakshmanan
 * Ticket 1-558356850
 * @DealDate - The time stamp is trimmed from the Deal date
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_ProductRateSelect]                                                                                    
	@ProductId	VARCHAR(50),
	@RateId		INT,
	@DealDate	DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @Today DATETIME
	SET @Today = dateadd(dd,datediff(dd,0,getdate()),0)

	--Added on 5/28/2014
	Set @DealDate= CONVERT(varchar(10),@DealDate,101)

	SELECT	product_id AS ProductId, rate_id AS RateId, term_months AS Term,
			eff_date AS EffectiveDate, due_date AS EndDate, rate AS Rate, GrossMargin
	INTO	#CurrentData
	FROM	common_product_rate (NOLOCK)
	WHERE	product_id	= @ProductId
	AND		rate_id		= @RateId

	IF @DealDate IS NULL OR @DealDate = @Today
	BEGIN
		SELECT *
		FROM #CurrentData
	END
	ELSE
	BEGIN
		SELECT	product_id AS ProductId, rate_id AS RateId, term_months AS Term,
				eff_date AS EffectiveDate, eff_date AS EndDate, rate AS Rate, GrossMargin
		INTO	#HistoricalData
		FROM	product_rate_history (NOLOCK)
		WHERE	product_id	= @ProductId
		AND		rate_id		= @RateId
		AND		eff_date	= @DealDate
		
		-- If there is no historical record found, we will use the current data.
		IF NOT EXISTS (select * from #HistoricalData)
			SELECT * FROM #CurrentData
		ELSE
			SELECT * FROM #HistoricalData
	END

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power


