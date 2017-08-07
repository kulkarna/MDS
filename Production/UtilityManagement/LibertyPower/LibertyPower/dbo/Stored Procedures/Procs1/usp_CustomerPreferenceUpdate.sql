CREATE PROCEDURE [dbo].[usp_CustomerPreferenceUpdate]
	@CustomerPreferenceID int,		
	@IsGoGreen bit,
	@OptOutSpecialOffers bit,
	@LanguageID int,
	@Pin varchar(16),						
	@ModifiedBy int
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Update 
		LibertyPower.dbo.CustomerPreference
	Set		 		
		IsGoGreen = @IsGoGreen,
		OptOutSpecialOffers = @OptOutSpecialOffers,
		LanguageID = @LanguageID,
		Pin = @Pin,
		Modified = GETDATE(),
		ModifiedBy = @ModifiedBy		
	Where
		CustomerPreferenceID = @CustomerPreferenceID
		
	EXEC LibertyPower.dbo.usp_CustomerPreferenceSelect @CustomerPreferenceID;
			
END

