
/*******************************************************************************
 * usp_EflChargesInsert
 * Insert/update EFL Charges
 *
 * History
 *******************************************************************************
 * 8/6/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EflChargesInsert]
	@UtilityCode	varchar(50),
	@AccountType	varchar(50),
	@TdspFixed		decimal(10,3),
	@TdspKwh		decimal(10,7),
	@TdspFixedAbove	decimal(10,3),
	@TdspKwhAbove	decimal(10,7),
	@TdspKw			decimal(10,7)			
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS(	SELECT	NULL
				FROM	EflCharges c WITH (NOLOCK)
						INNER JOIN AccountType a WITH (NOLOCK) ON a.ID = c.AccountTypeID
						INNER JOIN Utility u WITH (NOLOCK) ON u.ID = c.UtilityID
				WHERE	u.UtilityCode	= @UtilityCode
				AND		a.AccountType	= @AccountType    
			)
		BEGIN
			UPDATE	EflCharges
			SET		TdspFixed		= @TdspFixed,
					TdspKwh			= @TdspKwh,
					TdspFixedAbove	= @TdspFixedAbove,
					TdspKwhAbove	= @TdspKwhAbove,	
					TdspKw			= @TdspKw			
			FROM	EflCharges c WITH (NOLOCK)
					INNER JOIN AccountType a WITH (NOLOCK) ON a.ID = c.AccountTypeID
					INNER JOIN Utility u WITH (NOLOCK) ON u.ID = c.UtilityID
			WHERE	u.UtilityCode	= @UtilityCode
			AND		a.AccountType	= @AccountType 					
		END
	ELSE
		BEGIN
			DECLARE	@UtilityID		int,
					@AccountTypeID	int,
					@LpFixed		decimal(10,2)
					
			SELECT @UtilityID = [ID] FROM Utility WHERE UtilityCode	= @UtilityCode
			SELECT @AccountTypeID = [ID] FROM AccountType WHERE AccountType	= @AccountType
			SELECT @LpFixed = MAX(MonthlyServiceCharge) FROM EflParameters WHERE AccountTypeID = @AccountTypeID
					
			INSERT INTO	EflCharges (UtilityID, AccountTypeID, LpFixed, TdspFixed, TdspKwh,
						TdspFixedAbove, TdspKwhAbove, TdspKw)
			VALUES		(@UtilityID, @AccountTypeID, @LpFixed, @TdspFixed, @TdspKwh,
						@TdspFixedAbove, @TdspKwhAbove, @TdspKw)
						
		END
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power

