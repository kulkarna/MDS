CREATE PROCEDURE [dbo].[usp_CustomersSelect]
	
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select 
		C.CustomerID,
		C.NameID,
		N1.Name as CustomerName,
		C.OwnerNameID,
		N2.Name as OwnerName,
		C.AddressID,
		C.CustomerPreferenceID,
		C.ContactID,
		C.DBA,
		C.Duns,
		C.SsnClear,
		C.SsnEncrypted,
		C.TaxId,
		C.EmployerId,
		C.CreditAgencyID,
		C.CreditScoreEncrypted,
		C.BusinessTypeID,
		C.BusinessActivityID,
		C.ExternalNumber,
		C.Modified,
		C.ModifiedBy,
		C.DateCreated,
		C.CreatedBy
	From 
		LibertyPower.dbo.Customer C with (nolock)
		Left Outer Join Name N1 with (nolock) On C.NameID = N1.NameID
		Left Outer Join Name N2 with (nolock) On C.OwnerNameID = N2.NameID	
END

