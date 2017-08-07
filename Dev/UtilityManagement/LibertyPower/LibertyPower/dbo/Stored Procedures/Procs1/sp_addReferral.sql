CREATE PROCEDURE dbo.sp_addReferral (
	@accountNumber varchar(30), @contactFirstName varchar(50), @contactLastName varchar(50), @companyName varchar(50), 
	@phoneNumber varchar(15), @emailAddress varchar(255)) AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @accountID CHAR(12);
	DECLARE @confirmCode INT;

	SELECT @accountID = account_id FROM lp_account..account WHERE account_number=@accountNumber;
	SELECT @confirmCode = ROUND(RAND() * POWER(10, 6), 0);

	INSERT INTO referral VALUES (@accountID, @contactFirstName, @contactLastName, @companyName, @phoneNumber, @emailAddress, @confirmCode, 'New', GETDATE(), GETDATE(), @accountNumber, NULL);

	RETURN @confirmCode;
END;
