USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_MultiTermByAccountIdLegacySelect]    Script Date: 10/10/2012 08:56:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MultiTermByAccountIdLegacySelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_MultiTermByAccountIdLegacySelect]
GO
/****** Object:  StoredProcedure [dbo].[usp_MultiTermByAccountIdLegacySelect]    Script Date: 10/10/2012 08:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MultiTermByAccountIdLegacySelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_MultiTermByAccountIdLegacySelect
 * Gets sub-terms for specified legacy account id
 *
 * History
 *******************************************************************************
 * 10/9/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_MultiTermByAccountIdLegacySelect]
	@AccountIdLegacy	char(12)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@PriceID				bigint,
			@ProductCrossPriceID	int
                                                                                                               
	SELECT	TOP 1 @PriceID = r.PriceID
	FROM	Libertypower..Account a WITH (NOLOCK)
			INNER JOIN Libertypower..AccountContract c WITH (NOLOCK)
			ON a.AccountID = c.AccountID
			INNER JOIN Libertypower..AccountContractRate r WITH (NOLOCK)
			ON c.AccountContractID = r.AccountContractID			
	WHERE	a.AccountIdLegacy	= @AccountIdLegacy
	AND		r.IsContractedRate	= 1
	ORDER BY r.AccountContractRateID DESC
	
	SELECT	m.ProductCrossPriceMultiID, m.ProductCrossPriceID, m.StartDate, m.Term, m.MarkupRate, m.Price
	FROM	Libertypower..Price p WITH (NOLOCK)
			INNER JOIN Libertypower..ProductCrossPriceMulti m WITH (NOLOCK)
			ON p.ProductCrossPriceID = m.ProductCrossPriceID
	WHERE	p.ID = @PriceID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
' 
END
GO
