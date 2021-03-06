USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_MultiTermByPriceIDSelect]    Script Date: 10/08/2012 15:36:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MultiTermByPriceIDSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_MultiTermByPriceIDSelect]
GO
/****** Object:  StoredProcedure [dbo].[usp_MultiTermByPriceIDSelect]    Script Date: 10/08/2012 15:36:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MultiTermByPriceIDSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_MultiTermByPriceIDSelect
 * Gets sub-terms for specified price ID
 *
 * History
 *******************************************************************************
 * 10/8/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_MultiTermByPriceIDSelect]
	@PriceID	bigint
AS
BEGIN
    SET NOCOUNT ON;
                                                                                                                               
	SELECT	m.ProductCrossPriceMultiID, m.ProductCrossPriceID, m.StartDate, m.Term, m.MarkupRate, m.Price
	FROM	Libertypower..ProductCrossPriceMulti m WITH (NOLOCK)
			INNER JOIN Libertypower..Price p WITH (NOLOCK)
			ON m.ProductCrossPriceID = p.ProductCrossPriceID
	WHERE	p.ID = @PriceID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
' 
END
GO
