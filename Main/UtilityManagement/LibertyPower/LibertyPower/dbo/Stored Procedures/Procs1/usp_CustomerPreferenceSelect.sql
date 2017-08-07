CREATE PROCEDURE [dbo].[usp_CustomerPreferenceSelect]
	@CustomerPreferenceID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select 
		CustomerPreferenceID,		
		IsGoGreen,
		OptOutSpecialOffers,
		LanguageID,
		Pin,
		Modified,
		ModifiedBy,
		DateCreated,
		CreatedBy		
	From 
		LibertyPower.dbo.CustomerPreference with (nolock)		
	Where 
		CustomerPreferenceID = @CustomerPreferenceID 
END

