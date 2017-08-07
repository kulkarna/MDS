/*******************************************************************************
 * usp_ConvertAccountTypeID
 * Converts segment id to legacy id or vice versa
 *
 * History
 *******************************************************************************
 * 8/4/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ConvertAccountTypeID]
	@AccountTypeID	int,
	@ConvertTo		varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @ConvertTo = 'LEGACY'
		BEGIN
			SELECT	cat.account_type_id AS ID
			FROM	LibertyPower..AccountType lat
					INNER JOIN lp_common..product_account_type cat
					ON LEFT(lat.AccountType, 3) = LEFT(cat.account_type, 3)
			WHERE	lat.ID = @AccountTypeID		
		END
	ELSE
		BEGIN
			SELECT	lat.ID
			FROM	LibertyPower..AccountType lat
					INNER JOIN lp_common..product_account_type cat
					ON LEFT(lat.AccountType, 3) = LEFT(cat.account_type, 3)
			WHERE	cat.account_type_id = @AccountTypeID		
		END

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
