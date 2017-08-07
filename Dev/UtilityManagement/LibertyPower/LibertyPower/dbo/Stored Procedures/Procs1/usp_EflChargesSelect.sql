
/*******************************************************************************
 * usp_EflChargesSelect
 * To get EFL Charges
 *
 * History
 *******************************************************************************
 * 7/21/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EflChargesSelect]
	@UtilityCode	varchar(50),
	@AccountType	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	UtilityID, AccountTypeID, LpFixed, TdspFixed, TdspKwh,
			TdspFixedAbove, TdspKwhAbove, TdspKw
	FROM	EflCharges c WITH (NOLOCK)
			INNER JOIN AccountType a WITH (NOLOCK) ON a.ID = c.AccountTypeID
			INNER JOIN Utility u WITH (NOLOCK) ON u.ID = c.UtilityID
	WHERE	u.UtilityCode	= @UtilityCode
	AND		a.AccountType	= @AccountType
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power

