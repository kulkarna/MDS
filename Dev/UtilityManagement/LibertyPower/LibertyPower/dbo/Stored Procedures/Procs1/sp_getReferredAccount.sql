
CREATE PROCEDURE dbo.sp_getReferredAccount (
	@startDate DATETIME, @endDate DATETIME, @referringCustomersAccountStatus VARCHAR(255)) AS 
BEGIN
	SET NOCOUNT ON;

--	SELECT 
--		'' AS creationdate, confirmation_code, '' AS salesrepresentative, '' AS leadid, '' AS disposition, company_name, first_name, 
--		last_name, phone_number, email_address 
--	FROM 
--		referral 
--	WHERE 
--		creationdate>=@startDate AND creationdate<=@endDate; -- @referringCustomersAccountStatus ?
END;
