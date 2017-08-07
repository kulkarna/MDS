/*******************************************************************************
 * usp_EflDefaultProductSelect
 * Select default product record for soecified market, month, and year
 *
 * History
 *******************************************************************************
 * 8/4/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EflDefaultProductSelect]
	@AccountType	varchar(50),
	@MarketCode		varchar(50),
	@Month			int,
	@Year			int
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	TOP 1 p.[ID], MarketCode, [Month], [Year], Mcpe, Adder, Username, p.DateCreated
	FROM	EflDefaultProduct p WITH (NOLOCK)
			INNER JOIN AccountType a WITH (NOLOCK) ON p.AccountTypeID = a.ID
			WHERE	AccountType	= @AccountType
			AND		MarketCode	= @MarketCode
			AND		[Month]		= @Month
			AND		[Year]		= @Year
	ORDER BY p.[ID] DESC
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
