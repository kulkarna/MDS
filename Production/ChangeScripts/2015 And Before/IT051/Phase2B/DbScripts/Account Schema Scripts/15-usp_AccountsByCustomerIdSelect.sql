USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountsByCustomerIdSelect]    Script Date: 10/15/2013 17:39:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[usp_AccountsByCustomerIdSelect]
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
		N.Name as AccountName, 
		A.[DeliveryLocationRefId],
		A.[LoadProfileRefId],
		A.[ServiceClassRefID]
		
	FROM 
		LibertyPower.[dbo].[Account] A (NOLOCK)
		Inner Join LibertyPower.[dbo].[Name] N On A.AccountNameID = N.NameID
	WHERE
		CustomerId = @CustomerId
	
END	

