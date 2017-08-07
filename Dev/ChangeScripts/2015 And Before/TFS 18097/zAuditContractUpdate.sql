USE [Libertypower]
GO
/****** Object:  Trigger [dbo].[zAuditContractUpdate]    Script Date: 09/03/2013 15:51:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table zAuditContract
-- =============================================================
-- Modify		: Jose Munoz - SWCS
-- Create date	: 09/03/2013
-- Description	: RCR - 18097 (Contractstatusid = 2 not updating accountcontract status)
--                in contract table, whencontractstatusid is updated = 2, this means the contract was rejected. 
--				  The accountcontract status in the accountstatus table needs to be updated to reflect 999999-10
-- =============================================================

ALTER TRIGGER [dbo].[zAuditContractUpdate]
	ON  [dbo].[Contract]
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
			
			
	SET @ObjectID					= (SELECT id FROM sysobjects with (nolock) WHERE name='Contract')
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

	INSERT INTO [dbo].[zAuditContract] (
		[ContractID] 
		,[Number] 
		,[ContractTypeID] 
		,[ContractDealTypeID] 
		,[ContractStatusID] 
		,[ContractTemplateID] 
		,[ReceiptDate] 
		,[StartDate] 
		,[EndDate] 
		,[SignedDate] 
		,[SubmitDate] 
		,[SalesChannelID] 
		,[SalesRep] 
		,[SalesManagerID] 
		,[PricingTypeID] 
		,[Modified] 
		,[ModifiedBy] 
		,[DateCreated] 
		,[CreatedBy] 
		,[IsFutureContract]
		,[MigrationComplete]
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		a.[ContractID] 
		,a.[Number] 
		,a.[ContractTypeID] 
		,a.[ContractDealTypeID] 
		,a.[ContractStatusID] 
		,a.[ContractTemplateID] 
		,a.[ReceiptDate] 
		,a.[StartDate] 
		,a.[EndDate] 
		,a.[SignedDate] 
		,a.[SubmitDate] 
		,a.[SalesChannelID] 
		,a.[SalesRep] 
		,a.[SalesManagerID] 
		,a.[PricingTypeID] 
		,a.[Modified] 
		,a.[ModifiedBy] 
		,a.[DateCreated] 
		,a.[CreatedBy] 
		,a.[IsFutureContract]
		,a.[MigrationComplete]
		,'UPD'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,@ColumnsUpdated			-- [ColumnsUpdated]
		,CASE WHEN ISNULL(a.[ContractID],0) <> ISNULL(b.[ContractID],0) THEN 'ContractID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Number],'') <> ISNULL(b.[Number],'') THEN 'Number' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ContractTypeID],0) <> ISNULL(b.[ContractTypeID],0) THEN 'ContractTypeID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ContractDealTypeID],0) <> ISNULL(b.[ContractDealTypeID],0) THEN 'ContractDealTypeID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ContractStatusID],0) <> ISNULL(b.[ContractStatusID],0) THEN 'ContractStatusID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ContractTemplateID],0) <> ISNULL(b.[ContractTemplateID],0) THEN 'ContractTemplateID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ReceiptDate],'') <> ISNULL(b.[ReceiptDate],'') THEN 'ReceiptDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[StartDate],'') <> ISNULL(b.[StartDate],'') THEN 'StartDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[EndDate],'') <> ISNULL(b.[EndDate],'') THEN 'EndDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SignedDate],'') <> ISNULL(b.[SignedDate],'') THEN 'SignedDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SubmitDate],'') <> ISNULL(b.[SubmitDate],'') THEN 'SubmitDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SalesChannelID],0) <> ISNULL(b.[SalesChannelID],0) THEN 'SalesChannelID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SalesRep],'') <> ISNULL(b.[SalesRep],'') THEN 'SalesRep' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SalesManagerID],0) <> ISNULL(b.[SalesManagerID],0) THEN 'SalesManagerID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[PricingTypeID],0) <> ISNULL(b.[PricingTypeID],0) THEN 'PricingTypeID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Modified],'') <> ISNULL(b.[Modified],'') THEN 'Modified' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ModifiedBy],0) <> ISNULL(b.[ModifiedBy],0) THEN 'ModifiedBy' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[DateCreated],'') <> ISNULL(b.[DateCreated],'') THEN 'DateCreated' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[CreatedBy],0) <> ISNULL(b.[CreatedBy],0) THEN 'CreatedBy' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[IsFutureContract],0) <> ISNULL(b.[IsFutureContract],0) THEN 'IsFutureContract' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[MigrationComplete],0) <> ISNULL(b.[MigrationComplete],0) THEN 'MigrationComplete' + ',' ELSE '' END
	FROM inserted a
	INNER JOIN deleted b
	on b.[ContractID]		= a.[ContractID]
	
	/* RCR - 18097 001 Begin*/
	UPDATE Libertypower..AccountStatus
	SET [Status]			= '999999'
		,[SubStatus]		= '10'
	FROM Libertypower..AccountStatus ST WITH (NOLOCK)
	INNER JOIN Libertypower..AccountContract AC WITH (NOLOCK)
	ON AC.AccountContractId		= ST.AccountContractID
	INNER JOIN INSERTED I
	ON I.ContractId				= AC.ContractID
	WHERE I.ContractStatusID	= 2 
	/* RCR - 18097 001 End*/
	
	
	SET NOCOUNT OFF;
END
