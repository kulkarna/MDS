

/*
*
* PROCEDURE:	usp_AccountSelect
*
* DEFINITION:  Selects all records from Account
*
* RETURN CODE: 
*
* REVISIONS:	Jaime Forero
*/


CREATE PROCEDURE [dbo].[usp_AccountSelect]
	@AccountID INT
as
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	Select
		AccountID,
		AccountIdLegacy,
		AccountNumber,
		AccountTypeID,
		CustomerID,
		CustomerIdLegacy,
		EntityID,
		RetailMktID,
		UtilityID,
		AccountNameID,
		N.Name as AccountName,
		BillingAddressID,
		BillingContactID,
		ServiceAddressID,
		Origin,
		TaxStatusID,
		PorOption,
		BillingTypeID,
		Zone,
		ServiceRateClass,
		StratumVariable,
		BillingGroup,
		Icap,
		Tcap,
		LoadProfile,
		LossCode,
		MeterTypeID,
		CurrentContractID,
		CurrentRenewalContractID,
		A.Modified,
		A.ModifiedBy,
		A.DateCreated,
		A.CreatedBy,
		MigrationComplete
	From
		LibertyPower.[dbo].[Account] A with (nolock)
		Left Outer Join Name N with (nolock) On A.AccountNameID = N.NameID
	Where
		AccountID = @AccountID		
END	
