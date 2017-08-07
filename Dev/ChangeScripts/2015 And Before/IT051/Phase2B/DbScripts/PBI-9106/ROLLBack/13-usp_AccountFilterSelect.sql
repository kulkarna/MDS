USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountFilterSelect]    Script Date: 12/09/2013 16:07:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
*
* PROCEDURE:	[usp_AccountFilterRead]
*
* DEFINITION:  Selects all records from Account matching the filter criteria, if no 
			parameter is submitted (or null) then is ignored and not used in the query
				
*
* RETURN CODE: 
*
* REVISIONS:	7/8/2011 Jaime Forero

EXEC [usp_AccountFilterSelect] @UtilityID = 22, @AccountNumber = '08015941530000802553'

*/

ALTER PROCEDURE [dbo].[usp_AccountFilterSelect]
	@AccountIdLegacy	CHAR(12) = NULL,
	@AccountNumber		VARCHAR(30) = NULL,
	@AccountTypeID		INT	= NULL,
	@CustomerID			INT = NULL,
	@UtilityID			INT	= NULL
AS 
BEGIN
--  set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	SELECT 
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
	FROM LibertyPower.[dbo].[Account] A (NOLOCK)
	LEFT JOIN Name N with (nolock) On A.AccountNameID = N.NameID
	WHERE	(@AccountIdLegacy IS NULL OR AccountIdLegacy  = ISNULL(@AccountIdLegacy, AccountIdLegacy))
	AND		(@AccountNumber   IS NULL OR AccountNumber	  = ISNULL(@AccountNumber, AccountNumber))
	AND		(@AccountTypeID   IS NULL OR AccountTypeID	  = ISNULL(@AccountTypeID, AccountTypeID))
	AND		(@CustomerID      IS NULL OR CustomerID		  = ISNULL(@CustomerID, CustomerID))
	AND		(@UtilityID       IS NULL OR UtilityID		  = ISNULL(@UtilityID, UtilityID))
	
 END	

