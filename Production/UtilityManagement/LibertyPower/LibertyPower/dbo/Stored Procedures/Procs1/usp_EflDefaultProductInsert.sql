/*******************************************************************************
 * usp_EflDefaultProductInsert
 * Insert new default product record
 *
 * History
 *******************************************************************************
 * 8/4/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EflDefaultProductInsert]
	@MarketCode		varchar(50),
	@AccountType	varchar(50),
	@Month			int,
	@Year			int,
	@Mcpe			decimal(10,5),
	@Adder			decimal(10,5),
	@Username		varchar(100),
	@DateCreated	datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@AccountTypeID	int
    
    SELECT	@AccountTypeID = ID FROM AccountType WHERE AccountType = @AccountType
    
	INSERT INTO	EflDefaultProduct(MarketCode, AccountTypeID, [Month], [Year], Mcpe, Adder, Username, DateCreated)
	VALUES		(@MarketCode, @AccountTypeID, @Month, @Year, @Mcpe, @Adder, @Username, @DateCreated)
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
