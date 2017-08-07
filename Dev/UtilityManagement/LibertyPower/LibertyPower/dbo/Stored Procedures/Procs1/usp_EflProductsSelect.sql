
/*******************************************************************************
 * usp_EflProductsSelect
 * To get products by account type
 *
 * History
 *******************************************************************************
 * 7/29/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EflProductsSelect]
	@AccountType	varchar(50),
	@Process		varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	DISTINCT AccountTypeID, ProductId, ProductDescription
	FROM	EflParameters u WITH (NOLOCK)
			INNER JOIN AccountType a WITH (NOLOCK) ON a.ID = u.AccountTypeID
			INNER JOIN EflProcess p ON u.EflProcessID = p.ID
	WHERE	a.AccountType	= @AccountType
	AND		p.Process		= @Process
	AND		ProductId IS NOT NULL
	AND		ProductDescription IS NOT NULL	
	ORDER BY ProductDescription DESC
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power

