USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceMultiSelect]    Script Date: 09/20/2012 08:42:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceMultiSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCrossPriceMultiSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceMultiSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_ProductCrossPriceMultiSelect
 * Gets sub-terms for specified product cross price ID
 *
 * History
 *******************************************************************************
 * 9/18/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceMultiSelect]
	@ProductCrossPriceID	int
AS
BEGIN
    SET NOCOUNT ON;
                                                                                                                               
	SELECT	ProductCrossPriceMultiID, ProductCrossPriceID, StartDate, Term, MarkupRate, Price
	FROM	Libertypower..ProductCrossPriceMulti WITH (NOLOCK)
	WHERE	ProductCrossPriceID = @ProductCrossPriceID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
' 
END
GO
