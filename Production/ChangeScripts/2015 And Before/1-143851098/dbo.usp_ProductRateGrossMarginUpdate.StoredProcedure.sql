USE [Lp_common]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductRateGrossMarginUpdate]    Script Date: 07/08/2013 11:18:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductRateGrossMarginUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductRateGrossMarginUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductRateGrossMarginUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_ProductRateGrossMarginUpdate
 * Updates gross margin value for specified product and rate id
 *
 * History
 *******************************************************************************
 * 7/3/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductRateGrossMarginUpdate]
	@ProductId		varchar(20),
	@RateId			int,
	@GrossMargin	decimal(9,6)
AS
BEGIN
    SET NOCOUNT ON;

	UPDATE	lp_common..common_product_rate
	SET		GrossMargin	= @GrossMargin
	WHERE	product_id	= @ProductId
	AND		rate_id		= @RateId

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
