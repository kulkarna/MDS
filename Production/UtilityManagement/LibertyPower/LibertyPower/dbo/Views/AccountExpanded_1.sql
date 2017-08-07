





--select * from ufn_account_sales_channel('libertypower\I2C')

CREATE VIEW [dbo].[AccountExpanded]

AS


	SELECT   [AccountID]
			,[AccountIdLegacy]
			,[AccountNumber]
			,[AccountTypeID]
			,[CustomerID]
			,[CustomerIdLegacy]
			,[EntityID]
			,[RetailMktID]
			,[UtilityID]
			,[AccountNameID]
			,[BillingAddressID]
			,[BillingContactID]
			,[ServiceAddressID]
			,[Origin]
			,[TaxStatusID]
			,[PorOption]
			,[BillingTypeID]
			,[Zone]
			,[ServiceRateClass]
			,[StratumVariable]
			,[BillingGroup]
			,[Icap]
			,[Tcap]
			,[LoadProfile]
			,[LossCode]
			,[MeterTypeID]
			,[Modified]
			,[ModifiedBy]
			,[DateCreated]
			,[CreatedBy]
			,CurrentContractID as ContractID
			,IsRenewal = 0 
	FROM LibertyPower..Account (NOLOCK) 
	WHERE CurrentContractID IS NOT NULL
	
	
	
	UNION ALL
	
	SELECT   [AccountID]
			,[AccountIdLegacy]
			,[AccountNumber]
			,[AccountTypeID]
			,[CustomerID]
			,[CustomerIdLegacy]
			,[EntityID]
			,[RetailMktID]
			,[UtilityID]
			,[AccountNameID]
			,[BillingAddressID]
			,[BillingContactID]
			,[ServiceAddressID]
			,[Origin]
			,[TaxStatusID]
			,[PorOption]
			,[BillingTypeID]
			,[Zone]
			,[ServiceRateClass]
			,[StratumVariable]
			,[BillingGroup]
			,[Icap]
			,[Tcap]
			,[LoadProfile]
			,[LossCode]
			,[MeterTypeID]
			,[Modified]
			,[ModifiedBy]
			,[DateCreated]
			,[CreatedBy]
			,CurrentRenewalContractID as ContractID
			,IsRenewal = 1 
	FROM LibertyPower..Account (NOLOCK) 
	WHERE CurrentRenewalContractID IS NOT NULL