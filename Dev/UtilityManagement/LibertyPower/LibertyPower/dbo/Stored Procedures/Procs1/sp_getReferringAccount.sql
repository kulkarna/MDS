
CREATE PROCEDURE dbo.sp_getReferringAccount (
	@startDate DATETIME, @endDate DATETIME, @referringCustomersAccountStatus VARCHAR(255)) AS 
BEGIN
	SET NOCOUNT ON;

--	SELECT 
--		AccountNumber, CurrentAccountStatus, CompanyName, CustomerFullName, PhoneNumber, Email, BillingAddress, BillingAddress2, 
--		BillingCity, BillingState, BillingZip, AdditionalNotes, DealCaptureNotes
--	FROM 
--		referral 
--	WHERE 
--		creationdate>=@startDate AND creationdate<=@endDate; -- @referringCustomersAccountStatus ?
END;
