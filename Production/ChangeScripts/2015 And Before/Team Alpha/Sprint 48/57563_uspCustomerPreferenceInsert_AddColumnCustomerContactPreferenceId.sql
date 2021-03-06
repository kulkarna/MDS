/********************************************************************************
 * usp_CustomerPreferenceUpdate
 * Add a customer preferences table entry.
 *
 * History
 *******************************************************************************
 * <Date Created,date,> - Unknown
 * Created.
 *******************************************************************************
 * 01/08/2015 - Fernando Alves
 * PBI 57563 - Updates the CustomerPreferenceInsert stored procedure by adding a 
 * new column CustomerContactPreferenceID.
 *******************************************************************************
 */

USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_CustomerPreferenceInsert]    Script Date: 01/09/2015 13:12:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_CustomerPreferenceInsert]				
		@IsGoGreen bit=null,
		@OptOutSpecialOffers bit=null,
		@LanguageID int=null,
		@Pin varchar(16)=null,					
		@CustomerContactPreferenceID int=null, 
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
		[CustomerContactPreferenceId],
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
		@CustomerContactPreferenceID,
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
