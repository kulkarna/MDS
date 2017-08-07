USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountInsertAsDoNotEnroll]    Script Date: 04/23/2012 15:06:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rafael Vasconcelos
-- Create date: 5/15/2012
-- Description:	Selects all accounts marked as "do not enroll". 
--				Used for the page send_do_not_enroll_account.aspx (Enrollment app)
-- =============================================
CREATE PROCEDURE [dbo].[usp_AccountInsertAsDoNotEnroll]
(
	@UserName VARCHAR(100),
	@AccountID CHAR(12),
	@AccNumber VARCHAR(30),
	@AccName VARCHAR(100),
	@RequestedDate DATETIME,
	@ExpirationDate DATETIME,
	@UtilityID INT,
	@Phone VARCHAR(20),
	@Street CHAR(50),
	@City CHAR(28),
	@State CHAR(2),
	@Zip CHAR(10)	
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @AddressID AS INT
	DECLARE @AddressLink AS INT
	DECLARE @ContactID AS INT
	DECLARE @ContactLink AS INT
	DECLARE @AccountNameID AS INT
	DECLARE @NameLink AS INT
	DECLARE @UserID AS INT
	DECLARE @AccIDKey AS INT
	
	SET @AddressLink = 0
	SET @ContactLink = 0
	SET @NameLink =0
	
	SELECT @AddressLink = ISNULL(MAX(address_link), -1) + 1
		FROM lp_account..account_address
		WHERE account_id = @AccountID

	SELECT @ContactLink = ISNULL(MAX(contact_link), -1) + 1
		FROM lp_account..account_contact
		WHERE account_id = @AccountID
		
	SELECT @NameLink = ISNULL(MAX(name_link), -1) + 1
		FROM lp_account..account_name
		WHERE account_id = @AccountID
	
	INSERT INTO lp_account..account_address	
		SELECT 
		@AccountID,
		@AddressLink,
		@Street,
		'',
		@City,
		@State,
		@Zip,
		'',
		'',
		'',
		0
	
	SET @AddressID = SCOPE_IDENTITY()
	
	INSERT INTO lp_account..account_contact 
		SELECT
		@AccountID,
		@ContactLink,
		'',
		'',
		'',
		@Phone,
		'',
		'',
		'',
		0
	
	SET @ContactID = SCOPE_IDENTITY()
	
	INSERT INTO lp_account..account_name
		SELECT
		@AccountID,
		@NameLink,
		@AccName,
		0
		
	SET @AccountNameID = SCOPE_IDENTITY()
	
	SELECT @UserID = UserID FROM LibertyPower..[User] WHERE UserName = @UserName	
	
	INSERT INTO LibertyPower..Account
		(
			AccountIdLegacy,
			AccountNumber,
			UtilityID,
			AccountNameID,
			BillingAddressID,
			BillingContactID,
			ServiceAddressID,
			DateCreated,
			CreatedBy
		)
	VALUES
		(
			@AccountID,
			@AccNumber,
			@UtilityID,
			@AccountNameID,
			@AddressID,
			@ContactID,
			@AddressID,
			@RequestedDate,
			@UserID
		)
		
	SET @AccIDKey =  SCOPE_IDENTITY()
	
	INSERT INTO LibertyPower..AccountDetail
		VALUES(
			@AccIDKey,
			9, --DO NOT ENROLL
			NULL,
			GETDATE(),
			@UserID,
			GETDATE(),
			@UserID
		)
		
	INSERT INTO LibertyPower..AccountDateDetails
		VALUES(
			@AccIDKey,
			@ExpirationDate,
			DATEDIFF(DAY, @RequestedDate, @ExpirationDate),
			@UserID,
			GETDATE(),
			@UserID,
			GETDATE()			
		)
		
	SELECT @AccIDKey
	
	SET NOCOUNT OFF
END