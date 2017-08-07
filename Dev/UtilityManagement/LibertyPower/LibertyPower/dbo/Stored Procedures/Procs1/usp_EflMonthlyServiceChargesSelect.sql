/*******************************************************************************
 * usp_EflMonthlyServiceChargesSelect
 * To get monthly service charges by account type
 *
 * History
 *******************************************************************************
 * 7/29/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EflMonthlyServiceChargesSelect]
	@AccountType	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	DISTINCT AccountTypeID, MonthlyServiceCharge
	FROM	EflParameters u WITH (NOLOCK)
			INNER JOIN AccountType a WITH (NOLOCK) ON a.ID = u.AccountTypeID
	WHERE	a.AccountType	= @AccountType
	AND		MonthlyServiceCharge IS NOT NULL
	ORDER BY MonthlyServiceCharge DESC
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
