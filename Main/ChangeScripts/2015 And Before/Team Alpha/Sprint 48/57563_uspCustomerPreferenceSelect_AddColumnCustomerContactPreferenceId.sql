/********************************************************************************
 * usp_CustomerPreferenceSelect
 * Return a customer preference based in the given ID.
 *
 * History
 *******************************************************************************
 * <Date Created,date,> - Unknown
 * Created.
 *******************************************************************************
 * 01/09/2015 - Fernando Alves
 * PBI 57563 - Add a new return column CustomerContactPreferenceID.
 *******************************************************************************
 */
USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_CustomerPreferenceSelect]    Script Date: 01/10/2015 11:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_CustomerPreferenceSelect]
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
		CreatedBy,
		CustomerContactPreferenceID
	From 
		LibertyPower.dbo.CustomerPreference with (nolock)		
	Where 
		CustomerPreferenceID = @CustomerPreferenceID 
END

