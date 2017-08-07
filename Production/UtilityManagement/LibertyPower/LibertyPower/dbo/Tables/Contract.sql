CREATE TABLE [dbo].[Contract] (
    [ContractID]           INT          IDENTITY (1, 1) NOT NULL,
    [Number]               VARCHAR (50) NOT NULL,
    [ContractTypeID]       INT          CONSTRAINT [DF_Contract_ContractTypeID] DEFAULT ((1)) NOT NULL,
    [ContractDealTypeID]   INT          CONSTRAINT [DF_Contract_ContractDealTypeID] DEFAULT ((1)) NOT NULL,
    [ContractStatusID]     INT          CONSTRAINT [DF_Contract_ContractStatusID] DEFAULT ((1)) NOT NULL,
    [ContractTemplateID]   INT          CONSTRAINT [DF_Contract_ContractTemplateID] DEFAULT ((1)) NOT NULL,
    [ReceiptDate]          DATETIME     NULL,
    [StartDate]            DATETIME     CONSTRAINT [DF_Contract_StartDate] DEFAULT (getdate()) NOT NULL,
    [EndDate]              DATETIME     CONSTRAINT [DF_Contract_EndDate] DEFAULT (getdate()) NOT NULL,
    [SignedDate]           DATETIME     CONSTRAINT [DF_Contract_SignedDate] DEFAULT (getdate()) NOT NULL,
    [SubmitDate]           DATETIME     CONSTRAINT [DF_Contract_SubmitDate] DEFAULT (getdate()) NOT NULL,
    [SalesChannelID]       INT          CONSTRAINT [DF_Contract_SalesChannelID] DEFAULT ((441)) NOT NULL,
    [SalesRep]             VARCHAR (64) NULL,
    [SalesManagerID]       INT          NULL,
    [DateCreated]          DATETIME     CONSTRAINT [DF_Contract_DateCreated] DEFAULT (getdate()) NOT NULL,
    [PricingTypeID]        INT          NULL,
    [Modified]             DATETIME     CONSTRAINT [DF_Contract_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]           INT          CONSTRAINT [DF_Contract_ModifiedBy] DEFAULT ((883)) NOT NULL,
    [CreatedBy]            INT          CONSTRAINT [DF_Contract_CreatedBy] DEFAULT ((883)) NOT NULL,
    [MigrationComplete]    BIT          CONSTRAINT [DF_Contract_MigrationComplete] DEFAULT ((0)) NOT NULL,
    [IsRenewalMigration]   BIT          CONSTRAINT [DF_Contract_IsRenewalMigration] DEFAULT ((0)) NOT NULL,
    [IsFutureContract]     AS           (case when [ContractDealTypeID]=(2) AND ([StartDate]>getdate() OR ([ContractStatusID]=(2) OR [ContractStatusID]=(1))) then (1) else (0) end),
    [EstimatedAnnualUsage] INT          NULL,
    [ExternalNumber]       VARCHAR (50) NULL,
    CONSTRAINT [PK_Contract] PRIMARY KEY CLUSTERED ([ContractID] ASC),
    CONSTRAINT [FK_Contract_ContractDealType] FOREIGN KEY ([ContractDealTypeID]) REFERENCES [dbo].[ContractDealType] ([ContractDealTypeID]),
    CONSTRAINT [FK_Contract_ContractStatus] FOREIGN KEY ([ContractStatusID]) REFERENCES [dbo].[ContractStatus] ([ContractStatusID]),
    CONSTRAINT [FK_Contract_ContractTemplateType] FOREIGN KEY ([ContractTemplateID]) REFERENCES [dbo].[ContractTemplateType] ([ContractTemplateTypeID]),
    CONSTRAINT [FK_Contract_ContractType] FOREIGN KEY ([ContractTypeID]) REFERENCES [dbo].[ContractType] ([ContractTypeID]),
    CONSTRAINT [FK_Contract_PricingType] FOREIGN KEY ([PricingTypeID]) REFERENCES [dbo].[PricingType] ([PricingTypeID]),
    CONSTRAINT [FK_Contract_SalesChannel] FOREIGN KEY ([SalesChannelID]) REFERENCES [dbo].[SalesChannel] ([ChannelID]),
    CONSTRAINT [FK_Contract_UserCreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_Contract_UserModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [idx_number]
    ON [dbo].[Contract]([Number] ASC)
    INCLUDE([ContractID]);


GO
CREATE NONCLUSTERED INDEX [IDX_SalesChannelID]
    ON [dbo].[Contract]([SalesChannelID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [Contract__Number_I_SignedDate_ID]
    ON [dbo].[Contract]([SalesChannelID] ASC, [Number] ASC)
    INCLUDE([SignedDate], [ContractID]);


GO
CREATE NONCLUSTERED INDEX [Contract__ContractDealTypeID_ContractTypeID_I]
    ON [dbo].[Contract]([ContractDealTypeID] ASC, [ContractTypeID] ASC)
    INCLUDE([ContractTemplateID], [StartDate], [SignedDate], [SalesRep], [Number]);


GO
CREATE NONCLUSTERED INDEX [idx_SalesChannelID_submitdate__I]
    ON [dbo].[Contract]([SalesChannelID] ASC, [SubmitDate] ASC)
    INCLUDE([ContractID]);


GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table zAuditContract
-- =============================================================
CREATE TRIGGER [dbo].[zAuditContractInsert]
	ON  dbo.Contract
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

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
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table zAuditContract
-- =============================================================
CREATE TRIGGER [dbo].[zAuditContractDelete]
	ON  dbo.Contract
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

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
		,'DEL'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
	FROM deleted
	
	SET NOCOUNT OFF;
END

GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table zAuditContract
-- =============================================================
CREATE TRIGGER [dbo].[zAuditContractUpdate]
	ON  dbo.Contract
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
	
	SET NOCOUNT OFF;
END
