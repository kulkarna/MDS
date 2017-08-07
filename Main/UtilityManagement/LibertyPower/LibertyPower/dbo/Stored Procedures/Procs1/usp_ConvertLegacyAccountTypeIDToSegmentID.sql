/*******************************************************************************
 * usp_ConvertLegacyAccountTypeIDToSegmentID
 * Desc
 *
 * History
 *******************************************************************************
 * 8/4/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ConvertLegacyAccountTypeIDToSegmentID]
	@AccountTypeID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	lat.ID
	FROM	LibertyPower..AccountType lat
			INNER JOIN lp_common..product_account_type cat
			ON LEFT(lat.AccountType, 3) = LEFT(cat.account_type, 3)
	WHERE	cat.account_type_id = @AccountTypeID


    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
