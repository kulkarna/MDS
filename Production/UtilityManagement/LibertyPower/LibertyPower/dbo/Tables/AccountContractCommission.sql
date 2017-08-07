CREATE TABLE [dbo].[AccountContractCommission] (
    [AccountContractCommissionID] INT        IDENTITY (1, 1) NOT NULL,
    [AccountContractID]           INT        NOT NULL,
    [EvergreenOptionID]           INT        NULL,
    [EvergreenCommissionEnd]      DATETIME   NULL,
    [EvergreenCommissionRate]     FLOAT (53) NULL,
    [ResidualOptionID]            INT        NULL,
    [ResidualCommissionEnd]       DATETIME   NULL,
    [InitialPymtOptionID]         INT        NULL,
    [Modified]                    DATETIME   CONSTRAINT [DF_AccountContractCommission_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]                  INT        NOT NULL,
    [DateCreated]                 DATETIME   CONSTRAINT [DF_ContractCommission_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                   INT        NOT NULL,
    CONSTRAINT [PK_AccountContractCommission] PRIMARY KEY NONCLUSTERED ([AccountContractCommissionID] ASC),
    CONSTRAINT [FK_AccountContractCommission_AccountContract] FOREIGN KEY ([AccountContractID]) REFERENCES [dbo].[AccountContract] ([AccountContractID]),
    CONSTRAINT [FK_AccountContractCommission_UserCreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_AccountContractCommission_UserModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserID])
);


GO
CREATE UNIQUE CLUSTERED INDEX [IDX_ACC_AccountContractID]
    ON [dbo].[AccountContractCommission]([AccountContractID] ASC);


GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table AuditAccountContractCommission
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountContractCommissionInsert]
	ON  [dbo].[AccountContractCommission]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditAccountContractCommission] (
		[AccountContractCommissionID]
		,[AccountContractID]
		,[EvergreenOptionID]
		,[EvergreenCommissionEnd]
		,[EvergreenCommissionRate]
		,[ResidualOptionID]
		,[ResidualCommissionEnd]
		,[InitialPymtOptionID]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		[AccountContractCommissionID]
		,[AccountContractID]
		,[EvergreenOptionID]
		,[EvergreenCommissionEnd]
		,[EvergreenCommissionRate]
		,[ResidualOptionID]
		,[ResidualCommissionEnd]
		,[InitialPymtOptionID]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
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
-- Description	: Insert audit row into audit table AuditAccountContractCommission
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountContractCommissionDelete]
	ON  [dbo].[AccountContractCommission]
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditAccountContractCommission] (
		[AccountContractCommissionID]
		,[AccountContractID]
		,[EvergreenOptionID]
		,[EvergreenCommissionEnd]
		,[EvergreenCommissionRate]
		,[ResidualOptionID]
		,[ResidualCommissionEnd]
		,[InitialPymtOptionID]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		[AccountContractCommissionID]
		,[AccountContractID]
		,[EvergreenOptionID]
		,[EvergreenCommissionEnd]
		,[EvergreenCommissionRate]
		,[ResidualOptionID]
		,[ResidualCommissionEnd]
		,[InitialPymtOptionID]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
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
-- Description	: Insert audit row into audit table AuditAccountContractCommission
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountContractCommissionUpdate]
	ON  [dbo].[AccountContractCommission]
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
			
			
	SET @ObjectID					= (SELECT id FROM sysobjects with (nolock) WHERE name='AccountContractCommission')
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

	INSERT INTO [dbo].[zAuditAccountContractCommission] (
		[AccountContractCommissionID]
		,[AccountContractID]
		,[EvergreenOptionID]
		,[EvergreenCommissionEnd]
		,[EvergreenCommissionRate]
		,[ResidualOptionID]
		,[ResidualCommissionEnd]
		,[InitialPymtOptionID]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		a.[AccountContractCommissionID]
		,a.[AccountContractID]
		,a.[EvergreenOptionID]
		,a.[EvergreenCommissionEnd]
		,a.[EvergreenCommissionRate]
		,a.[ResidualOptionID]
		,a.[ResidualCommissionEnd]
		,a.[InitialPymtOptionID]
		,a.[Modified]
		,a.[ModifiedBy]
		,a.[DateCreated]
		,a.[CreatedBy]
		,'UPD'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,@ColumnsUpdated			-- [ColumnsUpdated]
		,CASE WHEN ISNULL(a.[AccountContractCommissionID],0) <> ISNULL(b.[AccountContractCommissionID],0) THEN 'AccountContractCommissionID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[AccountContractID],0) <> ISNULL(b.[AccountContractID],0) THEN 'AccountContractID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[EvergreenOptionID],0) <> ISNULL(b.[EvergreenOptionID],0) THEN 'EvergreenOptionID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[EvergreenCommissionEnd],'') <> ISNULL(b.[EvergreenCommissionEnd],'') THEN 'EvergreenCommissionEnd' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[EvergreenCommissionRate],0) <> ISNULL(b.[EvergreenCommissionRate],0) THEN 'EvergreenCommissionRate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ResidualOptionID],0) <> ISNULL(b.[ResidualOptionID],0) THEN 'ResidualOptionID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ResidualCommissionEnd],'') <> ISNULL(b.[ResidualCommissionEnd],'') THEN 'ResidualCommissionEnd' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[InitialPymtOptionID],0) <> ISNULL(b.[InitialPymtOptionID],0) THEN 'InitialPymtOptionID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Modified],'') <> ISNULL(b.[Modified],'') THEN 'Modified' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ModifiedBy],0) <> ISNULL(b.[ModifiedBy],0) THEN 'ModifiedBy' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[DateCreated],'') <> ISNULL(b.[DateCreated],'') THEN 'DateCreated' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[CreatedBy],0) <> ISNULL(b.[CreatedBy],0) THEN 'CreatedBy' + ',' ELSE '' END
	FROM inserted a
	INNER JOIN deleted b
	ON b.[AccountContractCommissionID]	= a.[AccountContractCommissionID]
	
	SET NOCOUNT OFF;
END
