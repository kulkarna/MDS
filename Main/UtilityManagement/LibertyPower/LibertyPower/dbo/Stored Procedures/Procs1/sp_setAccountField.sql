CREATE PROCEDURE [dbo].[sp_setAccountField] (
	@accountNumber varchar(30) = 0, 
	@zipcode varchar(10), 
	@fieldName varchar(255), 
	@value varchar(255)) AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @accountID char(12);

	SELECT 
		@accountID = a.account_id 
	FROM 
		 lp_account..account AS a WITH (NOLOCK) 
	JOIN lp_account..account_address AS b WITH (NOLOCK) 
	on a.account_id = b.account_id
	and a.service_address_link = b.address_link
	WHERE 
		a.account_id=b.account_id 
	AND a.account_number=@accountNumber 
	AND b.zip=@zipcode


	INSERT INTO AccountChangeRequest VALUES (@accountID, @fieldName, @value);
END;
