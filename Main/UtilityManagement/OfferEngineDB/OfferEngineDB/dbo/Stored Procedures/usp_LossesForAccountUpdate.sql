
/*******************************************************************************
 * usp_LossesForAccountUpdate
 * update loss value for account
 *
 * History
 *******************************************************************************
 * 5/17/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_LossesForAccountUpdate]
	@UtilityCode	varchar(50),
	@AccountNumber	varchar(50),
	@Losses			decimal(18,9)
AS
BEGIN
    SET NOCOUNT ON;
   
	UPDATE	OE_ACCOUNT
	SET		LOSSES			= @Losses
	WHERE	UTILITY			= @UtilityCode
	AND		ACCOUNT_NUMBER	= @AccountNumber

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


