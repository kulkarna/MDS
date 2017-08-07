-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- ADD @IsSilent parameter for procedure calls
-- =======================================

CREATE  PROCEDURE [dbo].[usp_CustomerContactCompleteInsert]
	@CustomerID INT,
	@FirstName NVARCHAR(50) = null,
	@LastName NVARCHAR(50) = null,
	@Title NVARCHAR(50) = null,
	@Phone VARCHAR(20) = null,
	@Fax VARCHAR(20) = '',
	@Email NVARCHAR(75) = null,
	@Birthdate DATETIME = null,	
	@ModifiedBy INT = null,
	@CreatedBy int
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @ContactID INT;

	EXECUTE @ContactID = [Libertypower].[dbo].[usp_ContactInsert] 
	   @FirstName
	  ,@LastName
	  ,@Title
	  ,@Phone
	  ,@Fax
	  ,@Email
	  ,@Birthdate
	  ,@ModifiedBy
	  ,@CreatedBy
	  ,1


	DECLARE @CustomerContactID int
	EXECUTE @CustomerContactID = [Libertypower].[dbo].[usp_CustomerContactInsert] 
		   @CustomerID
		  ,@ContactID
		  ,@ModifiedBy
		  ,@CreatedBy
		  ,1
		  	
	RETURN @ContactID;
END



