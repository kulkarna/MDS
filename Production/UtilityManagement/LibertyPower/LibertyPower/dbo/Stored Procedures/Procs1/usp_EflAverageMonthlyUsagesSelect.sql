/*******************************************************************************
 * usp_EflAverageMonthlyUsagesSelect
 * To get average monthly usages for specified account type
 *
 * History
 *******************************************************************************
 * 7/22/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EflAverageMonthlyUsagesSelect]
	@AccountType	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	AccountTypeID, AverageMonthlyUsage
	FROM	EflParameters u WITH (NOLOCK)
			INNER JOIN AccountType a WITH (NOLOCK) ON a.ID = u.AccountTypeID
	WHERE	a.AccountType	= @AccountType
	AND		AverageMonthlyUsage IS NOT NULL
	ORDER BY AverageMonthlyUsage
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
