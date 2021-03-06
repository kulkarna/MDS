/********************************************************************************
 * usp_CustomerPreferenceUpdate
 * Update a customer preferences table entry.
 *
 * History
 *******************************************************************************
 * <Date Created,date,> - Unknown
 * Created.
 *******************************************************************************
 * 01/08/2015 - Fernando Alves
 * PBI 57563 - Updates the CustomerPreferenceUpdate stored procedure by adding a 
 * new column CustomerContactPreferenceID.
 *******************************************************************************
 */
 
USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_CustomerPreferenceUpdate]    Script Date: 01/09/2015 13:12:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_CustomerPreferenceUpdate]
	@CustomerPreferenceID int,		
	@IsGoGreen bit,
	@OptOutSpecialOffers bit,
	@LanguageID int,
	@Pin varchar(16),
	@CustomerContactPreferenceID int, 
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
		CustomerContactPreferenceId = @CustomerContactPreferenceID, 
		Modified = GETDATE(),
		ModifiedBy = @ModifiedBy		
	Where
		CustomerPreferenceID = @CustomerPreferenceID
		
	EXEC LibertyPower.dbo.usp_CustomerPreferenceSelect @CustomerPreferenceID;
			
END

