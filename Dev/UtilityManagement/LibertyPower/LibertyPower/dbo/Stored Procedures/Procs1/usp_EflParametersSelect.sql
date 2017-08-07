/*******************************************************************************
 * usp_EflParametersSelect
 * To get various parameters for web UI
 *
 * History
 *******************************************************************************
 * 7/29/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EflParametersSelect]
	@AccountType	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	DISTINCT AccountTypeID, ProductId, ProductDescription, Term, MonthlyServiceCharge
	FROM	EflParameters u WITH (NOLOCK)
			INNER JOIN AccountType a WITH (NOLOCK) ON a.ID = u.AccountTypeID
	WHERE	a.AccountType	= @AccountType
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
