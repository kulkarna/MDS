
CREATE PROCEDURE dbo.sp_getReferral (
	@companyName VARCHAR(50), @email VARCHAR(255)) AS 
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM referral WHERE company_name=@companyName OR email_address=@email;
END;
