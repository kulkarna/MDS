
CREATE PROCEDURE [dbo].[usp_CustomerPreferenceInsert]				
		@IsGoGreen bit=null,
		@OptOutSpecialOffers bit=null,
		@LanguageID int=null,
		@Pin varchar(16)=null,					
		@ModifiedBy int=null,
		@CreatedBy int=null
AS
BEGIN 
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
					
	INSERT INTO [dbo].[CustomerPreference]
	(				
		[IsGoGreen],
		[OptOutSpecialOffers],
		[LanguageID],
		[Pin],
		[Modified],
		[ModifiedBy],
		[DateCreated],
		[CreatedBy]
	)
	VALUES
	(		
		@IsGoGreen,
		@OptOutSpecialOffers,
		@LanguageID,
		@Pin,
		getdate(),
		@ModifiedBy,
		getdate(),
		@CreatedBy
	)
		
	DECLARE @CustomerPreferenceID INT
	SET @CustomerPreferenceID = SCOPE_IDENTITY()
	
	EXEC LibertyPower.dbo.usp_CustomerPreferenceSelect @CustomerPreferenceID
	
	RETURN @CustomerPreferenceID

END
