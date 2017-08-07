USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountUpdateAsDoNotEnroll]    Script Date: 04/23/2012 15:08:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rafael Vasconcelos
-- Create date: 5/15/2012
-- Description:	Update an account marked as "do not enroll". 
--				Used for the Gridview in send_do_not_enroll_account.aspx (Enrollment app)
-- =============================================
CREATE PROCEDURE [dbo].[usp_AccountUpdateAsDoNotEnroll]
(
	@UserName VARCHAR(100),
	@AccNumber VARCHAR (30),
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
	
		UPDATE
		AA
		SET 
		AA.Address = @Street,
		AA.State = @State,
		AA.City = @City,
		AA.Zip = @Zip
		FROM
		lp_account..account_address AA
		JOIN LibertyPower..Account A ON A.BillingAddressID = AA.AccountAddressID
		WHERE
		A.AccountNumber = @AccNumber
		
		UPDATE
		AN
		SET
		AN.Full_name = @AccName
		FROM
		lp_account..account_name AN
		JOIN LibertyPower..Account A ON A.AccountNameID = AN.AccountNameID
		WHERE
		A.AccountNumber = @AccNumber
		
		UPDATE
		AC
		SET
		AC.Phone = @Phone
		FROM
		lp_account..account_contact AC
		JOIN LibertyPower..Account A ON A.BillingContactID = AC.AccountContactID
		WHERE
		A.AccountNumber = @AccNumber
		
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