

CREATE PROCEDURE [dbo].[usp_AccountsByCustomerIdSelect]
	@CustomerId Int
as
BEGIN

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	SELECT
		A.[AccountID],
		A.[AccountIdLegacy],
		A.[AccountNumber],
		A.[AccountTypeID],
		A.[CustomerID],
		A.[CustomerIdLegacy],
		A.[EntityID],
		A.[RetailMktID],
		A.[UtilityID],
		A.[AccountNameID],
		A.[BillingAddressID],
		A.[BillingContactID],
		A.[ServiceAddressID],
		A.[Origin],
		A.[TaxStatusID],
		A.[PorOption],
		A.[BillingTypeID],
		A.[Zone],
		A.[ServiceRateClass],
		A.[StratumVariable],
		A.[BillingGroup],
		A.[Icap],
		A.[Tcap],
		A.[LoadProfile],
		A.[LossCode],
		A.[MeterTypeID],
		A.[CurrentContractID],
		A.[CurrentRenewalContractID],
		A.[Modified],
		A.[ModifiedBy],
		A.[DateCreated],
		A.[CreatedBy],
		A.[MigrationComplete],
		N.Name as AccountName
	FROM 
		LibertyPower.[dbo].[Account] A (NOLOCK)
		Inner Join LibertyPower.[dbo].[Name] N On A.AccountNameID = N.NameID
	WHERE
		CustomerId = @CustomerId
	
END	

