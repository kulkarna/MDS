USE [Libertypower]
GO
/****** Object:  Trigger [dbo].[zAuditAccountInsert]    Script Date: 12/09/2013 15:15:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table AuditAccount
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
		,'INS'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
	FROM inserted
	
	SET NOCOUNT OFF;
END
