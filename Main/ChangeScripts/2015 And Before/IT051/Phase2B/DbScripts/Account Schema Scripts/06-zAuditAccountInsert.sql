USE [Libertypower]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table AuditAccount
-- =============================================================
--Modified	: Added Default ProfileID column. 
--By		: Gail Mangaroo
--Date		: 4/15/2013
-- =============================================================
ALTER TRIGGER [dbo].[zAuditAccountInsert]
	ON  [dbo].[Account]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditAccount] (
		[AccountID]
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
		,[CurrentContractID]
		,[CurrentRenewalContractID]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,[MigrationComplete]

		,[DeliveryLocationRefID]
		,[LoadProfileRefID]
		,[ServiceClassRefID]

		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		[AccountID]
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
		,[CurrentContractID]
		,[CurrentRenewalContractID]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,[MigrationComplete]

		,[DeliveryLocationRefID]
		,[LoadProfileRefID]
		,[ServiceClassRefID]

		,'INS'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
	FROM inserted
	
	SET NOCOUNT OFF;
END
GO