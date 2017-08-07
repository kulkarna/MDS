

CREATE PROCEDURE [dbo].[usp_UtilityClassLossFactorUpdate]
	@MarketID	   int,
	@UtilityID	   int,
	@AccountTypeID int,
	@Active	       varchar(50),
	@VoltageID     int,
	@LossFactor    decimal(20,16)
AS
BEGIN
    SET NOCOUNT ON;
               
	Update
		UtilityClassMapping
	Set
		LossFactor =  @LossFactor
	Where
		(UtilityId in (Select U.ID From Utility U Inner Join Market M On U.MarketID = M.ID Where M.ID = @MarketID) Or @MarketID = 0) And
		(UtilityID = @UtilityID Or @UtilityID = 0) And
		(AccountTypeID = @AccountTypeID Or @AccountTypeID = 0) And 
		((IsActive = 1 And @Active = 'ACTIVE') Or (IsActive = 0 And @Active = 'INACTIVE') Or (@Active = 'ALL')) And
		VoltageID = @VoltageID
		
    SET NOCOUNT OFF;
END
