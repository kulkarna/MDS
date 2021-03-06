USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceMultiInsert]    Script Date: 09/20/2012 08:42:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceMultiInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCrossPriceMultiInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceMultiInsert]') AND type in (N'P', N'PC'))
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
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceMultiInsert]
	@ProductCrossPriceID	int,
	@StartDate				datetime, 
	@Term					int, 
	@MarkupRate				decimal(13,5), 
	@Price					decimal(13,5)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS(	SELECT	NULL 
					FROM	Libertypower..ProductCrossPriceMulti WITH (NOLOCK) 
					WHERE	ProductCrossPriceID	= @ProductCrossPriceID
					AND		StartDate			= @StartDate
					AND		Term				= @Term
				  )
		BEGIN                                                                                                                               
			INSERT INTO	Libertypower..ProductCrossPriceMulti (ProductCrossPriceID, StartDate, Term, MarkupRate, Price)
			VALUES		(@ProductCrossPriceID, @StartDate, @Term, @MarkupRate, @Price)
		END

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
