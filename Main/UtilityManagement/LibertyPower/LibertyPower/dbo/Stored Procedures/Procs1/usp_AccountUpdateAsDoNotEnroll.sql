-- =============================================
-- Author:		Rafael Vasconcelos
-- Modified date: 7/3/2012
-- Description:	Changed joins with account_contact, account_address and account_name. They are using the AccountID instead of using address, contact and name ID keys. 				
-- =============================================
-- =============================================
-- Author:		Rafael Vasconcelos
-- Create date: 5/15/2012
-- Description:	Update an account marked as "do not enroll". 
--				Used for the Gridview in send_do_not_enroll_account.aspx (Enrollment app)
-- =============================================
CREATE PROCEDURE [dbo].[usp_AccountUpdateAsDoNotEnroll]
(
	@UserName VARCHAR(100),
	@AccNumber VARCHAR(30),
	@AccName VARCHAR(100),
	@ExpirationDays INT,
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
	
	BEGIN TRAN
		
		DECLARE @UserID AS INT
		SELECT @UserID = UserID FROM LibertyPower..[User] WHERE UserName = @UserName	
		
		DECLARE @AccountId AS INT
		SELECT @AccountId = AccountId FROM LibertyPower..account WHERE AccountNumber = @AccNumber

		UPDATE
		AA
		SET 
		AA.Address1 = @Street,
		AA.[State] = @State,
		AA.City = @City,
		AA.Zip = @Zip
		FROM
		libertypower..[address] AA
		JOIN LibertyPower..Account A ON A.ServiceAddressId = AA.addressid
		WHERE
		A.AccountId = @AccountId
		
		UPDATE
		AN
		SET
		AN.Name = @AccName
		FROM
		[Libertypower]..[Name] AN
		JOIN LibertyPower..Account A ON A.AccountNameId = AN.NameId
		WHERE
		A.AccountId = @AccountId
		
		UPDATE
		AC
		SET
		AC.Phone = @Phone
		FROM
		libertypower..contact AC
		JOIN LibertyPower..Account A ON A.CustomerId = AC.ContactId
		WHERE
		A.AccountId = @AccountId
		
		UPDATE
		ADT
		SET
		ADT.NumberOfDays = @ExpirationDays,
		ADT.ExpirationDate = DATEADD(DAY, @ExpirationDays, A.DateCreated),
		ADT.Modified = GETDATE(),
		ADT.ModifiedBy = @UserID
		FROM
		LibertyPower..AccountDateDetails ADT 
		JOIN LibertyPower..Account A ON ADT.AccountID = A.AccountID 		
		WHERE
		A.AccountNumber = @AccNumber
		
	COMMIT
		
		--ADT.ModifiedBy = @UserName
		--UPDATE
		--LibertyPower..Account,
		--lp_account..account_address,
		--lp_account..account_contact, 
		--lp_account..account_name,
		--LibertyPower..Utility,
		--LibertyPower..AccountDetail, 
		--LibertyPower..AccountDateDetails 
		--SET
		--AN.Full_name = @AccName,
		--AC.Phone = @Phone,
		--AA.Address = @Street,
		--AA.State = @State,
		--AA.City = @City,
		--AA.Zip = @Zip,
		--ADT.ExpirationDate = @ExpirationDate,
		--AD.Modified = GETDATE(),
		--AD.ModifiedBy = @UserName,
		--ADT.Modified = GETDATE(),
		--ADT.ModifiedBy = @UserName
		
		--FROM
		--LibertyPower..Account A
		--LEFT JOIN lp_account..account_address AA ON A.BillingAddressID = AA.AccountAddressID
		--LEFT JOIN lp_account..account_contact AC ON A.BillingContactID = AC.AccountContactID
		--LEFT JOIN lp_account..account_name AN ON A.AccountNameID = AN.AccountNameID
		--LEFT JOIN LibertyPower..Utility U ON A.UtilityID = U.ID
		--LEFT JOIN LibertyPower..AccountDetail AD ON A.AccountID = AD.AccountID
		--LEFT JOIN LibertyPower..AccountDateDetails ADT ON ADT.AccountID = A.AccountID
		--WHERE AD.EnrollmentTypeID = 9
		--AND A.AccountNumber = @AccNumber

END 