USE [Libertypower]
GO
/****** Object:  Trigger [dbo].[zAuditAccountUpdate]    Script Date: 12/09/2013 15:16:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table AuditAccount
-- =============================================================
ALTER TRIGGER [dbo].[zAuditAccountUpdate]
	ON  [dbo].[Account]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ColumnID				INT
			,@Columns				NVARCHAR(max)
			,@ObjectID				INT
			,@ColumnName			NVARCHAR(max)
			,@LastColumnID			INT
			,@ColumnsUpdated		VARCHAR(max)
			,@strQuery				VARCHAR(max)
			
			
	SET @ObjectID					= (SELECT id FROM sysobjects with (nolock) WHERE name='Account')
	SET @LastColumnID				= (SELECT MAX(colid) FROM syscolumns with (nolock) WHERE id=@ObjectID)
	SET @ColumnID					= 1
	
	WHILE @ColumnID <= @LastColumnID 
	BEGIN
		
		IF (SUBSTRING(COLUMNS_UPDATED(),(@ColumnID - 1) / 8 + 1, 1)) &
		POWER(2, (@ColumnID - 1) % 8) = POWER(2, (@ColumnID - 1) % 8)
		begin
			SET @Columns = ISNULL(@Columns + ',', '') + COL_NAME(@ObjectID, @ColumnID)
		end
		set @ColumnID = @ColumnID + 1
	END
		
	SET @ColumnsUpdated = @Columns
	
	IF @ColumnsUpdated  IS NULL
		SET @ColumnsUpdated = ''
 	
	
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
		a.[AccountID]
		,a.[AccountIdLegacy]
		,a.[AccountNumber]
		,a.[AccountTypeID]
		,a.[CustomerID]
		,a.[CustomerIdLegacy]
		,a.[EntityID]
		,a.[RetailMktID]
		,a.[UtilityID]
		,a.[AccountNameID]
		,a.[BillingAddressID]
		,a.[BillingContactID]
		,a.[ServiceAddressID]
		,a.[Origin]
		,a.[TaxStatusID]
		,a.[PorOption]
		,a.[BillingTypeID]
		,a.[Zone]
		,a.[ServiceRateClass]
		,a.[StratumVariable]
		,a.[BillingGroup]
		,a.[Icap]
		,a.[Tcap]
		,a.[LoadProfile]
		,a.[LossCode]
		,a.[MeterTypeID]
		,a.[CurrentContractID]
		,a.[CurrentRenewalContractID]
		,a.[Modified]
		,a.[ModifiedBy]
		,a.[DateCreated]
		,a.[CreatedBy]
		,a.[MigrationComplete]
		,'UPD'						--[AuditChangeType]
		--,a.[AuditChangeDate]		Default Value in SQLServer
		--,a.[AuditChangeBy]			Default Value in SQLServer
		--,a.[AuditChangeLocation]	Default Value in SQLServer
		,@ColumnsUpdated			-- [ColumnsUpdated]
		,CASE WHEN isnull(a.[AccountID],0) <> isnull(b.[AccountID],0) THEN 'AccountID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[AccountIdLegacy],'') <> isnull(b.[AccountIdLegacy],'') THEN 'AccountIdLegacy' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[AccountNumber],'') <> isnull(b.[AccountNumber],'') THEN 'AccountNumber' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[AccountTypeID],0) <> isnull(b.[AccountTypeID],0) THEN 'AccountTypeID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[CustomerID],0) <> isnull(b.[CustomerID],0) THEN 'CustomerID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[CustomerIdLegacy],'') <> isnull(b.[CustomerIdLegacy],'') THEN 'CustomerIdLegacy' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[EntityID],'') <> isnull(b.[EntityID],'') THEN 'EntityID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[RetailMktID],0) <> isnull(b.[RetailMktID],0) THEN 'RetailMktID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[UtilityID],0) <> isnull(b.[UtilityID],0) THEN 'UtilityID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[AccountNameID],0) <> isnull(b.[AccountNameID],0) THEN 'AccountNameID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[BillingAddressID],0) <> isnull(b.[BillingAddressID],0) THEN 'BillingAddressID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[BillingContactID],0) <> isnull(b.[BillingContactID],0) THEN 'BillingContactID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[ServiceAddressID],0) <> isnull(b.[ServiceAddressID],0) THEN 'ServiceAddressID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[Origin],'') <> isnull(b.[Origin],'') THEN 'Origin' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[TaxStatusID],0) <> isnull(b.[TaxStatusID],0) THEN 'TaxStatusID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[PorOption],0) <> isnull(b.[PorOption],0) THEN 'PorOption' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[BillingTypeID],0) <> isnull(b.[BillingTypeID],0) THEN 'BillingTypeID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[Zone],'') <> isnull(b.[Zone],'') THEN 'Zone' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[ServiceRateClass],'') <> isnull(b.[ServiceRateClass],'') THEN 'ServiceRateClass' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[StratumVariable],'') <> isnull(b.[StratumVariable],'') THEN 'StratumVariable' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[BillingGroup],'') <> isnull(b.[BillingGroup],'') THEN 'BillingGroup' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[Icap],'') <> isnull(b.[Icap],'') THEN 'Icap' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[Tcap],'') <> isnull(b.[Tcap],'') THEN 'Tcap' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[LoadProfile],'') <> isnull(b.[LoadProfile],'') THEN 'LoadProfile' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[LossCode],'') <> isnull(b.[LossCode],'') THEN 'LossCode' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[MeterTypeID],0) <> isnull(b.[MeterTypeID],0) THEN 'MeterTypeID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[CurrentContractID],0) <> isnull(b.[CurrentContractID],0) THEN 'CurrentContractID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[Modified],'') <> isnull(b.[Modified],'') THEN 'Modified' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[ModifiedBy],0) <> isnull(b.[ModifiedBy],0) THEN 'ModifiedBy' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[DateCreated],'') <> isnull(b.[DateCreated],'') THEN 'DateCreated' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[CreatedBy],0) <> isnull(b.[CreatedBy],0) THEN 'CreatedBy' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[MigrationComplete],0) <> isnull(b.[MigrationComplete],0) THEN 'MigrationComplete' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[CurrentRenewalContractID],0) <> isnull(b.[CurrentRenewalContractID],0) THEN 'CurrentRenewalContractID' + ',' ELSE '' END
	FROM inserted a
	INNER JOIN deleted b
	on b.[AccountID]		= a.[AccountID]
	SET NOCOUNT OFF;
END
